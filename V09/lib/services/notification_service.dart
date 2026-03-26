import 'dart:convert';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

/// ═══════════════════════════════════════════════════════════════════
/// 🔔 PUSH NOTIFICATION SERVICE
/// ═══════════════════════════════════════════════════════════════════
///
/// Handles:
/// - Push notification permissions
/// - FCM token management
/// - Local notifications
/// - Background message handling

class NotificationService {
  static final NotificationService _instance = NotificationService._internal();
  factory NotificationService() => _instance;
  NotificationService._internal();

  final FirebaseMessaging _fcm = FirebaseMessaging.instance;
  final FlutterLocalNotificationsPlugin _localNotifications = FlutterLocalNotificationsPlugin();

  String? _fcmToken;
  Function(RemoteMessage)? _onMessageCallback;
  Function(RemoteMessage)? _onMessageOpenedAppCallback;

  // ═══════════════════════════════════════════════════════════════════
  // 🚀 INITIALIZATION
  // ═══════════════════════════════════════════════════════════════════
  Future<void> initialize({
    Function(RemoteMessage)? onMessage,
    Function(RemoteMessage)? onMessageOpenedApp,
  }) async {
    _onMessageCallback = onMessage;
    _onMessageOpenedAppCallback = onMessageOpenedApp;

    // Request permissions (iOS mainly)
    await _requestPermissions();

    // Get FCM token
    await _getToken();

    // Listen to token refresh
    _fcm.onTokenRefresh.listen(_onTokenRefresh);

    // Initialize local notifications
    await _initLocalNotifications();

    // Handle foreground messages
    FirebaseMessaging.onMessage.listen(_handleForegroundMessage);

    // Handle background/terminated messages when app opened
    FirebaseMessaging.onMessageOpenedApp.listen(_handleMessageOpenedApp);

    // Check if app was opened from terminated state
    RemoteMessage? initialMessage = await _fcm.getInitialMessage();
    if (initialMessage != null) {
      _handleMessageOpenedApp(initialMessage);
    }

    debugPrint('✅ Notification Service initialized');
  }

  // ═══════════════════════════════════════════════════════════════════
  // 🔐 PERMISSIONS
  // ═══════════════════════════════════════════════════════════════════
  Future<void> _requestPermissions() async {
    NotificationSettings settings = await _fcm.requestPermission(
      alert: true,
      badge: true,
      sound: true,
      provisional: false,
    );

    debugPrint('🔔 Notification permission: ${settings.authorizationStatus}');
  }

  // ═══════════════════════════════════════════════════════════════════
  // 🎫 FCM TOKEN
  // ═══════════════════════════════════════════════════════════════════
  Future<void> _getToken() async {
    try {
      _fcmToken = await _fcm.getToken();
      debugPrint('🎫 FCM Token: $_fcmToken');
    } catch (e) {
      debugPrint('❌ Error getting FCM token: $e');
    }
  }

  void _onTokenRefresh(String token) {
    _fcmToken = token;
    debugPrint('🔄 FCM Token refreshed: $token');
    // TODO: Send new token to your server
  }

  String? get fcmToken => _fcmToken;

  // ═══════════════════════════════════════════════════════════════════
  // 📱 LOCAL NOTIFICATIONS
  // ═══════════════════════════════════════════════════════════════════
  Future<void> _initLocalNotifications() async {
    const AndroidInitializationSettings androidSettings =
        AndroidInitializationSettings('@mipmap/ic_launcher');

    const InitializationSettings initSettings = InitializationSettings(
      android: androidSettings,
    );

    await _localNotifications.initialize(
      initSettings,
      onDidReceiveNotificationResponse: _onLocalNotificationTap,
    );
  }

  void _onLocalNotificationTap(NotificationResponse response) {
    debugPrint('📱 Local notification tapped: ${response.payload}');
  }

