import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:estimate_calculator/data/mock/categories.dart';
import 'package:estimate_calculator/data/mock/products.dart';
import 'package:estimate_calculator/data/mock/recent_estimates.dart';
import 'package:estimate_calculator/features/estimates/domain/entities/estimate.dart';
import 'package:estimate_calculator/shared/models/category.dart';
import 'package:estimate_calculator/shared/models/product.dart';

// Categories Providers
final categoriesProvider = Provider<List<Category>>((ref) {
  return mockCategories;
});

class SelectedCategoryIdNotifier extends Notifier<String?> {
  @override
  String? build() => 'cat_steel'; // Default to first category or null

  void select(String? id) {
    state = id;
    // Reset subcategory filter when category changes
    ref.read(selectedSubCategoryProvider.notifier).select(null);
  }
}

final selectedCategoryIdProvider = NotifierProvider<SelectedCategoryIdNotifier, String?>(
  SelectedCategoryIdNotifier.new,
);

class SelectedSubCategoryNotifier extends Notifier<String?> {
  @override
  String? build() => null;

  void select(String? subCategory) => state = subCategory;
}

final selectedSubCategoryProvider = NotifierProvider<SelectedSubCategoryNotifier, String?>(
  SelectedSubCategoryNotifier.new,
);

final selectedCategoryProvider = Provider<Category?>((ref) {
  final selectedId = ref.watch(selectedCategoryIdProvider);
  if (selectedId == null) return null;
  return mockCategories.firstWhere(
    (c) => c.id == selectedId,
    orElse: () => mockCategories.first,
  );
});

// Products Providers
final allProductsProvider = Provider<List<Product>>((ref) {
  return mockProducts;
});

class ProductSearchQueryNotifier extends Notifier<String> {
  @override
  String build() => '';

  void setQuery(String q) => state = q;
}

final productSearchQueryProvider = NotifierProvider<ProductSearchQueryNotifier, String>(
  ProductSearchQueryNotifier.new,
);

final productsByCategoryProvider = Provider.family<List<Product>, String?>((ref, categoryId) {
  final products = ref.watch(allProductsProvider);
  if (categoryId == null || categoryId.isEmpty) {
    return products;
  }
  return products.where((p) => p.categoryId == categoryId).toList();
});

final filteredProductsProvider = Provider<List<Product>>((ref) {
  final categoryId = ref.watch(selectedCategoryIdProvider);
  final subCategory = ref.watch(selectedSubCategoryProvider);
  final query = ref.watch(productSearchQueryProvider).trim().toLowerCase();
  var list = ref.watch(productsByCategoryProvider(categoryId));

  if (subCategory != null && subCategory.isNotEmpty) {
    list = list.where((p) => p.subCategory == subCategory).toList();
  }

  if (query.isNotEmpty) {
    list = list.where((p) {
      final nameMatch = p.name.toLowerCase().contains(query);
      final brandMatch = p.brand.toLowerCase().contains(query);
      final unitMatch = p.pricingUnit.toLowerCase().contains(query);
      return nameMatch || brandMatch || unitMatch;
    }).toList();
  }
  return list;
});

// Selected Product for Calculator
class SelectedProductNotifier extends Notifier<Product?> {
  @override
  Product? build() => null;

  void select(Product? product) => state = product;
}

final selectedProductProvider = NotifierProvider<SelectedProductNotifier, Product?>(
  SelectedProductNotifier.new,
);

// Recent Demo Estimates Provider
final recentEstimatesProvider = Provider<List<Estimate>>((ref) {
  return mockRecentEstimates;
});
