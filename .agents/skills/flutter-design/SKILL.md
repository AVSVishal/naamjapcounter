---
name: flutter-design
description: Create beautiful, modern Flutter apps with Material 3, glassmorphism, smooth animations, proper theming, responsive layouts, and premium UI patterns. Use for building any Flutter/Dart mobile app with exceptional UI/UX quality.
---

# Flutter Design Skill

This skill governs ALL Flutter/Dart UI development. Follow every section. Produce apps that feel professionally designed — never like a default Material starter template.

---

## 1. Core Philosophy

Every Flutter app MUST look premium, polished, and distinctive.

**BANNED — never do these:**
- Use default Flutter colors (blue primary `0xFF2196F3`, default gray scaffold)
- Leave the default `AppBar` with plain white/blue styling
- Ship a screen without loading states, error states, and empty states
- Use `Navigator.push` directly — use `go_router`
- Use bare `CircularProgressIndicator` as the only loading indicator
- Use `Roboto` as the primary font
- Use `BottomNavigationBar` — use `NavigationBar` (Material 3)
- Hardcode color values anywhere in widget code

**MANDATED — always do these:**
- Build a custom `ThemeData` with a unique `ColorScheme` for every project
- Define BOTH light and dark themes
- Use Google Fonts — distinctive typefaces, not Roboto
- Animate every screen transition, every list entrance, every number change
- Reference ALL colors via `Theme.of(context).colorScheme`
- Reference ALL text styles via `Theme.of(context).textTheme`
- Use `const` constructors wherever possible
- Provide shimmer/skeleton loading for every async operation

Target: the app must feel like a professionally designed product from a top-tier studio, not a tutorial project.

---

## 2. Material 3 / Material You Theming

ALWAYS use Material 3 with a custom seed color. Define both light and dark themes in a dedicated `lib/theme/app_theme.dart` file.

