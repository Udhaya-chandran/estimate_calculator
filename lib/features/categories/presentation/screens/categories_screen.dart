import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../../app/theme/app_colors.dart';
import '../../../../app/theme/app_text_styles.dart';
import '../../../../shared/providers/app_providers.dart';
import '../../../../shared/widgets/app_header.dart';
import '../../../../shared/widgets/bottom_estimate_bar.dart';
import '../../../estimates/presentation/providers/estimate_provider.dart';
import '../widgets/category_card.dart';

class CategoriesScreen extends ConsumerWidget {
  const CategoriesScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final categories = ref.watch(categoriesProvider);
    final selectedCategoryId = ref.watch(selectedCategoryIdProvider);
    final activeCount = ref.watch(estimateCountProvider);
    final activeSubtotal = ref.watch(estimateSubtotalProvider);

    return Scaffold(
      appBar: AppHeader(
        title: 'Select Category',
        subtitle: 'Hardware & Materials',
        showBackButton: true,
        onBack: () => context.canPop() ? context.pop() : context.go('/'),
        actions: [
          if (activeCount > 0)
            Padding(
              padding: const EdgeInsets.only(right: 8.0),
              child: IconButton(
                icon: Badge(
                  label: Text('$activeCount'),
                  backgroundColor: AppColors.primaryRed,
                  child: const Icon(Icons.shopping_cart_outlined, color: AppColors.primaryText),
                ),
                onPressed: () => context.push('/estimate-list'),
              ),
            ),
        ],
      ),
      body: Column(
        children: [
          Container(
            width: double.infinity,
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            color: AppColors.surface,
            child: Row(
              children: [
                const Icon(Icons.info_outline_rounded, size: 18, color: AppColors.secondaryText),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(
                    'Choose a category to view materials and calculate costs.',
                    style: AppTextStyles.bodySmall.copyWith(color: AppColors.secondaryText),
                  ),
                ),
              ],
            ),
          ),
          const Divider(height: 1, color: AppColors.border),
          Expanded(
            child: GridView.builder(
              padding: const EdgeInsets.all(16),
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                crossAxisSpacing: 14,
                mainAxisSpacing: 14,
                childAspectRatio: 0.80,
              ),
              itemCount: categories.length,
              itemBuilder: (context, index) {
                final cat = categories[index];
                final isSelected = selectedCategoryId == cat.id;

                return CategoryCard(
                  category: cat,
                  isSelected: isSelected,
                  onTap: () {
                    ref.read(selectedCategoryIdProvider.notifier).select(cat.id);
                    ref.read(selectedSubCategoryProvider.notifier).select(null);
                    ref.read(productSearchQueryProvider.notifier).setQuery('');
                    context.push('/products');
                  },
                  onSubCategoryTap: (subCat) {
                    ref.read(selectedCategoryIdProvider.notifier).select(cat.id);
                    ref.read(selectedSubCategoryProvider.notifier).select(subCat);
                    ref.read(productSearchQueryProvider.notifier).setQuery('');
                    context.push('/products');
                  },
                );
              },
            ),
          ),
        ],
      ),
      bottomNavigationBar: BottomEstimateBar(
        itemCount: activeCount,
        totalAmount: activeSubtotal,
        onViewEstimate: () => context.push('/estimate-list'),
      ),
    );
  }
}
