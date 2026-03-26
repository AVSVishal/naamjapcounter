import 'dart:async';
import 'package:flutter/material.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:shared_preferences/shared_preferences.dart';

/// ═══════════════════════════════════════════════════════════════════
/// 📱 AD SERVICE - Strategic Ad Implementation
/// ═══════════════════════════════════════════════════════════════════
///
/// AdMob IDs:
/// App ID: ca-app-pub-7484296346485733~3127458539
/// App Open: ca-app-pub-7484296346485733/3911725468
/// Interstitial: ca-app-pub-7484296346485733/3337010391
/// Banner: ca-app-pub-7484296346485733/1640785345
///
/// Strategy:
/// - App Open: Max 1 per 5 min when app opens
/// - Banner: Bottom of Game Screen only (NOT in Reel mode)
/// - Interstitial: Every 5 purchases with 3 min cooldown
/// - Receipt Screen: NO ADS (as requested)

class AdService {
  static final AdService _instance = AdService._internal();
  factory AdService() => _instance;
  AdService._internal();

  // ═══════════════════════════════════════════════════════════════════
  // 📱 AD UNIT IDs
  // ═══════════════════════════════════════════════════════════════════
  static const String _appId = 'ca-app-pub-7484296346485733~3127458539';
  static const String _appOpenId = 'ca-app-pub-7484296346485733/3911725468';
  static const String _interstitialId = 'ca-app-pub-7484296346485733/3337010391';
  static const String _bannerId = 'ca-app-pub-7484296346485733/1640785345';

  // ═══════════════════════════════════════════════════════════════════
  // ⏱️ TIMING CONFIGURATION (Non-intrusive strategy)
  // ═══════════════════════════════════════════════════════════════════
  static const int _appOpenCooldownMinutes = 5;
  static const int _interstitialCooldownMinutes = 3;
  static const int _purchasesBeforeInterstitial = 5; // Every 5th purchase

  // ═══════════════════════════════════════════════════════════════════
  // 🎯 AD STATE
  // ═══════════════════════════════════════════════════════════════════
  AppOpenAd? _appOpenAd;
  InterstitialAd? _interstitialAd;
  BannerAd? _bannerAd;

  bool _isAppOpenAdLoading = false;
  bool _isInterstitialAdLoading = false;
  bool _isInitialized = false;

  int _purchaseCount = 0;
  DateTime? _lastAppOpenShown;
  DateTime? _lastInterstitialShown;

  // ═══════════════════════════════════════════════════════════════════
  // 🚀 INITIALIZATION
  // ═══════════════════════════════════════════════════════════════════
  Future<void> initialize() async {
    if (_isInitialized) return;

    await MobileAds.instance.initialize();
    await _loadTimingData();

    _isInitialized = true;

    // Preload ads in background
    _loadAppOpenAd();
    _loadInterstitialAd();
  }

  // ═══════════════════════════════════════════════════════════════════
  // 📱 APP OPEN AD
  // ═══════════════════════════════════════════════════════════════════
  /// Shows when app opens or returns from background
  /// Max 1 per 5 minutes to avoid irritation
  void _loadAppOpenAd() {
    if (_isAppOpenAdLoading || _appOpenAd != null) return;

    _isAppOpenAdLoading = true;

    AppOpenAd.load(
      adUnitId: _appOpenId,
      request: const AdRequest(),
      adLoadCallback: AppOpenAdLoadCallback(
        onAdLoaded: (ad) {
          _appOpenAd = ad;
          _isAppOpenAdLoading = false;
        },
        onAdFailedToLoad: (error) {
          _isAppOpenAdLoading = false;
          debugPrint('App Open Ad failed: ${error.message}');
        },
      ),
    );
  }

  Future<void> showAppOpenAd() async {
    // Check cooldown - only show if 5+ minutes passed
    if (_lastAppOpenShown != null) {
      final diff = DateTime.now().difference(_lastAppOpenShown!);
      if (diff.inMinutes < _appOpenCooldownMinutes) {
        debugPrint('App Open: Cooldown active (${diff.inMinutes} min)');
        return;
      }
    }

    if (_appOpenAd == null) {
      _loadAppOpenAd();
      return;
    }

    _appOpenAd!.fullScreenContentCallback = FullScreenContentCallback(
      onAdDismissedFullScreenContent: (ad) {
        ad.dispose();
        _appOpenAd = null;
        _lastAppOpenShown = DateTime.now();
        _saveTimingData();
        _loadAppOpenAd(); // Preload next
      },
      onAdFailedToShowFullScreenContent: (ad, error) {
        ad.dispose();
        _appOpenAd = null;
        _loadAppOpenAd();
      },
    );

    await _appOpenAd!.show();
  }

