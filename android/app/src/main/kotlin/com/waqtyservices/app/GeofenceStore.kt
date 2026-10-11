package com.waqtyservices.app

import android.content.Context
import org.json.JSONArray
import org.json.JSONObject

internal object GeofenceStore {
    private const val PREFS = "waqty_geofence"
    private const val BRANCH_UUID = "branch_uuid"
    private const val BRANCH_NAME = "branch_name"
    private const val LATITUDE = "latitude"
    private const val LONGITUDE = "longitude"
    private const val RADIUS = "radius_meters"
    private const val LANGUAGE = "language"
    private const val PRESENCE = "presence"
    private const val SCHEDULE = "schedule_json"
    private const val TIMEZONE = "timezone"
    private const val LAST_TRANSITION = "last_transition"
    private const val LAST_TRANSITION_AT = "last_transition_at"
    private const val PENDING_EVENTS = "pending_events"

    private fun prefs(context: Context) = context.getSharedPreferences(PREFS, Context.MODE_PRIVATE)

    fun saveConfig(context: Context, values: Map<String, Any?>) {
        prefs(context).edit()
            .putString(BRANCH_UUID, values[BRANCH_UUID]?.toString())
            .putString(BRANCH_NAME, values[BRANCH_NAME]?.toString().orEmpty())
            .putFloat(LATITUDE, (values[LATITUDE] as Number).toFloat())
            .putFloat(LONGITUDE, (values[LONGITUDE] as Number).toFloat())
            .putFloat(RADIUS, (values[RADIUS] as Number).toFloat())
            .putString(LANGUAGE, values[LANGUAGE]?.toString() ?: "ar")
            .putString(TIMEZONE, values[TIMEZONE]?.toString())
            .apply()
    }

    fun clearConfig(context: Context) = prefs(context).edit().clear().apply()
    fun saveSchedule(context: Context, schedule: String, timezone: String?) {
        val editor = prefs(context).edit().putString(SCHEDULE, schedule)
        if (timezone != null && timezone.isNotBlank()) editor.putString(TIMEZONE, timezone)
        editor.apply()
    }
    fun schedule(context: Context) = prefs(context).getString(SCHEDULE, "[]").orEmpty()
    fun timezone(context: Context) = prefs(context).getString(TIMEZONE, null)
    fun branchUuid(context: Context) = prefs(context).getString(BRANCH_UUID, null)
    fun branchName(context: Context) = prefs(context).getString(BRANCH_NAME, "").orEmpty()
    fun latitude(context: Context) = prefs(context).getFloat(LATITUDE, 0f).toDouble()
    fun longitude(context: Context) = prefs(context).getFloat(LONGITUDE, 0f).toDouble()
    fun radius(context: Context) = prefs(context).getFloat(RADIUS, 0f).toDouble()
    fun language(context: Context) = prefs(context).getString(LANGUAGE, "ar").orEmpty()
    fun presence(context: Context) = prefs(context).getString(PRESENCE, "unknown").orEmpty()
    fun setPresence(context: Context, value: String) = prefs(context).edit().putString(PRESENCE, value).apply()
    fun recordTransition(context: Context, event: String, occurredAt: String) {
        prefs(context).edit().putString(LAST_TRANSITION, event).putString(LAST_TRANSITION_AT, occurredAt).apply()
        val events = JSONArray(prefs(context).getString(PENDING_EVENTS, "[]"))
        events.put(JSONObject().apply {
            put("branch_uuid", branchUuid(context).orEmpty())
            put("event", event)
            put("occurred_at", occurredAt)
            put("source", "android_geofence")
        })
        prefs(context).edit().putString(PENDING_EVENTS, events.toString()).apply()
    }
}
