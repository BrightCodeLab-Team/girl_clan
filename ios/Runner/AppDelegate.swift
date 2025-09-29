import UIKit
import Flutter
import GoogleMaps   // Google Maps ke liye
import FirebaseCore // 👈 Firebase ke liye

@main
@objc class AppDelegate: FlutterAppDelegate {
  override func application(
    _ application: UIApplication,
    didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?
  ) -> Bool {
    
    // Google Maps API key
    GMSServices.provideAPIKey("AIzaSyCAqWhbapoh7Z_RlH4pJWZDvhMQNL_75jQ")
    
    // 👇 Firebase initialization
    FirebaseApp.configure()
    
    GeneratedPluginRegistrant.register(with: self)
    return super.application(application, didFinishLaunchingWithOptions: launchOptions)
  }
}
