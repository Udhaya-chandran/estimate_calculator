import 'package:estimate_calculator/features/calculator/presentation/providers/calculator_provider.dart';
import '../../../../shared/models/product.dart';
import '../../domain/entities/product_variant.dart';

class ProductCalculationInfo {
  final double baseTotal;
  final double gstPercent;
  final double gstAmount;
  final double totalWithGst;
  final double appliedRate;
  final String appliedRateUnit;
  final String headerRateString;
  final String breakdownItemText;
  final String breakdownQtyText;
  final List<MapEntry<String, double>> rateCard;

  const ProductCalculationInfo({
    required this.baseTotal,
    required this.gstPercent,
    required this.gstAmount,
    required this.totalWithGst,
    required this.appliedRate,
    required this.appliedRateUnit,
    required this.headerRateString,
    required this.breakdownItemText,
    required this.breakdownQtyText,
    required this.rateCard,
  });
}

class ProductCalculationHelper {
  static ProductVariantOption? _getOpt(
      ProductVariantConfig? vc, CalculatorInputState state, String keyword) {
    if (vc == null) return null;
    for (final g in vc.variantGroups) {
      if (g.title.toLowerCase().contains(keyword.toLowerCase())) {
        final idx = state.selectedVariantIndices[g.title] ?? 0;
        if (idx >= 0 && idx < g.options.length) {
          return g.options[idx];
        }
      }
    }
    return null;
  }

  static ProductCalculationInfo calculate(
      CalculatorInputState state, Product product) {
    final vc = product.variantConfig;
    final gstPct = vc?.gstPercent ?? 18.0;
    final qty = state.quantity > 0 ? state.quantity : 1;
    final catId = product.categoryId;

    final isCement = catId == 'cat_cement' || vc?.pricingUnitLabel == 'bags';
    final isRoofing = catId == 'cat_roofing' ||
        vc?.pricingUnitLabel == 'sq ft' ||
        vc?.pricingUnitLabel == 'sq.ft';
    final isPipe = catId == 'cat_pipes' ||
        vc?.pricingUnitLabel == 'metre' ||
        vc?.pricingUnitLabel == 'meter' ||
        vc?.pricingUnitLabel == 'm' ||
        vc?.pricingUnitLabel == 'foot';

    if (isCement) {
      return _calculateCement(state, product, vc, gstPct, qty);
    } else if (isRoofing) {
      return _calculateRoofing(state, product, vc, gstPct, qty);
    } else if (isPipe) {
      return _calculatePipe(state, product, vc, gstPct, qty);
    } else {
      return _calculateSteel(state, product, vc, gstPct, qty);
    }
  }

  // ──────────────────────────── 1. CEMENT ────────────────────────────
  static ProductCalculationInfo _calculateCement(
    CalculatorInputState state,
    Product product,
    ProductVariantConfig? vc,
    double gstPct,
    int qty,
  ) {
    final unitLabels = vc?.orderUnitLabels ?? const ['Bags', 'Tonnes'];
    final safeUnitIdx = (state.orderUnitIndex < unitLabels.length)
        ? state.orderUnitIndex
        : 0;
    final selUnit = unitLabels[safeUnitIdx];
    final unitsPerTonne = vc?.unitsPerTonne ?? 20.0;

    final brandOpt = _getOpt(vc, state, 'brand');
    final ratePerBag = (brandOpt != null && brandOpt.rate > 0)
        ? brandOpt.rate
        : (state.customRate > 0 ? state.customRate : product.rate);
    final ratePerTonne = ratePerBag * unitsPerTonne;

    final double bagsCount = (selUnit == 'Tonnes')
        ? (qty * unitsPerTonne)
        : qty.toDouble();

    final baseTotal = bagsCount * ratePerBag;
    final gstAmt = baseTotal * gstPct / 100;
    final totalWithGst = baseTotal + gstAmt;

    final breakdownQtyText = selUnit == 'Tonnes' && qty > 1
        ? '${bagsCount.toInt()} bags ($qty tonnes)'
        : '${bagsCount.toInt()} bags';

    return ProductCalculationInfo(
      baseTotal: baseTotal,
      gstPercent: gstPct,
      gstAmount: gstAmt,
      totalWithGst: totalWithGst,
      appliedRate: ratePerBag,
      appliedRateUnit: 'Bags',
      headerRateString: 'rate ₹${ratePerBag.toInt()}/bags',
      breakdownItemText: product.name,
      breakdownQtyText: breakdownQtyText,
      rateCard: [
        MapEntry('per Bags', ratePerBag),
        MapEntry('per Tonnes', ratePerTonne),
      ],
    );
  }