```dart
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class AppTheme {
  static const _seedColor = Color(0xFF7C3AED); // Rich Violet — replace per project

  static final light = ThemeData(
    useMaterial3: true,
    colorScheme: ColorScheme.fromSeed(
      seedColor: _seedColor,
      brightness: Brightness.light,
    ),
    textTheme: _buildTextTheme(Brightness.light),
    appBarTheme: const AppBarTheme(
      centerTitle: false,
      scrolledUnderElevation: 2,
      elevation: 0,
    ),
    cardTheme: CardTheme(
      elevation: 0,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      clipBehavior: Clip.antiAlias,
    ),
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 14),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        textStyle: const TextStyle(fontSize: 15, fontWeight: FontWeight.w600),
      ),
    ),
    outlinedButtonTheme: OutlinedButtonThemeData(
      style: OutlinedButton.styleFrom(
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 14),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        side: BorderSide(color: _seedColor.withOpacity(0.5)),
      ),
    ),
    inputDecorationTheme: InputDecorationTheme(
      filled: true,
      border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: BorderSide(color: Colors.grey.shade300),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: BorderSide(color: _seedColor, width: 2),
      ),
      errorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: const BorderSide(color: Color(0xFFDC2626)),
      ),
      focusedErrorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: const BorderSide(color: Color(0xFFDC2626), width: 2),
      ),
      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
    ),
    navigationBarTheme: NavigationBarThemeData(
      indicatorShape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      labelBehavior: NavigationDestinationLabelBehavior.onlyShowSelected,
      height: 64,
    ),
    pageTransitionsTheme: const PageTransitionsTheme(
      builders: {
        TargetPlatform.android: FadeUpwardsPageTransitionsBuilder(),
        TargetPlatform.iOS: CupertinoPageTransitionsBuilder(),
        TargetPlatform.macOS: CupertinoPageTransitionsBuilder(),
      },
    ),
  );

  static final dark = ThemeData(
    useMaterial3: true,
    colorScheme: ColorScheme.fromSeed(
      seedColor: _seedColor,
      brightness: Brightness.dark,
    ),
    textTheme: _buildTextTheme(Brightness.dark),
    appBarTheme: const AppBarTheme(
      centerTitle: false,
      scrolledUnderElevation: 2,
      elevation: 0,
    ),
    cardTheme: CardTheme(
      elevation: 0,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      clipBehavior: Clip.antiAlias,
    ),
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 14),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        textStyle: const TextStyle(fontSize: 15, fontWeight: FontWeight.w600),
      ),
    ),
    outlinedButtonTheme: OutlinedButtonThemeData(
      style: OutlinedButton.styleFrom(
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 14),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        side: BorderSide(color: _seedColor.withOpacity(0.5)),
      ),
    ),
    inputDecorationTheme: InputDecorationTheme(
      filled: true,
      border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: BorderSide(color: Colors.grey.shade700),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: BorderSide(color: _seedColor, width: 2),
      ),
      errorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: const BorderSide(color: Color(0xFFEF4444)),
      ),
      focusedErrorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: const BorderSide(color: Color(0xFFEF4444), width: 2),
      ),
      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
    ),
    navigationBarTheme: NavigationBarThemeData(
      indicatorShape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      labelBehavior: NavigationDestinationLabelBehavior.onlyShowSelected,
      height: 64,
    ),
    pageTransitionsTheme: const PageTransitionsTheme(
      builders: {
        TargetPlatform.android: FadeUpwardsPageTransitionsBuilder(),
        TargetPlatform.iOS: CupertinoPageTransitionsBuilder(),
        TargetPlatform.macOS: CupertinoPageTransitionsBuilder(),
      },
    ),
  );

  static TextTheme _buildTextTheme(Brightness brightness) {
    final color = brightness == Brightness.light
        ? const Color(0xFF1A1A2E)
        : const Color(0xFFE8E8F0);
    return GoogleFonts.plusJakartaSansTextTheme(TextTheme(
      displayLarge: TextStyle(fontSize: 57, fontWeight: FontWeight.w800, letterSpacing: -1.5, color: color),
      displayMedium: TextStyle(fontSize: 45, fontWeight: FontWeight.w700, letterSpacing: -1.0, color: color),
      displaySmall: TextStyle(fontSize: 36, fontWeight: FontWeight.w700, letterSpacing: -0.5, color: color),
      headlineLarge: TextStyle(fontSize: 32, fontWeight: FontWeight.w700, letterSpacing: -0.5, color: color),
      headlineMedium: TextStyle(fontSize: 28, fontWeight: FontWeight.w600, letterSpacing: -0.3, color: color),
      headlineSmall: TextStyle(fontSize: 24, fontWeight: FontWeight.w600, color: color),
      titleLarge: TextStyle(fontSize: 22, fontWeight: FontWeight.w600, color: color),
      titleMedium: TextStyle(fontSize: 16, fontWeight: FontWeight.w600, letterSpacing: 0.15, color: color),
      titleSmall: TextStyle(fontSize: 14, fontWeight: FontWeight.w600, letterSpacing: 0.1, color: color),
      bodyLarge: TextStyle(fontSize: 16, fontWeight: FontWeight.w400, letterSpacing: 0.15, color: color),
      bodyMedium: TextStyle(fontSize: 14, fontWeight: FontWeight.w400, letterSpacing: 0.25, color: color),
      bodySmall: TextStyle(fontSize: 12, fontWeight: FontWeight.w400, letterSpacing: 0.4, color: color),
      labelLarge: TextStyle(fontSize: 14, fontWeight: FontWeight.w600, letterSpacing: 0.1, color: color),
      labelMedium: TextStyle(fontSize: 12, fontWeight: FontWeight.w500, letterSpacing: 0.5, color: color),
      labelSmall: TextStyle(fontSize: 11, fontWeight: FontWeight.w500, letterSpacing: 0.5, color: color),
    ));
  }
}
```