  // Show local notification
  Future<void> showLocalNotification({
    required String title,
    required String body,
    String? payload,
  }) async {
    const AndroidNotificationDetails androidDetails = AndroidNotificationDetails(
      'spend_the_money_channel',
      'Spend The Money Notifications',
      channelDescription: 'Notifications for game events and offers',
      importance: Importance.high,
      priority: Priority.high,
      showWhen: true,
      enableVibration: true,
      playSound: true,
    );

    const NotificationDetails details = NotificationDetails(android: androidDetails);

    await _localNotifications.show(
      DateTime.now().millisecond,
      title,
      body,
      details,
      payload: payload,
    );
  }

  // ═══════════════════════════════════════════════════════════════════
  // 📨 MESSAGE HANDLERS
  // ═══════════════════════════════════════════════════════════════════
  void _handleForegroundMessage(RemoteMessage message) {
    debugPrint('📨 Foreground message received:');
    debugPrint('  Title: ${message.notification?.title}');
    debugPrint('  Body: ${message.notification?.body}');
    debugPrint('  Data: ${message.data}');

    // Show local notification
    if (message.notification != null) {
      showLocalNotification(
        title: message.notification!.title ?? 'Spend The Money',
        body: message.notification!.body ?? '',
        payload: jsonEncode(message.data),
      );
    }

    _onMessageCallback?.call(message);
  }

  void _handleMessageOpenedApp(RemoteMessage message) {
    debugPrint('📨 Message opened app:');
    debugPrint('  Data: ${message.data}');

    _onMessageOpenedAppCallback?.call(message);
  }

  // ═══════════════════════════════════════════════════════════════════
  // 🎯 SUBSCRIPTION TOPICS
  // ═══════════════════════════════════════════════════════════════════
  Future<void> subscribeToTopic(String topic) async {
    await _fcm.subscribeToTopic(topic);
    debugPrint('✅ Subscribed to topic: $topic');
  }

  Future<void> unsubscribeFromTopic(String topic) async {
    await _fcm.unsubscribeFromTopic(topic);
    debugPrint('✅ Unsubscribed from topic: $topic');
  }

  // Predefined topics for user segmentation
  Future<void> subscribeToUserTopics({
    required String country,
    required bool adsEnabled,
    required String budget,
  }) async {
    await subscribeToTopic('all_users');
    await subscribeToTopic('country_$country');
    await subscribeToTopic(adsEnabled ? 'ads_enabled' : 'ads_disabled');
    await subscribeToTopic('budget_$budget');
  }

  // ═══════════════════════════════════════════════════════════════════
  // 🔔 NOTIFICATION TYPES (Templates)
  // ═══════════════════════════════════════════════════════════════════
  Future<void> showBudgetReminder({
    required double remainingBudget,
    required double initialBudget,
    required double percentageSpent,
  }) async {
    final spent = initialBudget - remainingBudget;
    final percent = (spent / initialBudget * 100).toStringAsFixed(1);

    await showLocalNotification(
      title: '🎉 Spending Update!',
      body: 'You\'ve spent \$${spent.toStringAsFixed(0)} ($percent%) of your budget. Keep shopping!',
    );
  }

  Future<void> showAchievementNotification({
    required String achievement,
    required String description,
  }) async {
    await showLocalNotification(
      title: '🏆 Achievement Unlocked!',
      body: '$achievement: $description',
    );
  }

  Future<void> showComeBackReminder() async {
    await showLocalNotification(
      title: '💰 Come Back and Spend!',
      body: 'Your \$100 billion is waiting. Buy something awesome today!',
    );
  }

  // ═══════════════════════════════════════════════════════════════════
  // 🧹 CLEANUP
  // ═══════════════════════════════════════════════════════════════════
  Future<void> dispose() async {
    await _localNotifications.cancelAll();
  }
}

// ═══════════════════════════════════════════════════════════════════
// 📨 BACKGROUND MESSAGE HANDLER (Must be top-level function)
// ═══════════════════════════════════════════════════════════════════
@pragma('vm:entry-point')
Future<void> firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  debugPrint('📨 Background message received: ${message.messageId}');
  // If you need to do any background processing, do it here
}
