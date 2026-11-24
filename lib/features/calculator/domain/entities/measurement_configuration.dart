import '../../../../core/utils/unit_converter.dart';

class MeasurementConfiguration {
  final bool requiresQuantity;
  final bool requiresLength;
  final bool requiresWidth;
  final bool requiresHeight;
  final bool requiresWeight;
  final LengthUnit defaultLengthUnit;
  final LengthUnit defaultWidthUnit;
  final WeightUnit defaultWeightUnit;
  final String quantityLabel;
  final String standardUnitLabel;

  const MeasurementConfiguration({
    this.requiresQuantity = true,
    this.requiresLength = false,
    this.requiresWidth = false,
    this.requiresHeight = false,
    this.requiresWeight = false,
    this.defaultLengthUnit = LengthUnit.feet,
    this.defaultWidthUnit = LengthUnit.feet,
    this.defaultWeightUnit = WeightUnit.kilograms,
    this.quantityLabel = 'Quantity (Nos)',
    required this.standardUnitLabel,
  });

  // Common preset configurations
  factory MeasurementConfiguration.quantityOnly({
    String quantityLabel = 'Quantity (Nos)',
    String standardUnitLabel = 'nos',
  }) {
    return MeasurementConfiguration(
      requiresQuantity: true,
      requiresLength: false,
      requiresWidth: false,
      requiresHeight: false,
      requiresWeight: false,
      quantityLabel: quantityLabel,
      standardUnitLabel: standardUnitLabel,
    );
  }

  factory MeasurementConfiguration.lengthBased({
    String quantityLabel = 'Number of Pieces',
    String standardUnitLabel = 'ft',
    LengthUnit defaultUnit = LengthUnit.feet,
  }) {
    return MeasurementConfiguration(
      requiresQuantity: true,
      requiresLength: true,
      requiresWidth: false,
      requiresHeight: false,
      requiresWeight: false,
      quantityLabel: quantityLabel,
      standardUnitLabel: standardUnitLabel,
      defaultLengthUnit: defaultUnit,
    );
  }

  factory MeasurementConfiguration.areaBased({
    String quantityLabel = 'Number of Pieces / Sheets',
    String standardUnitLabel = 'sq.ft',
    LengthUnit defaultLengthUnit = LengthUnit.feet,
    LengthUnit defaultWidthUnit = LengthUnit.feet,
  }) {
    return MeasurementConfiguration(
      requiresQuantity: true,
      requiresLength: true,
      requiresWidth: true,
      requiresHeight: false,
      requiresWeight: false,
      quantityLabel: quantityLabel,
      standardUnitLabel: standardUnitLabel,
      defaultLengthUnit: defaultLengthUnit,
      defaultWidthUnit: defaultWidthUnit,
    );
  }

  factory MeasurementConfiguration.weightBased({
    String quantityLabel = 'Number of Pieces',
    String standardUnitLabel = 'kg',
    WeightUnit defaultWeightUnit = WeightUnit.kilograms,
  }) {
    return MeasurementConfiguration(
      requiresQuantity: true,
      requiresLength: false,
      requiresWidth: false,
      requiresHeight: false,
      requiresWeight: true,
      quantityLabel: quantityLabel,
      standardUnitLabel: standardUnitLabel,
      defaultWeightUnit: defaultWeightUnit,
    );
  }
}
