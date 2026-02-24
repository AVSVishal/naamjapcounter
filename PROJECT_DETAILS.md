# Trend Hook - Project Details (V02)

**App:** Trend Hook | **Package:** com.avsvishalmedia.trendhook | **Framework:** Flutter (Dart 3.0+)

**Structure:** Single-file app (`lib/main.dart`). Dependencies: flutter, shared_preferences, cupertino_icons.

**Classes:** TrendHookApp (MaterialApp), PremiumManager (SharedPreferences, code: "000"), HomePage (tabs, category chips, drawer), ReelDetailPage (stats, caption copy), AccountDetailPage (growth/strategy).

**Features:** Trending Instagram reels (8 categories: Entertainment/Comedy/Education/Fitness/Food/Tech/Fashion/Travel), exploding accounts discovery (growth stats, engagement rates), premium gating, glassmorphism dark UI, Instagram-gradient branding.

**Database:** SharedPreferences (key: "premium"). No Firebase/SQLite/API.

**Android:** compileSdk 34, minSdk 24, Kotlin 2.1.0.