  // ──────────────────────────── 2. ROOFING ───────────────────────────
  static ProductCalculationInfo _calculateRoofing(
    CalculatorInputState state,
    Product product,
    ProductVariantConfig? vc,
    double gstPct,
    int qty,
  ) {
    final isPolycarb = product.id == 'prod_polycarb_sheet';

    if (isPolycarb) {
      final brandOpt = _getOpt(vc, state, 'brand');
      final profileOpt = _getOpt(vc, state, 'profile');
      final widthOpt = _getOpt(vc, state, 'width');
      final lengthOpt = _getOpt(vc, state, 'length');

      final double ratePerSqFt = (profileOpt != null && profileOpt.rate > 0)
          ? profileOpt.rate
          : ((brandOpt != null && brandOpt.rate > 0)
              ? brandOpt.rate
              : (state.customRate > 0 ? state.customRate : 110.0));

      double widthFt = 3.0;
      if (widthOpt != null && widthOpt.detail != null) {
        widthFt = double.tryParse(widthOpt.detail!) ?? 3.0;
      }
      double lengthFt = 8.0;
      if (lengthOpt != null && lengthOpt.detail != null) {
        lengthFt = double.tryParse(lengthOpt.detail!) ?? 8.0;
      }

      final areaSqFt = widthFt * lengthFt;
      final ratePerNos = areaSqFt * ratePerSqFt * 1.05;
      final widthM = widthFt * 0.3048;
      final ratePerMetre = widthM * (ratePerSqFt * 10.7639104);

      final orderUnits = vc?.orderUnitLabels ?? const ['Sq Ft', 'Nos', 'Metre'];
      final safeUnitIdx = (state.orderUnitIndex < orderUnits.length)
          ? state.orderUnitIndex
          : 0;
      final selUnit = orderUnits[safeUnitIdx].toLowerCase();

      double baseTotal;
      String breakdownText;
      if (selUnit.contains('nos') || selUnit.contains('sheet')) {
        baseTotal = qty * ratePerNos;
        breakdownText = '$qty nos (${widthFt.toInt()}×${lengthFt.toInt()} ft)';
      } else if (selUnit.contains('m')) {
        baseTotal = qty * ratePerMetre;
        breakdownText = '$qty m';
      } else {
        baseTotal = qty * ratePerSqFt;
        breakdownText = '$qty sq ft';
      }

      final gstAmt = baseTotal * gstPct / 100;
      final totalWithGst = baseTotal + gstAmt;

      return ProductCalculationInfo(
        baseTotal: baseTotal,
        gstPercent: gstPct,
        gstAmount: gstAmt,
        totalWithGst: totalWithGst,
        appliedRate: ratePerSqFt,
        appliedRateUnit: 'Sq Ft',
        headerRateString: 'rate ₹${ratePerSqFt.toInt()}/sq ft',
        breakdownItemText: product.name,
        breakdownQtyText: breakdownText,
        rateCard: [
          MapEntry('per Sq Ft', ratePerSqFt),
          MapEntry('per Nos', ratePerNos),
          MapEntry('per Metre', ratePerMetre),
        ],
      );
    }

    // Sheet Metal (GI Plain, Colour Coated, Tile Sheet, Galvalume)
    final brandOpt = _getOpt(vc, state, 'brand');
    final zincOpt = _getOpt(vc, state, 'zinc') ?? _getOpt(vc, state, 'coating');
    final thickOpt = _getOpt(vc, state, 'thick');
    final widthOpt = _getOpt(vc, state, 'width');
    final lengthOpt = _getOpt(vc, state, 'length');

    final double ratePerKg = (zincOpt != null && zincOpt.rate > 0)
        ? zincOpt.rate
        : ((brandOpt != null && brandOpt.rate > 0)
            ? brandOpt.rate
            : (state.customRate > 0 ? state.customRate : product.rate));

    double thicknessMm = 0.47;
    if (thickOpt != null) {
      final match = RegExp(r'([0-9]+\.?[0-9]*)').firstMatch(thickOpt.label);
      if (match != null) {
        thicknessMm = double.tryParse(match.group(1)!) ?? 0.47;
      }
    }

    double widthFt = 3.0;
    if (widthOpt != null) {
      if (widthOpt.detail != null && double.tryParse(widthOpt.detail!) != null) {
        widthFt = double.parse(widthOpt.detail!);
      } else {
        final match =
            RegExp(r'([0-9]+\.?[0-9]*)\s*ft').firstMatch(widthOpt.label);
        if (match != null) {
          widthFt = double.tryParse(match.group(1)!) ?? 3.0;
        }
      }
    }

    double lengthFt = 10.0;
    if (lengthOpt != null) {
      if (lengthOpt.detail != null && double.tryParse(lengthOpt.detail!) != null) {
        lengthFt = double.parse(lengthOpt.detail!);
      } else {
        final match =
            RegExp(r'([0-9]+\.?[0-9]*)\s*ft').firstMatch(lengthOpt.label);
        if (match != null) {
          lengthFt = double.tryParse(match.group(1)!) ?? 10.0;
        }
      }
    }

    final weightPerM2 = thicknessMm * 7.85;
    final weightPerSqFt = weightPerM2 / 10.7639104;
    final ratePerSqFt = weightPerSqFt * ratePerKg;

    final areaSqFt = widthFt * lengthFt;
    final weightPerPiece = areaSqFt * weightPerSqFt * 1.06;
    final ratePerNos = weightPerPiece * ratePerKg;

    final widthM = widthFt * 0.3048;
    final weightPerMetre = widthM * weightPerM2;
    final ratePerMetre = weightPerMetre * ratePerKg;

    final orderUnits =
        vc?.orderUnitLabels ?? const ['Sq Ft', 'Nos', 'Kg', 'Metre'];
    final safeUnitIdx = (state.orderUnitIndex < orderUnits.length)
        ? state.orderUnitIndex
        : 0;
    final selUnit = orderUnits[safeUnitIdx]
        .toLowerCase()
        .replaceAll(' ', '')
        .replaceAll('.', '');

    double baseTotal;
    String breakdownText;

    if (selUnit.contains('sq') || selUnit.contains('ft')) {
      baseTotal = qty * ratePerSqFt;
      breakdownText = '$qty sq ft × ${weightPerSqFt.toStringAsFixed(3)} kg/sq ft';
    } else if (selUnit.contains('nos') ||
        selUnit.contains('sheet') ||
        selUnit.contains('piece')) {
      baseTotal = qty * ratePerNos;
      final wStr = widthFt == widthFt.roundToDouble()
          ? widthFt.toInt().toString()
          : widthFt.toString();
      final lStr = lengthFt == lengthFt.roundToDouble()
          ? lengthFt.toInt().toString()
          : lengthFt.toString();
      breakdownText =
          '$qty nos × ${weightPerPiece.toStringAsFixed(2)} kg ($wStr×$lStr ft)';
    } else if (selUnit.contains('kg')) {
      baseTotal = qty * ratePerKg;
      breakdownText = '$qty kg';
    } else if (selUnit.contains('metre') ||
        selUnit.contains('meter') ||
        selUnit.contains('m')) {
      baseTotal = qty * ratePerMetre;
      breakdownText = '$qty m × ${weightPerMetre.toStringAsFixed(3)} kg/m';
    } else {
      baseTotal = qty * ratePerSqFt;
      breakdownText = '$qty sq ft × ${weightPerSqFt.toStringAsFixed(3)} kg/sq ft';
    }

    final double gstAmt = baseTotal * gstPct / 100;
    final double totalWithGst = baseTotal + gstAmt;

    return ProductCalculationInfo(
      baseTotal: baseTotal,
      gstPercent: gstPct,
      gstAmount: gstAmt,
      totalWithGst: totalWithGst,
      appliedRate: ratePerKg,
      appliedRateUnit: 'Kg',
      headerRateString: 'rate ₹${ratePerKg.toInt()}/kg',
      breakdownItemText: product.name,
      breakdownQtyText: breakdownText,
      rateCard: [
        MapEntry('per Sq Ft', ratePerSqFt),
        MapEntry('per Nos', ratePerNos),
        MapEntry('per Kg', ratePerKg),
        MapEntry('per Metre', ratePerMetre),
      ],
    );
  }

