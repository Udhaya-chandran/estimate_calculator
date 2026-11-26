import 'package:flutter/material.dart';
import '../../../../app/theme/app_colors.dart';
import '../../../../app/theme/app_text_styles.dart';
import '../../../../core/widgets/custom_card.dart';
import '../../../../shared/models/category.dart';

class DashboardCategoryItem extends StatelessWidget {
  final Category category;
  final VoidCallback onTap;

  const DashboardCategoryItem({
    super.key,
    required this.category,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return CustomCard(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
      onTap: onTap,
      child: Row(
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(10),
            child: Container(
              width: 48,
              height: 48,
              color: context.colors.pillBg,
              child: category.imageUrl != null
                  ? Image.network(
                      category.imageUrl!,
                      fit: BoxFit.cover,
                      errorBuilder: (context, error, stackTrace) => _buildPlaceholder(context),
                      loadingBuilder: (context, child, progress) {
                        if (progress == null) return child;
                        return _buildPlaceholder(context);
                      },
                    )
                  : _buildPlaceholder(context),
            ),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  category.name,
                  style: AppTextStyles.titleSmall.copyWith(
                    fontSize: 14,
                    color: context.colors.primaryText,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 2),
                Text(
                  '${category.productCount} products',
                  style: AppTextStyles.bodySmall.copyWith(
                    color: context.colors.secondaryText,
                    fontSize: 12,
                  ),
                ),
              ],
            ),
          ),
          Icon(
            Icons.chevron_right_rounded,
            color: context.colors.secondaryText,
            size: 20,
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
          category.icon,
          color: AppColors.primaryRed,
          size: 24,
        ),
      ),
    );
  }
}
