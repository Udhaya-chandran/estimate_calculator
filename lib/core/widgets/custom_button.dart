import 'package:flutter/material.dart';
import '../../app/theme/app_colors.dart';

enum ButtonVariant { primary, secondary, outline, text }

class CustomButton extends StatelessWidget {
  final String text;
  final VoidCallback? onPressed;
  final IconData? icon;
  final ButtonVariant variant;
  final bool fullWidth;
  final double height;
  final double? fontSize;

  const CustomButton({
    super.key,
    required this.text,
    required this.onPressed,
    this.icon,
    this.variant = ButtonVariant.primary,
    this.fullWidth = false,
    this.height = 44.0,
    this.fontSize,
  });

  @override
  Widget build(BuildContext context) {
    final effectiveFontSize = fontSize ?? 12.5;

    Widget content;
    if (icon != null) {
      content = Row(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(icon, size: 15),
          const SizedBox(width: 4),
          Flexible(
            child: Text(
              text,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: TextStyle(
                fontSize: effectiveFontSize,
                fontWeight: FontWeight.w700,
              ),
            ),
          ),
        ],
      );
    } else {
      content = Text(
        text,
        textAlign: TextAlign.center,
        maxLines: 1,
        overflow: TextOverflow.ellipsis,
        style: TextStyle(
          fontSize: effectiveFontSize,
          fontWeight: FontWeight.w700,
        ),
      );
    }

    Widget button;
    switch (variant) {
      case ButtonVariant.primary:
        button = ElevatedButton(
          onPressed: onPressed,
          style: ElevatedButton.styleFrom(
            backgroundColor: AppColors.primaryRed,
            foregroundColor: AppColors.textOnPrimary,
            elevation: 0,
            padding: const EdgeInsets.symmetric(horizontal: 6),
            minimumSize: Size(0, height),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10),
            ),
          ),
          child: content,
        );
        break;

      case ButtonVariant.secondary:
        button = ElevatedButton(
          onPressed: onPressed,
          style: ElevatedButton.styleFrom(
            backgroundColor: AppColors.lightRed,
            foregroundColor: AppColors.primaryRed,
            elevation: 0,
            padding: const EdgeInsets.symmetric(horizontal: 6),
            minimumSize: Size(0, height),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10),
            ),
          ),
          child: content,
        );
        break;

      case ButtonVariant.outline:
        button = OutlinedButton(
          onPressed: onPressed,
          style: OutlinedButton.styleFrom(
            foregroundColor: AppColors.primaryRed,
            side: const BorderSide(color: AppColors.primaryRed, width: 1.5),
            padding: const EdgeInsets.symmetric(horizontal: 6),
            minimumSize: Size(0, height),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10),
            ),
          ),
          child: content,
        );
        break;

      case ButtonVariant.text:
        button = TextButton(
          onPressed: onPressed,
          style: TextButton.styleFrom(
            foregroundColor: AppColors.primaryRed,
            padding: const EdgeInsets.symmetric(horizontal: 6),
            minimumSize: Size(0, height),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8),
            ),
          ),
          child: content,
        );
        break;
    }

    if (fullWidth) {
      return SizedBox(
        width: double.infinity,
        height: height,
        child: button,
      );
    }

    return SizedBox(
      height: height,
      child: button,
    );
  }
}
