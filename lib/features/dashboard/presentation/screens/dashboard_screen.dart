import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../../app/theme/app_colors.dart';
import '../../../../core/constants/app_constants.dart';
import '../../../../core/utils/currency_formatter.dart';
import '../../../../core/widgets/custom_card.dart';
import '../../../../shared/providers/app_providers.dart';
import '../../../../shared/widgets/app_header.dart';
import '../../../categories/presentation/widgets/category_card.dart';
import '../../../estimates/presentation/providers/estimate_provider.dart';
import '../widgets/company_achievement_carousel.dart';

class DashboardScreen extends ConsumerStatefulWidget {
  const DashboardScreen({super.key});

  @override
  ConsumerState<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends ConsumerState<DashboardScreen> {
  late final TextEditingController _searchController;

  @override
  void initState() {
    super.initState();
    _searchController = TextEditingController();
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  void _performSearch(String query) {
    final trimmed = query.trim();
    if (trimmed.isNotEmpty) {
      ref.read(selectedCategoryIdProvider.notifier).select(null);
      ref.read(productSearchQueryProvider.notifier).setQuery(trimmed);
      context.push('/products');
    }
  }

  @override
  Widget build(BuildContext context) {
    final categories = ref.watch(categoriesProvider);
    final activeEstimateCount = ref.watch(estimateCountProvider);
    final activeEstimateSubtotal = ref.watch(estimateSubtotalProvider);

    return Scaffold(
      appBar: AppHeader(
        title: AppConstants.appName,
        showLogo: true,
        actions: [
          if (activeEstimateCount > 0)
            Padding(
              padding: const EdgeInsets.only(right: 12.0),
              child: IconButton(
                icon: Badge(
                  label: Text('$activeEstimateCount'),
                  backgroundColor: AppColors.primaryRed,
                  child: const Icon(Icons.shopping_cart_outlined, color: AppColors.primaryText),
                ),
                onPressed: () => context.push('/estimate-list'),
              ),
            ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 14.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // ================= 1. SEARCH INPUT BAR =================
            Container(
              height: 48,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: AppColors.border, width: 1),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.04),
                    blurRadius: 8,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              child: TextField(
                controller: _searchController,
                textInputAction: TextInputAction.search,
                onSubmitted: _performSearch,
                style: const TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                  color: AppColors.primaryText,
                ),
                decoration: InputDecoration(
                  hintText: 'Search cement, pipes, steel, hardware...',
                  hintStyle: const TextStyle(
                    color: AppColors.hintText,
                    fontSize: 13,
                    fontWeight: FontWeight.normal,
                  ),
                  prefixIcon: const Icon(
                    Icons.search_rounded,
                    color: AppColors.primaryRed,
                    size: 22,
                  ),
                  suffixIcon: _searchController.text.isNotEmpty
                      ? IconButton(
                          icon: const Icon(Icons.clear, size: 18, color: AppColors.secondaryText),
                          onPressed: () {
                            _searchController.clear();
                            setState(() {});
                          },
                        )
                      : Container(
                          margin: const EdgeInsets.all(7),
                          decoration: BoxDecoration(
                            color: AppColors.lightRed,
                            borderRadius: BorderRadius.circular(7),
                          ),
                          child: IconButton(
                            padding: EdgeInsets.zero,
                            icon: const Icon(Icons.arrow_forward_rounded, size: 16, color: AppColors.primaryRed),
                            onPressed: () => _performSearch(_searchController.text),
                          ),
                        ),
                  border: InputBorder.none,
                  enabledBorder: InputBorder.none,
                  focusedBorder: InputBorder.none,
                  contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
                ),
                onChanged: (_) => setState(() {}),
              ),
            ),

            const SizedBox(height: 16),

            // ================= 2. COMPANY ACHIEVEMENTS CAROUSEL BANNER =================
            CompanyAchievementCarousel(
              onStartEstimate: () {
                ref.read(estimateProvider.notifier).startNewEstimate();
                ref.read(selectedCategoryIdProvider.notifier).select(null);
                context.push('/categories');
              },
              onBrowseCategories: () {
                context.push('/categories');
              },
            ),

            // Active Customer Estimate Banner
            if (activeEstimateCount > 0) ...[
              const SizedBox(height: 14),
              CustomCard(
                backgroundColor: AppColors.lightRed,
                borderColor: AppColors.primaryRed.withValues(alpha: 0.35),
                padding: const EdgeInsets.all(14),
                child: Row(
                  children: [
                    Container(
                      width: 40,
                      height: 40,
                      decoration: BoxDecoration(
                        color: AppColors.primaryRed,
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: const Icon(
                        Icons.edit_note_rounded,
                        color: Colors.white,
                        size: 22,
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            'Your Active Estimate List',
                            style: TextStyle(
                              color: AppColors.darkRed,
                              fontWeight: FontWeight.w700,
                              fontSize: 14,
                            ),
                          ),
                          Text(
                            '$activeEstimateCount items added • Total: ${CurrencyFormatter.format(activeEstimateSubtotal)}',
                            style: const TextStyle(
                              color: AppColors.deepRed,
                              fontSize: 12,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ],
                      ),
                    ),
                    ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.primaryRed,
                        foregroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                      onPressed: () => context.push('/estimate-list'),
                      child: const Text('View Bill', style: TextStyle(fontWeight: FontWeight.w700, fontSize: 13)),
                    ),
                  ],
                ),
              ),
            ],

            const SizedBox(height: 18),

            // ================= 3. 2-COLUMN CATEGORIES GRID =================
            GridView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                crossAxisSpacing: 12,
                mainAxisSpacing: 12,
                childAspectRatio: 0.80,
              ),
              itemCount: categories.length,
              itemBuilder: (context, index) {
                final cat = categories[index];
                return CategoryCard(
                  category: cat,
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

            const SizedBox(height: 24),
          ],
        ),
      ),
    );
  }
}
