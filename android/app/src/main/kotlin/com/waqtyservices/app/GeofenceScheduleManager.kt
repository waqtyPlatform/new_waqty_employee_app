package com.waqtyservices.app

import android.app.AlarmManager
import android.app.PendingIntent
import android.content.Context
import android.content.Intent
import org.json.JSONArray
import java.time.ZoneId
import java.time.ZonedDateTime
import java.time.format.DateTimeFormatter

internal object GeofenceScheduleManager {
    private const val REQUEST_CODE = 7404
    private const val ACTION_REFRESH = "com.waqtyservices.app.REFRESH_GEOFENCE"
    private const val BUFFER_MINUTES = 15L
    private val timeFormatter = DateTimeFormatter.ofPattern("H:mm[:ss]")

    fun refresh(context: Context) {
        cancelAlarm(context)
        val now = ZonedDateTime.now(zone(context))
        if (isMonitoringWindow(context, now)) GeofenceManager.register(context) else GeofenceManager.unregister(context)
        nextBoundary(context, now)?.let { scheduleAlarm(context, it) }
    }

    fun isActive(context: Context): Boolean = isActiveShift(context, ZonedDateTime.now(zone(context)))

    fun clear(context: Context) {
        cancelAlarm(context)
        GeofenceManager.unregister(context)
        GeofenceStore.clearConfig(context)
    }

    private fun isMonitoringWindow(context: Context, now: ZonedDateTime): Boolean {
        val schedule = JSONArray(GeofenceStore.schedule(context))
        for (index in 0 until schedule.length()) {
            val item = schedule.optJSONObject(index) ?: continue
            if (item.optString("date") != now.toLocalDate().toString()) continue
            val start = parseTime(now, item.optString("start")) ?: continue
            var end = parseTime(now, item.optString("end")) ?: continue
            if (!end.isAfter(start)) end = end.plusDays(1)
            val activeStart = start.minusMinutes(BUFFER_MINUTES)
            if (!now.isBefore(activeStart) && now.isBefore(end)) return true
        }
        return false
    }

    private fun isActiveShift(context: Context, now: ZonedDateTime): Boolean {
        val schedule = JSONArray(GeofenceStore.schedule(context))
        for (index in 0 until schedule.length()) {
            val item = schedule.optJSONObject(index) ?: continue
            if (item.optString("date") != now.toLocalDate().toString()) continue
            val start = parseTime(now, item.optString("start")) ?: continue
            var end = parseTime(now, item.optString("end")) ?: continue
            if (!end.isAfter(start)) end = end.plusDays(1)
            if (!now.isBefore(start) && now.isBefore(end)) return true
        }
        return false
    }

    private fun nextBoundary(context: Context, now: ZonedDateTime): ZonedDateTime? {
        val schedule = JSONArray(GeofenceStore.schedule(context))
        var next: ZonedDateTime? = null
        for (index in 0 until schedule.length()) {
            val item = schedule.optJSONObject(index) ?: continue
            val date = item.optString("date")
            val start = parseTime(now, "$date ${item.optString("start")}", true) ?: continue
            var end = parseTime(now, "$date ${item.optString("end")}", true) ?: continue
            if (!end.isAfter(start)) end = end.plusDays(1)
            listOf(start.minusMinutes(BUFFER_MINUTES), end).forEach { candidate ->
                if (candidate.isAfter(now) && (next == null || candidate.isBefore(next))) next = candidate
            }
        }
        return next
    }

    private fun parseTime(now: ZonedDateTime, value: String, withDate: Boolean = false): ZonedDateTime? = try {
        if (withDate) {
            val parts = value.split(" ", limit = 2)
            ZonedDateTime.of(parts[0].let { java.time.LocalDate.parse(it) }, java.time.LocalTime.parse(parts[1], timeFormatter), now.zone)
        } else {
            ZonedDateTime.of(now.toLocalDate(), java.time.LocalTime.parse(value, timeFormatter), now.zone)
        }
    } catch (_: Exception) { null }

    private fun zone(context: Context): ZoneId = try {
        ZoneId.of(GeofenceStore.timezone(context) ?: java.util.TimeZone.getDefault().id)
    } catch (_: Exception) { ZoneId.systemDefault() }

    private fun scheduleAlarm(context: Context, at: ZonedDateTime) {
        val alarmManager = context.getSystemService(Context.ALARM_SERVICE) as AlarmManager
        val intent = Intent(context, GeofenceScheduleReceiver::class.java).setAction(ACTION_REFRESH)
        val pending = PendingIntent.getBroadcast(context, REQUEST_CODE, intent, PendingIntent.FLAG_UPDATE_CURRENT or PendingIntent.FLAG_IMMUTABLE)
        alarmManager.setAndAllowWhileIdle(AlarmManager.RTC_WAKEUP, at.toInstant().toEpochMilli(), pending)
    }

    private fun cancelAlarm(context: Context) {
        val intent = Intent(context, GeofenceScheduleReceiver::class.java).setAction(ACTION_REFRESH)
        val pending = PendingIntent.getBroadcast(context, REQUEST_CODE, intent, PendingIntent.FLAG_UPDATE_CURRENT or PendingIntent.FLAG_IMMUTABLE)
        (context.getSystemService(Context.ALARM_SERVICE) as AlarmManager).cancel(pending)
    }
}