Rules:
- ALWAYS define both `light` and `dark` in a single `AppTheme` class
- ALWAYS use `ColorScheme.fromSeed()` with a distinctive seed color — NOT default blue `0xFF2196F3`
- Reference colors via `Theme.of(context).colorScheme.primary`, `.surface`, `.onSurface`, etc. — NEVER hardcode
- Customize `AppBarTheme`, `CardTheme`, `ElevatedButtonTheme`, `OutlinedButtonTheme`, `InputDecorationTheme`, `NavigationBarTheme`
- Set `pageTransitionsTheme` for smooth transitions on all platforms
- Apply in `MaterialApp`: `theme: AppTheme.light, darkTheme: AppTheme.dark, themeMode: ThemeMode.system`

---

## 3. Typography with Google Fonts

Add to `pubspec.yaml`:
```yaml
dependencies:
  google_fonts: ^6.0.0
```

Rules:
- ALWAYS use Google Fonts — NEVER use default Roboto
- Recommended fonts: **Plus Jakarta Sans**, **Space Grotesk**, **Outfit**, **DM Sans**, **Manrope**, **Sora**. Poppins is acceptable as a last resort — it is overused
- Use `GoogleFonts.plusJakartaSansTextTheme()` to apply to the full text theme as shown in the theme example above
- Define proper scale with clear hierarchy:

| Token | Size | Weight | Use |
|---|---|---|---|
| `displayLarge` | 57 | 800 | Hero headlines |
| `displayMedium` | 45 | 700 | Page titles |
| `displaySmall` | 36 | 700 | Section headings |
| `headlineMedium` | 28 | 600 | Section subtitles |
| `titleLarge` | 22 | 600 | Card titles |
| `titleMedium` | 16 | 600 | List item titles |
| `bodyLarge` | 16 | 400 | Primary content |
| `bodyMedium` | 14 | 400 | Secondary content |
| `labelSmall` | 11 | 500 | Captions, metadata |

- ALWAYS reference text styles via `Theme.of(context).textTheme.bodyLarge` — NEVER use `TextStyle(fontSize: 16)` inline
- Add negative `letterSpacing` on display and headline sizes for tighter, more modern feel

---

## 4. Color System

Rules:
- Build a unique color palette — NOT default Material blue
- Good seed colors for `ColorScheme.fromSeed`:

| Name | Hex | Use Case |
|---|---|---|
| Deep Teal | `0xFF00897B` | Health, wellness, nature apps |
| Warm Coral | `0xFFFF6B6B` | Social, creative, lifestyle apps |
| Rich Violet | `0xFF7C3AED` | Premium, fintech, modern utility apps |
| Forest Green | `0xFF059669` | Productivity, eco, finance apps |
| Burnt Amber | `0xFFEA580C` | Energy, food, sports apps |
| Indigo | `0xFF4F46E5` | Enterprise, SaaS, professional apps |

- ALWAYS use `Theme.of(context).colorScheme.xxx` to reference colors in widget code
- NEVER use `Colors.blue`, `Colors.grey`, `Colors.white` directly — use `colorScheme.primary`, `colorScheme.surface`, `colorScheme.onSurface`
- For custom colors beyond the scheme, define an extension:

```dart
extension AppColors on ColorScheme {
  Color get success => brightness == Brightness.light
      ? const Color(0xFF059669)
      : const Color(0xFF34D399);
  Color get warning => brightness == Brightness.light
      ? const Color(0xFFD97706)
      : const Color(0xFFFBBF24);
  Color get info => brightness == Brightness.light
      ? const Color(0xFF2563EB)
      : const Color(0xFF60A5FA);
}
```

- Use as `Theme.of(context).colorScheme.success`
- Dark mode: `ColorScheme.fromSeed` handles base conversion — but ALWAYS verify contrast and readability on dark surfaces manually
- Use `colorScheme.error` for errors — never define a separate red

---

## 5. Glassmorphism & Modern Effects

Use these effects intentionally — not everywhere, but where they create depth and visual interest.

**Glassmorphism Card:**
```dart
import 'dart:ui';

class GlassCard extends StatelessWidget {
  final Widget child;
  final double blur;
  final double opacity;

  const GlassCard({
    super.key,
    required this.child,
    this.blur = 15,
    this.opacity = 0.1,
  });

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(16),
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: blur, sigmaY: blur),
        child: Container(
          decoration: BoxDecoration(
            color: Theme.of(context).colorScheme.surface.withOpacity(opacity),
            borderRadius: BorderRadius.circular(16),
            border: Border.all(
              color: Theme.of(context).colorScheme.outline.withOpacity(0.2),
            ),
          ),
          padding: const EdgeInsets.all(20),
          child: child,
        ),
      ),
    );
  }
}
```

