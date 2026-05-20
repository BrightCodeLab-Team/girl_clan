import UIKit
import Flutter
import GoogleMaps
import FirebaseCore
import FirebaseMessaging
import flutter_local_notifications

@main
@objc class AppDelegate: FlutterAppDelegate {
  override func application(
    _ application: UIApplication,
    didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?
  ) -> Bool {

    // ✅ Initialize Firebase
    FirebaseApp.configure()

    // ✅ Set Firebase Messaging delegate
    Messaging.messaging().delegate = self

    // ✅ Register for remote notifications (iOS push)
    UNUserNotificationCenter.current().delegate = self
    application.registerForRemoteNotifications()

    // ✅ Provide Google Maps API Key
    GMSServices.provideAPIKey("AIzaSyCAqWhbapoh7Z_RlH4pJWZDvhMQNL_75jQ")

    // ✅ Initialize Flutter Local Notifications (background support)
    FlutterLocalNotificationsPlugin.setPluginRegistrantCallback { registry in
      GeneratedPluginRegistrant.register(with: registry)
    }

    // ✅ Register Flutter plugins
    GeneratedPluginRegistrant.register(with: self)

    return super.application(application, didFinishLaunchingWithOptions: launchOptions)
  }

  // ✅ (Optional) Log APNs token for debugging
  override func application(
    _ application: UIApplication,
    didRegisterForRemoteNotificationsWithDeviceToken deviceToken: Data
  ) {
    Messaging.messaging().apnsToken = deviceToken
    let tokenParts = deviceToken.map { data in String(format: "%02.2hhx", data) }
    let token = tokenParts.joined()
    print("📱 APNs Token: \(token)")
  }
}

// ✅ Firebase Messaging delegate extension
extension AppDelegate: MessagingDelegate {
  func messaging(_ messaging: Messaging, didReceiveRegistrationToken fcmToken: String?) {
    print("🔥 Firebase FCM Token: \(fcmToken ?? "")")
  }
}
