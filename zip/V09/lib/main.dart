import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'theme/app_theme.dart';
import 'router/app_router.dart';
import 'providers/game_provider.dart';
import 'services/ad_service.dart';
import 'services/analytics_service.dart';
import 'services/notification_service.dart';

/// Background message handler for FCM
@pragma('vm:entry-point')
Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  await Firebase.initializeApp();
  debugPrint('📨 Background message: ${message.messageId}');
}

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Initialize Firebase
  await Firebase.initializeApp();

  // Set background message handler
  FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);

  // Initialize Analytics
  await AnalyticsService().initialize();
  AnalyticsService().startSession();
  AnalyticsService().logAppOpen();

  // Initialize Notifications
  await NotificationService().initialize(
    onMessage: (message) {
      debugPrint('📨 Foreground notification received');
    },
    onMessageOpenedApp: (message) {
      debugPrint('📨 Notification opened app');
    },
  );

  // Initialize AdMob
  await AdService().initialize();

  runApp(
    ChangeNotifierProvider(
      create: (_) => GameProvider(),
      child: const SpendTheMoneyApp(),
    ),
  );
}

class SpendTheMoneyApp extends StatefulWidget {
  const SpendTheMoneyApp({super.key});

  @override
  State<SpendTheMoneyApp> createState() => _SpendTheMoneyAppState();
}

class _SpendTheMoneyAppState extends State<SpendTheMoneyApp>
    with WidgetsBindingObserver {

  @override
  void initState() {
    super.initState();
    WidgetsFlutterBinding.instance.addObserver(this);

    // Log screen view for initial screen
    AnalyticsService().logScreenView('splash');

    // Show app open ad on first launch (after 2 sec delay)
    Future.delayed(const Duration(seconds: 2), () {
      AdService().showAppOpenAd();
    });
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    AnalyticsService().endSession();
    AdService().dispose();
    NotificationService().dispose();
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    switch (state) {
      case AppLifecycleState.resumed:
        // Show app open ad when app comes to foreground
        AdService().showAppOpenAd();
        AnalyticsService().startSession();
        AnalyticsService().logScreenView('app_resumed');
        break;
      case AppLifecycleState.paused:
        AnalyticsService().logAppBackground();
        break;
      case AppLifecycleState.detached:
        AnalyticsService().endSession();
        break;
      default:
        break;
    }
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      title: 'Spend The Money',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.light,
      darkTheme: AppTheme.dark,
      themeMode: ThemeMode.light,
      routerConfig: appRouter,
    );
  }
}
