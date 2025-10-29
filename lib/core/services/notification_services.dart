// ignore_for_file: avoid_print

import 'dart:convert';
import 'dart:io';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:girl_clan/server_key.dart';
import 'package:http/http.dart' as http;

/// ------------------------------------------------------------
/// 🧱 CLASS: NotificationServices
/// ------------------------------------------------------------
/// Handles Firebase Cloud Messaging (FCM) + Local Notifications
/// Includes:
///   ✅ Permission request
///   ✅ Local notifications setup
///   ✅ FCM message handling (foreground, background, openedApp)
///   ✅ Token fetching
/// ------------------------------------------------------------
class NotificationServices {
  final FirebaseMessaging _firebaseMessaging = FirebaseMessaging.instance;
  final FlutterLocalNotificationsPlugin _localNotificationsPlugin =
      FlutterLocalNotificationsPlugin();
  String? _serverKey;

  /// ------------------------------------------------------------
  /// 🚀 INIT METHOD — call this once (e.g., in main.dart)
  /// ------------------------------------------------------------
  Future<void> initNotification() async {
    print("🔧 Initializing Notification Services...");
    await _requestPermission();
    await _initLocalNotifications();
    await _configureFCMListeners();

    final fcmToken = await _firebaseMessaging.getToken();
    _serverKey = await GetServerKey().serverKeyToken(); // ✅ FIX HERE

    print("@NotificationServices: FCM Token => $fcmToken");
    print("@NotificationServices: server Token  => $_serverKey");
  }

  // ===========================================================================
  // 🟦 PART 1: PERMISSION HANDLING
  // ===========================================================================
  Future<void> _requestPermission() async {
    print("🟨 Requesting notification permissions...");

    NotificationSettings settings = await _firebaseMessaging.requestPermission(
      alert: true,
      badge: true,
      sound: true,
      provisional: false,
      announcement: false,
    );

    if (settings.authorizationStatus == AuthorizationStatus.denied) {
      print("🔴 User denied notification permission");
    } else if (settings.authorizationStatus == AuthorizationStatus.authorized) {
      print("🟢 User granted notification permission");
    } else {
      print("🟡 Permission status: ${settings.authorizationStatus}");
    }

    // iOS foreground behavior (show alert/sound even when app open)
    if (Platform.isIOS) {
      await _firebaseMessaging.setForegroundNotificationPresentationOptions(
        alert: true,
        badge: true,
        sound: true,
      );
      print("🍏 iOS foreground notification options set");
    }
  }

  // ===========================================================================
  // 🟩 PART 2: LOCAL NOTIFICATION INITIALIZATION
  // ===========================================================================
  Future<void> _initLocalNotifications() async {
    print("📦 Initializing local notifications...");

    const AndroidInitializationSettings androidSettings =
        AndroidInitializationSettings('@mipmap/ic_launcher');

    const DarwinInitializationSettings iosSettings =
        DarwinInitializationSettings();

    const InitializationSettings initSettings = InitializationSettings(
      android: androidSettings,
      iOS: iosSettings,
    );

    await _localNotificationsPlugin.initialize(initSettings);
    print("✅ Local notifications initialized successfully");
  }

  // ===========================================================================
  // 🟪 PART 3: FCM CONFIGURATION (LISTENERS)
  // ===========================================================================
  Future<void> _configureFCMListeners() async {
    print("🔔 Configuring FCM message listeners...");

    // 🔹 When app is in foreground
    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      print("📩 Foreground message received: ${message.notification?.title}");
      _showLocalNotification(message);
    });

    // 🔹 When app is in background or terminated
    FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);

    // 🔹 When user taps the notification and opens the app
    FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) {
      print("📬 Notification opened by user: ${message.notification?.title}");
    });

    print("✅ FCM listeners configured");
  }

  // ===========================================================================
  // 🟥 PART 4: LOCAL NOTIFICATION DISPLAY
  // ===========================================================================
  Future<void> _showLocalNotification(RemoteMessage message) async {
    print("📲 Displaying local notification...");

    const AndroidNotificationDetails androidDetails =
        AndroidNotificationDetails(
          'default_channel_id', // Channel ID (unique per app)
          'General Notifications', // Channel Name (visible to user)
          channelDescription: 'Used for general app notifications',
          importance: Importance.max,
          priority: Priority.high,
          icon: '@mipmap/ic_launcher',
        );

    const NotificationDetails notificationDetails = NotificationDetails(
      android: androidDetails,
    );

    await _localNotificationsPlugin.show(
      message.hashCode,
      message.notification?.title ?? 'No Title',
      message.notification?.body ?? 'No Body',
      notificationDetails,
    );

    print("✅ Local notification displayed");
  }

  // ===========================================================================
  // 🟨 PART 5: FETCH USER FCM TOKEN (PUBLIC USE)
  // ===========================================================================
  Future<String?> getFcmToken() async {
    final token = await _firebaseMessaging.getToken();
    print("🔑 Current user FCM Token: $token");
    return token;
  }

  // ===========================================================================
  // 🟧 PART 6: DELETE TOKEN (OPTIONAL)
  // ===========================================================================
  Future<void> deleteFcmToken() async {
    await _firebaseMessaging.deleteToken();
    print("🗑️ FCM Token deleted");
  }
}

