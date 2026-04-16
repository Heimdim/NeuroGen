import 'package:flutter/material.dart';

class AppTheme {
  static const Color _seedColor = Color(0xFF6C63FF);

  static ThemeData light() {
    final ColorScheme scheme = ColorScheme.fromSeed(
      seedColor: _seedColor,
      brightness: Brightness.light,
    );
    return _buildTheme(
      scheme: scheme,
      customColors: AppThemeColors(
        promptFieldFill: const Color(0xFFF2F2F7),
        promptCounter: const Color(0xFF8FA3B0),
        promptInputText: const Color(0xFF424242),
        promptHintText: const Color(0xFF9E9E9E),
        promptActionIcon: const Color(0xFF757575),
        promptClearBackground: Colors.black,
        promptClearForeground: Colors.white,
        toolbarBackground: const Color(0xFFEDE7F5),
        toolbarIcon: const Color(0xFF5E35B1),
        toolbarLabel: const Color(0xFF424242),
        brandTitle: Colors.black87,
        brandBadgeStart: const Color(0xFF7C4DFF),
        brandBadgeEnd: const Color(0xFF536DFE),
        brandBadgeForeground: Colors.white,
        brandAccent: const Color(0xFF1976D2),
        mediaOverlay: Colors.black54,
        mediaMenuOverlay: Colors.black45,
        mediaOverlayForeground: Colors.white,
      ),
    );
  }

  static ThemeData dark() {
    final ColorScheme scheme = ColorScheme.fromSeed(
      seedColor: _seedColor,
      brightness: Brightness.dark,
    );
    return _buildTheme(
      scheme: scheme,
      customColors: const AppThemeColors(
        promptFieldFill: Color(0xFF1F2230),
        promptCounter: Color(0xFF9AA8C5),
        promptInputText: Color(0xFFF2F4F8),
        promptHintText: Color(0xFF9FA8BC),
        promptActionIcon: Color(0xFFC6CDD9),
        promptClearBackground: Color(0xFFF2F4F8),
        promptClearForeground: Color(0xFF151822),
        toolbarBackground: Color(0xFF2A2439),
        toolbarIcon: Color(0xFFD1C4FF),
        toolbarLabel: Color(0xFFF2F4F8),
        brandTitle: Color(0xFFF2F4F8),
        brandBadgeStart: Color(0xFFB388FF),
        brandBadgeEnd: Color(0xFF8C9EFF),
        brandBadgeForeground: Color(0xFF121212),
        brandAccent: Color(0xFF8AB4FF),
        mediaOverlay: Color(0xCC121212),
        mediaMenuOverlay: Color(0xB2121212),
        mediaOverlayForeground: Color(0xFFF7F7F7),
      ),
    );
  }

  static ThemeData _buildTheme({
    required ColorScheme scheme,
    required AppThemeColors customColors,
  }) {
    return ThemeData(
      useMaterial3: true,
      colorScheme: scheme,
      scaffoldBackgroundColor: scheme.surface,
      textTheme: Typography.material2021().black.apply(
        bodyColor: scheme.onSurface,
        displayColor: scheme.onSurface,
      ),
      appBarTheme: AppBarTheme(
        backgroundColor: scheme.surface,
        foregroundColor: scheme.onSurface,
        surfaceTintColor: Colors.transparent,
        elevation: 0,
      ),
      cardTheme: CardThemeData(
        elevation: 0,
        color: scheme.surfaceContainerHighest.withValues(alpha: 0.35),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      ),
      dividerTheme: DividerThemeData(color: scheme.outlineVariant),
      snackBarTheme: SnackBarThemeData(
        behavior: SnackBarBehavior.floating,
        backgroundColor: scheme.inverseSurface,
        contentTextStyle: TextStyle(color: scheme.onInverseSurface),
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: scheme.primary,
          foregroundColor: scheme.onPrimary,
          elevation: 0,
          padding: const EdgeInsets.symmetric(vertical: 16),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(14),
          ),
          textStyle: const TextStyle(fontWeight: FontWeight.w600, fontSize: 16),
        ),
      ),
      extensions: <ThemeExtension<dynamic>>[customColors],
    );
  }
}

@immutable
class AppThemeColors extends ThemeExtension<AppThemeColors> {
  const AppThemeColors({
    required this.promptFieldFill,
    required this.promptCounter,
    required this.promptInputText,
    required this.promptHintText,
    required this.promptActionIcon,
    required this.promptClearBackground,
    required this.promptClearForeground,
    required this.toolbarBackground,
    required this.toolbarIcon,
    required this.toolbarLabel,
    required this.brandTitle,
    required this.brandBadgeStart,
    required this.brandBadgeEnd,
    required this.brandBadgeForeground,
    required this.brandAccent,
    required this.mediaOverlay,
    required this.mediaMenuOverlay,
    required this.mediaOverlayForeground,
  });

