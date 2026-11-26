import 'package:flutter/material.dart';

class AppColors {
  AppColors._();

  // Primary Reds (Brand palette based on Straight Tension Fabric reference)
  static const Color primaryRed = Color(0xFFD90000);
  static const Color deepRed = Color(0xFF900000);
  static const Color darkRed = Color(0xFF650000);
  static const Color lightRed = Color(0xFFFDEBEC);

  // Background and Surfaces (Light Mode)
  static const Color background = Color(0xFFF4F5F7);
  static const Color surface = Color(0xFFFFFFFF);
  static const Color surfaceElevated = Color(0xFFFFFFFF);
  static const Color cardBackground = Color(0xFFFFFFFF);

  // Background and Surfaces (Dark Mode - Modern Grey Theme)
  static const Color darkBackground = Color(0xFF181A20);
  static const Color darkSurface = Color(0xFF22252D);
  static const Color darkSurfaceElevated = Color(0xFF292C36);
  static const Color darkCardBackground = Color(0xFF22252D);

  // Typography (Light Mode)
  static const Color primaryText = Color(0xFF1F2937);
  static const Color secondaryText = Color(0xFF6B7280);
  static const Color hintText = Color(0xFF9CA3AF);
  static const Color textOnPrimary = Color(0xFFFFFFFF);

  // Typography (Dark Mode)
  static const Color darkPrimaryText = Color(0xFFF3F4F6);
  static const Color darkSecondaryText = Color(0xFFA0A6B2);
  static const Color darkHintText = Color(0xFF707684);

  // Borders & Dividers (Light Mode)
  static const Color border = Color(0xFFE2E4E9);
  static const Color borderSubtle = Color(0xFFECEEF2);
  static const Color divider = Color(0xFFE9EBEF);

  // Borders & Dividers (Dark Mode)
  static const Color darkBorder = Color(0xFF353945);
  static const Color darkBorderSubtle = Color(0xFF2A2D37);
  static const Color darkDivider = Color(0xFF2E323D);

  // Dark Crimson Container
  static const Color darkLightRed = Color(0xFF381417);
  static const Color darkActivePill = Color(0xFFB71C1C);

  // Status & Accents
  static const Color success = Color(0xFF2E7D32);
  static const Color successLight = Color(0xFFE8F5E9);
  static const Color darkSuccessLight = Color(0xFF1A381E);
  static const Color warning = Color(0xFFED6C02);
  static const Color warningLight = Color(0xFFFFF4E5);
  static const Color darkWarningLight = Color(0xFF3B2B16);
  static const Color info = Color(0xFF0288D1);
  static const Color infoLight = Color(0xFFE1F5FE);
  static const Color darkInfoLight = Color(0xFF132F3D);

  // Shadows
  static const Color shadow = Color(0x0D000000);
  static const Color darkShadow = Color(0x33000000);
  static const Color redShadow = Color(0x33D90000);

  /// Helper to get theme-aware colors from context
  static AppCustomColors of(BuildContext context) {
    return Theme.of(context).extension<AppCustomColors>() ??
        (Theme.of(context).brightness == Brightness.dark
            ? AppCustomColors.dark
            : AppCustomColors.light);
  }
}

/// ThemeExtension that holds all dynamic colors adapting to Light and Dark mode.
class AppCustomColors extends ThemeExtension<AppCustomColors> {
  final Color background;
  final Color surface;
  final Color surfaceElevated;
  final Color cardBackground;
  final Color primaryText;
  final Color secondaryText;
  final Color hintText;
  final Color border;
  final Color borderSubtle;
  final Color divider;
  final Color lightRed;
  final Color pillBg;
  final Color pillBorder;
  final Color inputBg;
  final Color cardShadow;
  final Color activePill;
  final Color segmentedSelectedBg;

  const AppCustomColors({
    required this.background,
    required this.surface,
    required this.surfaceElevated,
    required this.cardBackground,
    required this.primaryText,
    required this.secondaryText,
    required this.hintText,
    required this.border,
    required this.borderSubtle,
    required this.divider,
    required this.lightRed,
    required this.pillBg,
    required this.pillBorder,
    required this.inputBg,
    required this.cardShadow,
    required this.activePill,
    required this.segmentedSelectedBg,
  });

