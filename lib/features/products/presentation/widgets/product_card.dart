import 'package:flutter/material.dart';
import '../../../../app/theme/app_colors.dart';
import '../../../../core/utils/currency_formatter.dart';
import '../../../../core/widgets/custom_card.dart';
import '../../../../core/widgets/status_badge.dart';
import '../../../../shared/models/product.dart';

class ProductCard extends StatelessWidget {
  final Product product;
  final VoidCallback onSelect;

  const ProductCard({
    super.key,
    required this.product,
    required this.onSelect,
  });

  @override
  Widget build(BuildContext context) {
    return CustomCard(
      onTap: onSelect,
      padding: const EdgeInsets.all(11),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(8),
                child: Container(
                  width: 52,
                  height: 52,
                  color: context.colors.pillBg,
                  child: product.imageUrl != null
                      ? Image.network(
                          product.imageUrl!,
                          fit: BoxFit.cover,
                          errorBuilder: (context, error, stackTrace) => _buildPlaceholder(context),
                          loadingBuilder: (context, child, progress) {
                            if (progress == null) return child;
                            return Container(
                              color: context.colors.pillBg,
                              child: const Center(
                                child: SizedBox(
                                  width: 14,
                                  height: 14,
                                  child: CircularProgressIndicator(
                                    strokeWidth: 2,
                                    color: AppColors.primaryRed,
                                  ),
                                ),
                              ),
                            );
                          },
                        )
                      : _buildPlaceholder(context),
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Text(
                          product.brand.toUpperCase(),
                          style: TextStyle(
                            fontSize: 9.5,
                            fontWeight: FontWeight.w700,
                            color: context.colors.secondaryText,
                            letterSpacing: 0.6,
                          ),
                        ),
                        const Spacer(),
                        StatusBadge.neutral(product.measurementType.label),
                      ],
                    ),
                    const SizedBox(height: 2),
                    Text(
                      product.name,
                      style: TextStyle(
                        fontSize: 13,
                        fontWeight: FontWeight.w700,
                        color: context.colors.primaryText,
                      ),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                ),
              ),
            ],
          ),
          if (product.description != null) ...[
            const SizedBox(height: 6),
            Text(
              product.description!,
              style: TextStyle(
                color: context.colors.secondaryText,
                height: 1.3,
                fontSize: 11,
              ),
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),
          ],
          const SizedBox(height: 8),
          Divider(height: 1, color: context.colors.borderSubtle),
          const SizedBox(height: 8),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Rate / Unit',
                      style: TextStyle(
                        fontSize: 10,
                        color: context.colors.secondaryText,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    const SizedBox(height: 1),
                    Text.rich(
                      TextSpan(
                        children: [
                          TextSpan(
                            text: CurrencyFormatter.format(product.rate),
                            style: TextStyle(
                              fontSize: 15,
                              fontWeight: FontWeight.w800,
                              color: context.colors.primaryText,
                            ),
                          ),
                          TextSpan(
                            text: ' / ${product.pricingUnit}',
                            style: TextStyle(
                              fontSize: 11,
                              color: context.colors.secondaryText,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              ElevatedButton.icon(
                style: ElevatedButton.styleFrom(
                  backgroundColor: context.colors.pillBg,
                  foregroundColor: context.colors.primaryText,
                  elevation: 0,
                  side: BorderSide(color: context.colors.pillBorder, width: 1),
                  padding: const EdgeInsets.symmetric(horizontal: 11, vertical: 6),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(7),
                  ),
                ),
                onPressed: onSelect,
                icon: const Icon(Icons.calculate_outlined, size: 14),
                label: const Text(
                  'Calculate',
                  style: TextStyle(
                    fontWeight: FontWeight.w700,
                    fontSize: 11.5,
                  ),
                ),
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
          product.icon ?? Icons.category_outlined,
          color: AppColors.primaryRed.withValues(alpha: 0.7),
          size: 28,
        ),
      ),
    );
  }
}
