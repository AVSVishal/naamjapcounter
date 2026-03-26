import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:flutter/material.dart';

/// ═══════════════════════════════════════════════════════════════════
/// 📊 ANALYTICS SERVICE - Complete User Behavior Tracking
/// ═══════════════════════════════════════════════════════════════════
///
/// Tracks: Every screen, every click, every purchase, every selection
/// User segments: Ad status, purchase behavior, time spent, country

class AnalyticsService {
  static final AnalyticsService _instance = AnalyticsService._internal();
  factory AnalyticsService() => _instance;
  AnalyticsService._internal();

  final FirebaseAnalytics _analytics = FirebaseAnalytics.instance;

  // ═══════════════════════════════════════════════════════════════════
  // 🚀 INITIALIZATION
  // ═══════════════════════════════════════════════════════════════════
  Future<void> initialize() async {
    await _analytics.setAnalyticsCollectionEnabled(true);
    debugPrint('✅ Firebase Analytics initialized');
  }

  // ═══════════════════════════════════════════════════════════════════
  // 📱 SCREEN TRACKING
  // ═══════════════════════════════════════════════════════════════════
  /// Track every screen view
  Future<void> logScreenView(String screenName, {String? screenClass}) async {
    await _analytics.logScreenView(
      screenName: screenName,
      screenClass: screenClass ?? screenName,
    );
    debugPrint('📱 Screen: $screenName');
  }

  // ═══════════════════════════════════════════════════════════════════
  // 🖱️ BUTTON CLICK TRACKING
  // ═══════════════════════════════════════════════════════════════════
  Future<void> logButtonClick(String buttonName, {Map<String, Object>? parameters}) async {
    await _analytics.logEvent(
      name: 'button_click',
      parameters: {
        'button_name': buttonName,
        'timestamp': DateTime.now().toIso8601String(),
        ...?parameters,
      },
    );
    debugPrint('🖱️ Button: $buttonName');
  }

  // ═══════════════════════════════════════════════════════════════════
  // 🌍 COUNTRY SELECTION TRACKING
  // ═══════════════════════════════════════════════════════════════════
  Future<void> logCountrySelected(String countryName, String countryCode, String currencySymbol) async {
    await _analytics.logEvent(
      name: 'country_selected',
      parameters: {
        'country_name': countryName,
        'country_code': countryCode,
        'currency_symbol': currencySymbol,
        'selection_time': DateTime.now().toIso8601String(),
      },
    );
    
    // Set user property for segmentation
    await _analytics.setUserProperty(
      name: 'selected_country',
      value: countryCode,
    );
    
    debugPrint('🌍 Country: $countryName ($countryCode)');
  }

  // ═══════════════════════════════════════════════════════════════════
  // 💰 BUDGET SELECTION TRACKING
  // ═══════════════════════════════════════════════════════════════════
  Future<void> logBudgetSelected(double amount, String countryCode) async {
    await _analytics.logEvent(
      name: 'budget_selected',
      parameters: {
        'budget_amount': amount,
        'country_code': countryCode,
        'selection_time': DateTime.now().toIso8601String(),
      },
    );
    
    // Set user property for revenue segmentation
    await _analytics.setUserProperty(
      name: 'selected_budget',
      value: amount.toString(),
    );
    
    debugPrint('💰 Budget: $amount ($countryCode)');
  }

  // ═══════════════════════════════════════════════════════════════════
  // 🛍️ ITEM PURCHASE TRACKING
  // ═══════════════════════════════════════════════════════════════════
  Future<void> logItemPurchase({
    required String itemName,
    required double price,
    required int quantity,
    required String itemCategory,
    required double remainingBudget,
    required int totalOwned,
  }) async {
    await _analytics.logEvent(
      name: 'item_purchase',
      parameters: {
        'item_name': itemName,
        'price': price,
        'quantity': quantity,
        'total_price': price * quantity,
        'item_category': itemCategory,
        'remaining_budget': remainingBudget,
        'total_owned': totalOwned,
        'purchase_time': DateTime.now().toIso8601String(),
      },
    );
    debugPrint('🛍️ Purchase: $itemName x$quantity = ${price * quantity}');
  }

  // ═══════════════════════════════════════════════════════════════════
  // 🎮 GAME MODE TRACKING
  // ═══════════════════════════════════════════════════════════════════
  Future<void> logGameModeSwitched(String modeName, {String? fromMode}) async {
    await _analytics.logEvent(
      name: 'game_mode_switched',
      parameters: {
        'to_mode': modeName,
        'from_mode': fromMode ?? 'unknown',
        'switch_time': DateTime.now().toIso8601String(),
      },
    );
    debugPrint('🎮 Mode: $modeName (from: $fromMode)');
  }

  // ═══════════════════════════════════════════════════════════════════
  // 📜 RECEIPT TRACKING
  // ═══════════════════════════════════════════════════════════════════
  Future<void> logReceiptViewed(int itemsCount, double totalSpent, int uniqueItems) async {
    await _analytics.logEvent(
      name: 'receipt_viewed',
      parameters: {
        'items_count': itemsCount,
        'total_spent': totalSpent,
        'unique_items': uniqueItems,
        'view_time': DateTime.now().toIso8601String(),
      },
    );
    debugPrint('📜 Receipt: $uniqueItems items, spent: $totalSpent');
  }

