import 'package:flutter/material.dart';
import 'package:estimate_calculator/app/theme/app_colors.dart';
import 'package:estimate_calculator/app/theme/app_text_styles.dart';
import 'package:estimate_calculator/core/utils/currency_formatter.dart';
import 'package:estimate_calculator/core/widgets/custom_card.dart';
import 'package:estimate_calculator/features/estimates/domain/entities/estimate_item.dart';

class SummaryBreakdownCard extends StatelessWidget {
  final List<EstimateItem> items;

  const SummaryBreakdownCard({
    super.key,
    required this.items,
  });

  @override
  Widget build(BuildContext context) {
    return CustomCard(
      padding: const EdgeInsets.all(12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Icon(Icons.table_chart_outlined, size: 16, color: AppColors.primaryRed),
              const SizedBox(width: 7),
              const Text(
                'Product Cost Breakdown',
                style: TextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.w700,
                  color: AppColors.primaryText,
                ),
              ),
              const Spacer(),
              Text(
                '${items.length} items',
                style: AppTextStyles.bodySmall.copyWith(
                  fontWeight: FontWeight.w600,
                  fontSize: 11,
                ),
              ),
            ],
          ),
          const SizedBox(height: 10),
          const Divider(height: 1, color: AppColors.border),
          const SizedBox(height: 6),
          ListView.separated(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: items.length,
            separatorBuilder: (_, _) => const Padding(
              padding: EdgeInsets.symmetric(vertical: 6.0),
              child: Divider(height: 1, color: AppColors.borderSubtle),
            ),
            itemBuilder: (context, index) {
              final item = items[index];
              return Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    width: 20,
                    height: 20,
                    alignment: Alignment.center,
                    decoration: BoxDecoration(
                      color: AppColors.lightRed,
                      borderRadius: BorderRadius.circular(5),
                    ),
                    child: Text(
                      '${index + 1}',
                      style: const TextStyle(
                        fontSize: 10,
                        fontWeight: FontWeight.w700,
                        color: AppColors.primaryRed,
                      ),
                    ),
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          item.product.name,
                          style: const TextStyle(
                            fontSize: 12.5,
                            fontWeight: FontWeight.w700,
                            color: AppColors.primaryText,
                          ),
                        ),
                        const SizedBox(height: 2),
                        Text(
                          item.breakdown,
                          style: const TextStyle(
                            color: AppColors.secondaryText,
                            fontSize: 11,
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(width: 10),
                  Text(
                    CurrencyFormatter.format(item.totalAmount),
                    style: const TextStyle(
                      fontSize: 13.5,
                      fontWeight: FontWeight.w700,
                      color: AppColors.primaryText,
                    ),
                  ),
                ],
              );
            },
          ),
        ],
      ),
    );
  }
}
