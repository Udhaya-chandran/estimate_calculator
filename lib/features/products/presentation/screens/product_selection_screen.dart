import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:estimate_calculator/app/theme/app_colors.dart';
import 'package:estimate_calculator/core/widgets/empty_state_view.dart';
import 'package:estimate_calculator/features/calculator/presentation/providers/calculator_provider.dart';
import 'package:estimate_calculator/features/estimates/presentation/providers/estimate_provider.dart';
import 'package:estimate_calculator/shared/models/product.dart';
import 'package:estimate_calculator/shared/providers/app_providers.dart';
import 'package:estimate_calculator/shared/widgets/app_header.dart';
import 'package:estimate_calculator/shared/widgets/bottom_estimate_bar.dart';
import '../widgets/product_card.dart';

class ProductSelectionScreen extends ConsumerStatefulWidget {
  const ProductSelectionScreen({super.key});

  @override
  ConsumerState<ProductSelectionScreen> createState() => _ProductSelectionScreenState();
}

class _ProductSelectionScreenState extends ConsumerState<ProductSelectionScreen> {
  @override
  Widget build(BuildContext context) {
    final categories = ref.watch(categoriesProvider);
    final selectedCategoryId = ref.watch(selectedCategoryIdProvider);
    final selectedCategory = ref.watch(selectedCategoryProvider) ?? categories.first;
    final selectedSubCategory = ref.watch(selectedSubCategoryProvider);
    final filteredProducts = ref.watch(filteredProductsProvider);
    final categoryAllProducts = ref.watch(productsByCategoryProvider(selectedCategory.id));
    final activeCount = ref.watch(estimateCountProvider);
    final activeSubtotal = ref.watch(estimateSubtotalProvider);
    final screenWidth = MediaQuery.of(context).size.width;
    final isWide = screenWidth >= 640;

    return Scaffold(
      backgroundColor: context.colors.background,
      appBar: AppHeader(
        title: selectedCategory.name,
        subtitle: '${categoryAllProducts.length} items available',
        showBackButton: true,
        onBack: () => context.canPop() ? context.pop() : context.go('/dashboard'),
        actions: [
          if (activeCount > 0)
            Padding(
              padding: const EdgeInsets.only(right: 4.0),
              child: IconButton(
                icon: Badge(
                  label: Text('$activeCount'),
                  backgroundColor: AppColors.primaryRed,
                  child: Icon(Icons.shopping_cart_outlined, color: context.colors.primaryText),
                ),
                onPressed: () => context.push('/estimate-list'),
              ),
            ),
        ],
      ),
      body: CustomScrollView(
        slivers: [
          // 1. Top Category Tabs Bar
          SliverToBoxAdapter(
            child: Container(
              color: context.colors.surface,
              padding: const EdgeInsets.symmetric(vertical: 9),
              child: SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: Row(
                  children: categories.map((cat) {
                    final isSelected = cat.id == (selectedCategoryId ?? selectedCategory.id);
                    return Padding(
                      padding: const EdgeInsets.only(right: 8),
                      child: InkWell(
                        onTap: () {
                          ref.read(selectedCategoryIdProvider.notifier).select(cat.id);
                        },
                        borderRadius: BorderRadius.circular(20),
                        child: AnimatedContainer(
                          duration: const Duration(milliseconds: 200),
                          padding: const EdgeInsets.symmetric(horizontal: 13, vertical: 7),
                          decoration: BoxDecoration(
                            color: isSelected ? AppColors.primaryRed : context.colors.cardBackground,
                            borderRadius: BorderRadius.circular(20),
                            border: Border.all(
                              color: isSelected ? AppColors.primaryRed : context.colors.border,
                              width: 1.1,
                            ),
                            boxShadow: isSelected
                                ? [
                                    BoxShadow(
                                      color: AppColors.primaryRed.withValues(alpha: 0.25),
                                      blurRadius: 6,
                                      offset: const Offset(0, 2),
                                    ),
                                  ]
                                : [
                                    BoxShadow(
                                      color: context.colors.cardShadow,
                                      blurRadius: 3,
                                      offset: const Offset(0, 1),
                                    ),
                                  ],
                          ),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Icon(
                                _getCategoryIcon(cat.id),
                                size: 16,
                                color: isSelected ? Colors.white : context.colors.primaryText,
                              ),
                              const SizedBox(width: 6),
                              Text(
                                cat.name,
                                style: TextStyle(
                                  color: isSelected ? Colors.white : context.colors.primaryText,
                                  fontWeight: isSelected ? FontWeight.w700 : FontWeight.w600,
                                  fontSize: 12.5,
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
            ),
          ),

          SliverToBoxAdapter(
            child: Divider(height: 1, thickness: 1, color: context.colors.border),
          ),

          // 2. Breadcrumb, Title & Subtitle
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(16, 12, 16, 8),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Breadcrumb Navigation
                  Row(
                    children: [
                      GestureDetector(
                        onTap: () {
                          if (context.canPop()) {
                            context.pop();
                          } else {
                            context.go('/dashboard');
                          }
                        },
                        child: Text(
                          'All categories',
                          style: TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.w700,
                            color: context.colors.primaryText,
                          ),
                        ),
                      ),
                      Text(
                        '  /  ',
                        style: TextStyle(
                          fontSize: 12,
                          color: context.colors.secondaryText,
                          fontWeight: FontWeight.w400,
                        ),
                      ),
                      Text(
                        selectedCategory.name,
                        style: TextStyle(
                          fontSize: 12,
                          color: context.colors.secondaryText,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),

                  // Category Title
                  Text(
                    selectedCategory.name,
                    style: TextStyle(
                      fontSize: 21,
                      fontWeight: FontWeight.w800,
                      color: context.colors.primaryText,
                      letterSpacing: -0.4,
                    ),
                  ),
                  const SizedBox(height: 3),

                  // Category Subtitle & Count
                  Text(
                    '${selectedCategory.subtitle ?? ''} · ${categoryAllProducts.length} products in this sample',
                    style: TextStyle(
                      fontSize: 12,
                      color: context.colors.secondaryText,
                      fontWeight: FontWeight.w400,
                    ),
                  ),
                ],
              ),
            ),
          ),

          // 3. Subcategory FILTER Card
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
              child: Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: context.colors.surface,
                  borderRadius: BorderRadius.circular(14),
                  border: Border.all(color: context.colors.border, width: 1.1),
                  boxShadow: [
                    BoxShadow(
                      color: context.colors.cardShadow,
                      blurRadius: 6,
                      offset: const Offset(0, 2),
                    ),
                  ],
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // FILTER uppercase label
                    Text(
                      'FILTER',
                      style: TextStyle(
                        fontSize: 10,
                        fontWeight: FontWeight.w800,
                        color: context.colors.secondaryText,
                        letterSpacing: 1.1,
                      ),
                    ),
                    const SizedBox(height: 9),

                    // Filter Pills Wrap
                    Wrap(
                      spacing: 7,
                      runSpacing: 7,
                      children: [
                        // "All" Pill
                        _buildFilterPill(
                          label: 'All',
                          count: categoryAllProducts.length,
                          isSelected: selectedSubCategory == null,
                          onTap: () {
                            ref.read(selectedSubCategoryProvider.notifier).select(null);
                          },
                        ),

                        // Subcategory specific pills
                        ...selectedCategory.subcategories.entries.map((entry) {
                          final isSelected = selectedSubCategory == entry.key;
                          return _buildFilterPill(
                            label: entry.key,
                            count: entry.value,
                            isSelected: isSelected,
                            onTap: () {
                              if (isSelected) {
                                ref.read(selectedSubCategoryProvider.notifier).select(null);
                              } else {
                                ref.read(selectedSubCategoryProvider.notifier).select(entry.key);
                              }
                            },
                          );
                        }),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ),

          const SliverToBoxAdapter(
            child: SizedBox(height: 12),
          ),

          // 4. Filtered Products List / Grid
          if (filteredProducts.isEmpty)
            SliverFillRemaining(
              hasScrollBody: false,
              child: Center(
                child: EmptyStateView(
                  icon: Icons.inventory_2_outlined,
                  title: 'No Products in this Category',
                  description: 'Try selecting "All" or a different subcategory filter.',
                  buttonText: 'Show All Products',
                  onButtonPressed: () {
                    ref.read(selectedSubCategoryProvider.notifier).select(null);
                  },
                ),
              ),
            )
          else if (isWide)
            SliverPadding(
              padding: const EdgeInsets.fromLTRB(16, 4, 16, 24),
              sliver: SliverGrid(
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: screenWidth >= 1000 ? 3 : 2,
                  crossAxisSpacing: 12,
                  mainAxisSpacing: 12,
                  mainAxisExtent: 175,
                ),
                delegate: SliverChildBuilderDelegate(
                  (context, index) {
                    final product = filteredProducts[index];
                    return ProductCard(
                      product: product,
                      onSelect: () => _navigateToCalculator(context, ref, product),
                    );
                  },
                  childCount: filteredProducts.length,
                ),
              ),
            )
          else
            SliverPadding(
              padding: const EdgeInsets.fromLTRB(16, 4, 16, 24),
              sliver: SliverList(
                delegate: SliverChildBuilderDelegate(
                  (context, index) {
                    final product = filteredProducts[index];
                    return Padding(
                      padding: const EdgeInsets.only(bottom: 12),
                      child: ProductCard(
                        product: product,
                        onSelect: () => _navigateToCalculator(context, ref, product),
                      ),
                    );
                  },
                  childCount: filteredProducts.length,
                ),
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

  Widget _buildFilterPill({
    required String label,
    required int count,
    required bool isSelected,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(18),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 150),
        padding: const EdgeInsets.symmetric(horizontal: 11, vertical: 5.5),
        decoration: BoxDecoration(
          color: isSelected ? context.colors.activePill : context.colors.pillBg,
          borderRadius: BorderRadius.circular(18),
          border: Border.all(
            color: isSelected ? context.colors.activePill : context.colors.pillBorder,
            width: 1,
          ),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              label,
              style: TextStyle(
                color: isSelected ? Colors.white : context.colors.primaryText,
                fontWeight: isSelected ? FontWeight.w700 : FontWeight.w600,
                fontSize: 12,
              ),
            ),
            const SizedBox(width: 5),
            Text(
              '$count',
              style: TextStyle(
                color: isSelected ? Colors.white : context.colors.secondaryText,
                fontWeight: FontWeight.w800,
                fontSize: 12,
              ),
            ),
          ],
        ),
      ),
    );
  }

  IconData _getCategoryIcon(String categoryId) {
    switch (categoryId) {
      case 'cat_steel':
        return Icons.table_rows_rounded;
      case 'cat_roofing':
        return Icons.layers_outlined;
      case 'cat_cement':
        return Icons.inventory_2_outlined;
      case 'cat_pipes':
        return Icons.water_drop_outlined;
      default:
        return Icons.category_outlined;
    }
  }

  void _navigateToCalculator(BuildContext context, WidgetRef ref, Product product) {
    ref.read(selectedProductProvider.notifier).select(product);
    ref.read(calculatorProvider.notifier).initForProduct(product);
    context.push('/calculator');
  }
}
