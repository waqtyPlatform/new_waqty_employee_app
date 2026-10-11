package com.waqtyservices.app

import android.Manifest
import android.app.PendingIntent
import android.content.Context
import android.content.Intent
import android.content.pm.PackageManager
import android.util.Log
import androidx.core.content.ContextCompat
import com.google.android.gms.location.Geofence
import com.google.android.gms.location.GeofencingClient
import com.google.android.gms.location.GeofencingRequest
import com.google.android.gms.location.LocationServices

internal object GeofenceManager {
    private const val TAG = "WAQTY_GEOFENCE"
    private const val REQUEST_CODE = 7401
    private const val GEOFENCE_ID = "assigned_branch"

    private fun client(context: Context): GeofencingClient = LocationServices.getGeofencingClient(context)

    private fun pendingIntent(context: Context): PendingIntent = PendingIntent.getBroadcast(
        context, REQUEST_CODE, Intent(context, GeofenceBroadcastReceiver::class.java),
        PendingIntent.FLAG_UPDATE_CURRENT or PendingIntent.FLAG_MUTABLE,
    )

    fun register(context: Context) {
        val branchUuid = GeofenceStore.branchUuid(context) ?: run {
            Log.w(TAG, "register skipped: missing branch uuid")
            return
        }
        if (ContextCompat.checkSelfPermission(context, Manifest.permission.ACCESS_FINE_LOCATION) != PackageManager.PERMISSION_GRANTED &&
            ContextCompat.checkSelfPermission(context, Manifest.permission.ACCESS_COARSE_LOCATION) != PackageManager.PERMISSION_GRANTED) {
            Log.w(TAG, "register skipped: foreground location permission missing")
            return
        }
        if (ContextCompat.checkSelfPermission(context, Manifest.permission.ACCESS_BACKGROUND_LOCATION) != PackageManager.PERMISSION_GRANTED) {
            Log.w(TAG, "register skipped: background location permission missing")
            return
        }

        val radius = GeofenceStore.radius(context)
        Log.d(TAG, "register requested id=$GEOFENCE_ID:$branchUuid center=${GeofenceStore.latitude(context)},${GeofenceStore.longitude(context)} radius=$radius")

        val geofence = Geofence.Builder()
            .setRequestId("$GEOFENCE_ID:$branchUuid")
            .setCircularRegion(GeofenceStore.latitude(context), GeofenceStore.longitude(context), radius.toFloat())
            .setExpirationDuration(Geofence.NEVER_EXPIRE)
            .setTransitionTypes(Geofence.GEOFENCE_TRANSITION_ENTER or Geofence.GEOFENCE_TRANSITION_EXIT)
            .build()
        val request = GeofencingRequest.Builder()
            .setInitialTrigger(GeofencingRequest.INITIAL_TRIGGER_ENTER)
            .addGeofence(geofence)
            .build()
        client(context).removeGeofences(pendingIntent(context)).addOnCompleteListener { removeTask ->
            Log.d(TAG, "remove before register success=${removeTask.isSuccessful} error=${removeTask.exception?.message}")
            client(context).addGeofences(request, pendingIntent(context))
                .addOnSuccessListener {
                    Log.i(TAG, "WAQTY_GEOFENCE_REGISTERED id=${geofence.requestId} radius=$radius transitions=ENTER|EXIT")
                    Log.d(TAG, "monitored region expected id=${geofence.requestId}")
                }
                .addOnFailureListener { error ->
                    Log.e(TAG, "WAQTY_GEOFENCE_REGISTER_FAILED id=${geofence.requestId} error=${error.message}", error)
                }
        }
    }

    fun clear(context: Context) {
        GeofenceScheduleManager.clear(context)
    }

    fun unregister(context: Context) {
        client(context).removeGeofences(pendingIntent(context))
    }
}
