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
    return super.application(application, didFinishLaunchingWithOptions: launchOptions)
  }

  func didInitializeImplicitFlutterEngine(_ engineBridge: FlutterImplicitEngineBridge) {
    GeneratedPluginRegistrant.register(with: engineBridge.pluginRegistry)
    let registrar = engineBridge.pluginRegistry.registrar(forPlugin: "BranchGeofenceManager")
    let channel = FlutterMethodChannel(name: "waqty/geofence", binaryMessenger: registrar!.messenger())
    branchGeofenceManager = BranchGeofenceManager(channel: channel)
    branchGeofenceManager?.reevaluate()
  }

  override func applicationDidBecomeActive(_ application: UIApplication) {
    super.applicationDidBecomeActive(application)
    branchGeofenceManager?.reevaluate()
  }
}

private final class BranchGeofenceManager: NSObject, CLLocationManagerDelegate {
  private let channel: FlutterMethodChannel
  private let manager = CLLocationManager()
  private let defaults = UserDefaults.standard
  private let regionId = "waqty.assigned.branch"
  private let bufferMinutes: TimeInterval = 15 * 60

  private var branchName: String { defaults.string(forKey: "waqty.geofence.branch_name") ?? "" }
  private var timezone: TimeZone {
    if let value = defaults.string(forKey: "waqty.geofence.timezone"), let zone = TimeZone(identifier: value) {
      return zone
    }
    return .current
  }

  init(channel: FlutterMethodChannel) {
    self.channel = channel
    super.init()
    manager.delegate = self
    manager.pausesLocationUpdatesAutomatically = true
    channel.setMethodCallHandler { [weak self] call, result in
      self?.handle(call, result: result)
    }
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
      if let zone = args["timezone"] as? String, !zone.isEmpty {
        defaults.set(zone, forKey: "waqty.geofence.timezone")
      }
      requestAlwaysIfNeeded()
      reevaluate()
      result(true)
    case "updateSchedule":
      guard let args = call.arguments as? [String: Any] else {
        result(FlutterError(code: "INVALID_SCHEDULE", message: "Missing schedule", details: nil))
        return
      }
      defaults.set(args["schedule"] as? [[String: Any]] ?? [], forKey: "waqty.geofence.schedule")
      if let zone = args["timezone"] as? String, !zone.isEmpty {
        defaults.set(zone, forKey: "waqty.geofence.timezone")
      }
      reevaluate()
      result(nil)
    case "clear":
      stopMonitoring()
      [
        "waqty.geofence.branch_uuid", "waqty.geofence.branch_name",
        "waqty.geofence.latitude", "waqty.geofence.longitude",
        "waqty.geofence.radius", "waqty.geofence.language",
        "waqty.geofence.timezone", "waqty.geofence.schedule",
        "waqty.geofence.presence", "waqty.geofence.last_transition",
        "waqty.geofence.last_transition_at", "waqty.geofence.pending_events"
      ].forEach { defaults.removeObject(forKey: $0) }
      result(nil)
    case "requestAlwaysPermission":
      requestAlwaysIfNeeded()
      result(nil)
    default:
      result(FlutterMethodNotImplemented)
    }
  }

  func reevaluate() {
    guard CLLocationManager.isMonitoringAvailable(for: CLCircularRegion.self),
          CLLocationManager.locationServicesEnabled(),
          CLLocationManager.authorizationStatus() == .authorizedAlways,
          let region = configuredRegion() else {
      stopMonitoring()
      return
    }
    if isWithinActiveShift() {
      stopMonitoring()
      manager.startMonitoring(for: region)
    } else {
      stopMonitoring()
    }
  }

  private func requestAlwaysIfNeeded() {
    let status = CLLocationManager.authorizationStatus()
    if status == .notDetermined || status == .authorizedWhenInUse {
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
  }

  private func isWithinActiveShift(now: Date = Date(), includeBuffer: Bool = true) -> Bool {
    guard let schedule = defaults.array(forKey: "waqty.geofence.schedule") as? [[String: Any]] else { return false }
    let calendar = Calendar(identifier: .gregorian)
    let formatter = DateFormatter()
    formatter.calendar = calendar
    formatter.timeZone = timezone
    formatter.dateFormat = "yyyy-MM-dd H:mm"
    let nowInZone = now
    for item in schedule {
      guard let date = item["date"] as? String,
            let start = item["start"] as? String,
            let end = item["end"] as? String,
            let startDate = formatter.date(from: "\(date) \(start)"),
            var endDate = formatter.date(from: "\(date) \(end)") else { continue }
      if endDate <= startDate { endDate = calendar.date(byAdding: .day, value: 1, to: endDate) ?? endDate }
      let activeStart = includeBuffer ? startDate.addingTimeInterval(-bufferMinutes) : startDate
      if nowInZone >= activeStart && nowInZone < endDate { return true }
    }
    return false
  }

  func locationManager(_ manager: CLLocationManager, didEnterRegion region: CLRegion) {
    processTransition("inside_branch")
  }

  func locationManager(_ manager: CLLocationManager, didExitRegion region: CLRegion) {
    processTransition("outside_branch")
  }

  private func processTransition(_ nextState: String) {
    guard isInsideActiveShift(), defaults.string(forKey: "waqty.geofence.presence") != nextState else { return }
    defaults.set(nextState, forKey: "waqty.geofence.presence")
    defaults.set(nextState == "inside_branch" ? "enter" : "exit", forKey: "waqty.geofence.last_transition")
    defaults.set(ISO8601DateFormatter().string(from: Date()), forKey: "waqty.geofence.last_transition_at")
    var pending = defaults.array(forKey: "waqty.geofence.pending_events") as? [[String: Any]] ?? []
    pending.append([
      "branch_uuid": defaults.string(forKey: "waqty.geofence.branch_uuid") ?? "",
      "event": nextState == "inside_branch" ? "enter" : "exit",
      "occurred_at": ISO8601DateFormatter().string(from: Date()),
      "source": "ios_region_monitoring"
    ])
    defaults.set(pending, forKey: "waqty.geofence.pending_events")
    showNotification(state: nextState)
  }

  private func isInsideActiveShift(now: Date = Date()) -> Bool {
    isWithinActiveShift(now: now, includeBuffer: false)
  }

  private func showNotification(state: String) {
    let english = defaults.string(forKey: "waqty.geofence.language") == "en"
    let inside = state == "inside_branch"
    let title = inside
      ? (english ? "You are now inside the branch area" : "أنت الآن داخل نطاق الفرع")
      : (english ? "You are now outside the branch area" : "أنت الآن خارج نطاق الفرع")
    let body = inside
      ? (english ? "Your presence inside \(branchName) has been verified." : "تم التحقق من وجودك داخل نطاق فرع \(branchName).")
      : (english ? "You have left the \(branchName) branch area." : "غادرت نطاق فرع \(branchName).")
    let content = UNMutableNotificationContent()
    content.title = title
    content.body = body
    content.sound = .default
    UNUserNotificationCenter.current().add(UNNotificationRequest(identifier: "waqty-geofence-\(UUID().uuidString)", content: content, trigger: nil))
  }
}
