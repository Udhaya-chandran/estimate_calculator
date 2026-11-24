import 'package:flutter/material.dart';
import '../../app/theme/app_colors.dart';

class CustomCard extends StatelessWidget {
  final Widget child;
  final EdgeInsetsGeometry padding;
  final VoidCallback? onTap;
  final Color backgroundColor;
  final Color? borderColor;
  final double borderRadius;
  final bool hasShadow;

  const CustomCard({
    super.key,
    required this.child,
    this.padding = const EdgeInsets.all(16),
    this.onTap,
    this.backgroundColor = AppColors.surface,
    this.borderColor,
    this.borderRadius = 14.0,
    this.hasShadow = true,
  });

  @override
  Widget build(BuildContext context) {
    final border = BorderSide(
      color: borderColor ?? AppColors.border,
      width: 1,
    );

    final boxDecoration = BoxDecoration(
      color: backgroundColor,
      borderRadius: BorderRadius.circular(borderRadius),
      border: Border.fromBorderSide(border),
      boxShadow: hasShadow
          ? [
              const BoxShadow(
                color: AppColors.shadow,
                blurRadius: 10,
                offset: Offset(0, 3),
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
            splashColor: AppColors.lightRed.withValues(alpha: 0.5),
            highlightColor: AppColors.lightRed.withValues(alpha: 0.2),
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

