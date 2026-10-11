import Flutter
import UIKit
import CoreLocation
import UserNotifications

@main
@objc class AppDelegate: FlutterAppDelegate, FlutterImplicitEngineDelegate {
  private var branchGeofenceManager: BranchGeofenceManager?

  override func application(
    _ application: UIApplication,
    didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?
  ) -> Bool {
    branchGeofenceManager = BranchGeofenceManager()
    let didFinish = super.application(application, didFinishLaunchingWithOptions: launchOptions)
    branchGeofenceManager?.reevaluate(reason: "didFinishLaunching")
    return didFinish
  }

  func didInitializeImplicitFlutterEngine(_ engineBridge: FlutterImplicitEngineBridge) {
    GeneratedPluginRegistrant.register(with: engineBridge.pluginRegistry)
    let registrar = engineBridge.pluginRegistry.registrar(forPlugin: "BranchGeofenceManager")
    let channel = FlutterMethodChannel(name: "waqty/geofence", binaryMessenger: registrar!.messenger())
    branchGeofenceManager?.attach(channel: channel)
    branchGeofenceManager?.reevaluate(reason: "flutterEngineReady")
  }

  override func applicationDidBecomeActive(_ application: UIApplication) {
    super.applicationDidBecomeActive(application)
    branchGeofenceManager?.reevaluate(reason: "applicationDidBecomeActive")
  }
}

private final class BranchGeofenceManager: NSObject, CLLocationManagerDelegate {
  private var channel: FlutterMethodChannel?
  private let manager = CLLocationManager()
  private let defaults = UserDefaults.standard
  private let regionId = "waqty.assigned.branch"
  private let bufferMinutes: TimeInterval = 15 * 60

  private var branchName: String { defaults.string(forKey: "waqty.geofence.branch_name") ?? "" }
  private var timezone: TimeZone {
    if let value = defaults.string(forKey: "waqty.geofence.timezone"), let zone = TimeZone(identifier: value) { return zone }
    return .current
  }

  override init() {
    super.init()
    manager.delegate = self
    manager.pausesLocationUpdatesAutomatically = true
    logAuthorization("init")
    logLocationServices("init")
    logNotificationPermission("init")
  }

  func attach(channel: FlutterMethodChannel) {
    self.channel = channel
    channel.setMethodCallHandler { [weak self] call, result in self?.handle(call, result: result) }
    log("Flutter method channel attached")
  }

  func handle(_ call: FlutterMethodCall, result: @escaping FlutterResult) {
    switch call.method {
    case "getPresence":
      result(defaults.string(forKey: "waqty.geofence.presence") ?? "unknown")
    case "configure":
      guard let args = call.arguments as? [String: Any],
            let uuid = args["branch_uuid"] as? String,
            let latitude = args["latitude"] as? Double,
            let longitude = args["longitude"] as? Double,
            let radius = args["radius_meters"] as? Double else {
        result(FlutterError(code: "INVALID_CONFIG", message: "Missing branch configuration", details: nil))
        return
      }
      defaults.set(uuid, forKey: "waqty.geofence.branch_uuid")
      defaults.set(args["branch_name"] as? String ?? "", forKey: "waqty.geofence.branch_name")
      defaults.set(latitude, forKey: "waqty.geofence.latitude")
      defaults.set(longitude, forKey: "waqty.geofence.longitude")
      defaults.set(radius, forKey: "waqty.geofence.radius")
      defaults.set(args["language"] as? String ?? "ar", forKey: "waqty.geofence.language")
      if let zone = args["timezone"] as? String, !zone.isEmpty { defaults.set(zone, forKey: "waqty.geofence.timezone") }
      log("cache branch updated uuid=\(uuid) center=\(latitude),\(longitude) radius=\(radius) timezone=\(timezone.identifier)")
      requestAlwaysIfNeeded()
      reevaluate(reason: "configure")
      result(true)
    case "updateSchedule":
      guard let args = call.arguments as? [String: Any] else {
        result(FlutterError(code: "INVALID_SCHEDULE", message: "Missing schedule", details: nil))
        return
      }
      let schedule = args["schedule"] as? [[String: Any]] ?? []
      defaults.set(schedule, forKey: "waqty.geofence.schedule")
      if let zone = args["timezone"] as? String, !zone.isEmpty { defaults.set(zone, forKey: "waqty.geofence.timezone") }
      log("cache schedule updated count=\(schedule.count) timezone=\(timezone.identifier)")
      reevaluate(reason: "updateSchedule")
      result(nil)
    case "clear":
      stopMonitoring()
      [
        "waqty.geofence.branch_uuid", "waqty.geofence.branch_name", "waqty.geofence.latitude", "waqty.geofence.longitude",
        "waqty.geofence.radius", "waqty.geofence.language", "waqty.geofence.timezone", "waqty.geofence.schedule",
        "waqty.geofence.presence", "waqty.geofence.last_transition", "waqty.geofence.last_transition_at", "waqty.geofence.pending_events"
      ].forEach { defaults.removeObject(forKey: $0) }
      log("cache cleared")
      result(nil)
    case "requestAlwaysPermission":
      requestAlwaysIfNeeded()
      result(nil)
    case "debugTestExitNotification":
      log("WAQTY_DEBUG_EXIT_NOTIFICATION_TRIGGERED")
      showNotification(state: "outside_branch", isDebugTest: true)
      result(nil)
    default:
      result(FlutterMethodNotImplemented)
    }
  }

