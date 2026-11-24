import 'package:flutter/material.dart';
import 'package:estimate_calculator/app/theme/app_colors.dart';
import 'package:estimate_calculator/core/utils/currency_formatter.dart';
import 'package:estimate_calculator/core/widgets/custom_card.dart';
import 'package:estimate_calculator/features/estimates/domain/entities/estimate_item.dart';

class EstimateItemTile extends StatelessWidget {
  final EstimateItem item;
  final VoidCallback onEdit;
  final VoidCallback onDelete;

  const EstimateItemTile({
    super.key,
    required this.item,
    required this.onEdit,
    required this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    return CustomCard(
      padding: const EdgeInsets.all(11),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(7),
                child: Container(
                  width: 38,
                  height: 38,
                  color: const Color(0xFFF0F0F2),
                  child: item.product.imageUrl != null
                      ? Image.network(
                          item.product.imageUrl!,
                          fit: BoxFit.cover,
                          errorBuilder: (context, error, stackTrace) => _buildPlaceholder(),
                        )
                      : _buildPlaceholder(),
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      item.product.brand.toUpperCase(),
                      style: const TextStyle(
                        fontSize: 9.5,
                        fontWeight: FontWeight.w700,
                        color: AppColors.primaryRed,
                        letterSpacing: 0.5,
                      ),
                    ),
                    const SizedBox(height: 1),
                    Text(
                      item.product.name,
                      style: const TextStyle(
                        fontSize: 13.5,
                        fontWeight: FontWeight.w700,
                        color: AppColors.primaryText,
                      ),
                    ),
                  ],
                ),
              ),
              Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  IconButton(
                    icon: const Icon(Icons.edit_outlined, size: 18, color: AppColors.secondaryText),
                    tooltip: 'Edit item',
                    splashRadius: 16,
                    padding: const EdgeInsets.all(6),
                    constraints: const BoxConstraints(),
                    onPressed: onEdit,
                  ),
                  const SizedBox(width: 4),
                  IconButton(
                    icon: const Icon(Icons.delete_outline_rounded, size: 18, color: AppColors.primaryRed),
                    tooltip: 'Delete item',
                    splashRadius: 16,
                    padding: const EdgeInsets.all(6),
                    constraints: const BoxConstraints(),
                    onPressed: onDelete,
                  ),
                ],
              ),
            ],
          ),
          const SizedBox(height: 7),
          Container(
            width: double.infinity,
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 5),
            decoration: BoxDecoration(
              color: AppColors.background,
              borderRadius: BorderRadius.circular(6),
            ),
            child: Text(
              item.breakdown,
              style: const TextStyle(
                color: AppColors.primaryText,
                fontWeight: FontWeight.w500,
                fontSize: 11,
              ),
            ),
          ),
          const SizedBox(height: 8),
          const Divider(height: 1, color: AppColors.borderSubtle),
          const SizedBox(height: 8),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Rate: ${CurrencyFormatter.formatRate(item.rateSnapshot, item.product.pricingUnit)}',
                style: const TextStyle(
                  fontSize: 11,
                  color: AppColors.secondaryText,
                  fontWeight: FontWeight.w500,
                ),
              ),
              Row(
                children: [
                  const Text(
                    'Amount: ',
                    style: TextStyle(
                      fontSize: 11,
                      color: AppColors.secondaryText,
                    ),
                  ),
                  Text(
                    CurrencyFormatter.format(item.totalAmount),
                    style: const TextStyle(
                      fontSize: 14.5,
                      fontWeight: FontWeight.w800,
                      color: AppColors.primaryRed,
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

  Widget _buildPlaceholder() {
    return Container(
      color: AppColors.lightRed,
      child: Center(
        child: Icon(
          item.product.icon ?? Icons.category_outlined,
          color: AppColors.primaryRed,
          size: 20,
        ),
      ),
    );
  }
}
