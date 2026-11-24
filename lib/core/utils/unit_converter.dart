enum LengthUnit {
  inches('in', 'Inches', 1 / 12),
  feet('ft', 'Feet', 1.0),
  centimetres('cm', 'Centimetres', 0.0328084),
  metres('m', 'Metres', 3.28084);

  final String symbol;
  final String label;
  // Multiplier to convert to standard base unit: Feet
  final double toFeetMultiplier;

  const LengthUnit(this.symbol, this.label, this.toFeetMultiplier);

  double toFeet(double value) => value * toFeetMultiplier;
  static double fromFeet(double feet, LengthUnit targetUnit) => feet / targetUnit.toFeetMultiplier;
}

enum AreaUnit {
  squareInches('sq.in', 'Square Inches', 1 / 144),
  squareFeet('sq.ft', 'Square Feet', 1.0),
  squareMetres('sq.m', 'Square Metres', 10.7639);

  final String symbol;
  final String label;
  // Multiplier to convert to standard base unit: Square Feet
  final double toSqFeetMultiplier;

  const AreaUnit(this.symbol, this.label, this.toSqFeetMultiplier);

  double toSquareFeet(double value) => value * toSqFeetMultiplier;
}

enum WeightUnit {
  grams('g', 'Grams', 0.001),
  kilograms('kg', 'Kilograms', 1.0),
  quintals('qtl', 'Quintals', 100.0),
  tonnes('tonne', 'Tonnes', 1000.0);

  final String symbol;
  final String label;
  // Multiplier to convert to standard base unit: Kilograms
  final double toKgMultiplier;

  const WeightUnit(this.symbol, this.label, this.toKgMultiplier);

  double toKg(double value) => value * toKgMultiplier;
}

class UnitConverter {
  UnitConverter._();

  /// Converts any length measurement to Feet
  static double toFeet(double value, LengthUnit unit) {
    return value * unit.toFeetMultiplier;
  }

  /// Calculates area in Square Feet given length and width with their respective length units
  static double calculateAreaInSqFeet({
    required double length,
    required LengthUnit lengthUnit,
    required double width,
    required LengthUnit widthUnit,
  }) {
    final lengthInFeet = toFeet(length, lengthUnit);
    final widthInFeet = toFeet(width, widthUnit);
    return lengthInFeet * widthInFeet;
  }

  /// Converts weight to Kilograms
  static double toKilograms(double value, WeightUnit unit) {
    return value * unit.toKgMultiplier;
  }

  /// Calculates volume in Cubic Feet given length, width, height in feet
  static double calculateVolumeInCuFeet({
    required double length,
    required LengthUnit lengthUnit,
    required double width,
    required LengthUnit widthUnit,
    required double height,
    required LengthUnit heightUnit,
  }) {
    final l = toFeet(length, lengthUnit);
    final w = toFeet(width, widthUnit);
    final h = toFeet(height, heightUnit);
    return l * w * h;
  }
}