  // ──────────────────────────── 3. PIPES ────────────────────────────
  static ProductCalculationInfo _calculatePipe(
    CalculatorInputState state,
    Product product,
    ProductVariantConfig? vc,
    double gstPct,
    int qty,
  ) {
    final isSSPipe = product.id == 'prod_ss_pipe';

    if (isSSPipe) {
      final gradeOpt = _getOpt(vc, state, 'grade');
      final sizeOpt = _getOpt(vc, state, 'size') ?? _getOpt(vc, state, 'diameter');
      final lengthOpt = _getOpt(vc, state, 'length');

      double gradeMultiplier = 1.0;
      if (gradeOpt != null) {
        if (gradeOpt.label.contains('304')) {
          gradeMultiplier = 285.0 / 173.16;
        } else if (gradeOpt.label.contains('316')) {
          gradeMultiplier = 519.75 / 173.16;
        }
      }

      final double baseSizeRate = (sizeOpt != null && sizeOpt.rate > 0)
          ? sizeOpt.rate
          : ((gradeOpt != null && gradeOpt.rate > 0)
              ? gradeOpt.rate
              : (state.customRate > 0 ? state.customRate : 173.16));
      final double ratePerMetre = baseSizeRate * gradeMultiplier;

      double lengthInM = 6.0;
      if (lengthOpt != null) {
        if (lengthOpt.detail != null &&
            double.tryParse(lengthOpt.detail!) != null) {
          lengthInM = double.parse(lengthOpt.detail!);
        } else {
          final match =
              RegExp(r'([0-9]+\.?[0-9]*)').firstMatch(lengthOpt.label);
          if (match != null) {
            lengthInM = double.tryParse(match.group(1)!) ?? 6.0;
          }
        }
      }

      final double ratePerNos = ratePerMetre * lengthInM;

      final orderUnits = vc?.orderUnitLabels ?? const ['Metre', 'Nos'];
      final safeUnitIdx = (state.orderUnitIndex < orderUnits.length)
          ? state.orderUnitIndex
          : 0;
      final selUnit = orderUnits[safeUnitIdx].toLowerCase();

      double baseTotal;
      String breakdownText;
      if (selUnit.contains('nos') || selUnit.contains('piece')) {
        baseTotal = qty * ratePerNos;
        breakdownText =
            '$qty nos (${lengthInM == lengthInM.roundToDouble() ? lengthInM.toInt() : lengthInM} m)';
      } else {
        baseTotal = qty * ratePerMetre;
        breakdownText = '$qty m';
      }

      final double gstAmt = baseTotal * gstPct / 100;
      final double totalWithGst = baseTotal + gstAmt;

      final rateMetreFormatted = ratePerMetre == ratePerMetre.roundToDouble()
          ? ratePerMetre.toInt().toString()
          : ratePerMetre.toStringAsFixed(2);

      return ProductCalculationInfo(
        baseTotal: baseTotal,
        gstPercent: gstPct,
        gstAmount: gstAmt,
        totalWithGst: totalWithGst,
        appliedRate: ratePerMetre,
        appliedRateUnit: 'Metre',
        headerRateString: 'rate ₹$rateMetreFormatted/metre',
        breakdownItemText: product.name,
        breakdownQtyText: breakdownText,
        rateCard: [
          MapEntry('per Metre', ratePerMetre),
          MapEntry('per Nos', ratePerNos),
        ],
      );
    }

    // Other pipes: GI round, GI square/rect, MS square, PVC, CPVC
    final sizeOpt = _getOpt(vc, state, 'size');
    final classOpt = _getOpt(vc, state, 'class') ??
        _getOpt(vc, state, 'pressure') ??
        _getOpt(vc, state, 'gauge');
    final brandOpt = _getOpt(vc, state, 'brand');
    final lengthOpt = _getOpt(vc, state, 'length');

    final double ratePerFoot = (sizeOpt != null && sizeOpt.rate > 0)
        ? sizeOpt.rate
        : ((classOpt != null && classOpt.rate > 0)
            ? classOpt.rate
            : ((brandOpt != null && brandOpt.rate > 0)
                ? brandOpt.rate
                : (state.customRate > 0 ? state.customRate : product.rate)));

    final double ratePerMetre = ratePerFoot * 3.28084;

    double lengthInM = 6.10;
    double lengthInFt = 20.0;
    if (lengthOpt != null) {
      if (lengthOpt.detail != null &&
          double.tryParse(lengthOpt.detail!) != null) {
        lengthInM = double.parse(lengthOpt.detail!);
        lengthInFt = lengthInM / 0.3048;
      } else {
        final match =
            RegExp(r'([0-9]+\.?[0-9]*)\s*ft').firstMatch(lengthOpt.label);
        if (match != null) {
          lengthInFt = double.tryParse(match.group(1)!) ?? 20.0;
          lengthInM = lengthInFt * 0.3048;
        }
      }
    }

    final double ratePerNos = ratePerFoot * lengthInFt;

    final orderUnits =
        vc?.orderUnitLabels ?? const ['Metre', 'Nos', 'Feet'];
    final safeUnitIdx = (state.orderUnitIndex < orderUnits.length)
        ? state.orderUnitIndex
        : 0;
    final selUnit = orderUnits[safeUnitIdx].toLowerCase();

    double baseTotal;
    String breakdownText;
    if (selUnit.contains('nos') || selUnit.contains('piece')) {
      baseTotal = qty * ratePerNos;
      breakdownText =
          '$qty nos (${lengthInFt.toInt()} ft / ${lengthInM.toStringAsFixed(1)} m)';
    } else if (selUnit.contains('ft') || selUnit.contains('feet')) {
      baseTotal = qty * ratePerFoot;
      breakdownText = '$qty ft';
    } else {
      baseTotal = qty * ratePerMetre;
      breakdownText = '$qty m';
    }

    final double gstAmt = baseTotal * gstPct / 100;
    final double totalWithGst = baseTotal + gstAmt;

    final rateFootFormatted = ratePerFoot == ratePerFoot.roundToDouble()
        ? ratePerFoot.toInt().toString()
        : ratePerFoot.toStringAsFixed(2);

    return ProductCalculationInfo(
      baseTotal: baseTotal,
      gstPercent: gstPct,
      gstAmount: gstAmt,
      totalWithGst: totalWithGst,
      appliedRate: ratePerFoot,
      appliedRateUnit: 'Foot',
      headerRateString: 'rate ₹$rateFootFormatted/ft',
      breakdownItemText: product.name,
      breakdownQtyText: breakdownText,
      rateCard: [
        MapEntry('per Metre', ratePerMetre),
        MapEntry('per Nos', ratePerNos),
        MapEntry('per Feet', ratePerFoot),
      ],
    );
  }

