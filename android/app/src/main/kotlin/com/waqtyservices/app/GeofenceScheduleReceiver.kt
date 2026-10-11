package com.waqtyservices.app

import android.content.BroadcastReceiver
import android.content.Context
import android.content.Intent

class GeofenceScheduleReceiver : BroadcastReceiver() {
    override fun onReceive(context: Context, intent: Intent) {
        GeofenceScheduleManager.refresh(context)
    }
}
