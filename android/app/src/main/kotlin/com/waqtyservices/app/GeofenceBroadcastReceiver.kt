package com.waqtyservices.app

import android.Manifest
import android.app.NotificationChannel
import android.app.NotificationManager
import android.app.PendingIntent
import android.content.BroadcastReceiver
import android.content.Context
import android.content.Intent
import android.content.pm.PackageManager
import android.util.Log
import androidx.core.app.NotificationCompat
import androidx.core.app.NotificationManagerCompat
import androidx.core.content.ContextCompat
import com.google.android.gms.location.Geofence
import com.google.android.gms.location.GeofencingEvent

class GeofenceBroadcastReceiver : BroadcastReceiver() {
    companion object { private const val TAG = "WAQTY_GEOFENCE" }

    override fun onReceive(context: Context, intent: Intent) {
        Log.d(TAG, "broadcast received action=${intent.action}")
        val event = GeofencingEvent.fromIntent(intent) ?: run {
            Log.e(TAG, "broadcast ignored: GeofencingEvent is null")
            return
        }
        if (event.hasError()) {
            Log.e(TAG, "broadcast error code=${event.errorCode}")
            return
        }
        val active = GeofenceScheduleManager.isActive(context)
        Log.d(TAG, "transition=${event.geofenceTransition} activeShift=$active")
        if (!active) {
            Log.d(TAG, "transition ignored: outside active shift")
            return
        }
        val nextState = when (event.geofenceTransition) {
            Geofence.GEOFENCE_TRANSITION_ENTER -> "inside_branch"
            Geofence.GEOFENCE_TRANSITION_EXIT -> "outside_branch"
            else -> return
        }
        if (GeofenceStore.presence(context) == nextState) {
            Log.d(TAG, "transition ignored: duplicate state=$nextState")
            return
        }
        Log.i(TAG, "WAQTY_GEOFENCE_${if (nextState == "outside_branch") "EXIT" else "ENTER"}_RECEIVED")
        GeofenceStore.setPresence(context, nextState)
        GeofenceStore.recordTransition(context, if (nextState == "inside_branch") "enter" else "exit", java.time.Instant.now().toString())
        showNotification(context, nextState, false)
    }

    fun debugTestNotification(context: Context) = showNotification(context, "outside_branch", true)

    private fun showNotification(context: Context, state: String, debugTest: Boolean) {
        val english = GeofenceStore.language(context) == "en"
        val branch = GeofenceStore.branchName(context)
        val inside = state == "inside_branch"
        val title = if (inside) {
            if (english) "You are now inside the branch area" else "أنت الآن داخل نطاق الفرع"
        } else {
            if (english) "You are now outside the branch area" else "أنت الآن خارج نطاق الفرع"
        }
        val body = if (inside) {
            if (english) "Your presence inside $branch has been verified." else "تم التحقق من وجودك داخل نطاق فرع $branch."
        } else {
            if (english) "You have left the $branch branch area." else "غادرت نطاق فرع $branch."
        }

        val manager = context.getSystemService(Context.NOTIFICATION_SERVICE) as NotificationManager
        manager.createNotificationChannel(NotificationChannel("waqty_geofence", "Branch presence", NotificationManager.IMPORTANCE_HIGH))
        if (android.os.Build.VERSION.SDK_INT >= 33 &&
            ContextCompat.checkSelfPermission(context, Manifest.permission.POST_NOTIFICATIONS) != PackageManager.PERMISSION_GRANTED) {
            Log.w(TAG, "notification skipped: POST_NOTIFICATIONS not granted")
            return
        }
        val openIntent = Intent(context, MainActivity::class.java).apply {
            flags = Intent.FLAG_ACTIVITY_NEW_TASK or Intent.FLAG_ACTIVITY_CLEAR_TOP
            putExtra("open_attendance", true)
        }
        val pendingIntent = PendingIntent.getActivity(context, 7402, openIntent, PendingIntent.FLAG_UPDATE_CURRENT or PendingIntent.FLAG_IMMUTABLE)
        val notification = NotificationCompat.Builder(context, "waqty_geofence")
            .setSmallIcon(R.mipmap.ic_launcher)
            .setContentTitle(title)
            .setContentText(body)
            .setAutoCancel(true)
            .setPriority(NotificationCompat.PRIORITY_HIGH)
            .setContentIntent(pendingIntent)
            .build()
        NotificationManagerCompat.from(context).notify(7403, notification)
        val marker = when {
            debugTest -> "WAQTY_DEBUG_EXIT_NOTIFICATION_SCHEDULED"
            state == "outside_branch" -> "WAQTY_EXIT_NOTIFICATION_SCHEDULED"
            else -> "WAQTY_ENTER_NOTIFICATION_SCHEDULED"
        }
        Log.i(TAG, marker)
    }
}
