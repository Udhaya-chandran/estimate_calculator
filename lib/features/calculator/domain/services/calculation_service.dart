import '../../../../core/utils/currency_formatter.dart';
import '../../../../core/utils/unit_converter.dart';
import '../../../../shared/models/product.dart';
import '../entities/calculation_result.dart';
import '../entities/measurement_type.dart';

class CalculationService {
  const CalculationService();

  CalculationResult calculate({
    required Product product,
    required int quantity,
    double? length,
    LengthUnit? lengthUnit,
    double? width,
    LengthUnit? widthUnit,
    double? height,
    LengthUnit? heightUnit,
    double? weight,
    WeightUnit? weightUnit,
    required double rate,
  }) {
    if (quantity <= 0 || rate < 0) {
      return CalculationResult(
        calculatedQuantity: 0,
        standardUnit: product.measurementConfiguration.standardUnitLabel,
        rate: rate,
        totalAmount: 0,
        breakdownSummary: 'Invalid quantity or rate',
      );
    }

    switch (product.measurementType) {
      case MeasurementType.quantityOnly:
        return _calculateQuantityOnly(
          product: product,
          quantity: quantity,
          rate: rate,
        );

      case MeasurementType.lengthBased:
        return _calculateLengthBased(
          product: product,
          quantity: quantity,
          length: length ?? 0.0,
          lengthUnit: lengthUnit ?? product.measurementConfiguration.defaultLengthUnit,
          rate: rate,
        );

      case MeasurementType.areaBased:
        return _calculateAreaBased(
          product: product,
          quantity: quantity,
          length: length ?? 0.0,
          lengthUnit: lengthUnit ?? product.measurementConfiguration.defaultLengthUnit,
          width: width ?? 0.0,
          widthUnit: widthUnit ?? product.measurementConfiguration.defaultWidthUnit,
          rate: rate,
        );

      case MeasurementType.weightBased:
        return _calculateWeightBased(
          product: product,
          quantity: quantity,
          weight: weight ?? 0.0,
          weightUnit: weightUnit ?? product.measurementConfiguration.defaultWeightUnit,
          rate: rate,
        );
    }
  }

  CalculationResult _calculateQuantityOnly({
    required Product product,
    required int quantity,
    required double rate,
  }) {
    final double calculatedQty = quantity.toDouble();
    final double totalAmount = _roundMoney(calculatedQty * rate);
    final unit = product.measurementConfiguration.standardUnitLabel;

    return CalculationResult(
      calculatedQuantity: calculatedQty,
      standardUnit: unit,
      rate: rate,
      totalAmount: totalAmount,
      breakdownSummary: '$quantity $unit × ${CurrencyFormatter.format(rate)}',
    );
  }

  CalculationResult _calculateLengthBased({
    required Product product,
    required int quantity,
    required double length,
    required LengthUnit lengthUnit,
    required double rate,
  }) {
    if (length <= 0) {
      return CalculationResult(
        calculatedQuantity: 0,
        standardUnit: product.measurementConfiguration.standardUnitLabel,
        rate: rate,
        totalAmount: 0,
        breakdownSummary: 'Enter valid length',
      );
    }

    // Convert length to standard feet
    final double lengthInFeet = UnitConverter.toFeet(length, lengthUnit);
    final double totalFeet = _roundDecimals(quantity * lengthInFeet, 2);
    final double totalAmount = _roundMoney(totalFeet * rate);

    final lengthText = length % 1 == 0 ? length.toInt().toString() : length.toStringAsFixed(2);
    final feetText = totalFeet.toStringAsFixed(2);

    return CalculationResult(
      calculatedQuantity: totalFeet,
      standardUnit: 'ft',
      rate: rate,
      totalAmount: totalAmount,
      breakdownSummary: '$quantity pcs × $lengthText ${lengthUnit.symbol} ($feetText ft) × ${CurrencyFormatter.format(rate)}/ft',
    );
  }

  CalculationResult _calculateAreaBased({
    required Product product,
    required int quantity,
    required double length,
    required LengthUnit lengthUnit,
    required double width,
    required LengthUnit widthUnit,
    required double rate,
  }) {
    if (length <= 0 || width <= 0) {
      return CalculationResult(
        calculatedQuantity: 0,
        standardUnit: product.measurementConfiguration.standardUnitLabel,
        rate: rate,
        totalAmount: 0,
        breakdownSummary: 'Enter valid length and width',
      );
    }

    final double singlePieceAreaSqFt = UnitConverter.calculateAreaInSqFeet(
      length: length,
      lengthUnit: lengthUnit,
      width: width,
      widthUnit: widthUnit,
    );

    final double totalSqFt = _roundDecimals(quantity * singlePieceAreaSqFt, 2);
    final double totalAmount = _roundMoney(totalSqFt * rate);

    final lText = length % 1 == 0 ? length.toInt().toString() : length.toStringAsFixed(2);
    final wText = width % 1 == 0 ? width.toInt().toString() : width.toStringAsFixed(2);
    final sqFtText = totalSqFt.toStringAsFixed(2);

    return CalculationResult(
      calculatedQuantity: totalSqFt,
      standardUnit: 'sq.ft',
      rate: rate,
      totalAmount: totalAmount,
      breakdownSummary: '$quantity pcs × ($lText ${lengthUnit.symbol} × $wText ${widthUnit.symbol}) = $sqFtText sq.ft × ${CurrencyFormatter.format(rate)}/sq.ft',
    );
  }

  CalculationResult _calculateWeightBased({
    required Product product,
    required int quantity,
    required double weight,
    required WeightUnit weightUnit,
    required double rate,
  }) {
    if (weight <= 0) {
      return CalculationResult(
        calculatedQuantity: 0,
        standardUnit: product.measurementConfiguration.standardUnitLabel,
        rate: rate,
        totalAmount: 0,
        breakdownSummary: 'Enter valid weight',
      );
    }

    final double singleWeightKg = UnitConverter.toKilograms(weight, weightUnit);
    final double totalKg = _roundDecimals(quantity * singleWeightKg, 2);
    final double totalAmount = _roundMoney(totalKg * rate);

    final wText = weight % 1 == 0 ? weight.toInt().toString() : weight.toStringAsFixed(2);
    final totalKgText = totalKg.toStringAsFixed(2);

    return CalculationResult(
      calculatedQuantity: totalKg,
      standardUnit: 'kg',
      rate: rate,
      totalAmount: totalAmount,
      breakdownSummary: '$quantity pcs × $wText ${weightUnit.symbol} ($totalKgText kg) × ${CurrencyFormatter.format(rate)}/kg',
    );
  }

  double _roundMoney(double val) {
    return (val * 100).roundToDouble() / 100.0;
  }

  double _roundDecimals(double val, int places) {
    double mod = 1.0;
    for (int i = 0; i < places; i++) {
      mod *= 10.0;
    }
    return (val * mod).roundToDouble() / mod;
  }
}