**Gradient Background:**
```dart
Container(
  decoration: BoxDecoration(
    gradient: LinearGradient(
      begin: Alignment.topLeft,
      end: Alignment.bottomRight,
      colors: [
        Theme.of(context).colorScheme.primary,
        Theme.of(context).colorScheme.tertiary,
      ],
    ),
  ),
)
```

**Soft Shadows (Neomorphism-lite):**
```dart
Container(
  decoration: BoxDecoration(
    color: Theme.of(context).colorScheme.surface,
    borderRadius: BorderRadius.circular(16),
    boxShadow: [
      BoxShadow(
        color: Theme.of(context).colorScheme.shadow.withOpacity(0.08),
        blurRadius: 24,
        offset: const Offset(0, 8),
      ),
      BoxShadow(
        color: Theme.of(context).colorScheme.shadow.withOpacity(0.04),
        blurRadius: 8,
        offset: const Offset(0, 2),
      ),
    ],
  ),
)
```

Rules:
- NEVER use `Colors.white.withOpacity()` — use `colorScheme.surface.withOpacity()` so it works in dark mode
- Use double-shadow layering (large soft + small tight) for realistic depth
- Glassmorphism requires a colored or image background behind it to be visible — DO NOT use on plain white
- Consistent border radius: 12px for small elements, 16px for cards, 20px for sheets, 24px for modals

---

## 6. Animation Guidelines

Rules:
- EVERY screen transition MUST be animated
- EVERY list MUST use staggered entrance animations
- EVERY button MUST have tap feedback (ripple + subtle scale)
- EVERY number change MUST animate (use `AnimatedSwitcher` or `TweenAnimationBuilder`)
- Loading states MUST use shimmer skeleton screens — NEVER a bare `CircularProgressIndicator` alone

**Staggered List Animation:**
```dart
class StaggeredListItem extends StatefulWidget {
  final int index;
  final Widget child;
  const StaggeredListItem({super.key, required this.index, required this.child});

  @override
  State<StaggeredListItem> createState() => _StaggeredListItemState();
}

class _StaggeredListItemState extends State<StaggeredListItem>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;
  late final Animation<double> _opacity;
  late final Animation<Offset> _slide;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 400),
      vsync: this,
    );
    _opacity = CurvedAnimation(parent: _controller, curve: Curves.easeOut);
    _slide = Tween<Offset>(
      begin: const Offset(0, 0.1),
      end: Offset.zero,
    ).animate(CurvedAnimation(parent: _controller, curve: Curves.easeOut));

    Future.delayed(Duration(milliseconds: 80 * widget.index), () {
      if (mounted) _controller.forward();
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return FadeTransition(
      opacity: _opacity,
      child: SlideTransition(position: _slide, child: widget.child),
    );
  }
}
```

**Custom Page Transition (for go_router):**
```dart
CustomTransitionPage(
  child: page,
  transitionsBuilder: (context, animation, secondaryAnimation, child) {
    final fadeAnimation = CurveTween(curve: Curves.easeInOut).animate(animation);
    final slideAnimation = Tween<Offset>(
      begin: const Offset(0, 0.05),
      end: Offset.zero,
    ).animate(CurveTween(curve: Curves.easeOut).animate(animation));
    return FadeTransition(
      opacity: fadeAnimation,
      child: SlideTransition(position: slideAnimation, child: child),
    );
  },
)
```

**Animated Number Counter:**
```dart
TweenAnimationBuilder<int>(
  tween: IntTween(begin: 0, end: targetValue),
  duration: const Duration(milliseconds: 800),
  curve: Curves.easeOut,
  builder: (context, value, child) {
    return Text(
      '$value',
      style: Theme.of(context).textTheme.displayMedium,
    );
  },
)
```

