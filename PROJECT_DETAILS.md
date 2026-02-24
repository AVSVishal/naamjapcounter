# Jewellery AI - Project Details (V01)

**App:** Jewellery AI | **Package:** com.avsvishalmedia.jewelleryai | **Framework:** Flutter (Dart 3.0+)

**Structure:** Single-file app (`lib/main.dart`, 1900 lines). Dependencies: flutter, shared_preferences, cupertino_icons.

**Classes:** JewelleryAiApp (MaterialApp), PremiumManager (SharedPreferences-based, code: "000"), HomePage (drawer, filters, grid/list), PromptDetailPage (copy prompts), CoursePlayerPage (video UI).

**Features:** Prompt library (4 categories: Art/All/Imagine/Model, 6 items each), premium gating, clipboard copy, course video player with controls, glassmorphism dark UI (#0A0A0A), navigation drawer.

**Database:** SharedPreferences only (key: "premium"). No Firebase/SQLite/API.

**Android:** compileSdk 34, minSdk 24, Kotlin 2.1.0, Gradle 8.6.1.
