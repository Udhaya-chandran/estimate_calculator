import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:estimate_calculator/app/theme/app_colors.dart';
import 'package:estimate_calculator/app/theme/app_text_styles.dart';
import 'package:estimate_calculator/core/utils/currency_formatter.dart';
import 'package:estimate_calculator/core/widgets/custom_card.dart';
import 'package:estimate_calculator/core/widgets/status_badge.dart';
import 'package:estimate_calculator/features/estimates/domain/entities/estimate.dart';

class RecentEstimateCard extends StatelessWidget {
  final Estimate estimate;
  final VoidCallback? onTap;

  const RecentEstimateCard({
    super.key,
    required this.estimate,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final dateFormat = DateFormat('dd MMM yyyy, hh:mm a');
    final formattedDate = dateFormat.format(estimate.createdAt);

    return CustomCard(
      padding: const EdgeInsets.all(16),
      onTap: onTap,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  Container(
                    width: 32,
                    height: 32,
                    decoration: BoxDecoration(
                      color: context.colors.segmentedSelectedBg,
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Icon(
                      Icons.receipt_long_rounded,
                      color: context.colors.primaryText,
                      size: 18,
                    ),
                  ),
                  const SizedBox(width: 10),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        estimate.id,
                        style: AppTextStyles.titleSmall.copyWith(
                          color: context.colors.primaryText,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                      Text(
                        formattedDate,
                        style: AppTextStyles.bodySmall.copyWith(fontSize: 11),
                      ),
                    ],
                  ),
                ],
              ),
              StatusBadge.red('${estimate.items.length} ${estimate.items.length == 1 ? 'item' : 'items'}'),
            ],
          ),
          const SizedBox(height: 12),
          const Divider(height: 1, color: AppColors.borderSubtle),
          const SizedBox(height: 12),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Expanded(
                child: Text(
                  estimate.customerName ?? 'Walk-in Client',
                  style: AppTextStyles.labelLarge.copyWith(
                    color: AppColors.primaryText,
                    fontSize: 13,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Text(
                    'Total Amount',
                    style: TextStyle(
                      fontSize: 11,
                      color: context.colors.secondaryText,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  Text(
                    CurrencyFormatter.format(estimate.finalAmount),
                    style: AppTextStyles.priceMedium.copyWith(
                      fontSize: 17,
                      color: context.colors.primaryText,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }
}