  func reevaluate(reason: String) {
    logAuthorization(reason)
    logLocationServices(reason)
    logNotificationPermission(reason)
    guard CLLocationManager.isMonitoringAvailable(for: CLCircularRegion.self) else { log("monitoring unavailable"); stopMonitoring(); return }
    guard CLLocationManager.locationServicesEnabled() else { log("reevaluate ignored: location services disabled"); stopMonitoring(); return }
    guard CLLocationManager.authorizationStatus() == .authorizedAlways else { log("reevaluate ignored: Always authorization is required"); stopMonitoring(); return }
    guard let region = configuredRegion() else { log("reevaluate ignored: configured region missing or invalid"); stopMonitoring(); return }
    logRegion("configured", region)
    if isWithinActiveShift(reason: reason) {
      stopMonitoring()
      manager.startMonitoring(for: region)
      logRegion("startMonitoring requested", region)
      logMonitoredRegions("after startMonitoring")
      manager.requestState(for: region)
    } else {
      log("reevaluate: outside active shift, stopping region monitoring")
      stopMonitoring()
    }
  }

  private func requestAlwaysIfNeeded() {
    let status = CLLocationManager.authorizationStatus()
    logAuthorization("requestAlwaysIfNeeded")
    if status == .notDetermined || status == .authorizedWhenInUse {
      log("requestAlwaysAuthorization called")
      manager.requestAlwaysAuthorization()
    }
  }

  private func configuredRegion() -> CLCircularRegion? {
    let latitude = defaults.double(forKey: "waqty.geofence.latitude")
    let longitude = defaults.double(forKey: "waqty.geofence.longitude")
    let configuredRadius = defaults.double(forKey: "waqty.geofence.radius")
    guard latitude != 0, longitude != 0, configuredRadius > 0 else { return nil }
    let maxRadius = manager.maximumRegionMonitoringDistance
    let radius = min(configuredRadius, maxRadius > 0 ? maxRadius : configuredRadius)
    let region = CLCircularRegion(center: CLLocationCoordinate2D(latitude: latitude, longitude: longitude), radius: radius, identifier: regionId)
    region.notifyOnEntry = true
    region.notifyOnExit = true
    return region
  }

  private func stopMonitoring() {
    manager.monitoredRegions.filter { $0.identifier == regionId }.forEach { manager.stopMonitoring(for: $0) }
    logMonitoredRegions("after stopMonitoring")
  }

