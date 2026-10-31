import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

/// Parkzumi design tokens (docs/briefs/parkzumi-design-system.md), applied with
/// iOS interaction conventions on both platforms.
class StatusColors {
  const StatusColors(this.fg, this.bg);
  final Color fg;
  final Color bg;
}

class Pz extends ThemeExtension<Pz> {
  const Pz({
    required this.background,
    required this.surface,
    required this.surfaceRaised,
    required this.textPrimary,
    required this.textSecondary,
    required this.border,
    required this.tint,
    required this.restriction,
    required this.caution,
    required this.permitted,
    required this.unknown,
    required this.community,
  });

  static const lime = Color(0xFFC5FF45);
  static const ink = Color(0xFF171917);
  static const paper = Color(0xFFF5F4EE);
  static const purple = Color(0xFF6B46C1);

  final Color background;
  final Color surface;
  final Color surfaceRaised;
  final Color textPrimary;
  final Color textSecondary;
  final Color border;

  /// Interactive tint: ink on light (lime fails contrast on paper), lime on dark.
  final Color tint;
  final StatusColors restriction;
  final StatusColors caution;
  final StatusColors permitted;
  final StatusColors unknown;
  final StatusColors community;

  static const light = Pz(
    background: paper,
    surface: Color(0xFFFFFFFF),
    surfaceRaised: Color(0xFFFFFFFF),
    textPrimary: ink,
    textSecondary: Color(0xFF62675F),
    border: Color(0xFFD9DDD3),
    tint: ink,
    restriction: StatusColors(Color(0xFFB42318), Color(0xFFFEE4E2)),
    caution: StatusColors(Color(0xFF8A4B08), Color(0xFFFFF0C2)),
    permitted: StatusColors(Color(0xFF176B45), Color(0xFFDCFCE7)),
    unknown: StatusColors(Color(0xFF4B5563), Color(0xFFEEF1F4)),
    community: StatusColors(purple, Color(0xFFF0EAFE)),
  );

  static const dark = Pz(
    background: Color(0xFF121512),
    surface: Color(0xFF1C211C),
    surfaceRaised: Color(0xFF252C25),
    textPrimary: paper,
    textSecondary: Color(0xFFAFB8AC),
    border: Color(0xFF404A40),
    tint: lime,
    restriction: StatusColors(Color(0xFFFFA79F), Color(0xFF401D1B)),
    caution: StatusColors(Color(0xFFFFD98A), Color(0xFF352B14)),
    permitted: StatusColors(Color(0xFF86E0B0), Color(0xFF153425)),
    unknown: StatusColors(Color(0xFFCBD5E1), Color(0xFF252C35)),
    community: StatusColors(Color(0xFFD2BCFF), Color(0xFF2D2241)),
  );

  static Pz of(BuildContext context) => Theme.of(context).extension<Pz>()!;

  @override
  Pz copyWith() => this;

  @override
  Pz lerp(Pz? other, double t) => t < 0.5 || other == null ? this : other;
}

abstract final class Space {
  static const xs = 4.0;
  static const s = 8.0;
  static const m = 12.0;
  static const l = 16.0;
  static const xl = 20.0;
  static const xxl = 24.0;
  static const x3 = 32.0;
  static const x4 = 40.0;
  static const x5 = 48.0;
}

abstract final class Radii {
  static const control = 12.0;
  static const card = 16.0;
  static const container = 24.0;
}

abstract final class Motion {
  static const quick = Duration(milliseconds: 120);
  static const standard = Duration(milliseconds: 180);
  static const context = Duration(milliseconds: 240);
  static const curve = Cubic(0.2, 0.8, 0.2, 1);

  /// Respect the system's reduce-motion setting.
  static Duration of(BuildContext c, Duration d) => MediaQuery.disableAnimationsOf(c) ? Duration.zero : d;
}

abstract final class Fonts {
  static const heading = 'SpaceGrotesk';
  static const body = 'DMSans';
  static const tabular = [FontFeature.tabularFigures()];
}

ThemeData buildTheme(Brightness brightness) {
  final pz = brightness == Brightness.light ? Pz.light : Pz.dark;
  TextStyle heading(double size, double height, FontWeight w) =>
      TextStyle(fontFamily: Fonts.heading, fontSize: size, height: height / size, fontWeight: w, color: pz.textPrimary, letterSpacing: -0.2);
  TextStyle body(double size, double height, FontWeight w, [Color? c]) =>
      TextStyle(fontFamily: Fonts.body, fontSize: size, height: height / size, fontWeight: w, color: c ?? pz.textPrimary);

  final textTheme = TextTheme(
    displaySmall: heading(32, 38, FontWeight.w700),
    headlineSmall: heading(24, 30, FontWeight.w700),
    titleLarge: heading(20, 26, FontWeight.w600),
    titleMedium: body(16, 22, FontWeight.w700),
    bodyLarge: body(16, 24, FontWeight.w400),
    bodyMedium: body(14, 20, FontWeight.w400, pz.textSecondary),
    labelLarge: body(16, 20, FontWeight.w700),
    labelMedium: body(14, 18, FontWeight.w500),
    labelSmall: body(12, 16, FontWeight.w500, pz.textSecondary),
  );

  return ThemeData(
    useMaterial3: true,
    brightness: brightness,
    platform: TargetPlatform.iOS,
    fontFamily: Fonts.body,
    scaffoldBackgroundColor: pz.background,
    canvasColor: pz.background,
    colorScheme: ColorScheme(
      brightness: brightness,
      primary: Pz.lime,
      onPrimary: Pz.ink,
      secondary: Pz.purple,
      onSecondary: Colors.white,
      error: pz.restriction.fg,
      onError: Colors.white,
      surface: pz.surface,
      onSurface: pz.textPrimary,
    ),
    textTheme: textTheme,
    dividerColor: pz.border,
    splashFactory: NoSplash.splashFactory,
    highlightColor: Colors.transparent,
    pageTransitionsTheme: PageTransitionsTheme(
      builders: {for (final p in TargetPlatform.values) p: const CupertinoPageTransitionsBuilder()},
    ),
    extensions: [pz],
    cupertinoOverrideTheme: CupertinoThemeData(
      brightness: brightness,
      primaryColor: pz.tint,
      scaffoldBackgroundColor: pz.background,
      barBackgroundColor: pz.background.withValues(alpha: 0.86),
      textTheme: CupertinoTextThemeData(
        primaryColor: pz.tint,
        textStyle: body(16, 22, FontWeight.w400),
        actionTextStyle: body(16, 22, FontWeight.w500, pz.tint),
        navTitleTextStyle: heading(17, 22, FontWeight.w600),
        navLargeTitleTextStyle: heading(32, 38, FontWeight.w700),
        navActionTextStyle: body(16, 22, FontWeight.w500, pz.tint),
        tabLabelTextStyle: body(10, 12, FontWeight.w500),
        pickerTextStyle: body(20, 26, FontWeight.w400),
        dateTimePickerTextStyle: body(20, 26, FontWeight.w400),
      ),
    ),
  );
}