**Tap Scale Effect:**
```dart
class ScaleTapWidget extends StatefulWidget {
  final Widget child;
  final VoidCallback onTap;
  const ScaleTapWidget({super.key, required this.child, required this.onTap});

  @override
  State<ScaleTapWidget> createState() => _ScaleTapWidgetState();
}

class _ScaleTapWidgetState extends State<ScaleTapWidget> {
  bool _pressed = false;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTapDown: (_) => setState(() => _pressed = true),
      onTapUp: (_) => setState(() => _pressed = false),
      onTapCancel: () => setState(() => _pressed = false),
      onTap: widget.onTap,
      child: AnimatedScale(
        scale: _pressed ? 0.95 : 1.0,
        duration: const Duration(milliseconds: 100),
        curve: Curves.easeInOut,
        child: widget.child,
      ),
    );
  }
}
```

**Spring / Elastic Animations:**
```dart
final controller = AnimationController(
  duration: const Duration(milliseconds: 600),
  vsync: this,
);
final animation = controller.drive(
  Tween(begin: 0.0, end: 1.0).chain(
    CurveTween(curve: Curves.elasticOut),
  ),
);
```

**Hero Animations:**
- Wrap shared elements in `Hero` widget with matching `tag` on both screens
- Use `flightShuttleBuilder` for custom morphing when the child widgets differ
- ALWAYS set a unique, descriptive `tag` — never use index alone

**Lottie / Rive:**
- Use `lottie: ^3.0.0` for vector animations (success checkmarks, onboarding illustrations, empty states)
- Use `rive: ^0.13.0` for interactive state-machine animations
- NEVER use animated GIFs — they are heavy and low quality

**Timing Reference:**
- Micro-interactions (tap, toggle): 100-150ms
- Entrance animations (fade, slide): 300-500ms, `Curves.easeOut`
- Exit animations: 150-250ms, `Curves.easeIn`
- Stagger delay between list items: 60-100ms
- Page transitions: 200-400ms
- Spring / bounce: 500-800ms, `Curves.elasticOut`

---

## 7. Navigation with go_router

Add to `pubspec.yaml`:
```yaml
dependencies:
  go_router: ^14.0.0
```

ALWAYS use `go_router` for navigation. NEVER use `Navigator.push` directly.

```dart
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

final router = GoRouter(
  initialLocation: '/',
  routes: [
    ShellRoute(
      builder: (context, state, child) => AppShell(child: child),
      routes: [
        GoRoute(
          path: '/',
          pageBuilder: (context, state) => CustomTransitionPage(
            key: state.pageKey,
            child: const HomeScreen(),
            transitionsBuilder: _fadeSlideTransition,
          ),
        ),
        GoRoute(
          path: '/settings',
          pageBuilder: (context, state) => CustomTransitionPage(
            key: state.pageKey,
            child: const SettingsScreen(),
            transitionsBuilder: _fadeSlideTransition,
          ),
        ),
      ],
    ),
    GoRoute(
      path: '/detail/:id',
      pageBuilder: (context, state) => CustomTransitionPage(
        key: state.pageKey,
        child: DetailScreen(id: state.pathParameters['id']!),
        transitionsBuilder: _fadeSlideTransition,
      ),
    ),
  ],
);

Widget _fadeSlideTransition(
  BuildContext context,
  Animation<double> animation,
  Animation<double> secondaryAnimation,
  Widget child,
) {
  return FadeTransition(
    opacity: CurveTween(curve: Curves.easeInOut).animate(animation),
    child: SlideTransition(
      position: Tween<Offset>(
        begin: const Offset(0, 0.04),
        end: Offset.zero,
      ).animate(CurveTween(curve: Curves.easeOut).animate(animation)),
      child: child,
    ),
  );
}
```

