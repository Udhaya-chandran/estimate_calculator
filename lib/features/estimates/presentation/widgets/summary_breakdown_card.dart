import 'package:flutter/material.dart';
import 'package:estimate_calculator/app/theme/app_colors.dart';
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
              Icon(Icons.table_chart_outlined, size: 16, color: context.colors.secondaryText),
              const SizedBox(width: 7),
              Text(
                'Product Cost Breakdown',
                style: TextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.w700,
                  color: context.colors.primaryText,
                ),
              ),
              const Spacer(),
              Text(
                '${items.length} items',
                style: TextStyle(
                  fontWeight: FontWeight.w600,
                  fontSize: 11,
                  color: context.colors.secondaryText,
                ),
              ),
            ],
          ),
          const SizedBox(height: 10),
          Divider(height: 1, color: context.colors.border),
          const SizedBox(height: 6),
          ListView.separated(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: items.length,
            separatorBuilder: (_, _) => Padding(
              padding: const EdgeInsets.symmetric(vertical: 6.0),
              child: Divider(height: 1, color: context.colors.borderSubtle),
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
                      color: context.colors.segmentedSelectedBg,
                      borderRadius: BorderRadius.circular(5),
                    ),
                    child: Text(
                      '${index + 1}',
                      style: TextStyle(
                        fontSize: 10,
                        fontWeight: FontWeight.w700,
                        color: context.colors.primaryText,
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
                          style: TextStyle(
                            fontSize: 12.5,
                            fontWeight: FontWeight.w700,
                            color: context.colors.primaryText,
                          ),
                        ),
                        const SizedBox(height: 2),
                        Text(
                          item.breakdown,
                          style: TextStyle(
                            color: context.colors.secondaryText,
                            fontSize: 11,
                          ),
                        ),
                        const SizedBox(height: 2),
                        Text(
                          'Rate: ${CurrencyFormatter.formatRate(item.rateSnapshot, item.product.pricingUnit)}',
                          style: TextStyle(
                            color: context.colors.secondaryText,
                            fontSize: 10.5,
                            fontStyle: FontStyle.italic,
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(width: 8),
                  Text(
                    CurrencyFormatter.format(item.totalAmount),
                    style: TextStyle(
                      fontSize: 13,
                      fontWeight: FontWeight.w800,
                      color: context.colors.primaryText,
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
