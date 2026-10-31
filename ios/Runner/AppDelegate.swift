import Flutter
import Measure
import UIKit
import UserNotifications

@main
@objc class AppDelegate: FlutterAppDelegate, FlutterImplicitEngineDelegate {
  override func application(
    _ application: UIApplication,
    didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?
  ) -> Bool {
    // Lets parking reminders show while the app is open.
    UNUserNotificationCenter.current().delegate = self
    startMeasureIfConfigured()
    return super.application(application, didFinishLaunchingWithOptions: launchOptions)
  }

  func didInitializeImplicitFlutterEngine(_ engineBridge: FlutterImplicitEngineBridge) {
    GeneratedPluginRegistrant.register(with: engineBridge.pluginRegistry)
  }

  /// Measure (measure.sh) starts only when ios/Flutter/Secrets.xcconfig provides
  /// credentials; otherwise the app keeps its own local diagnostics.
  private func startMeasureIfConfigured() {
    guard
      let key = Bundle.main.object(forInfoDictionaryKey: "MeasureApiKey") as? String,
      let url = Bundle.main.object(forInfoDictionaryKey: "MeasureApiUrl") as? String,
      !key.isEmpty, !url.isEmpty, !key.hasPrefix("$(")
    else { return }
    Measure.initialize(with: ClientInfo(apiKey: key, apiUrl: url), config: BaseMeasureConfig())
  }
}
