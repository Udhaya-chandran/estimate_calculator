import 'package:flutter_test/flutter_test.dart';
import 'package:estimate_calculator/core/utils/unit_converter.dart';
import 'package:estimate_calculator/features/calculator/domain/entities/measurement_configuration.dart';
import 'package:estimate_calculator/features/calculator/domain/entities/measurement_type.dart';
import 'package:estimate_calculator/features/calculator/domain/services/calculation_service.dart';
import 'package:estimate_calculator/shared/models/product.dart';

void main() {
  group('CalculationService Unit Tests', () {
    const service = CalculationService();

    test('Quantity-based calculation (Cement bags)', () {
      final cement = Product(
        id: 'cement_1',
        categoryId: 'cat_cement',
        name: 'PPC Cement',
        brand: 'UltraTech',
        measurementType: MeasurementType.quantityOnly,
        pricingUnit: 'bag',
        rate: 380.0,
        measurementConfiguration: MeasurementConfiguration.quantityOnly(
          quantityLabel: 'Number of Bags',
          standardUnitLabel: 'bags',
        ),
      );

      final result = service.calculate(
        product: cement,
        quantity: 50,
        rate: 380.0,
      );

      expect(result.calculatedQuantity, 50.0);
      expect(result.totalAmount, 19000.0);
      expect(result.standardUnit, 'bags');
    });

    test('Length-based calculation in feet (PVC Pipe)', () {
      final pvcPipe = Product(
        id: 'pvc_1',
        categoryId: 'cat_pipes',
        name: 'PVC Pipe',
        brand: 'Supreme',
        measurementType: MeasurementType.lengthBased,
        pricingUnit: 'foot',
        rate: 25.0,
        measurementConfiguration: MeasurementConfiguration.lengthBased(
          quantityLabel: 'Number of Pipes',
          standardUnitLabel: 'ft',
        ),
      );

      // 10 pipes, each 20 feet long @ 25 per foot => 200 feet * 25 = 5000
      final result = service.calculate(
        product: pvcPipe,
        quantity: 10,
        length: 20.0,
        lengthUnit: LengthUnit.feet,
        rate: 25.0,
      );

      expect(result.calculatedQuantity, 200.0);
      expect(result.totalAmount, 5000.0);
      expect(result.standardUnit, 'ft');
    });

    test('Length-based calculation with unit conversion (Inches to Feet)', () {
      final pvcPipe = Product(
        id: 'pvc_1',
        categoryId: 'cat_pipes',
        name: 'PVC Pipe',
        brand: 'Supreme',
        measurementType: MeasurementType.lengthBased,
        pricingUnit: 'foot',
        rate: 25.0,
        measurementConfiguration: MeasurementConfiguration.lengthBased(
          quantityLabel: 'Number of Pipes',
          standardUnitLabel: 'ft',
        ),
      );

      // 2 pipes of 120 inches each = 10 feet each = 20 feet total @ 25 = 500
      final result = service.calculate(
        product: pvcPipe,
        quantity: 2,
        length: 120.0,
        lengthUnit: LengthUnit.inches,
        rate: 25.0,
      );

      expect(result.calculatedQuantity, 20.0);
      expect(result.totalAmount, 500.0);
    });

    test('Area-based calculation (Floor Tiles in sq.ft)', () {
      final tiles = Product(
        id: 'tile_1',
        categoryId: 'cat_tiles',
        name: 'Floor Tiles',
        brand: 'Kajaria',
        measurementType: MeasurementType.areaBased,
        pricingUnit: 'sq.ft',
        rate: 50.0,
        measurementConfiguration: MeasurementConfiguration.areaBased(
          quantityLabel: 'Number of Rooms',
          standardUnitLabel: 'sq.ft',
        ),
      );

      // 2 rooms of 12 ft x 10 ft = 120 sq.ft each = 240 sq.ft total @ 50 = 12000
      final result = service.calculate(
        product: tiles,
        quantity: 2,
        length: 12.0,
        lengthUnit: LengthUnit.feet,
        width: 10.0,
        widthUnit: LengthUnit.feet,
        rate: 50.0,
      );

      expect(result.calculatedQuantity, 240.0);
      expect(result.totalAmount, 12000.0);
      expect(result.standardUnit, 'sq.ft');
    });

    test('Area-based calculation with inch unit conversion (Tiles 24in x 24in)', () {
      final tiles = Product(
        id: 'tile_1',
        categoryId: 'cat_tiles',
        name: 'Floor Tiles',
        brand: 'Kajaria',
        measurementType: MeasurementType.areaBased,
        pricingUnit: 'sq.ft',
        rate: 50.0,
        measurementConfiguration: MeasurementConfiguration.areaBased(
          quantityLabel: 'Number of Tiles',
          standardUnitLabel: 'sq.ft',
        ),
      );

      // 10 tiles of 24 in x 24 in (2 ft x 2 ft = 4 sq.ft each) => 40 sq.ft @ 50 = 2000
      final result = service.calculate(
        product: tiles,
        quantity: 10,
        length: 24.0,
        lengthUnit: LengthUnit.inches,
        width: 24.0,
        widthUnit: LengthUnit.inches,
        rate: 50.0,
      );

      expect(result.calculatedQuantity, 40.0);
      expect(result.totalAmount, 2000.0);
    });

    test('Weight-based calculation (MS Angle in kg)', () {
      final msAngle = Product(
        id: 'angle_1',
        categoryId: 'cat_steel',
        name: 'MS Angle',
        brand: 'Jindal',
        measurementType: MeasurementType.weightBased,
        pricingUnit: 'kg',
        rate: 80.0,
        measurementConfiguration: MeasurementConfiguration.weightBased(
          quantityLabel: 'Number of Angles',
          standardUnitLabel: 'kg',
        ),
      );

      // 5 angles, each weighing 25 kg => 125 kg total @ 80 = 10000
      final result = service.calculate(
        product: msAngle,
        quantity: 5,
        weight: 25.0,
        weightUnit: WeightUnit.kilograms,
        rate: 80.0,
      );

      expect(result.calculatedQuantity, 125.0);
      expect(result.totalAmount, 10000.0);
      expect(result.standardUnit, 'kg');
    });

    test('Weight-based calculation with Tonnes unit conversion', () {
      final msAngle = Product(
        id: 'angle_1',
        categoryId: 'cat_steel',
        name: 'MS Angle',
        brand: 'Jindal',
        measurementType: MeasurementType.weightBased,
        pricingUnit: 'kg',
        rate: 80.0,
        measurementConfiguration: MeasurementConfiguration.weightBased(
          quantityLabel: 'Number of Bundles',
          standardUnitLabel: 'kg',
        ),
      );

      // 1 bundle of 0.5 tonnes = 500 kg @ 80 = 40000
      final result = service.calculate(
        product: msAngle,
        quantity: 1,
        weight: 0.5,
        weightUnit: WeightUnit.tonnes,
        rate: 80.0,
      );

      expect(result.calculatedQuantity, 500.0);
      expect(result.totalAmount, 40000.0);
    });

    test('Zero or negative quantity validation returns 0 amount', () {
      final cement = Product(
        id: 'cement_1',
        categoryId: 'cat_cement',
        name: 'PPC Cement',
        brand: 'UltraTech',
        measurementType: MeasurementType.quantityOnly,
        pricingUnit: 'bag',
        rate: 380.0,
        measurementConfiguration: MeasurementConfiguration.quantityOnly(
          quantityLabel: 'Number of Bags',
          standardUnitLabel: 'bags',
        ),
      );

      final result = service.calculate(
        product: cement,
        quantity: 0,
        rate: 380.0,
      );

      expect(result.calculatedQuantity, 0.0);
      expect(result.totalAmount, 0.0);
    });
  });
}
