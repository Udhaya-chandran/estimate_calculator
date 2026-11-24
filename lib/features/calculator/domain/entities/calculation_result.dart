class CalculationResult {
  final double calculatedQuantity;
  final String standardUnit;
  final double rate;
  final double totalAmount;
  final String breakdownSummary;

  const CalculationResult({
    required this.calculatedQuantity,
    required this.standardUnit,
    required this.rate,
    required this.totalAmount,
    required this.breakdownSummary,
  });

  static const CalculationResult zero = CalculationResult(
    calculatedQuantity: 0,
    standardUnit: '',
    rate: 0,
    totalAmount: 0,
    breakdownSummary: 'Enter measurements to calculate',
  );
}
