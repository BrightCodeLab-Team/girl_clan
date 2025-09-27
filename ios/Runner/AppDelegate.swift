import UIKit
import Flutter
import GoogleMaps   // 👈 Ye import zaroori hai

@main
@objc class AppDelegate: FlutterAppDelegate {
  override func application(
    _ application: UIApplication,
    didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?
  ) -> Bool {
    
    // 👇 Yahan per apni Google Maps API key add karein
    GMSServices.provideAPIKey("AIzaSyCAqWhbapoh7Z_RlH4pJWZDvhMQNL_75jQ")

    GeneratedPluginRegistrant.register(with: self)
    return super.application(application, didFinishLaunchingWithOptions: launchOptions)
  }
}
