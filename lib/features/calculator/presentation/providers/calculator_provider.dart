import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:estimate_calculator/core/utils/unit_converter.dart';
import 'package:estimate_calculator/features/calculator/domain/entities/calculation_result.dart';
import 'package:estimate_calculator/features/calculator/domain/services/calculation_service.dart';
import 'package:estimate_calculator/features/calculator/domain/services/product_calculation_helper.dart';
import 'package:estimate_calculator/features/estimates/domain/entities/estimate_item.dart';
import 'package:estimate_calculator/shared/models/product.dart';

class CalculatorInputState {
  final Product? product;
  final int quantity;
  final double? length;
  final LengthUnit lengthUnit;
  final double? width;
  final LengthUnit widthUnit;
  final double? height;
  final LengthUnit heightUnit;
  final double? weight;
  final WeightUnit weightUnit;
  final double customRate;
  final CalculationResult result;
  final String? editingItemId;

  /// Variant group selected indices: key = group title, value = selected option index
  final Map<String, int> selectedVariantIndices;

  /// Order unit index for Quantity tabs: 0=Nos, 1=Metre, 2=Kg, 3=Tonnes
  final int orderUnitIndex;

  const CalculatorInputState({
    this.product,
    this.quantity = 1,
    this.length,
    this.lengthUnit = LengthUnit.feet,
    this.width,
    this.widthUnit = LengthUnit.feet,
    this.height,
    this.heightUnit = LengthUnit.feet,
    this.weight,
    this.weightUnit = WeightUnit.kilograms,
    this.customRate = 0.0,
    this.result = CalculationResult.zero,
    this.editingItemId,
    this.selectedVariantIndices = const {},
    this.orderUnitIndex = 0,
  });

  bool get isEditing => editingItemId != null;

  CalculatorInputState copyWith({
    Product? product,
    int? quantity,
    double? length,
    LengthUnit? lengthUnit,
    double? width,
    LengthUnit? widthUnit,
    double? height,
    LengthUnit? heightUnit,
    double? weight,
    WeightUnit? weightUnit,
    double? customRate,
    CalculationResult? result,
    String? editingItemId,
    bool clearEditingId = false,
    Map<String, int>? selectedVariantIndices,
    int? orderUnitIndex,
  }) {
    return CalculatorInputState(
      product: product ?? this.product,
      quantity: quantity ?? this.quantity,
      length: length ?? this.length,
      lengthUnit: lengthUnit ?? this.lengthUnit,
      width: width ?? this.width,
      widthUnit: widthUnit ?? this.widthUnit,
      height: height ?? this.height,
      heightUnit: heightUnit ?? this.heightUnit,
      weight: weight ?? this.weight,
      weightUnit: weightUnit ?? this.weightUnit,
      customRate: customRate ?? this.customRate,
      result: result ?? this.result,
      editingItemId: clearEditingId ? null : (editingItemId ?? this.editingItemId),
      selectedVariantIndices: selectedVariantIndices ?? this.selectedVariantIndices,
      orderUnitIndex: orderUnitIndex ?? this.orderUnitIndex,
    );
  }
}

final calculationServiceProvider = Provider<CalculationService>((ref) {
  return const CalculationService();
});

class CalculatorNotifier extends Notifier<CalculatorInputState> {
  CalculationService get _calculationService => ref.read(calculationServiceProvider);

  @override
  CalculatorInputState build() {
    return const CalculatorInputState();
  }

  void initForProduct(Product product, {EstimateItem? existingItem}) {
    if (existingItem != null) {
      final rate = existingItem.rateSnapshot;
      final config = product.measurementConfiguration;
      final res = _calculationService.calculate(
        product: product,
        quantity: existingItem.quantity,
        length: existingItem.length,
        lengthUnit: existingItem.lengthUnit ?? config.defaultLengthUnit,
        width: existingItem.width,
        widthUnit: existingItem.widthUnit ?? config.defaultWidthUnit,
        weight: existingItem.weight,
        weightUnit: existingItem.weightUnit ?? config.defaultWeightUnit,
        rate: rate,
      );

      state = CalculatorInputState(
        product: product,
        quantity: existingItem.quantity,
        length: existingItem.length,
        lengthUnit: existingItem.lengthUnit ?? config.defaultLengthUnit,
        width: existingItem.width,
        widthUnit: existingItem.widthUnit ?? config.defaultWidthUnit,
        height: existingItem.height,
        heightUnit: existingItem.heightUnit ?? LengthUnit.feet,
        weight: existingItem.weight,
        weightUnit: existingItem.weightUnit ?? config.defaultWeightUnit,
        customRate: rate,
        result: res,
        editingItemId: existingItem.id,
        selectedVariantIndices: const {},
        orderUnitIndex: 0,
      );
    } else {
      final config = product.measurementConfiguration;
      const defaultQty = 1;
      final defaultLen = config.requiresLength ? 10.0 : null;
      final defaultWidth = config.requiresWidth ? 10.0 : null;
      // For TMT-style weight-based: default weight derived from diameter variant
      // 6mm bar at 12m = D²/162 * L = 36/162 * 12 = 2.667 kg
      final defaultWeight = config.requiresWeight ? _defaultWeightForProduct(product) : null;
      final rate = product.rate;

      final res = _calculationService.calculate(
        product: product,
        quantity: defaultQty,
        length: defaultLen,
        lengthUnit: config.defaultLengthUnit,
        width: defaultWidth,
        widthUnit: config.defaultWidthUnit,
        weight: defaultWeight,
        weightUnit: config.defaultWeightUnit,
        rate: rate,
      );

      state = CalculatorInputState(
        product: product,
        quantity: defaultQty,
        length: defaultLen,
        lengthUnit: config.defaultLengthUnit,
        width: defaultWidth,
        widthUnit: config.defaultWidthUnit,
        weight: defaultWeight,
        weightUnit: config.defaultWeightUnit,
        customRate: rate,
        result: res,
        editingItemId: null,
        selectedVariantIndices: const {},
        orderUnitIndex: 0,
      );
      if (product.variantConfig != null) {
        _recalculate();
      }
    }
  }

