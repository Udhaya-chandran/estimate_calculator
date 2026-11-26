import 'package:flutter/material.dart';
import '../../../../app/theme/app_colors.dart';
import '../../../../app/theme/app_text_styles.dart';
import '../../../../core/utils/currency_formatter.dart';
import '../../../../core/widgets/custom_card.dart';
import '../../../calculator/domain/entities/calculation_result.dart';

class LivePreviewCard extends StatelessWidget {
  final CalculationResult result;
  final String productName;
  final String brand;
  final double unitRate;
  final String pricingUnit;

  const LivePreviewCard({
    super.key,
    required this.result,
    required this.productName,
    required this.brand,
    this.unitRate = 0.0,
    this.pricingUnit = 'unit',
  });

  @override
  Widget build(BuildContext context) {
    return CustomCard(
      backgroundColor: AppColors.surface,
      borderColor: AppColors.border,
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  Icon(
                    Icons.receipt_long_outlined,
                    size: 18,
                    color: context.colors.primaryText,
                  ),
                  const SizedBox(width: 8),
                  Text(
                    'Calculation Summary',
                    style: TextStyle(
                      fontSize: 13,
                      fontWeight: FontWeight.w700,
                      color: context.colors.primaryText,
                    ),
                  ),
                ],
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                decoration: BoxDecoration(
                  color: context.colors.segmentedSelectedBg,
                  borderRadius: BorderRadius.circular(6),
                ),
                child: Text(
                  '${result.calculatedQuantity.toStringAsFixed(2)} ${result.standardUnit}',
                  style: TextStyle(
                    fontSize: 11,
                    fontWeight: FontWeight.w700,
                    color: context.colors.primaryText,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: const Color(0xFFFBFBFC),
              borderRadius: BorderRadius.circular(10),
              border: Border.all(color: AppColors.borderSubtle),
            ),
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text(
                      'Measurement',
                      style: TextStyle(
                        fontSize: 12,
                        color: AppColors.secondaryText,
                      ),
                    ),
                    Text(
                      result.breakdownSummary.split('×').first.trim(),
                      style: const TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w600,
                        color: AppColors.primaryText,
                      ),
                    ),
                  ],
                ),
                if (unitRate > 0) ...[
                  const SizedBox(height: 6),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text(
                        'Store Rate',
                        style: TextStyle(
                          fontSize: 12,
                          color: AppColors.secondaryText,
                        ),
                      ),
                      Text(
                        '${CurrencyFormatter.format(unitRate)} / $pricingUnit',
                        style: const TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.w600,
                          color: AppColors.primaryText,
                        ),
                      ),
                    ],
                  ),
                ],
                const Padding(
                  padding: EdgeInsets.symmetric(vertical: 8),
                  child: Divider(height: 1, color: AppColors.borderSubtle),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.baseline,
                  textBaseline: TextBaseline.alphabetic,
                  children: [
                    Text(
                      'Estimated Total',
                      style: TextStyle(
                        fontSize: 13.5,
                        fontWeight: FontWeight.w700,
                        color: context.colors.primaryText,
                      ),
                    ),
                    Text(
                      CurrencyFormatter.format(result.totalAmount),
                      style: AppTextStyles.priceHighlight.copyWith(
                        fontSize: 22,
                        color: context.colors.primaryText,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
