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
              padding: const EdgeInsets.only(right: 4.0),
              child: IconButton(
                icon: Badge(
                  label: Text('$activeEstimateCount'),
                  backgroundColor: AppColors.primaryRed,
                  child: Icon(Icons.shopping_cart_outlined, color: context.colors.primaryText),
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
                color: context.colors.surface,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: context.colors.border, width: 1),
                boxShadow: [
                  BoxShadow(
                    color: context.colors.cardShadow,
                    blurRadius: 8,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              child: TextField(
                controller: _searchController,
                textInputAction: TextInputAction.search,
                onSubmitted: _performSearch,
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                  color: context.colors.primaryText,
                ),
                decoration: InputDecoration(
                  hintText: 'Search cement, pipes, steel, hardware...',
                  hintStyle: TextStyle(
                    color: context.colors.hintText,
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
                          icon: Icon(Icons.clear, size: 18, color: context.colors.secondaryText),
                          onPressed: () {
                            _searchController.clear();
                            setState(() {});
                          },
                        )
                      : Container(
                          margin: const EdgeInsets.all(7),
                          decoration: BoxDecoration(
                            color: context.colors.lightRed,
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
              LayoutBuilder(
                builder: (context, constraints) {
                  final isCompact = constraints.maxWidth < 360;

                  return CustomCard(
                    backgroundColor: context.colors.lightRed,
                    borderColor: AppColors.primaryRed.withValues(alpha: 0.35),
                    padding: const EdgeInsets.all(14),
                    child: isCompact
                        ? Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                children: [
                                  Container(
                                    width: 36,
                                    height: 36,
                                    decoration: BoxDecoration(
                                      color: AppColors.primaryRed,
                                      borderRadius: BorderRadius.circular(9),
                                    ),
                                    child: const Icon(
                                      Icons.edit_note_rounded,
                                      color: Colors.white,
                                      size: 20,
                                    ),
                                  ),
                                  const SizedBox(width: 10),
                                  Expanded(
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          'Active Estimate List',
                                          style: TextStyle(
                                            color: context.isDarkMode ? Colors.white : AppColors.darkRed,
                                            fontWeight: FontWeight.w700,
                                            fontSize: 13.5,
                                          ),
                                        ),
                                        Text(
                                          '$activeEstimateCount items • ${CurrencyFormatter.format(activeEstimateSubtotal)}',
                                          style: TextStyle(
                                            color: context.isDarkMode ? const Color(0xFFFFCDD2) : AppColors.deepRed,
                                            fontSize: 11.5,
                                            fontWeight: FontWeight.w600,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 10),
                              SizedBox(
                                width: double.infinity,
                                height: 36,
                                child: ElevatedButton(
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: AppColors.primaryRed,
                                    foregroundColor: Colors.white,
                                    padding: EdgeInsets.zero,
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(8),
                                    ),
                                  ),
                                  onPressed: () => context.push('/estimate-list'),
                                  child: const Text('View Bill', style: TextStyle(fontWeight: FontWeight.w700, fontSize: 13)),
                                ),
                              ),
                            ],
                          )
                        : Row(
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
                                    Text(
                                      'Your Active Estimate List',
                                      style: TextStyle(
                                        color: context.isDarkMode ? Colors.white : AppColors.darkRed,
                                        fontWeight: FontWeight.w700,
                                        fontSize: 14,
                                      ),
                                    ),
                                    Text(
                                      '$activeEstimateCount items added • Total: ${CurrencyFormatter.format(activeEstimateSubtotal)}',
                                      style: TextStyle(
                                        color: context.isDarkMode ? const Color(0xFFFFCDD2) : AppColors.deepRed,
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
                  );
                },
              ),
            ],

            const SizedBox(height: 18),

            // ================= 3. RESPONSIVE CATEGORIES GRID =================
            LayoutBuilder(
              builder: (context, constraints) {
                final width = constraints.maxWidth;
                final crossAxisCount = width >= 900
                    ? 4
                    : (width >= 600 ? 3 : 2);
                final childAspectRatio = width < 360
                    ? 0.74
                    : (width >= 900 ? 0.95 : (width >= 600 ? 0.88 : 0.80));

                return GridView.builder(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: crossAxisCount,
                    crossAxisSpacing: 12,
                    mainAxisSpacing: 12,
                    childAspectRatio: childAspectRatio,
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