**AppShell with NavigationBar:**
```dart
class AppShell extends StatelessWidget {
  final Widget child;
  const AppShell({super.key, required this.child});

  static int _indexOf(String location) {
    if (location.startsWith('/settings')) return 1;
    return 0;
  }

  @override
  Widget build(BuildContext context) {
    final location = GoRouterState.of(context).uri.toString();
    return Scaffold(
      body: child,
      bottomNavigationBar: NavigationBar(
        selectedIndex: _indexOf(location),
        onDestinationSelected: (index) {
          switch (index) {
            case 0: context.go('/');
            case 1: context.go('/settings');
          }
        },
        destinations: const [
          NavigationDestination(icon: Icon(Icons.home_outlined), selectedIcon: Icon(Icons.home), label: 'Home'),
          NavigationDestination(icon: Icon(Icons.settings_outlined), selectedIcon: Icon(Icons.settings), label: 'Settings'),
        ],
      ),
    );
  }
}
```

Rules:
- Define ALL routes in one place — `lib/router/app_router.dart`
- Use `ShellRoute` for persistent bottom navigation bars
- Use `CustomTransitionPage` with `_fadeSlideTransition` for every route
- Use `context.go()` for tab-level navigation, `context.push()` for detail screens
- Support deep linking — every screen must be reachable via its route path

---

## 8. Responsive Design

Rules:
- NEVER hardcode widths — use `MediaQuery`, `LayoutBuilder`, `Expanded`, or `Flexible`
- NEVER use fixed pixel widths for containers that should be fluid
- Define breakpoints as constants:

```dart
class Breakpoints {
  static const double mobile = 600;
  static const double tablet = 1024;

  static bool isMobile(BuildContext context) =>
      MediaQuery.sizeOf(context).width < mobile;
  static bool isTablet(BuildContext context) =>
      MediaQuery.sizeOf(context).width >= mobile &&
      MediaQuery.sizeOf(context).width < tablet;
  static bool isDesktop(BuildContext context) =>
      MediaQuery.sizeOf(context).width >= tablet;
}
```

- Use `LayoutBuilder` for widgets that change structure at breakpoints:

```dart
LayoutBuilder(
  builder: (context, constraints) {
    if (constraints.maxWidth >= 1024) {
      return _buildDesktopLayout();
    } else if (constraints.maxWidth >= 600) {
      return _buildTabletLayout();
    }
    return _buildMobileLayout();
  },
)
```

- Text sizes: ALWAYS use `Theme.of(context).textTheme` — never hardcoded sizes
- Padding: use proportional or constrained padding, not fixed values for outer margins:

```dart
EdgeInsets.symmetric(
  horizontal: MediaQuery.sizeOf(context).width > 600 ? 32 : 16,
)
```

- Bottom sheets and dialogs: apply `constraints: BoxConstraints(maxWidth: 480)` on larger screens
- Use `MediaQuery.sizeOf(context)` instead of `MediaQuery.of(context).size` for better performance (avoids rebuilds on unrelated MediaQuery changes)
- Test on: 360px (small phone), 390px (standard phone), 428px (large phone), 768px (tablet)

---

## 9. Component Design Patterns

### Cards
```dart
Container(
  decoration: BoxDecoration(
    color: Theme.of(context).colorScheme.surface,
    borderRadius: BorderRadius.circular(16),
    boxShadow: [
      BoxShadow(
        color: Theme.of(context).colorScheme.shadow.withOpacity(0.06),
        blurRadius: 16,
        offset: const Offset(0, 4),
      ),
    ],
  ),
  child: Material(
    color: Colors.transparent,
    child: InkWell(
      borderRadius: BorderRadius.circular(16),
      onTap: () {},
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: content,
      ),
    ),
  ),
)
```
- Use `elevation: 0` on Material `Card` and add custom `BoxShadow` for modern look
- Wrap with `InkWell` for ripple + tap effect
- Consistent border radius: 12-16px

### Buttons with Loading State
```dart
class LoadingButton extends StatelessWidget {
  final String label;
  final bool isLoading;
  final VoidCallback? onPressed;

  const LoadingButton({
    super.key,
    required this.label,
    this.isLoading = false,
    this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: isLoading ? null : onPressed,
      child: isLoading
          ? SizedBox(
              height: 20,
              width: 20,
              child: CircularProgressIndicator(
                strokeWidth: 2.5,
                color: Theme.of(context).colorScheme.onPrimary,
              ),
            )
          : Text(label),
    );
  }
}
```
- ALWAYS define button themes in ThemeData (see Section 2)
- Include loading state for every async button action
- Use `ElevatedButton`, `OutlinedButton`, `TextButton`, `IconButton` — all styled via theme