  // ──────────────────────────── 4. STEEL ────────────────────────────
  static ProductCalculationInfo _calculateSteel(
    CalculatorInputState state,
    Product product,
    ProductVariantConfig? vc,
    double gstPct,
    int qty,
  ) {
    if (product.id == 'prod_wire_mesh') {
      final brandOpt = _getOpt(vc, state, 'brand');
      final gaugeOpt = _getOpt(vc, state, 'gauge') ?? _getOpt(vc, state, 'mesh');
      final rollOpt = _getOpt(vc, state, 'roll');

      final double ratePerSqFt = (gaugeOpt != null && gaugeOpt.rate > 0)
          ? gaugeOpt.rate
          : ((brandOpt != null && brandOpt.rate > 0)
              ? brandOpt.rate
              : (state.customRate > 0 ? state.customRate : 35.0));

      double rollSqFt = 200.0;
      if (rollOpt != null && rollOpt.detail != null) {
        rollSqFt = double.tryParse(rollOpt.detail!) ?? 200.0;
      }

      final ratePerRoll = rollSqFt * ratePerSqFt;
      final ratePerMetre = ratePerSqFt * 3.28;

      final orderUnits = vc?.orderUnitLabels ?? const ['Rolls', 'Sq Ft', 'Metre'];
      final safeUnitIdx = (state.orderUnitIndex < orderUnits.length)
          ? state.orderUnitIndex
          : 0;
      final selUnit = orderUnits[safeUnitIdx].toLowerCase();

      double baseTotal;
      String breakdownText;
      if (selUnit.contains('roll')) {
        baseTotal = qty * ratePerRoll;
        breakdownText = '$qty rolls (${(qty * rollSqFt).toInt()} sq ft)';
      } else if (selUnit.contains('m')) {
        baseTotal = qty * ratePerMetre;
        breakdownText = '$qty m';
      } else {
        baseTotal = qty * ratePerSqFt;
        breakdownText = '$qty sq ft';
      }

      final double gstAmt = baseTotal * gstPct / 100;
      final double totalWithGst = baseTotal + gstAmt;

      return ProductCalculationInfo(
        baseTotal: baseTotal,
        gstPercent: gstPct,
        gstAmount: gstAmt,
        totalWithGst: totalWithGst,
        appliedRate: ratePerSqFt,
        appliedRateUnit: 'Sq Ft',
        headerRateString: 'rate ₹${ratePerSqFt.toInt()}/sq ft',
        breakdownItemText: product.name,
        breakdownQtyText: breakdownText,
        rateCard: [
          MapEntry('per Rolls', ratePerRoll),
          MapEntry('per Sq Ft', ratePerSqFt),
          MapEntry('per Metre', ratePerMetre),
        ],
      );
    }

    if (product.id == 'prod_steel_plate') {
      final brandOpt = _getOpt(vc, state, 'brand');
      final thickOpt = _getOpt(vc, state, 'thick');
      final sizeOpt = _getOpt(vc, state, 'size');

      final double ratePerKg = (thickOpt != null && thickOpt.rate > 0)
          ? thickOpt.rate
          : ((brandOpt != null && brandOpt.rate > 0)
              ? brandOpt.rate
              : (state.customRate > 0 ? state.customRate : 75.0));

      double thicknessMm = 6.0;
      if (thickOpt != null) {
        final match = RegExp(r'([0-9]+\.?[0-9]*)').firstMatch(thickOpt.label);
        if (match != null) {
          thicknessMm = double.tryParse(match.group(1)!) ?? 6.0;
        }
      }

      double plateAreaSqFt = 32.0;
      if (sizeOpt != null && sizeOpt.detail != null) {
        plateAreaSqFt = double.tryParse(sizeOpt.detail!) ?? 32.0;
      }

      final weightPerM2 = thicknessMm * 7.85;
      final weightPerSqFt = weightPerM2 / 10.7639104;
      final kgPerPlate = plateAreaSqFt * weightPerSqFt;

      final ratePerNos = kgPerPlate * ratePerKg;
      final ratePerSqFt = weightPerSqFt * ratePerKg;
      final ratePerTonne = ratePerKg * 1000.0;

      final orderUnits =
          vc?.orderUnitLabels ?? const ['Nos', 'Sq Ft', 'Kg', 'Tonnes'];
      final safeUnitIdx = (state.orderUnitIndex < orderUnits.length)
          ? state.orderUnitIndex
          : 0;
      final selUnit = orderUnits[safeUnitIdx].toLowerCase();

      double baseTotal;
      String breakdownText;
      if (selUnit.contains('nos') || selUnit.contains('plate')) {
        baseTotal = qty * ratePerNos;
        breakdownText = '$qty nos × ${kgPerPlate.toStringAsFixed(1)} kg';
      } else if (selUnit.contains('sq') || selUnit.contains('ft')) {
        baseTotal = qty * ratePerSqFt;
        breakdownText =
            '$qty sq ft × ${weightPerSqFt.toStringAsFixed(2)} kg/sq ft';
      } else if (selUnit.contains('tonne')) {
        baseTotal = qty * ratePerTonne;
        breakdownText = '$qty tonnes';
      } else {
        baseTotal = qty * ratePerKg;
        breakdownText = '$qty kg';
      }

      final double gstAmt = baseTotal * gstPct / 100;
      final double totalWithGst = baseTotal + gstAmt;

      return ProductCalculationInfo(
        baseTotal: baseTotal,
        gstPercent: gstPct,
        gstAmount: gstAmt,
        totalWithGst: totalWithGst,
        appliedRate: ratePerKg,
        appliedRateUnit: 'Kg',
        headerRateString: 'rate ₹${ratePerKg.toInt()}/kg',
        breakdownItemText: product.name,
        breakdownQtyText: breakdownText,
        rateCard: [
          MapEntry('per Nos', ratePerNos),
          MapEntry('per Sq Ft', ratePerSqFt),
          MapEntry('per Kg', ratePerKg),
          MapEntry('per Tonnes', ratePerTonne),
        ],
      );
    }

    if (product.id == 'prod_ms_angle') {
      final brandOpt = _getOpt(vc, state, 'brand');
      final sizeOpt = _getOpt(vc, state, 'size');
      final lengthOpt = _getOpt(vc, state, 'length');

      final double ratePerKg = (sizeOpt != null && sizeOpt.rate > 0)
          ? sizeOpt.rate
          : ((brandOpt != null && brandOpt.rate > 0)
              ? brandOpt.rate
              : (state.customRate > 0 ? state.customRate : 80.0));

      double kgPerMetre = 2.97;
      if (sizeOpt != null && sizeOpt.detail != null) {
        final match =
            RegExp(r'([0-9]+\.?[0-9]*)').firstMatch(sizeOpt.detail!);
        if (match != null) {
          kgPerMetre = double.tryParse(match.group(1)!) ?? 2.97;
        }
      }

      double lengthInM = 6.0;
      if (lengthOpt != null) {
        if (lengthOpt.detail != null &&
            double.tryParse(lengthOpt.detail!) != null) {
          lengthInM = double.parse(lengthOpt.detail!);
        } else {
          final match =
              RegExp(r'([0-9]+\.?[0-9]*)').firstMatch(lengthOpt.label);
          if (match != null) {
            lengthInM = double.tryParse(match.group(1)!) ?? 6.0;
          }
        }
      }

      final kgPerNos = kgPerMetre * lengthInM;
      final ratePerNos = ratePerKg * kgPerNos;
      final ratePerMetre = ratePerKg * kgPerMetre;
      final ratePerTonne = ratePerKg * 1000.0;

      final orderUnits =
          vc?.orderUnitLabels ?? const ['Nos', 'Metre', 'Kg', 'Tonnes'];
      final safeUnitIdx = (state.orderUnitIndex < orderUnits.length)
          ? state.orderUnitIndex
          : 0;
      final selUnit = orderUnits[safeUnitIdx].toLowerCase();

      double baseTotal;
      String breakdownText;
      if (selUnit.contains('metre') || selUnit.contains('m')) {
        baseTotal = qty * ratePerMetre;
        breakdownText = '$qty m × ${kgPerMetre.toStringAsFixed(2)} kg/m';
      } else if (selUnit.contains('tonne')) {
        baseTotal = qty * ratePerTonne;
        breakdownText = '$qty tonnes';
      } else if (selUnit.contains('kg')) {
        baseTotal = qty * ratePerKg;
        breakdownText = '$qty kg';
      } else {
        baseTotal = qty * ratePerNos;
        breakdownText =
            '$qty nos × ${kgPerNos.toStringAsFixed(2)} kg (${lengthInM.toInt()} m)';
      }

      final double gstAmt = baseTotal * gstPct / 100;
      final double totalWithGst = baseTotal + gstAmt;

      return ProductCalculationInfo(
        baseTotal: baseTotal,
        gstPercent: gstPct,
        gstAmount: gstAmt,
        totalWithGst: totalWithGst,
        appliedRate: ratePerKg,
        appliedRateUnit: 'Kg',
        headerRateString: 'rate ₹${ratePerKg.toInt()}/kg',
        breakdownItemText: product.name,
        breakdownQtyText: breakdownText,
        rateCard: [
          MapEntry('per Nos', ratePerNos),
          MapEntry('per Metre', ratePerMetre),
          MapEntry('per Kg', ratePerKg),
          MapEntry('per Tonnes', ratePerTonne),
        ],
      );
    }

    // Default TMT Bar (Fe 500D)
    final brandOpt = _getOpt(vc, state, 'brand');
    final diamOpt = _getOpt(vc, state, 'diam') ?? _getOpt(vc, state, 'size');
    final lengthOpt = _getOpt(vc, state, 'length');

    final double ratePerKg = (diamOpt != null && diamOpt.rate > 0)
        ? diamOpt.rate
        : ((brandOpt != null && brandOpt.rate > 0)
            ? brandOpt.rate
            : (state.customRate > 0 ? state.customRate : 76.0));

    double diamMm = 6.0;
    if (diamOpt != null) {
      final match = RegExp(r'([0-9]+)').firstMatch(diamOpt.label);
      if (match != null) {
        diamMm = double.tryParse(match.group(1)!) ?? 6.0;
      }
    }

    // D² / 162.0 kg/m
    final kgPerMetre = (diamMm * diamMm) / 162.0;

    double lengthInM = 12.0;
    String lenLabel = '(12 m)';
    if (lengthOpt != null) {
      if (lengthOpt.detail != null &&
          double.tryParse(lengthOpt.detail!) != null) {
        lengthInM = double.parse(lengthOpt.detail!);
        lenLabel = '(${lengthOpt.detail})';
      } else if (lengthOpt.label.contains('40 ft') ||
          lengthOpt.label.contains('12.19')) {
        lengthInM = 12.19;
        lenLabel = '(12.19 m)';
      } else {
        lenLabel = '(${lengthOpt.detail ?? lengthOpt.label})';
      }
    }

    final kgPerNos = kgPerMetre * lengthInM;
    final ratePerNos = ratePerKg * kgPerNos;
    final ratePerMetre = ratePerKg * kgPerMetre;
    final ratePerTonne = ratePerKg * 1000.0;

    final orderUnits =
        vc?.orderUnitLabels ?? const ['Nos', 'Metre', 'Kg', 'Tonnes'];
    final safeUnitIdx = (state.orderUnitIndex < orderUnits.length)
        ? state.orderUnitIndex
        : 0;
    final selUnit = orderUnits[safeUnitIdx].toLowerCase();

    double baseTotal;
    String breakdownText;
    if (selUnit.contains('metre') || selUnit.contains('m')) {
      baseTotal = qty * ratePerMetre;
      breakdownText = '$qty m × ${kgPerMetre.toStringAsFixed(3)} kg/m';
    } else if (selUnit.contains('tonne')) {
      baseTotal = qty * ratePerTonne;
      breakdownText = '$qty tonnes (${(qty * 1000).toInt()} kg)';
    } else if (selUnit.contains('kg')) {
      baseTotal = qty * ratePerKg;
      breakdownText = '$qty kg';
    } else {
      baseTotal = qty * ratePerNos;
      breakdownText = '$qty nos × ${kgPerNos.toStringAsFixed(3)} kg $lenLabel';
    }

    final double gstAmt = baseTotal * gstPct / 100;
    final double totalWithGst = baseTotal + gstAmt;

    return ProductCalculationInfo(
      baseTotal: baseTotal,
      gstPercent: gstPct,
      gstAmount: gstAmt,
      totalWithGst: totalWithGst,
      appliedRate: ratePerKg,
      appliedRateUnit: 'Kg',
      headerRateString: 'rate ₹${ratePerKg.toInt()}/kg',
      breakdownItemText: product.name,
      breakdownQtyText: breakdownText,
      rateCard: [
        MapEntry('per Nos', ratePerNos),
        MapEntry('per Metre', ratePerMetre),
        MapEntry('per Kg', ratePerKg),
        MapEntry('per Tonnes', ratePerTonne),
      ],
    );
  }
}

