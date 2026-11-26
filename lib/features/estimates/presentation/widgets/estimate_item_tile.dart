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
                  color: context.colors.pillBg,
                  child: item.product.imageUrl != null
                      ? Image.network(
                          item.product.imageUrl!,
                          fit: BoxFit.cover,
                          errorBuilder: (context, error, stackTrace) => _buildPlaceholder(context),
                        )
                      : _buildPlaceholder(context),
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      item.product.brand.toUpperCase(),
                      style: TextStyle(
                        fontSize: 9.5,
                        fontWeight: FontWeight.w700,
                        color: context.colors.secondaryText,
                        letterSpacing: 0.5,
                      ),
                    ),
                    const SizedBox(height: 1),
                    Text(
                      item.product.name,
                      style: TextStyle(
                        fontSize: 13.5,
                        fontWeight: FontWeight.w700,
                        color: context.colors.primaryText,
                      ),
                    ),
                  ],
                ),
              ),
              Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  IconButton(
                    icon: Icon(Icons.edit_outlined, size: 18, color: context.colors.secondaryText),
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
              color: context.colors.pillBg,
              borderRadius: BorderRadius.circular(6),
            ),
            child: Text(
              item.breakdown,
              style: TextStyle(
                color: context.colors.primaryText,
                fontWeight: FontWeight.w500,
                fontSize: 11,
              ),
            ),
          ),
          const SizedBox(height: 8),
          Divider(height: 1, color: context.colors.borderSubtle),
          const SizedBox(height: 8),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Rate: ${CurrencyFormatter.formatRate(item.rateSnapshot, item.product.pricingUnit)}',
                style: TextStyle(
                  fontSize: 11,
                  color: context.colors.secondaryText,
                  fontWeight: FontWeight.w500,
                ),
              ),
              Row(
                children: [
                  Text(
                    'Amount: ',
                    style: TextStyle(
                      fontSize: 11,
                      color: context.colors.secondaryText,
                    ),
                  ),
                  Text(
                    CurrencyFormatter.format(item.totalAmount),
                    style: TextStyle(
                      fontSize: 14.5,
                      fontWeight: FontWeight.w800,
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

  Widget _buildPlaceholder(BuildContext context) {
    return Container(
      color: context.colors.lightRed,
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