  static const AppCustomColors light = AppCustomColors(
    background: AppColors.background,
    surface: AppColors.surface,
    surfaceElevated: AppColors.surfaceElevated,
    cardBackground: AppColors.cardBackground,
    primaryText: AppColors.primaryText,
    secondaryText: AppColors.secondaryText,
    hintText: AppColors.hintText,
    border: AppColors.border,
    borderSubtle: AppColors.borderSubtle,
    divider: AppColors.divider,
    lightRed: AppColors.lightRed,
    pillBg: Color(0xFFF0F1F4),
    pillBorder: Color(0xFFDDE0E6),
    inputBg: Colors.white,
    cardShadow: AppColors.shadow,
    activePill: Color(0xFF8A0000),
    segmentedSelectedBg: Color(0xFFE5E7EB),
  );

  static const AppCustomColors dark = AppCustomColors(
    background: AppColors.darkBackground,
    surface: AppColors.darkSurface,
    surfaceElevated: AppColors.darkSurfaceElevated,
    cardBackground: AppColors.darkCardBackground,
    primaryText: AppColors.darkPrimaryText,
    secondaryText: AppColors.darkSecondaryText,
    hintText: AppColors.darkHintText,
    border: AppColors.darkBorder,
    borderSubtle: AppColors.darkBorderSubtle,
    divider: AppColors.darkDivider,
    lightRed: AppColors.darkLightRed,
    pillBg: Color(0xFF2A2D37),
    pillBorder: Color(0xFF3D414E),
    inputBg: Color(0xFF1E2027),
    cardShadow: AppColors.darkShadow,
    activePill: Color(0xFF9E0B0B),
    segmentedSelectedBg: Color(0xFF363A46),
  );

  @override
  AppCustomColors copyWith({
    Color? background,
    Color? surface,
    Color? surfaceElevated,
    Color? cardBackground,
    Color? primaryText,
    Color? secondaryText,
    Color? hintText,
    Color? border,
    Color? borderSubtle,
    Color? divider,
    Color? lightRed,
    Color? pillBg,
    Color? pillBorder,
    Color? inputBg,
    Color? cardShadow,
    Color? activePill,
    Color? segmentedSelectedBg,
  }) {
    return AppCustomColors(
      background: background ?? this.background,
      surface: surface ?? this.surface,
      surfaceElevated: surfaceElevated ?? this.surfaceElevated,
      cardBackground: cardBackground ?? this.cardBackground,
      primaryText: primaryText ?? this.primaryText,
      secondaryText: secondaryText ?? this.secondaryText,
      hintText: hintText ?? this.hintText,
      border: border ?? this.border,
      borderSubtle: borderSubtle ?? this.borderSubtle,
      divider: divider ?? this.divider,
      lightRed: lightRed ?? this.lightRed,
      pillBg: pillBg ?? this.pillBg,
      pillBorder: pillBorder ?? this.pillBorder,
      inputBg: inputBg ?? this.inputBg,
      cardShadow: cardShadow ?? this.cardShadow,
      activePill: activePill ?? this.activePill,
      segmentedSelectedBg: segmentedSelectedBg ?? this.segmentedSelectedBg,
    );
  }

  @override
  AppCustomColors lerp(ThemeExtension<AppCustomColors>? other, double t) {
    if (other is! AppCustomColors) return this;
    return AppCustomColors(
      background: Color.lerp(background, other.background, t)!,
      surface: Color.lerp(surface, other.surface, t)!,
      surfaceElevated: Color.lerp(surfaceElevated, other.surfaceElevated, t)!,
      cardBackground: Color.lerp(cardBackground, other.cardBackground, t)!,
      primaryText: Color.lerp(primaryText, other.primaryText, t)!,
      secondaryText: Color.lerp(secondaryText, other.secondaryText, t)!,
      hintText: Color.lerp(hintText, other.hintText, t)!,
      border: Color.lerp(border, other.border, t)!,
      borderSubtle: Color.lerp(borderSubtle, other.borderSubtle, t)!,
      divider: Color.lerp(divider, other.divider, t)!,
      lightRed: Color.lerp(lightRed, other.lightRed, t)!,
      pillBg: Color.lerp(pillBg, other.pillBg, t)!,
      pillBorder: Color.lerp(pillBorder, other.pillBorder, t)!,
      inputBg: Color.lerp(inputBg, other.inputBg, t)!,
      cardShadow: Color.lerp(cardShadow, other.cardShadow, t)!,
      activePill: Color.lerp(activePill, other.activePill, t)!,
      segmentedSelectedBg: Color.lerp(segmentedSelectedBg, other.segmentedSelectedBg, t)!,
    );
  }
}

/// Convenience extension on BuildContext to quickly access colors and theme.
extension ThemeContextExtension on BuildContext {
  AppCustomColors get colors => AppColors.of(this);
  bool get isDarkMode => Theme.of(this).brightness == Brightness.dark;
  ThemeData get theme => Theme.of(this);
  ColorScheme get colorScheme => Theme.of(this).colorScheme;
}