/// ------------------------------------------------------------
/// 🟫 TOP-LEVEL HANDLER — Runs when app is in background/terminated
/// ------------------------------------------------------------
@pragma('vm:entry-point')
Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  print("🌙 Handling background message...");
  print("🔸 Title: ${message.notification?.title}");
  print("🔹 Body: ${message.notification?.body}");
}

/// ------------------------------------------------------------
/// 📦 CLASS: SendNotificationService
/// ------------------------------------------------------------
/// This class is used to send push notifications via Firebase Cloud Messaging (FCM)
/// directly from your Flutter app using your Firebase server key.
///
/// Use Cases:
/// ✅ Notify host when someone joins an event
/// ✅ Notify user when host accepts/declines request
/// ✅ Notify all users when event ends
/// ------------------------------------------------------------
class SendNotificationService {
  // 🔑 Your Firebase Server Key (get it from Firebase Console)
  static const String _serverKey =
      'ya29.c.c0ASRK0GYO4nTb2cSKw01baQynqXJ98RWvDe4jgRrBpWjx1jlrXBfhZfGTZ1Q4vYnkfbStw-I-KN0IsedvlBrvvVHQ2WzMrREwf6faaZG13zEMC_Ks703wJK27qiShtLk36bu4JO4YvblYDsLPjXTFRrvPOV7CPx-XljJbcIVjs9PzdQr6fsRfknxTJtQrOAjiQzbmZcjYKgtcfS0Yg3UBdOKopYzs7n5ykLdvuDyRi6sCuVG7dnSdB2L0J6nlklfVMdPc4HHB701DFnxbwkeB7gjMyqidTx3wtFjObpEMJSBt4rEDS18p2ogDJ2zAEalA07nOXFXMIcfuuDXkVVy5_ugnt7RVUqY6Qqg7QU5n5UDrBcv3S_o_tYlDAdgM6wL391PRaIYeY3UYilhMxbqg-tjuIajj12MVfIgk70slS9ytgactueVc9OXR3d-byfRpW7dsQFWZ3iXVUJRemXIds8iF4odZ4w5vFjXuJcesjJfz3QjbbOx414njeJ4_xmeVambRcXyQlethxkO097JbgnZ16pamYitg3jSWeti7eppsgt9h7bYvcncdZ4-bi7VXow-zt2_YRnWi-I9mq8i8qa8g3J6lpsppMpn_uOu6Jxh3_2p6_ck6OXy4Ixwc0Vy9cqfFke8eZemuI-Uqxh5sW8tXFhFVBjefJ1RtWWJudU3u-J8M3RSif9Sjff83o2l5wcamoXdMkjggBX-v3d_3J2w2ftU2VqpRhJbug1Mt5zr-cBiSfd0FgyUU0FaJilQB5wkFSn-_i5-e1wa1Ysg7XS6My1qfXJwukVg7MIrigYzQ04j52_F_90UiRahV3WzUVmOaYI7iyveeu3sJw4eeYcxdI4b5bzqdbuprju8Q3mWf6I5sSz-9h49Y6VM_Ifs-p5dSz2WJtgwtFBZYQnw1lrWyW9zhYgXdla0qm7jMI9xee2xM-2w9Z3w_WwtZ_edSSyo-vwO4n5dxv1';

  /// ------------------------------------------------------------
  /// 📬 Send notification to a specific user by their FCM token
  /// ------------------------------------------------------------
  static Future<void> sendToUser({
    required String token,
    required String title,
    required String body,
    Map<String, dynamic>? data,
  }) async {
    try {
      final response = await http.post(
        Uri.parse('https://fcm.googleapis.com/fcm/send'),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'key=$_serverKey',
        },
        body: jsonEncode({
          'to': token,
          'notification': {'title': title, 'body': body, 'sound': 'default'},
          'data': data ?? {},
        }),
      );

      if (response.statusCode == 200) {
        print("✅ Notification sent successfully to token: $token");
      } else {
        print("🔴 Failed to send notification: ${response.body}");
      }
    } catch (e) {
      print("⚠️ Error sending notification: $e");
    }
  }

  /// ------------------------------------------------------------
  /// 📣 Send notification to multiple users (bulk)
  /// ------------------------------------------------------------
  static Future<void> sendToMultiple({
    required List<String> tokens,
    required String title,
    required String body,
    Map<String, dynamic>? data,
  }) async {
    try {
      final response = await http.post(
        Uri.parse('https://fcm.googleapis.com/fcm/send'),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'key=$_serverKey',
        },
        body: jsonEncode({
          'registration_ids': tokens,
          'notification': {'title': title, 'body': body, 'sound': 'default'},
          'data': data ?? {},
        }),
      );

      if (response.statusCode == 200) {
        print("✅ Notification sent successfully to ${tokens.length} users");
      } else {
        print("🔴 Failed to send notifications: ${response.body}");
      }
    } catch (e) {
      print("⚠️ Error sending notifications: $e");
    }
  }
}
