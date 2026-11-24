import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:estimate_calculator/features/calculator/presentation/providers/calculator_provider.dart';
import '../../domain/entities/estimate.dart';
import '../../domain/entities/estimate_item.dart';

class EstimateState {
  final String estimateId;
  final DateTime createdAt;
  final List<EstimateItem> items;
  final double discount;
  final String? customerName;
  final String? customerPhone;

  const EstimateState({
    required this.estimateId,
    required this.createdAt,
    required this.items,
    this.discount = 0.0,
    this.customerName,
    this.customerPhone,
  });

  double get subtotal => items.fold(0.0, (sum, item) => sum + item.totalAmount);
  double get finalAmount => subtotal;
  int get itemCount => items.length;

  EstimateState copyWith({
    String? estimateId,
    DateTime? createdAt,
    List<EstimateItem>? items,
    double? discount,
    String? customerName,
    String? customerPhone,
  }) {
    return EstimateState(
      estimateId: estimateId ?? this.estimateId,
      createdAt: createdAt ?? this.createdAt,
      items: items ?? this.items,
      discount: discount ?? this.discount,
      customerName: customerName ?? this.customerName,
      customerPhone: customerPhone ?? this.customerPhone,
    );
  }

  Estimate toEstimate() {
    return Estimate(
      id: estimateId,
      createdAt: createdAt,
      items: items,
      subtotal: subtotal,
      discount: 0.0,
      finalAmount: finalAmount,
      customerName: customerName,
      customerPhone: customerPhone,
    );
  }
}

class EstimateNotifier extends Notifier<EstimateState> {
  static String _generateEstimateId() {
    final now = DateTime.now();
    final randomSuffix = (1000 + (now.millisecondsSinceEpoch % 9000)).toString();
    return 'EST-${now.year}-$randomSuffix';
  }

  @override
  EstimateState build() {
    return EstimateState(
      estimateId: _generateEstimateId(),
      createdAt: DateTime.now(),
      items: const [],
    );
  }

  void startNewEstimate() {
    state = EstimateState(
      estimateId: _generateEstimateId(),
      createdAt: DateTime.now(),
      items: const [],
      discount: 0.0,
    );
  }

  void saveCurrentCalculatorItem(CalculatorInputState calcState) {
    if (calcState.product == null) return;

    final item = EstimateItem(
      id: calcState.editingItemId ?? 'item_${DateTime.now().millisecondsSinceEpoch}',
      product: calcState.product!,
      quantity: calcState.quantity,
      length: calcState.length,
      lengthUnit: calcState.lengthUnit,
      width: calcState.width,
      widthUnit: calcState.widthUnit,
      height: calcState.height,
      heightUnit: calcState.heightUnit,
      weight: calcState.weight,
      weightUnit: calcState.weightUnit,
      rateSnapshot: calcState.customRate,
      calculatedQuantity: calcState.result.calculatedQuantity,
      standardUnit: calcState.result.standardUnit,
      totalAmount: calcState.result.totalAmount,
      breakdown: calcState.result.breakdownSummary,
    );

    if (calcState.isEditing) {
      // Update existing item
      final updatedItems = state.items.map((i) => i.id == item.id ? item : i).toList();
      state = state.copyWith(items: updatedItems);
    } else {
      // Add new item
      state = state.copyWith(items: [...state.items, item]);
    }
  }

  void removeItem(String itemId) {
    final updated = state.items.where((i) => i.id != itemId).toList();
    state = state.copyWith(items: updated);
  }

  void setCustomerInfo({String? name, String? phone}) {
    state = state.copyWith(
      customerName: name ?? state.customerName,
      customerPhone: phone ?? state.customerPhone,
    );
  }
}

final estimateProvider = NotifierProvider<EstimateNotifier, EstimateState>(EstimateNotifier.new);

// Derived Providers
final estimateItemsProvider = Provider<List<EstimateItem>>((ref) {
  return ref.watch(estimateProvider).items;
});

final estimateSubtotalProvider = Provider<double>((ref) {
  return ref.watch(estimateProvider).subtotal;
});

final estimateFinalAmountProvider = Provider<double>((ref) {
  return ref.watch(estimateProvider).finalAmount;
});

final estimateCountProvider = Provider<int>((ref) {
  return ref.watch(estimateProvider).itemCount;
});
