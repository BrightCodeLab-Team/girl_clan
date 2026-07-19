// ignore_for_file: avoid_print

import 'dart:convert';
import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:girl_clan/firebase_options.dart';
import 'package:girl_clan/server_key.dart';
import 'package:http/http.dart' as http;

const String _usersCollection = 'app-user';
const String _fcmTokenField = 'fcmToken';

@pragma('vm:entry-point')
Future<void> firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  print('Background FCM: ${message.notification?.title}');
}

class NotificationServices {
  final FirebaseMessaging _firebaseMessaging = FirebaseMessaging.instance;
  final FlutterLocalNotificationsPlugin _localNotificationsPlugin =
      FlutterLocalNotificationsPlugin();
  final FirebaseFirestore _db = FirebaseFirestore.instance;

  Future<void> initNotification() async {
    await _requestPermission();
    await _initLocalNotifications();
    await _configureFCMListeners();
    await saveFcmTokenToFirestore();

    _firebaseMessaging.onTokenRefresh.listen((token) async {
      await _persistToken(token);
    });
  }

  Future<void> _requestPermission() async {
    final settings = await _firebaseMessaging.requestPermission(
      alert: true,
      badge: true,
      sound: true,
      provisional: false,
      announcement: false,
    );

    if (settings.authorizationStatus == AuthorizationStatus.denied) {
      print('Notification permission denied');
    }

    if (Platform.isIOS) {
      await _firebaseMessaging.setForegroundNotificationPresentationOptions(
        alert: true,
        badge: true,
        sound: true,
      );
    }
  }

  Future<void> _initLocalNotifications() async {
    const androidSettings = AndroidInitializationSettings(
      '@mipmap/launcher_icon',
    );
    const iosSettings = DarwinInitializationSettings();
    const initSettings = InitializationSettings(
      android: androidSettings,
      iOS: iosSettings,
    );
    await _localNotificationsPlugin.initialize(initSettings);

    final androidPlugin =
        _localNotificationsPlugin
            .resolvePlatformSpecificImplementation<
              AndroidFlutterLocalNotificationsPlugin
            >();
    await androidPlugin?.createNotificationChannel(
      const AndroidNotificationChannel(
        'default_channel_id',
        'General Notifications',
        description: 'Used for general app notifications',
        importance: Importance.max,
      ),
    );
  }

  Future<void> _configureFCMListeners() async {
    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      _showLocalNotification(message);
    });

    FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) {
      print('Notification opened: ${message.notification?.title}');
    });
  }

  Future<void> _showLocalNotification(RemoteMessage message) async {
    const androidDetails = AndroidNotificationDetails(
      'default_channel_id',
      'General Notifications',
      channelDescription: 'Used for general app notifications',
      importance: Importance.max,
      priority: Priority.high,
      icon: '@mipmap/launcher_icon',
    );

    const notificationDetails = NotificationDetails(
      android: androidDetails,
      iOS: DarwinNotificationDetails(),
    );

    await _localNotificationsPlugin.show(
      message.hashCode,
      message.notification?.title ?? 'Girl Clan',
      message.notification?.body ?? '',
      notificationDetails,
    );
  }

  Future<String?> getFcmToken() async {
    return _firebaseMessaging.getToken();
  }

  /// Saves current device FCM token to `app-user/{uid}` so others can notify this user.
  Future<void> saveFcmTokenToFirestore() async {
    final uid = FirebaseAuth.instance.currentUser?.uid;
    if (uid == null) return;

    final token = await _firebaseMessaging.getToken();
    if (token == null || token.isEmpty) return;

    await _persistToken(token);
  }

  Future<void> _persistToken(String token) async {
    final uid = FirebaseAuth.instance.currentUser?.uid;
    if (uid == null) return;

    try {
      await _db.collection(_usersCollection).doc(uid).set({
        _fcmTokenField: token,
        'fcmTokenUpdatedAt': FieldValue.serverTimestamp(),
      }, SetOptions(merge: true));
      print('FCM token saved for $uid');
    } catch (e) {
      print('Failed to save FCM token: $e');
    }
  }

  Future<void> deleteFcmToken() async {
    final uid = FirebaseAuth.instance.currentUser?.uid;
    if (uid != null) {
      try {
        await _db.collection(_usersCollection).doc(uid).set({
          _fcmTokenField: FieldValue.delete(),
        }, SetOptions(merge: true));
      } catch (_) {}
    }
    await _firebaseMessaging.deleteToken();
  }

  Future<String?> getUserFcmToken(String userId) async {
    if (userId.isEmpty) return null;
    final doc = await _db.collection(_usersCollection).doc(userId).get();
    final token = doc.data()?[_fcmTokenField];
    return token is String && token.isNotEmpty ? token : null;
  }

  /// Notify another user by their Firestore uid.
  Future<void> sendNotificationToUser({
    required String receiverId,
    required String title,
    required String body,
    Map<String, String>? data,
  }) async {
    final token = await getUserFcmToken(receiverId);
    if (token == null) {
      print('No FCM token for user $receiverId');
      return;
    }
    await SendNotificationService.sendToUser(
      token: token,
      title: title,
      body: body,
      data: data,
    );
  }
}

class SendNotificationService {
  static const String _projectId = 'event-app-d66c5';
  static final GetServerKey _serverKey = GetServerKey();

  static Future<void> sendToUser({
    required String token,
    required String title,
    required String body,
    Map<String, String>? data,
  }) async {
    try {
      final accessToken = await _serverKey.serverKeyToken();
      final response = await http.post(
        Uri.parse(
          'https://fcm.googleapis.com/v1/projects/$_projectId/messages:send',
        ),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $accessToken',
        },
        body: jsonEncode({
          'message': {
            'token': token,
            'notification': {'title': title, 'body': body},
            'data': data ?? {},
            'android': {
              'priority': 'high',
              'notification': {
                'channel_id': 'default_channel_id',
                'sound': 'default',
              },
            },
            'apns': {
              'payload': {
                'aps': {'sound': 'default'},
              },
            },
          },
        }),
      );

      if (response.statusCode == 200) {
        print('Notification sent');
      } else {
        print('Failed to send notification: ${response.statusCode} ${response.body}');
      }
    } catch (e) {
      print('Error sending notification: $e');
    }
  }

  static Future<void> sendToMultiple({
    required List<String> tokens,
    required String title,
    required String body,
    Map<String, String>? data,
  }) async {
    for (final token in tokens) {
      if (token.isEmpty) continue;
      await sendToUser(
        token: token,
        title: title,
        body: body,
        data: data,
      );
    }
  }
}
