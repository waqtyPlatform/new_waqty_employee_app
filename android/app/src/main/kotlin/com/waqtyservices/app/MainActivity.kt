package com.waqtyservices.app

import io.flutter.embedding.android.FlutterFragmentActivity
import io.flutter.embedding.engine.FlutterEngine
import io.flutter.plugin.common.MethodChannel
import org.json.JSONArray

class MainActivity : FlutterFragmentActivity() {
    override fun configureFlutterEngine(flutterEngine: FlutterEngine) {
        super.configureFlutterEngine(flutterEngine)
        MethodChannel(flutterEngine.dartExecutor.binaryMessenger, "waqty/geofence").setMethodCallHandler { call, result ->
            when (call.method) {
                "configure" -> {
                    val args = call.arguments as? Map<*, *>
                    if (args == null || args["latitude"] !is Number || args["longitude"] !is Number || args["radius_meters"] !is Number) {
                        result.error("INVALID_CONFIG", "Missing branch coordinates or radius", null)
                        return@setMethodCallHandler
                    }
                    GeofenceStore.saveConfig(this, mapOf(
                        "branch_uuid" to args["branch_uuid"],
                        "branch_name" to args["branch_name"],
                        "latitude" to args["latitude"],
                        "longitude" to args["longitude"],
                        "radius_meters" to args["radius_meters"],
                        "language" to args["language"],
                        "timezone" to args["timezone"],
                    ))
                    GeofenceScheduleManager.refresh(this)
                    result.success(true)
                }
                "updateSchedule" -> {
                    val args = call.arguments as? Map<*, *>
                    val schedule = args?.get("schedule") as? List<*> ?: emptyList<Any>()
                    val scheduleJson = JSONArray(schedule.mapNotNull { item ->
                        (item as? Map<*, *>)?.let { map ->
                            org.json.JSONObject().apply {
                                map.forEach { (key, value) -> put(key.toString(), value) }
                            }
                        }
                    }).toString()
                    GeofenceStore.saveSchedule(this, scheduleJson, args?.get("timezone")?.toString())
                    GeofenceScheduleManager.refresh(this)
                    result.success(null)
                }
                "clear" -> {
                    GeofenceManager.clear(this)
                    result.success(null)
                }
                "getPresence" -> result.success(GeofenceStore.presence(this))
                "debugTestExitNotification" -> {
                    android.util.Log.i("WAQTY_GEOFENCE", "WAQTY_DEBUG_EXIT_NOTIFICATION_TRIGGERED")
                    GeofenceBroadcastReceiver().debugTestNotification(this)
                    result.success(null)
                }
                else -> result.notImplemented()
            }
        }
    }
}
