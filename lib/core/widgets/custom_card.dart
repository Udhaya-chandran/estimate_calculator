import 'package:flutter/material.dart';
import '../../app/theme/app_colors.dart';

class CustomCard extends StatelessWidget {
  final Widget child;
  final EdgeInsetsGeometry padding;
  final VoidCallback? onTap;
  final Color? backgroundColor;
  final Color? borderColor;
  final double borderRadius;
  final bool hasShadow;

  const CustomCard({
    super.key,
    required this.child,
    this.padding = const EdgeInsets.all(16),
    this.onTap,
    this.backgroundColor,
    this.borderColor,
    this.borderRadius = 14.0,
    this.hasShadow = true,
  });

  @override
  Widget build(BuildContext context) {
    final effectiveBg = (backgroundColor == null ||
            backgroundColor == AppColors.surface ||
            backgroundColor == AppColors.cardBackground)
        ? context.colors.cardBackground
        : (backgroundColor == AppColors.lightRed
            ? context.colors.lightRed
            : backgroundColor!);

    final effectiveBorder = (borderColor == null || borderColor == AppColors.border)
        ? context.colors.border
        : (borderColor == AppColors.borderSubtle
            ? context.colors.borderSubtle
            : borderColor!);

    final border = BorderSide(
      color: effectiveBorder,
      width: 1,
    );

    final boxDecoration = BoxDecoration(
      color: effectiveBg,
      borderRadius: BorderRadius.circular(borderRadius),
      border: Border.fromBorderSide(border),
      boxShadow: hasShadow
          ? [
              BoxShadow(
                color: context.colors.cardShadow,
                blurRadius: context.isDarkMode ? 6 : 10,
                offset: const Offset(0, 3),
              ),
            ]
          : null,
    );

    if (onTap != null) {
      return Container(
        decoration: boxDecoration,
        child: Material(
          color: Colors.transparent,
          borderRadius: BorderRadius.circular(borderRadius),
          child: InkWell(
            onTap: onTap,
            borderRadius: BorderRadius.circular(borderRadius),
            splashColor: AppColors.primaryRed.withValues(alpha: 0.12),
            highlightColor: AppColors.primaryRed.withValues(alpha: 0.06),
            child: Padding(
              padding: padding,
              child: child,
            ),
          ),
        ),
      );
    }

    return Container(
      decoration: boxDecoration,
      padding: padding,
      child: child,
    );
  }
}