  // ═══════════════════════════════════════════════════════════════════
  // 📺 AD TRACKING (User Segmentation)
  // ═══════════════════════════════════════════════════════════════════
  Future<void> logAdStatusChanged(bool adsEnabled) async {
    await _analytics.logEvent(
      name: 'ad_status_changed',
      parameters: {
        'ads_enabled': adsEnabled,
        'change_time': DateTime.now().toIso8601String(),
      },
    );
    
    // Set user property for segmentation
    await _analytics.setUserProperty(
      name: 'ads_enabled',
      value: adsEnabled.toString(),
    );
    
    debugPrint('📺 Ads: ${adsEnabled ? 'ENABLED' : 'DISABLED'}');
  }

  Future<void> logAdImpression(String adType, {String? adUnitId}) async {
    await _analytics.logEvent(
      name: 'ad_impression',
      parameters: {
        'ad_type': adType,
        'ad_unit_id': adUnitId ?? 'unknown',
        'impression_time': DateTime.now().toIso8601String(),
      },
    );
  }

  Future<void> logAdClicked(String adType) async {
    await _analytics.logEvent(
      name: 'ad_clicked',
      parameters: {
        'ad_type': adType,
        'click_time': DateTime.now().toIso8601String(),
      },
    );
  }

  // ═══════════════════════════════════════════════════════════════════
  // ⏱️ TIME SPENT TRACKING
  // ═══════════════════════════════════════════════════════════════════
  DateTime? _sessionStartTime;
  DateTime? _currentScreenStartTime;
  String? _currentScreenName;

  void startSession() {
    _sessionStartTime = DateTime.now();
    debugPrint('⏱️ Session started');
  }

  void startScreenTime(String screenName) {
    // Log previous screen time if exists
    if (_currentScreenStartTime != null && _currentScreenName != null) {
      final duration = DateTime.now().difference(_currentScreenStartTime!);
      _analytics.logEvent(
        name: 'screen_time',
        parameters: {
          'screen_name': _currentScreenName!,
          'duration_seconds': duration.inSeconds,
        },
      );
    }
    
    _currentScreenName = screenName;
    _currentScreenStartTime = DateTime.now();
  }

  Future<void> endSession() async {
    if (_sessionStartTime != null) {
      final duration = DateTime.now().difference(_sessionStartTime!);
      await _analytics.logEvent(
        name: 'session_end',
        parameters: {
          'session_duration_seconds': duration.inSeconds,
          'session_duration_minutes': duration.inMinutes,
        },
      );
      
      // Set user property for engagement segmentation
      await _analytics.setUserProperty(
        name: 'session_duration',
        value: duration.inMinutes.toString(),
      );
      
      debugPrint('⏱️ Session ended: ${duration.inMinutes} min');
    }
  }

  // ═══════════════════════════════════════════════════════════════════
  // 🎯 USER PROPERTIES (Segmentation)
  // ═══════════════════════════════════════════════════════════════════
  Future<void> setUserProperties({
    String? userId,
    String? country,
    double? budget,
    bool? adsEnabled,
    int? totalPurchases,
    double? totalSpent,
  }) async {
    if (country != null) {
      await _analytics.setUserProperty(name: 'user_country', value: country);
    }
    if (budget != null) {
      await _analytics.setUserProperty(name: 'user_budget', value: budget.toString());
    }
    if (adsEnabled != null) {
      await _analytics.setUserProperty(name: 'user_ads_status', value: adsEnabled ? 'enabled' : 'disabled');
    }
    if (totalPurchases != null) {
      await _analytics.setUserProperty(name: 'user_purchases', value: totalPurchases.toString());
    }
    if (totalSpent != null) {
      await _analytics.setUserProperty(name: 'user_spent', value: totalSpent.toString());
    }
  }

  // ═══════════════════════════════════════════════════════════════════
  // 🔄 APP LIFECYCLE
  // ═══════════════════════════════════════════════════════════════════
  Future<void> logAppOpen() async {
    await _analytics.logAppOpen();
    debugPrint('🚀 App opened');
  }

  Future<void> logAppBackground() async {
    await endSession();
  }

  // ═══════════════════════════════════════════════════════════════════
  // 📊 E-COMMERCE TRACKING
  // ═══════════════════════════════════════════════════════════════════
  Future<void> logAddToCart({
    required String itemName,
    required double price,
    required int quantity,
  }) async {
    await _analytics.logAddToCart(
      items: [
        AnalyticsEventItem(
          itemName: itemName,
          price: price,
          quantity: quantity,
        ),
      ],
    );
  }

  Future<void> logPurchaseComplete({
    required double totalValue,
    required int itemCount,
    required String currency,
  }) async {
    await _analytics.logPurchase(
      value: totalValue,
      currency: currency,
      items: [], // Can add individual items if needed
    );
    debugPrint('💳 Purchase logged: $totalValue $currency');
  }
}