  double _defaultWeightForProduct(Product product) {
    // TMT 6mm at 12m: D²÷162 × length_in_m = 36÷162×12 = 2.667 kg
    if (product.id == 'prod_tmt_rod') return 2.667;
    return 25.0;
  }

  void selectVariantOption(String groupTitle, int optionIndex) {
    final newIndices = Map<String, int>.from(state.selectedVariantIndices);
    newIndices[groupTitle] = optionIndex;
    // Update rate from variant if the group changes the rate
    final variantConfig = state.product?.variantConfig;
    if (variantConfig != null) {
      // Find the brand group to get the base rate
      double newRate = state.customRate;
      for (final group in variantConfig.variantGroups) {
        final selectedIdx = group.title == groupTitle ? optionIndex : (newIndices[group.title] ?? 0);
        if (selectedIdx < group.options.length) {
          final option = group.options[selectedIdx];
          // Brand, Diameter, Size, Grade, Zinc coating drives rate
          if ((group.title == 'Brand' ||
                  group.title == 'Diameter' ||
                  group.title == 'Size' ||
                  group.title == 'Grade' ||
                  group.title.toLowerCase().contains('zinc') ||
                  group.title.toLowerCase().contains('coating')) &&
              option.rate > 0) {
            newRate = option.rate;
          }
        }
      }
      state = state.copyWith(
        selectedVariantIndices: newIndices,
        customRate: newRate,
      );
    } else {
      state = state.copyWith(selectedVariantIndices: newIndices);
    }
    _recalculate();
  }

  void setOrderUnitIndex(int idx) {
    state = state.copyWith(orderUnitIndex: idx);
    _recalculate();
  }

  void updateQuantity(int quantity) {
    if (quantity < 1) return;
    state = state.copyWith(quantity: quantity);
    _recalculate();
  }

  void updateLength(double? length) {
    state = state.copyWith(length: length);
    _recalculate();
  }

  void updateLengthUnit(LengthUnit unit) {
    state = state.copyWith(lengthUnit: unit);
    _recalculate();
  }

  void updateWidth(double? width) {
    state = state.copyWith(width: width);
    _recalculate();
  }

  void updateWidthUnit(LengthUnit unit) {
    state = state.copyWith(widthUnit: unit);
    _recalculate();
  }

  void updateWeight(double? weight) {
    state = state.copyWith(weight: weight);
    _recalculate();
  }

  void updateWeightUnit(WeightUnit unit) {
    state = state.copyWith(weightUnit: unit);
    _recalculate();
  }

  void updateRate(double rate) {
    if (rate < 0) return;
    state = state.copyWith(customRate: rate);
    _recalculate();
  }

  void _recalculate() {
    if (state.product == null) return;
    if (state.product!.variantConfig != null) {
      final info = ProductCalculationHelper.calculate(state, state.product!);
      state = state.copyWith(
        result: CalculationResult(
          calculatedQuantity: state.quantity.toDouble(),
          standardUnit: info.appliedRateUnit,
          rate: info.appliedRate,
          totalAmount: info.baseTotal,
          breakdownSummary: info.breakdownQtyText,
        ),
      );
      return;
    }
    final res = _calculationService.calculate(
      product: state.product!,
      quantity: state.quantity,
      length: state.length,
      lengthUnit: state.lengthUnit,
      width: state.width,
      widthUnit: state.widthUnit,
      height: state.height,
      heightUnit: state.heightUnit,
      weight: state.weight,
      weightUnit: state.weightUnit,
      rate: state.customRate,
    );
    state = state.copyWith(result: res);
  }
}

final calculatorProvider = NotifierProvider<CalculatorNotifier, CalculatorInputState>(CalculatorNotifier.new);
