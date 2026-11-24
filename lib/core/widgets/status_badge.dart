import 'package:flutter/material.dart';
import '../../app/theme/app_colors.dart';

class StatusBadge extends StatelessWidget {
  final String label;
  final Color backgroundColor;
  final Color textColor;
  final IconData? icon;

  const StatusBadge({
    super.key,
    required this.label,
    this.backgroundColor = AppColors.lightRed,
    this.textColor = AppColors.primaryRed,
    this.icon,
  });

  factory StatusBadge.red(String label, {IconData? icon}) {
    return StatusBadge(
      label: label,
      backgroundColor: AppColors.lightRed,
      textColor: AppColors.primaryRed,
      icon: icon,
    );
  }

  factory StatusBadge.neutral(String label, {IconData? icon}) {
    return StatusBadge(
      label: label,
      backgroundColor: const Color(0xFFF0F0F0),
      textColor: AppColors.primaryText,
      icon: icon,
    );
  }

  factory StatusBadge.success(String label, {IconData? icon}) {
    return StatusBadge(
      label: label,
      backgroundColor: AppColors.successLight,
      textColor: AppColors.success,
      icon: icon,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        color: backgroundColor,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (icon != null) ...[
            Icon(icon, size: 13, color: textColor),
            const SizedBox(width: 4),
          ],
          Text(
            label,
            style: TextStyle(
              fontSize: 11,
              fontWeight: FontWeight.w700,
              color: textColor,
              letterSpacing: 0.2,
            ),
          ),
        ],
      ),
    );
  }
}

