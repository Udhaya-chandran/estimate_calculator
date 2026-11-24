import '../../../../core/utils/unit_converter.dart';
import '../../../../shared/models/product.dart';

class EstimateItem {
  final String id;
  final Product product;
  final int quantity;
  final double? length;
  final LengthUnit? lengthUnit;
  final double? width;
  final LengthUnit? widthUnit;
  final double? height;
  final LengthUnit? heightUnit;
  final double? weight;
  final WeightUnit? weightUnit;
  final double rateSnapshot;
  final double calculatedQuantity;
  final String standardUnit;
  final double totalAmount;
  final String breakdown;

  const EstimateItem({
    required this.id,
    required this.product,
    required this.quantity,
    this.length,
    this.lengthUnit,
    this.width,
    this.widthUnit,
    this.height,
    this.heightUnit,
    this.weight,
    this.weightUnit,
    required this.rateSnapshot,
    required this.calculatedQuantity,
    required this.standardUnit,
    required this.totalAmount,
    required this.breakdown,
  });

  EstimateItem copyWith({
    String? id,
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
    double? rateSnapshot,
    double? calculatedQuantity,
    String? standardUnit,
    double? totalAmount,
    String? breakdown,
  }) {
    return EstimateItem(
      id: id ?? this.id,
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
      rateSnapshot: rateSnapshot ?? this.rateSnapshot,
      calculatedQuantity: calculatedQuantity ?? this.calculatedQuantity,
      standardUnit: standardUnit ?? this.standardUnit,
      totalAmount: totalAmount ?? this.totalAmount,
      breakdown: breakdown ?? this.breakdown,
    );
  }
}
