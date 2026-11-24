import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../../../../app/theme/app_colors.dart';
import '../../../../app/theme/app_text_styles.dart';

class MeasurementInputField extends StatelessWidget {
  final String label;
  final String? hint;
  final TextEditingController controller;
  final ValueChanged<String> onChanged;
  final VoidCallback? onIncrement;
  final VoidCallback? onDecrement;
  final Widget? trailingUnitSelector;
  final String? helperText;
  final bool isIntegerOnly;
  final List<Widget>? quickChips;

  const MeasurementInputField({
    super.key,
    required this.label,
    this.hint,
    required this.controller,
    required this.onChanged,
    this.onIncrement,
    this.onDecrement,
    this.trailingUnitSelector,
    this.helperText,
    this.isIntegerOnly = false,
    this.quickChips,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    label,
                    style: AppTextStyles.titleSmall.copyWith(fontSize: 13.5),
                  ),
                  if (helperText != null)
                    Text(
                      helperText!,
                      style: AppTextStyles.bodySmall.copyWith(
                        fontSize: 11,
                        color: AppColors.secondaryText,
                      ),
                    ),
                ],
              ),
            ),
            const SizedBox(width: 12),
            Container(
              decoration: BoxDecoration(
                color: AppColors.surface,
                borderRadius: BorderRadius.circular(10),
                border: Border.all(color: AppColors.border, width: 1),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  if (onDecrement != null)
                    IconButton(
                      icon: const Icon(Icons.remove_rounded, size: 18, color: AppColors.secondaryText),
                      onPressed: onDecrement,
                      constraints: const BoxConstraints(minWidth: 36, minHeight: 38),
                      padding: EdgeInsets.zero,
                      splashRadius: 18,
                      tooltip: 'Decrease',
                    ),
                  SizedBox(
                    width: trailingUnitSelector != null ? 52 : 44,
                    child: TextField(
                      controller: controller,
                      onChanged: onChanged,
                      keyboardType: TextInputType.numberWithOptions(decimal: !isIntegerOnly),
                      inputFormatters: [
                        if (isIntegerOnly)
                          FilteringTextInputFormatter.digitsOnly
                        else
                          FilteringTextInputFormatter.allow(RegExp(r'^\d*\.?\d*')),
                      ],
                      textAlign: TextAlign.center,
                      style: const TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.w700,
                        color: AppColors.primaryText,
                      ),
                      decoration: InputDecoration(
                        hintText: hint ?? '0',
                        hintStyle: const TextStyle(color: AppColors.hintText, fontWeight: FontWeight.normal),
                        border: InputBorder.none,
                        isDense: true,
                        contentPadding: const EdgeInsets.symmetric(vertical: 8),
                      ),
                    ),
                  ),
                  if (onIncrement != null)
                    IconButton(
                      icon: const Icon(Icons.add_rounded, size: 18, color: AppColors.primaryRed),
                      onPressed: onIncrement,
                      constraints: const BoxConstraints(minWidth: 36, minHeight: 38),
                      padding: EdgeInsets.zero,
                      splashRadius: 18,
                      tooltip: 'Increase',
                    ),
                  if (trailingUnitSelector != null) ...[
                    Container(
                      height: 24,
                      width: 1,
                      color: AppColors.border,
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 6),
                      child: trailingUnitSelector!,
                    ),
                  ],
                ],
              ),
            ),
          ],
        ),
        if (quickChips != null && quickChips!.isNotEmpty) ...[
          const SizedBox(height: 8),
          Wrap(
            spacing: 8,
            runSpacing: 6,
            children: quickChips!,
          ),
        ],
      ],
    );
  }
}