  final Color promptFieldFill;
  final Color promptCounter;
  final Color promptInputText;
  final Color promptHintText;
  final Color promptActionIcon;
  final Color promptClearBackground;
  final Color promptClearForeground;
  final Color toolbarBackground;
  final Color toolbarIcon;
  final Color toolbarLabel;
  final Color brandTitle;
  final Color brandBadgeStart;
  final Color brandBadgeEnd;
  final Color brandBadgeForeground;
  final Color brandAccent;
  final Color mediaOverlay;
  final Color mediaMenuOverlay;
  final Color mediaOverlayForeground;

  @override
  AppThemeColors copyWith({
    Color? promptFieldFill,
    Color? promptCounter,
    Color? promptInputText,
    Color? promptHintText,
    Color? promptActionIcon,
    Color? promptClearBackground,
    Color? promptClearForeground,
    Color? toolbarBackground,
    Color? toolbarIcon,
    Color? toolbarLabel,
    Color? brandTitle,
    Color? brandBadgeStart,
    Color? brandBadgeEnd,
    Color? brandBadgeForeground,
    Color? brandAccent,
    Color? mediaOverlay,
    Color? mediaMenuOverlay,
    Color? mediaOverlayForeground,
  }) {
    return AppThemeColors(
      promptFieldFill: promptFieldFill ?? this.promptFieldFill,
      promptCounter: promptCounter ?? this.promptCounter,
      promptInputText: promptInputText ?? this.promptInputText,
      promptHintText: promptHintText ?? this.promptHintText,
      promptActionIcon: promptActionIcon ?? this.promptActionIcon,
      promptClearBackground:
          promptClearBackground ?? this.promptClearBackground,
      promptClearForeground:
          promptClearForeground ?? this.promptClearForeground,
      toolbarBackground: toolbarBackground ?? this.toolbarBackground,
      toolbarIcon: toolbarIcon ?? this.toolbarIcon,
      toolbarLabel: toolbarLabel ?? this.toolbarLabel,
      brandTitle: brandTitle ?? this.brandTitle,
      brandBadgeStart: brandBadgeStart ?? this.brandBadgeStart,
      brandBadgeEnd: brandBadgeEnd ?? this.brandBadgeEnd,
      brandBadgeForeground: brandBadgeForeground ?? this.brandBadgeForeground,
      brandAccent: brandAccent ?? this.brandAccent,
      mediaOverlay: mediaOverlay ?? this.mediaOverlay,
      mediaMenuOverlay: mediaMenuOverlay ?? this.mediaMenuOverlay,
      mediaOverlayForeground:
          mediaOverlayForeground ?? this.mediaOverlayForeground,
    );
  }

  @override
  AppThemeColors lerp(ThemeExtension<AppThemeColors>? other, double t) {
    if (other is! AppThemeColors) {
      return this;
    }
    return AppThemeColors(
      promptFieldFill: Color.lerp(promptFieldFill, other.promptFieldFill, t)!,
      promptCounter: Color.lerp(promptCounter, other.promptCounter, t)!,
      promptInputText: Color.lerp(promptInputText, other.promptInputText, t)!,
      promptHintText: Color.lerp(promptHintText, other.promptHintText, t)!,
      promptActionIcon: Color.lerp(
        promptActionIcon,
        other.promptActionIcon,
        t,
      )!,
      promptClearBackground: Color.lerp(
        promptClearBackground,
        other.promptClearBackground,
        t,
      )!,
      promptClearForeground: Color.lerp(
        promptClearForeground,
        other.promptClearForeground,
        t,
      )!,
      toolbarBackground: Color.lerp(
        toolbarBackground,
        other.toolbarBackground,
        t,
      )!,
      toolbarIcon: Color.lerp(toolbarIcon, other.toolbarIcon, t)!,
      toolbarLabel: Color.lerp(toolbarLabel, other.toolbarLabel, t)!,
      brandTitle: Color.lerp(brandTitle, other.brandTitle, t)!,
      brandBadgeStart: Color.lerp(brandBadgeStart, other.brandBadgeStart, t)!,
      brandBadgeEnd: Color.lerp(brandBadgeEnd, other.brandBadgeEnd, t)!,
      brandBadgeForeground: Color.lerp(
        brandBadgeForeground,
        other.brandBadgeForeground,
        t,
      )!,
      brandAccent: Color.lerp(brandAccent, other.brandAccent, t)!,
      mediaOverlay: Color.lerp(mediaOverlay, other.mediaOverlay, t)!,
      mediaMenuOverlay: Color.lerp(
        mediaMenuOverlay,
        other.mediaMenuOverlay,
        t,
      )!,
      mediaOverlayForeground: Color.lerp(
        mediaOverlayForeground,
        other.mediaOverlayForeground,
        t,
      )!,
    );
  }
}

extension AppThemeContext on BuildContext {
  AppThemeColors get appColors => Theme.of(this).extension<AppThemeColors>()!;
}
