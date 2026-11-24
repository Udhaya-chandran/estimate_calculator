import 'package:flutter/material.dart';
import '../../../../app/theme/app_colors.dart';
import '../../../../app/theme/app_text_styles.dart';
import '../../../../core/utils/currency_formatter.dart';
import '../../../../core/widgets/custom_card.dart';
import '../../../../shared/models/product.dart';

class SampleShowcaseCard extends StatelessWidget {
  final Product product;
  final VoidCallback onCalculate;

  const SampleShowcaseCard({
    super.key,
    required this.product,
    required this.onCalculate,
  });

  @override
  Widget build(BuildContext context) {
    return CustomCard(
      padding: EdgeInsets.zero,
      onTap: onCalculate,
      borderRadius: 14,
      child: SizedBox(
        width: 165,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Top Image Container with Brand & Category Badges
            ClipRRect(
              borderRadius: const BorderRadius.vertical(top: Radius.circular(14)),
              child: Stack(
                children: [
                  Container(
                    height: 95,
                    width: double.infinity,
                    color: const Color(0xFFF0F0F2),
                    child: product.imageUrl != null
                        ? Image.network(
                            product.imageUrl!,
                            fit: BoxFit.cover,
                            errorBuilder: (context, error, stackTrace) => _buildPlaceholder(),
                            loadingBuilder: (context, child, progress) {
                              if (progress == null) return child;
                              return Container(
                                color: const Color(0xFFEEEEEE),
                                child: const Center(
                                  child: SizedBox(
                                    width: 18,
                                    height: 18,
                                    child: CircularProgressIndicator(
                                      strokeWidth: 2,
                                      color: AppColors.primaryRed,
                                    ),
                                  ),
                                ),
                              );
                            },
                          )
                        : _buildPlaceholder(),
                  ),
                  Positioned(
                    top: 6,
                    left: 6,
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                      decoration: BoxDecoration(
                        color: Colors.black.withValues(alpha: 0.65),
                        borderRadius: BorderRadius.circular(5),
                      ),
                      child: Text(
                        product.brand.toUpperCase(),
                        style: const TextStyle(
                          fontSize: 8.5,
                          fontWeight: FontWeight.w800,
                          color: Colors.white,
                          letterSpacing: 0.5,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),

            // Bottom Product Details
            Expanded(
              child: Padding(
                padding: const EdgeInsets.fromLTRB(10, 8, 10, 8),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      product.name,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(
                        fontSize: 12.5,
                        fontWeight: FontWeight.w700,
                        color: AppColors.primaryText,
                        height: 1.2,
                      ),
                    ),
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.baseline,
                      textBaseline: TextBaseline.alphabetic,
                      children: [
                        Flexible(
                          child: FittedBox(
                            fit: BoxFit.scaleDown,
                            child: Text(
                              CurrencyFormatter.format(product.rate),
                              style: AppTextStyles.priceMedium.copyWith(fontSize: 13.5),
                            ),
                          ),
                        ),
                        const SizedBox(width: 3),
                        Text(
                          '/ ${product.pricingUnit}',
                          style: const TextStyle(
                            fontSize: 9.5,
                            color: AppColors.secondaryText,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ],
                    ),
                    SizedBox(
                      width: double.infinity,
                      height: 28,
                      child: ElevatedButton.icon(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppColors.lightRed,
                          foregroundColor: AppColors.primaryRed,
                          elevation: 0,
                          padding: const EdgeInsets.symmetric(horizontal: 6),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(7),
                          ),
                        ),
                        onPressed: onCalculate,
                        icon: const Icon(Icons.calculate_outlined, size: 13),
                        label: const Text(
                          'Estimate',
                          style: TextStyle(
                            fontSize: 11,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildPlaceholder() {
    return Container(
      color: AppColors.lightRed.withValues(alpha: 0.6),
      child: Center(
        child: Icon(
          product.icon ?? Icons.category_outlined,
          size: 36,
          color: AppColors.primaryRed.withValues(alpha: 0.7),
        ),
      ),
    );
  }
}
