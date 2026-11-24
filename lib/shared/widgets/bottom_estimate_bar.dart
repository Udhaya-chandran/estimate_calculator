import 'package:flutter/material.dart';
import '../../app/theme/app_colors.dart';
import '../../app/theme/app_text_styles.dart';
import '../../core/utils/currency_formatter.dart';
import '../../core/widgets/custom_button.dart';

class BottomEstimateBar extends StatelessWidget {
  final int itemCount;
  final double totalAmount;
  final VoidCallback onViewEstimate;
  final String actionLabel;
  final VoidCallback? onSecondaryAction;
  final String? secondaryActionLabel;

  const BottomEstimateBar({
    super.key,
    required this.itemCount,
    required this.totalAmount,
    required this.onViewEstimate,
    this.actionLabel = 'View Estimate',
    this.onSecondaryAction,
    this.secondaryActionLabel,
  });

  @override
  Widget build(BuildContext context) {
    if (itemCount == 0) return const SizedBox.shrink();

    final hasSecondaryAction = onSecondaryAction != null && secondaryActionLabel != null;

    return Container(
      padding: EdgeInsets.only(
        left: 12,
        right: 12,
        top: 10,
        bottom: 10 + MediaQuery.of(context).padding.bottom,
      ),
      decoration: BoxDecoration(
        color: AppColors.surface,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.08),
            blurRadius: 16,
            offset: const Offset(0, -4),
          ),
        ],
        border: const Border(
          top: BorderSide(color: AppColors.border, width: 1),
        ),
      ),
      child: LayoutBuilder(
        builder: (context, constraints) {
          final isStacked = constraints.maxWidth < 480 || hasSecondaryAction;

          if (isStacked) {
            return Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                      decoration: BoxDecoration(
                        color: AppColors.lightRed,
                        borderRadius: BorderRadius.circular(6),
                      ),
                      child: Text(
                        '$itemCount ${itemCount == 1 ? 'item' : 'items'}',
                        style: const TextStyle(
                          fontSize: 11,
                          fontWeight: FontWeight.w700,
                          color: AppColors.primaryRed,
                        ),
                      ),
                    ),
                    const SizedBox(width: 6),
                    const Expanded(
                      child: Text(
                        'ESTIMATED TOTAL',
                        style: TextStyle(
                          fontSize: 11,
                          fontWeight: FontWeight.w600,
                          color: AppColors.secondaryText,
                          letterSpacing: 0.4,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                    const SizedBox(width: 6),
                    FittedBox(
                      fit: BoxFit.scaleDown,
                      alignment: Alignment.centerRight,
                      child: Text(
                        CurrencyFormatter.format(totalAmount),
                        style: AppTextStyles.priceHighlight.copyWith(fontSize: 18),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                if (hasSecondaryAction)
                  Row(
                    children: [
                      Expanded(
                        child: CustomButton(
                          text: secondaryActionLabel!,
                          onPressed: onSecondaryAction,
                          variant: ButtonVariant.outline,
                          height: 42,
                        ),
                      ),
                      const SizedBox(width: 8),
                      Expanded(
                        child: CustomButton(
                          text: actionLabel,
                          onPressed: onViewEstimate,
                          icon: Icons.arrow_forward_rounded,
                          height: 42,
                        ),
                      ),
                    ],
                  )
                else
                  CustomButton(
                    text: actionLabel,
                    onPressed: onViewEstimate,
                    icon: Icons.arrow_forward_rounded,
                    fullWidth: true,
                    height: 44,
                  ),
              ],
            );
          }

          // Single-line layout for wide tablet/desktop screens with single button
          return Row(
            children: [
              Expanded(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                          decoration: BoxDecoration(
                            color: AppColors.lightRed,
                            borderRadius: BorderRadius.circular(6),
                          ),
                          child: Text(
                            '$itemCount ${itemCount == 1 ? 'item' : 'items'}',
                            style: const TextStyle(
                              fontSize: 11,
                              fontWeight: FontWeight.w700,
                              color: AppColors.primaryRed,
                            ),
                          ),
                        ),
                        const SizedBox(width: 6),
                        const Flexible(
                          child: Text(
                            'ESTIMATED TOTAL',
                            style: TextStyle(
                              fontSize: 11,
                              fontWeight: FontWeight.w600,
                              color: AppColors.secondaryText,
                              letterSpacing: 0.5,
                            ),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 2),
                    FittedBox(
                      fit: BoxFit.scaleDown,
                      alignment: Alignment.centerLeft,
                      child: Text(
                        CurrencyFormatter.format(totalAmount),
                        style: AppTextStyles.priceHighlight.copyWith(fontSize: 22),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 12),
              CustomButton(
                text: actionLabel,
                onPressed: onViewEstimate,
                icon: Icons.arrow_forward_rounded,
                height: 46,
              ),
            ],
          );
        },
      ),
    );
  }
}
