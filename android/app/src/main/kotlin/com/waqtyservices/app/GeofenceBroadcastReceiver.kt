package com.waqtyservices.app

import android.Manifest
import android.app.NotificationChannel
import android.app.NotificationManager
import android.app.PendingIntent
import android.content.BroadcastReceiver
import android.content.Context
import android.content.Intent
import android.content.pm.PackageManager
import androidx.core.app.NotificationCompat
import androidx.core.app.NotificationManagerCompat
import androidx.core.content.ContextCompat
import com.google.android.gms.location.Geofence
import com.google.android.gms.location.GeofencingEvent

class GeofenceBroadcastReceiver : BroadcastReceiver() {
    override fun onReceive(context: Context, intent: Intent) {
        val event = GeofencingEvent.fromIntent(intent) ?: return
        if (event.hasError()) return
        if (!GeofenceScheduleManager.isActive(context)) return
        val nextState = when (event.geofenceTransition) {
            Geofence.GEOFENCE_TRANSITION_ENTER -> "inside_branch"
            Geofence.GEOFENCE_TRANSITION_EXIT -> "outside_branch"
            else -> return
        }
        if (GeofenceStore.presence(context) == nextState) return
        GeofenceStore.setPresence(context, nextState)
        GeofenceStore.recordTransition(context, if (nextState == "inside_branch") "enter" else "exit", java.time.Instant.now().toString())
        showNotification(context, nextState)
    }

    private fun showNotification(context: Context, state: String) {
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
            ContextCompat.checkSelfPermission(context, Manifest.permission.POST_NOTIFICATIONS) != PackageManager.PERMISSION_GRANTED) return
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
    }
}
