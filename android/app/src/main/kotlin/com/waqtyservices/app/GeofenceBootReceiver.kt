package com.waqtyservices.app

import android.content.BroadcastReceiver
import android.content.Context
import android.content.Intent

class GeofenceBootReceiver : BroadcastReceiver() {
    override fun onReceive(context: Context, intent: Intent) {
        if (intent.action == Intent.ACTION_BOOT_COMPLETED || intent.action == Intent.ACTION_MY_PACKAGE_REPLACED) {
            GeofenceScheduleManager.refresh(context)
        }
    }
}