### Text Fields
- ALWAYS use `OutlineInputBorder` — NEVER `UnderlineInputBorder` for modern look
- Define `enabledBorder`, `focusedBorder`, `errorBorder`, `focusedErrorBorder` in `InputDecorationTheme` (see Section 2)
- Use prefix/suffix icons for context (search, password toggle, clear)
- Error text appears below via `errorText` parameter

### Bottom Navigation
- Use `NavigationBar` (Material 3) — NEVER `BottomNavigationBar` (legacy)
- Use `selectedIcon` and `icon` for filled/outlined toggle on selection
- Style via `NavigationBarTheme` in ThemeData

### App Bar
```dart
SliverAppBar(
  expandedHeight: 200,
  floating: false,
  pinned: true,
  flexibleSpace: FlexibleSpaceBar(
    title: Text('Title', style: Theme.of(context).textTheme.titleLarge),
    background: Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            Theme.of(context).colorScheme.primary,
            Theme.of(context).colorScheme.tertiary,
          ],
        ),
      ),
    ),
  ),
)
```
- Use `SliverAppBar` with `flexibleSpace` for collapsing scroll effects
- Apply `BackdropFilter` on the scrolled/pinned state for a glass effect
- NEVER leave AppBar as default white/blue

### Bottom Sheets
```dart
showModalBottomSheet(
  context: context,
  isScrollControlled: true,
  backgroundColor: Colors.transparent,
  builder: (context) => DraggableScrollableSheet(
    initialChildSize: 0.6,
    minChildSize: 0.3,
    maxChildSize: 0.9,
    builder: (context, scrollController) => Container(
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surface,
        borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
      ),
      child: Column(
        children: [
          const SizedBox(height: 8),
          Container(
            width: 40,
            height: 4,
            decoration: BoxDecoration(
              color: Theme.of(context).colorScheme.outline.withOpacity(0.3),
              borderRadius: BorderRadius.circular(2),
            ),
          ),
          const SizedBox(height: 16),
          Expanded(
            child: ListView(controller: scrollController, children: [/* content */]),
          ),
        ],
      ),
    ),
  ),
);
```
- Rounded top corners with handle indicator
- Use `DraggableScrollableSheet` for variable-height content
- Set `backgroundColor: Colors.transparent` on `showModalBottomSheet`

### Skeleton Loading
Add to `pubspec.yaml`:
```yaml
dependencies:
  shimmer: ^3.0.0
```

```dart
import 'package:shimmer/shimmer.dart';

class SkeletonCard extends StatelessWidget {
  const SkeletonCard({super.key});

  @override
  Widget build(BuildContext context) {
    final baseColor = Theme.of(context).colorScheme.surfaceContainerHighest;
    final highlightColor = Theme.of(context).colorScheme.surface;
    return Shimmer.fromColors(
      baseColor: baseColor,
      highlightColor: highlightColor,
      child: Container(
        height: 120,
        decoration: BoxDecoration(
          color: baseColor,
          borderRadius: BorderRadius.circular(16),
        ),
      ),
    );
  }
}
```
- Match shimmer base/highlight colors to the current theme
- Mirror the layout structure of the real content for smooth transition
- NEVER show a bare `CircularProgressIndicator` as the only loading state

---

## 10. Essential Packages

ALWAYS evaluate these packages for any Flutter project:

```yaml
dependencies:
  google_fonts: ^6.0.0          # Custom typography — REQUIRED
  go_router: ^14.0.0            # Declarative navigation — REQUIRED
  shimmer: ^3.0.0               # Skeleton loading screens
  flutter_animate: ^4.5.0       # Declarative animation chains
  cached_network_image: ^3.4.0  # Image caching with fade-in placeholders
  flutter_svg: ^2.0.0           # SVG icon and illustration support
  gap: ^3.0.0                   # Clean SizedBox replacement (Gap(16))
  lottie: ^3.0.0                # Vector animations (optional, for premium)
  rive: ^0.13.0                 # Interactive animations (optional, for premium)
```

