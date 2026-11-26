import 'package:flutter/material.dart';
import '../../app/theme/app_colors.dart';

enum _BadgeVariant { red, neutral, success }

class StatusBadge extends StatelessWidget {
  final String label;
  final Color? backgroundColor;
  final Color? textColor;
  final IconData? icon;
  final _BadgeVariant? _variant;

  const StatusBadge({
    super.key,
    required this.label,
    this.backgroundColor,
    this.textColor,
    this.icon,
  }) : _variant = null;

  const StatusBadge.red(
    this.label, {
    super.key,
    this.icon,
  })  : backgroundColor = null,
        textColor = null,
        _variant = _BadgeVariant.red;

  const StatusBadge.neutral(
    this.label, {
    super.key,
    this.icon,
  })  : backgroundColor = null,
        textColor = null,
        _variant = _BadgeVariant.neutral;

  const StatusBadge.success(
    this.label, {
    super.key,
    this.icon,
  })  : backgroundColor = null,
        textColor = null,
        _variant = _BadgeVariant.success;

  @override
  Widget build(BuildContext context) {
    Color effectiveBg;
    Color effectiveTextColor;

    if (_variant == _BadgeVariant.red) {
      effectiveBg = context.colors.lightRed;
      effectiveTextColor = AppColors.primaryRed;
    } else if (_variant == _BadgeVariant.neutral) {
      effectiveBg = context.colors.pillBg;
      effectiveTextColor = context.colors.primaryText;
    } else if (_variant == _BadgeVariant.success) {
      effectiveBg = context.isDarkMode ? AppColors.darkSuccessLight : AppColors.successLight;
      effectiveTextColor = context.isDarkMode ? const Color(0xFF81C784) : AppColors.success;
    } else {
      effectiveBg = backgroundColor ?? context.colors.lightRed;
      effectiveTextColor = textColor ?? AppColors.primaryRed;
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        color: effectiveBg,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (icon != null) ...[
            Icon(icon, size: 13, color: effectiveTextColor),
            const SizedBox(width: 4),
          ],
          Text(
            label,
            style: TextStyle(
              fontSize: 11,
              fontWeight: FontWeight.w700,
              color: effectiveTextColor,
              letterSpacing: 0.2,
            ),
          ),
        ],
      ),
    );
  }
}
