import 'package:flutter/material.dart';
import '../../../../app/theme/app_colors.dart';
import '../../../../app/theme/app_text_styles.dart';
import '../../../../core/widgets/custom_card.dart';
import '../../../../shared/models/category.dart';

class CategoryCard extends StatelessWidget {
  final Category category;
  final bool isSelected;
  final VoidCallback onTap;
  final void Function(String subCategory)? onSubCategoryTap;

  const CategoryCard({
    super.key,
    required this.category,
    this.isSelected = false,
    required this.onTap,
    this.onSubCategoryTap,
  });

  @override
  Widget build(BuildContext context) {
    return CustomCard(
      onTap: onTap,
      padding: EdgeInsets.zero,
      backgroundColor: isSelected ? AppColors.lightRed : AppColors.surface,
      borderColor: isSelected ? AppColors.primaryRed : AppColors.border,
      borderRadius: 14,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // 1. Top Image Header (proportional flex to adapt to any screen size)
          Expanded(
            flex: 11,
            child: ClipRRect(
              borderRadius: const BorderRadius.vertical(top: Radius.circular(14)),
              child: Stack(
                fit: StackFit.expand,
                children: [
                  Container(
                    color: const Color(0xFFF0F0F2),
                    child: category.imageUrl != null
                        ? Image.network(
                            category.imageUrl!,
                            fit: BoxFit.cover,
                            errorBuilder: (context, error, stackTrace) => _buildPlaceholder(),
                            loadingBuilder: (context, child, progress) {
                              if (progress == null) return child;
                              return Container(
                                color: const Color(0xFFF5F5F5),
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
                  // Subtle gradient overlay
                  Positioned.fill(
                    child: DecoratedBox(
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          begin: Alignment.topCenter,
                          end: Alignment.bottomCenter,
                          colors: [
                            Colors.black.withValues(alpha: 0.25),
                            Colors.transparent,
                            Colors.black.withValues(alpha: 0.15),
                          ],
                        ),
                      ),
                    ),
                  ),
                  // Icon Chip on Image
                  Positioned(
                    top: 7,
                    left: 7,
                    child: Container(
                      padding: const EdgeInsets.all(5),
                      decoration: BoxDecoration(
                        color: isSelected ? AppColors.primaryRed : Colors.white.withValues(alpha: 0.92),
                        shape: BoxShape.circle,
                      ),
                      child: Icon(
                        category.icon,
                        size: 14,
                        color: isSelected ? Colors.white : AppColors.primaryRed,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),

          // 2. Name, Subtitle & Row-Wise Sub-Categories (fits available height safely)
          Expanded(
            flex: 10,
            child: Padding(
              padding: const EdgeInsets.fromLTRB(10, 6, 10, 6),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  // Category Title
                  Text(
                    category.name,
                    style: AppTextStyles.titleSmall.copyWith(
                      color: isSelected ? AppColors.darkRed : AppColors.primaryText,
                      fontWeight: FontWeight.w800,
                      fontSize: 13.5,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),

                  // Subtitle
                  if (category.subtitle != null)
                    Text(
                      category.subtitle!,
                      style: const TextStyle(
                        color: AppColors.secondaryText,
                        fontSize: 10.5,
                        fontWeight: FontWeight.w500,
                        height: 1.15,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),

                  // Sub-category pills in a row-wise horizontal layout
                  if (category.subcategories.isNotEmpty)
                    SingleChildScrollView(
                      scrollDirection: Axis.horizontal,
                      physics: const BouncingScrollPhysics(),
                      child: Row(
                        children: category.subcategories.entries.take(3).map((entry) {
                          return Padding(
                            padding: const EdgeInsets.only(right: 5.0),
                            child: GestureDetector(
                              onTap: onSubCategoryTap != null ? () => onSubCategoryTap!(entry.key) : null,
                              child: Container(
                                padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2.5),
                                decoration: BoxDecoration(
                                  color: const Color(0xFFF4F4F6),
                                  borderRadius: BorderRadius.circular(12),
                                  border: Border.all(
                                    color: const Color(0xFFE2E2E6),
                                    width: 1,
                                  ),
                                ),
                                child: Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    Text(
                                      entry.key,
                                      style: const TextStyle(
                                        fontSize: 9.5,
                                        fontWeight: FontWeight.w600,
                                        color: AppColors.primaryText,
                                      ),
                                    ),
                                    const SizedBox(width: 3),
                                    Text(
                                      '${entry.value}',
                                      style: const TextStyle(
                                        fontSize: 9.5,
                                        fontWeight: FontWeight.w800,
                                        color: AppColors.primaryRed,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          );
                        }).toList(),
                      ),
                    ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPlaceholder() {
    return Container(
      color: AppColors.lightRed.withValues(alpha: 0.5),
      child: Center(
        child: Icon(
          category.icon,
          size: 32,
          color: AppColors.primaryRed.withValues(alpha: 0.7),
        ),
      ),
    );
  }
}