  private func isWithinActiveShift(now: Date = Date(), includeBuffer: Bool = true, reason: String = "event") -> Bool {
    guard let schedule = defaults.array(forKey: "waqty.geofence.schedule") as? [[String: Any]] else {
      logShiftDecision(now: now, reason: reason, active: false, detail: "no cached schedule")
      return false
    }
    var calendar = Calendar(identifier: .gregorian)
    calendar.timeZone = timezone
    let formatter = DateFormatter()
    formatter.calendar = calendar
    formatter.timeZone = timezone
    formatter.dateFormat = "yyyy-MM-dd H:mm"
    var firstWindow = "none"
    for item in schedule {
      guard let date = item["date"] as? String, let start = item["start"] as? String, let end = item["end"] as? String,
            let startDate = formatter.date(from: "\(date) \(start)"), var endDate = formatter.date(from: "\(date) \(end)") else { continue }
      if firstWindow == "none" { firstWindow = "\(date) \(start)-\(end)" }
      if endDate <= startDate { endDate = calendar.date(byAdding: .day, value: 1, to: endDate) ?? endDate }
      let activeStart = includeBuffer ? startDate.addingTimeInterval(-bufferMinutes) : startDate
      let window = "\(date) \(start)-\(end)"
      if now >= activeStart && now < endDate {
        logShiftDecision(now: now, reason: reason, active: true, detail: window)
        return true
      }
    }
    logShiftDecision(now: now, reason: reason, active: false, detail: firstWindow)
    return false
  }

  func locationManager(_ manager: CLLocationManager, didEnterRegion region: CLRegion) {
    logRegionCallback("didEnterRegion", region)
    processTransition("inside_branch")
  }

  func locationManager(_ manager: CLLocationManager, didExitRegion region: CLRegion) {
    logRegionCallback("didExitRegion", region)
    log("WAQTY_GEOFENCE_EXIT_RECEIVED")
    processTransition("outside_branch")
  }

  func locationManager(_ manager: CLLocationManager, didStartMonitoringFor region: CLRegion) {
    logRegionCallback("didStartMonitoringForRegion", region)
    logMonitoredRegions("didStartMonitoringForRegion")
    manager.requestState(for: region)
  }

  func locationManager(_ manager: CLLocationManager, monitoringDidFailFor region: CLRegion?, withError error: Error) {
    log("monitoringDidFailForRegion id=\(region?.identifier ?? "nil") error=\(error.localizedDescription)")
    logMonitoredRegions("monitoringDidFailForRegion")
  }

  func locationManager(_ manager: CLLocationManager, didDetermineState state: CLRegionState, for region: CLRegion) {
    let value: String
    switch state {
    case .inside: value = "inside"
    case .outside: value = "outside"
    case .unknown: value = "unknown"
    @unknown default: value = "unknown"
    }
    log("didDetermineState id=\(region.identifier) state=\(value)")
  }

  func locationManagerDidChangeAuthorization(_ manager: CLLocationManager) {
    logAuthorization("locationManagerDidChangeAuthorization")
    logLocationServices("locationManagerDidChangeAuthorization")
    reevaluate(reason: "authorizationChanged")
  }