  // ═══════════════════════════════════════════════════════════════════
  // 📺 INTERSTITIAL AD
  // ═══════════════════════════════════════════════════════════════════
  /// Shows every 5 purchases with 3-minute cooldown
  /// Not shown on receipt screen (as requested)
  void _loadInterstitialAd() {
    if (_isInterstitialAdLoading || _interstitialAd != null) return;

    _isInterstitialAdLoading = true;

    InterstitialAd.load(
      adUnitId: _interstitialId,
      request: const AdRequest(),
      adLoadCallback: InterstitialAdLoadCallback(
        onAdLoaded: (ad) {
          _interstitialAd = ad;
          _isInterstitialAdLoading = false;
        },
        onAdFailedToLoad: (error) {
          _isInterstitialAdLoading = false;
          debugPrint('Interstitial failed: ${error.message}');
        },
      ),
    );
  }

  /// Call this when user makes a purchase
  /// Shows interstitial every 5th purchase with cooldown
  Future<void> onPurchaseMade() async {
    _purchaseCount++;
    await _saveTimingData();

    // Only show after every 5 purchases
    if (_purchaseCount >= _purchasesBeforeInterstitial) {
      _purchaseCount = 0;
      await _tryShowInterstitial();
      await _saveTimingData();
    }
  }

  Future<void> _tryShowInterstitial() async {
    // Check cooldown - only show if 3+ minutes passed
    if (_lastInterstitialShown != null) {
      final diff = DateTime.now().difference(_lastInterstitialShown!);
      if (diff.inMinutes < _interstitialCooldownMinutes) {
        debugPrint('Interstitial: Cooldown active (${diff.inMinutes} min)');
        return;
      }
    }

    if (_interstitialAd == null) {
      _loadInterstitialAd();
      return;
    }

    _interstitialAd!.fullScreenContentCallback = FullScreenContentCallback(
      onAdDismissedFullScreenContent: (ad) {
        ad.dispose();
        _interstitialAd = null;
        _lastInterstitialShown = DateTime.now();
        _saveTimingData();
        _loadInterstitialAd(); // Preload next
      },
      onAdFailedToShowFullScreenContent: (ad, error) {
        ad.dispose();
        _interstitialAd = null;
        _loadInterstitialAd();
      },
    );

    await _interstitialAd!.show();
  }

  // ═══════════════════════════════════════════════════════════════════
  // 📰 BANNER AD
  // ═══════════════════════════════════════════════════════════════════
  /// Creates banner ad for Game Screen
  /// Size: 320x50 standard banner
  BannerAd? createBannerAd() {
    _bannerAd?.dispose();

    _bannerAd = BannerAd(
      adUnitId: _bannerId,
      size: AdSize.banner,
      request: const AdRequest(),
      listener: BannerAdListener(
        onAdLoaded: (ad) => debugPrint('Banner loaded'),
        onAdFailedToLoad: (ad, error) {
          ad.dispose();
          debugPrint('Banner failed: ${error.message}');
        },
      ),
    );

    _bannerAd!.load();
    return _bannerAd;
  }

  // ═══════════════════════════════════════════════════════════════════
  // 💾 PERSISTENCE - Save ad timing across sessions
  // ═══════════════════════════════════════════════════════════════════
  Future<void> _loadTimingData() async {
    try {
      final prefs = await SharedPreferences.getInstance();

      final appOpenStr = prefs.getString('last_app_open');
      final interstitialStr = prefs.getString('last_interstitial');
      final purchaseCount = prefs.getInt('purchase_count') ?? 0;

      if (appOpenStr != null) {
        _lastAppOpenShown = DateTime.tryParse(appOpenStr);
      }
      if (interstitialStr != null) {
        _lastInterstitialShown = DateTime.tryParse(interstitialStr);
      }
      _purchaseCount = purchaseCount;

      debugPrint('Ad timing loaded: purchases=$_purchaseCount');
    } catch (e) {
      debugPrint('Error loading ad timing: $e');
    }
  }

  Future<void> _saveTimingData() async {
    try {
      final prefs = await SharedPreferences.getInstance();

      if (_lastAppOpenShown != null) {
        await prefs.setString('last_app_open', _lastAppOpenShown!.toIso8601String());
      }
      if (_lastInterstitialShown != null) {
        await prefs.setString('last_interstitial', _lastInterstitialShown!.toIso8601String());
      }
      await prefs.setInt('purchase_count', _purchaseCount);
    } catch (e) {
      debugPrint('Error saving ad timing: $e');
    }
  }

  // ═══════════════════════════════════════════════════════════════════
  // 🧹 CLEANUP
  // ═══════════════════════════════════════════════════════════════════
  void dispose() {
    _appOpenAd?.dispose();
    _interstitialAd?.dispose();
    _bannerAd?.dispose();
  }
}
