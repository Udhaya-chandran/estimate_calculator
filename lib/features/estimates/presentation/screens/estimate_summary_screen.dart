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
      body: LayoutBuilder(
        builder: (context, constraints) {
          final isWide = constraints.maxWidth >= 768;

          // Header Banner
          final headerBanner = CustomCard(
            backgroundColor: context.colors.surface,
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
                              color: context.colors.segmentedSelectedBg,
                              borderRadius: BorderRadius.circular(5),
                            ),
                            child: Text(
                              'HARDWARE ESTIMATION SHEET',
                              style: TextStyle(
                                fontSize: 9.5,
                                fontWeight: FontWeight.w700,
                                color: context.colors.primaryText,
                                letterSpacing: 0.5,
                              ),
                            ),
                          ),
                          const SizedBox(height: 5),
                          Text(
                            estimate.estimateId,
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.w800,
                              color: context.colors.primaryText,
                              letterSpacing: -0.3,
                            ),
                          ),
                        ],
                      ),
                    ),
                    Container(
                      padding: const EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        color: context.colors.segmentedSelectedBg,
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Icon(
                        Icons.receipt_long_rounded,
                        color: context.colors.primaryText,
                        size: 22,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 10),
                Divider(height: 1, color: context.colors.borderSubtle),
                const SizedBox(height: 10),
                Row(
                  children: [
                    Icon(Icons.calendar_today_outlined, size: 13, color: context.colors.secondaryText),
                    const SizedBox(width: 5),
                    Expanded(
                      child: Text(
                        dateFormatted,
                        style: TextStyle(
                          color: context.colors.secondaryText,
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
                        Icon(Icons.inventory_2_outlined, size: 13, color: context.colors.secondaryText),
                        const SizedBox(width: 4),
                        Text(
                          '${items.length} ${items.length == 1 ? 'item' : 'items'}',
                          style: TextStyle(
                            color: context.colors.secondaryText,
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
          );

          // Breakdown Card
          final breakdownCard = SummaryBreakdownCard(items: items);

          // Calculation Summary Card
          final calculationCard = CustomCard(
            padding: const EdgeInsets.all(12),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Calculation Summary',
                  style: TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.w700,
                    color: context.colors.primaryText,
                  ),
                ),
                const SizedBox(height: 10),

                // Total items row
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Total Items',
                      style: TextStyle(fontSize: 12.5, color: context.colors.secondaryText),
                    ),
                    Text(
                      '${items.length} ${items.length == 1 ? 'Product' : 'Products'}',
                      style: TextStyle(
                        fontSize: 13,
                        fontWeight: FontWeight.w700,
                        color: context.colors.primaryText,
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: 10),
                Divider(height: 1, color: context.colors.border),
                const SizedBox(height: 10),

                // Final Estimated Amount
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.baseline,
                  textBaseline: TextBaseline.alphabetic,
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'TOTAL ESTIMATE',
                            style: TextStyle(
                              fontSize: 10.5,
                              fontWeight: FontWeight.w800,
                              color: context.colors.primaryText,
                              letterSpacing: 0.6,
                            ),
                          ),
                          Text(
                            'Calculated total of all products',
                            style: TextStyle(
                              fontSize: 10.5,
                              color: context.colors.secondaryText,
                            ),
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
                          style: AppTextStyles.priceHighlight.copyWith(
                            fontSize: 22,
                            color: context.colors.primaryText,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          );

          // Action buttons
          final actionButtons = Column(
            mainAxisSize: MainAxisSize.min,
            children: [
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
            ],
          );

          if (isWide) {
            return SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                    flex: 6,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        headerBanner,
                        const SizedBox(height: 16),
                        breakdownCard,
                      ],
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    flex: 4,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        calculationCard,
                        const SizedBox(height: 16),
                        actionButtons,
                      ],
                    ),
                  ),
                ],
              ),
            );
          }

          // Mobile Layout
          return SingleChildScrollView(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                headerBanner,
                const SizedBox(height: 16),
                breakdownCard,
                const SizedBox(height: 16),
                calculationCard,
                const SizedBox(height: 20),
                actionButtons,
                const SizedBox(height: 24),
              ],
            ),
          );
        },
      ),
    );
  }

  void _showStartNewEstimateDialog(BuildContext context, WidgetRef ref) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        backgroundColor: context.colors.surface,
        title: Text(
          'Start New Estimate Session?',
          style: TextStyle(color: context.colors.primaryText, fontWeight: FontWeight.bold),
        ),
        content: Text(
          'This will reset the current items and begin a fresh estimate for another client.',
          style: TextStyle(color: context.colors.secondaryText),
        ),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: Text('Cancel', style: TextStyle(color: context.colors.secondaryText)),
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