  func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
    logAuthorization("didChangeAuthorization")
  }

  private func processTransition(_ nextState: String) {
    guard isWithinActiveShift(now: Date(), includeBuffer: false, reason: "transition \(nextState)") else {
      log("transition ignored: shift is not active")
      return
    }
    guard defaults.string(forKey: "waqty.geofence.presence") != nextState else {
      log("transition ignored: duplicate state \(nextState)")
      return
    }
    defaults.set(nextState, forKey: "waqty.geofence.presence")
    defaults.set(nextState == "inside_branch" ? "enter" : "exit", forKey: "waqty.geofence.last_transition")
    defaults.set(ISO8601DateFormatter().string(from: Date()), forKey: "waqty.geofence.last_transition_at")
    var pending = defaults.array(forKey: "waqty.geofence.pending_events") as? [[String: Any]] ?? []
    pending.append(["branch_uuid": defaults.string(forKey: "waqty.geofence.branch_uuid") ?? "", "event": nextState == "inside_branch" ? "enter" : "exit", "occurred_at": ISO8601DateFormatter().string(from: Date()), "source": "ios_region_monitoring"])
    defaults.set(pending, forKey: "waqty.geofence.pending_events")
    showNotification(state: nextState, isDebugTest: false)
  }

  private func showNotification(state: String, isDebugTest: Bool) {
    let english = defaults.string(forKey: "waqty.geofence.language") == "en"
    let inside = state == "inside_branch"
    let title = inside ? (english ? "You are now inside the branch area" : "أنت الآن داخل نطاق الفرع") : (english ? "You are now outside the branch area" : "أنت الآن خارج نطاق الفرع")
    let body = inside ? (english ? "Your presence inside \(branchName) has been verified." : "تم التحقق من وجودك داخل نطاق فرع \(branchName).") : (english ? "You have left the \(branchName) branch area." : "غادرت نطاق فرع \(branchName).")
    let content = UNMutableNotificationContent()
    content.title = title
    content.body = body
    content.sound = .default
    let identifier = "waqty-geofence-\(UUID().uuidString)"
    UNUserNotificationCenter.current().add(UNNotificationRequest(identifier: identifier, content: content, trigger: nil)) { [weak self] error in
      if let error { self?.log("notification scheduling failed id=\(identifier) error=\(error.localizedDescription)") }
      else if isDebugTest { self?.log("WAQTY_DEBUG_EXIT_NOTIFICATION_SCHEDULED") }
      else if !inside { self?.log("WAQTY_EXIT_NOTIFICATION_SCHEDULED") }
      else { self?.log("WAQTY_ENTER_NOTIFICATION_SCHEDULED") }
    }
  }

  private func log(_ message: String) { print("WAQTY_GEOFENCE \(message)") }

  private func logAuthorization(_ source: String) {
    let status = CLLocationManager.authorizationStatus()
    let value: String
    switch status {
    case .authorizedAlways: value = "authorizedAlways"
    case .authorizedWhenInUse: value = "authorizedWhenInUse"
    case .denied: value = "denied"
    case .restricted: value = "restricted"
    case .notDetermined: value = "notDetermined"
    @unknown default: value = "unknown"
    }
    log("authorization source=\(source) status=\(value)")
  }

  private func logLocationServices(_ source: String) { log("locationServices source=\(source) enabled=\(CLLocationManager.locationServicesEnabled())") }

  private func logNotificationPermission(_ source: String) {
    UNUserNotificationCenter.current().getNotificationSettings { [weak self] settings in
      self?.log("notificationPermission source=\(source) status=\(settings.authorizationStatus.rawValue) alert=\(settings.alertSetting.rawValue)")
    }
  }

  private func logRegion(_ source: String, _ region: CLCircularRegion) { log("region source=\(source) id=\(region.identifier) center=\(region.center.latitude),\(region.center.longitude) radius=\(region.radius) notifyOnEntry=\(region.notifyOnEntry) notifyOnExit=\(region.notifyOnExit)") }

  private func logRegionCallback(_ source: String, _ region: CLRegion) {
    if let circular = region as? CLCircularRegion { logRegion(source, circular) }
    else { log("region callback source=\(source) id=\(region.identifier)") }
  }

  private func logMonitoredRegions(_ source: String) {
    let regions = manager.monitoredRegions
    let ids = regions.map { $0.identifier }.sorted()
    log("monitoredRegions source=\(source) count=\(ids.count) ids=\(ids.joined(separator: ",")) expected=\(ids.contains(regionId))")
    for region in regions {
      if let circular = region as? CLCircularRegion {
        logRegion("monitored", circular)
      }
    }
  }

  private func logShiftDecision(now: Date, reason: String, active: Bool, detail: String) {
    let formatter = ISO8601DateFormatter()
    let count = (defaults.array(forKey: "waqty.geofence.schedule") as? [[String: Any]])?.count ?? 0
    log("shiftCheck reason=\(reason) now=\(formatter.string(from: now)) timezone=\(timezone.identifier) active=\(active) detail=\(detail) cacheScheduleCount=\(count)")
  }
}
