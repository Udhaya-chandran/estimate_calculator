import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import '../../../../app/theme/app_colors.dart';
import '../../../../app/theme/app_text_styles.dart';
import '../../../../core/utils/currency_formatter.dart';
import '../../../../core/widgets/custom_button.dart';
import '../../../../core/widgets/custom_card.dart';
import '../../../../shared/widgets/app_header.dart';
import '../providers/estimate_provider.dart';
import '../widgets/summary_breakdown_card.dart';

class EstimateSummaryScreen extends ConsumerWidget {
  const EstimateSummaryScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final estimate = ref.watch(estimateProvider);
    final items = estimate.items;
    final finalAmount = estimate.finalAmount;

    final dateFormatted = DateFormat('dd MMMM yyyy, hh:mm a').format(estimate.createdAt);

    return Scaffold(
      appBar: AppHeader(
        title: 'Estimate Summary',
        subtitle: estimate.estimateId,
        showBackButton: true,
        onBack: () => context.canPop() ? context.pop() : context.go('/estimate-list'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Estimate Header Banner
            CustomCard(
              backgroundColor: AppColors.surface,
              padding: const EdgeInsets.all(12),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Container(
                              padding: const EdgeInsets.symmetric(horizontal: 7, vertical: 2.5),
                              decoration: BoxDecoration(
                                color: AppColors.lightRed,
                                borderRadius: BorderRadius.circular(5),
                              ),
                              child: const Text(
                                'HARDWARE ESTIMATION SHEET',
                                style: TextStyle(
                                  fontSize: 9.5,
                                  fontWeight: FontWeight.w700,
                                  color: AppColors.primaryRed,
                                  letterSpacing: 0.5,
                                ),
                              ),
                            ),
                            const SizedBox(height: 5),
                            Text(
                              estimate.estimateId,
                              style: const TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.w800,
                                color: AppColors.primaryText,
                                letterSpacing: -0.3,
                              ),
                            ),
                          ],
                        ),
                      ),
                      Container(
                        padding: const EdgeInsets.all(8),
                        decoration: BoxDecoration(
                          color: AppColors.lightRed,
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: const Icon(
                          Icons.receipt_long_rounded,
                          color: AppColors.primaryRed,
                          size: 22,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 10),
                  const Divider(height: 1, color: AppColors.borderSubtle),
                  const SizedBox(height: 10),
                  Row(
                    children: [
                      const Icon(Icons.calendar_today_outlined, size: 13, color: AppColors.secondaryText),
                      const SizedBox(width: 5),
                      Expanded(
                        child: Text(
                          dateFormatted,
                          style: AppTextStyles.bodySmall.copyWith(
                            fontWeight: FontWeight.w500,
                            fontSize: 11,
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                      const SizedBox(width: 8),
                      Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          const Icon(Icons.inventory_2_outlined, size: 13, color: AppColors.secondaryText),
                          const SizedBox(width: 4),
                          Text(
                            '${items.length} ${items.length == 1 ? 'item' : 'items'}',
                            style: AppTextStyles.bodySmall.copyWith(
                              fontWeight: FontWeight.w600,
                              fontSize: 11,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ],
              ),
            ),

            const SizedBox(height: 16),

            // Product Breakdown Card
            SummaryBreakdownCard(items: items),

            const SizedBox(height: 16),

            // Financial Summary Calculation Card
            CustomCard(
              padding: const EdgeInsets.all(12),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Calculation Summary',
                    style: TextStyle(
                      fontSize: 13,
                      fontWeight: FontWeight.w700,
                      color: AppColors.primaryText,
                    ),
                  ),
                  const SizedBox(height: 10),

                  // Total items row
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text(
                        'Total Items',
                        style: TextStyle(fontSize: 12.5, color: AppColors.secondaryText),
                      ),
                      Text(
                        '${items.length} ${items.length == 1 ? 'Product' : 'Products'}',
                        style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w700),
                      ),
                    ],
                  ),

                  const SizedBox(height: 10),
                  const Divider(height: 1, color: AppColors.border),
                  const SizedBox(height: 10),

                  // Final Estimated Amount (Prominent Red)
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.baseline,
                    textBaseline: TextBaseline.alphabetic,
                    children: [
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text(
                              'TOTAL ESTIMATE',
                              style: TextStyle(
                                fontSize: 10.5,
                                fontWeight: FontWeight.w800,
                                color: AppColors.primaryRed,
                                letterSpacing: 0.6,
                              ),
                            ),
                            Text(
                              'Calculated total of all products',
                              style: AppTextStyles.bodySmall.copyWith(fontSize: 10.5),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(width: 8),
                      Flexible(
                        child: FittedBox(
                          fit: BoxFit.scaleDown,
                          alignment: Alignment.centerRight,
                          child: Text(
                            CurrencyFormatter.format(finalAmount),
                            style: AppTextStyles.priceHighlight.copyWith(fontSize: 22),
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),

            const SizedBox(height: 20),

            // Actions: Start New Estimate OR Return to Edit
            CustomButton(
              text: 'Start New Estimate',
              icon: Icons.add_circle_outline_rounded,
              fullWidth: true,
              height: 44,
              onPressed: () {
                _showStartNewEstimateDialog(context, ref);
              },
            ),
            const SizedBox(height: 10),
            CustomButton(
              text: 'Back to Edit Estimate',
              variant: ButtonVariant.outline,
              icon: Icons.edit_note_rounded,
              fullWidth: true,
              height: 44,
              onPressed: () => context.canPop() ? context.pop() : context.go('/estimate-list'),
            ),
            const SizedBox(height: 24),
          ],
        ),
      ),
    );
  }

  void _showStartNewEstimateDialog(BuildContext context, WidgetRef ref) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Start New Estimate Session?'),
        content: const Text(
          'This will reset the current items and begin a fresh estimate for another client.',
        ),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: const Text('Cancel', style: TextStyle(color: AppColors.secondaryText)),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.primaryRed,
              foregroundColor: Colors.white,
            ),
            onPressed: () {
              ref.read(estimateProvider.notifier).startNewEstimate();
              Navigator.pop(ctx);
              context.go('/');
            },
            child: const Text('Start New'),
          ),
        ],
      ),
    );
  }
}