- `google_fonts` and `go_router` are REQUIRED for every project
- Use `flutter_animate` for quick declarative animations:

```dart
import 'package:flutter_animate/flutter_animate.dart';

child.animate()
  .fadeIn(duration: 400.ms)
  .slideY(begin: 0.1, end: 0, curve: Curves.easeOut);
```

- Use `cached_network_image` for ALL network images:

```dart
CachedNetworkImage(
  imageUrl: url,
  placeholder: (context, url) => const SkeletonCard(),
  errorWidget: (context, url, error) => const Icon(Icons.broken_image_outlined),
  fit: BoxFit.cover,
)
```

- Use `Gap(16)` from the `gap` package instead of `SizedBox(height: 16)` for cleaner code

---

## 11. Icon System

Rules:
- Prefer SVG icons via `flutter_svg` for custom icon sets
- For standard UI icons, use Material Symbols (outlined style): `Icons.home_outlined`, `Icons.settings_outlined`
- NEVER use emojis as UI elements
- Icons MUST be consistent in style throughout the app — ALL outlined OR ALL filled, never mixed
- On active/selected state, swap to filled variant: `Icons.home_outlined` -> `Icons.home`
- Include `semanticLabel` for accessibility on every `Icon`:

```dart
Icon(
  Icons.favorite_outlined,
  semanticLabel: 'Add to favorites',
  color: Theme.of(context).colorScheme.primary,
)
```

- Size icons consistently: 20px for inline, 24px for standard, 28px for emphasis, 48px for empty states

---

## 12. Pre-Delivery Checklist

BEFORE delivering any Flutter app code, verify EVERY item. Do not skip any.

### Visual Quality
- [ ] Custom `ThemeData` with unique `ColorScheme` — NOT default blue
- [ ] Custom Google Font applied — NOT Roboto
- [ ] Dark mode theme defined and working via `ThemeMode.system`
- [ ] Custom `AppBarTheme` — NOT default white/blue
- [ ] Cards have soft custom shadows, not default `Material` elevation
- [ ] Buttons styled with proper themes and loading states
- [ ] Loading states use shimmer/skeleton — no bare spinners
- [ ] Empty states are designed with icon/illustration and descriptive message

### Animations
- [ ] Page transitions are smooth (fade + slide via `CustomTransitionPage`)
- [ ] Lists have staggered entrance animations
- [ ] Buttons have tap feedback (ripple via `InkWell` + optional subtle scale)
- [ ] Number changes are animated (`AnimatedSwitcher` or `TweenAnimationBuilder`)
- [ ] No janky or dropped frames — animations use only `transform` and `opacity`

### UX & Accessibility
- [ ] `Semantics` widgets and `semanticLabel` used for screen reader support
- [ ] Touch targets minimum 48x48 dp (Material accessibility guidelines)
- [ ] Text contrast meets WCAG AA — 4.5:1 for normal text, 3:1 for large
- [ ] Responsive on different screen sizes — 360px through 768px with no overflow
- [ ] No `RenderFlex overflowed` errors on any screen size
- [ ] Keyboard dismisses properly on text fields (`FocusScope.of(context).unfocus()`)
- [ ] Safe area handled via `SafeArea` or `MediaQuery.paddingOf(context)`

### Code Quality
- [ ] Colors referenced via `Theme.of(context).colorScheme` — zero hardcoded colors
- [ ] Text styles via `Theme.of(context).textTheme` — zero hardcoded sizes
- [ ] `const` constructors used on every widget that permits it
- [ ] Navigation via `go_router` — zero direct `Navigator.push` calls
- [ ] Assets (fonts, images, SVGs) properly declared in `pubspec.yaml`
- [ ] No `setState` abuse — state management is clean (provider, riverpod, or bloc)
- [ ] Platform-aware: respects iOS conventions on iOS, Material on Android
