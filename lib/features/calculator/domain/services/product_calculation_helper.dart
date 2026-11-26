import 'package:estimate_calculator/features/calculator/domain/services/calculation_service.dart';
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

  static double _optionDelta(
      ProductVariantConfig? vc, CalculatorInputState state, String keyword) {
    if (vc == null) return 0.0;
    for (final g in vc.variantGroups) {
      if (g.title.toLowerCase().contains(keyword.toLowerCase()) &&
          g.options.isNotEmpty) {
        final baseRate = g.options.first.rate;
        final idx = state.selectedVariantIndices[g.title] ?? 0;
        if (idx >= 0 &&
            idx < g.options.length &&
            baseRate > 0 &&
            g.options[idx].rate > 0) {
          return g.options[idx].rate - baseRate;
        }
      }
    }
    return 0.0;
  }

  static double _brandDelta(
          ProductVariantConfig? vc, CalculatorInputState state) =>
      _optionDelta(vc, state, 'brand');

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
    } else if (catId == 'cat_steel') {
      return _calculateSteel(state, product, vc, gstPct, qty);
    } else {
      return _calculateGeneric(state, product, vc, gstPct, qty);
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

    final kgPerBag = (1000.0 / unitsPerTonne).round();
    final totalKg = (bagsCount * kgPerBag).round();
    final kgStr = totalKg.toString().replaceAllMapped(
        RegExp(r'(\d+?)(?=(\d{3})+(?!\d))'), (m) => '${m[1]},');

    final breakdownQtyText = selUnit == 'Tonnes'
        ? '$qty ${qty == 1 ? 'tonne' : 'tonnes'} (${bagsCount.toInt()} bags · $kgStr kg)'
        : '${bagsCount.toInt()} ${bagsCount.toInt() == 1 ? 'bag' : 'bags'} ($kgStr kg)';

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

      final double ratePerSqFt = ((profileOpt != null && profileOpt.rate > 0)
              ? profileOpt.rate + _brandDelta(vc, state)
              : ((brandOpt != null && brandOpt.rate > 0)
                  ? brandOpt.rate
                  : (state.customRate > 0 ? state.customRate : 110.0)))
          .clamp(1.0, double.infinity);

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

    final double ratePerKg = ((zincOpt != null && zincOpt.rate > 0)
            ? zincOpt.rate + _brandDelta(vc, state)
            : ((brandOpt != null && brandOpt.rate > 0)
                ? brandOpt.rate
                : (state.customRate > 0 ? state.customRate : product.rate)))
        .clamp(1.0, double.infinity);

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
    final isPlasticPipe =
        product.id == 'prod_pvc_pipe' || product.id == 'prod_cpvc_pipe';

    if (!isPlasticPipe) {
      return _calculateMetalPipe(state, product, vc, gstPct, qty);
    }

    // Plastic pipes (PVC / CPVC): length-based pricing
    final sizeOpt = _getOpt(vc, state, 'size');
    final classOpt = _getOpt(vc, state, 'class') ??
        _getOpt(vc, state, 'pressure') ??
        _getOpt(vc, state, 'gauge');
    final brandOpt = _getOpt(vc, state, 'brand');
    final lengthOpt = _getOpt(vc, state, 'length');

    final double classDelta = _optionDelta(vc, state, 'class');
    final double ratePerFoot = ((sizeOpt != null && sizeOpt.rate > 0)
            ? sizeOpt.rate + _brandDelta(vc, state) + classDelta
            : ((classOpt != null && classOpt.rate > 0)
                ? classOpt.rate + _brandDelta(vc, state)
                : ((brandOpt != null && brandOpt.rate > 0)
                    ? brandOpt.rate
                    : (state.customRate > 0 ? state.customRate : product.rate))))
        .clamp(1.0, double.infinity);

    final double ratePerMetre = ratePerFoot * 3.28084;

    double lengthInM = 6.10;
    double lengthInFt = 20.0;
    bool isCutToLength = false;
    if (lengthOpt != null) {
      if (lengthOpt.detail == 'custom' ||
          lengthOpt.label.toLowerCase().contains('cut')) {
        isCutToLength = true;
        lengthInFt = (state.length != null && state.length! > 0)
            ? state.length!
            : 0.0;
        lengthInM = lengthInFt * 0.3048;
      } else if (lengthOpt.detail != null &&
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
    if (isCutToLength) {
      baseTotal = qty * ratePerNos;
      final ftStr = lengthInFt == lengthInFt.roundToDouble()
          ? lengthInFt.toInt().toString()
          : lengthInFt.toStringAsFixed(1);
      breakdownText =
          '$qty ${qty == 1 ? 'cut' : 'cuts'} ($ftStr ft / ${lengthInM.toStringAsFixed(2)} m)';
    } else if (selUnit.contains('nos') || selUnit.contains('piece')) {
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

  /// Weight-based calculation for Metal Pipes (SS, MS Square, GI Round, GI Square/Rect)
  /// based on Size (OD or WxH), Gauge/Class wall thickness, and Length (including Cut to length).
  static ProductCalculationInfo _calculateMetalPipe(
    CalculatorInputState state,
    Product product,
    ProductVariantConfig? vc,
    double gstPct,
    int qty,
  ) {
    final brandOpt = _getOpt(vc, state, 'brand');
    final gradeOpt = _getOpt(vc, state, 'grade');
    final gaugeOpt = _getOpt(vc, state, 'gauge') ?? _getOpt(vc, state, 'class');
    final sizeOpt = _getOpt(vc, state, 'size');
    final lengthOpt = _getOpt(vc, state, 'length');

    // 1. Rate per kg (Grade for SS pipe, Brand for MS/GI pipes)
    final double ratePerKg = (product.id == 'prod_ss_pipe' &&
            gradeOpt != null &&
            gradeOpt.rate > 0)
        ? gradeOpt.rate
        : ((brandOpt != null && brandOpt.rate > 0)
            ? brandOpt.rate
            : (state.customRate > 0 ? state.customRate : product.rate));

    // 2. Wall thickness (mm) from Gauge / Class
    double thicknessMm = 1.6;
    if (gaugeOpt != null) {
      if (gaugeOpt.detail != null &&
          double.tryParse(gaugeOpt.detail!) != null) {
        thicknessMm = double.parse(gaugeOpt.detail!);
      } else {
        final m = RegExp(r'([0-9]+\.?[0-9]*)\s*mm').firstMatch(gaugeOpt.label);
        if (m != null) {
          thicknessMm = double.tryParse(m.group(1)!) ?? 1.6;
        }
      }
    }

    // 3. Theoretical weight per metre (kg/m) from cross-section & thickness
    final double kgPerMetre;
    if (product.id == 'prod_ss_pipe' ||
        product.id == 'prod_gi_round_1inch' ||
        product.id == 'prod_gi_round_2inch') {
      double odMm = product.id == 'prod_gi_round_2inch'
          ? 60.3
          : (product.id == 'prod_gi_round_1inch' ? 33.7 : 21.3);
      if (sizeOpt?.detail != null &&
          double.tryParse(sizeOpt!.detail!) != null) {
        odMm = double.parse(sizeOpt.detail!);
      }
      final factor = product.id == 'prod_ss_pipe' ? 0.02491 : 0.02466;
      kgPerMetre = ((odMm - thicknessMm) * thicknessMm * factor)
          .clamp(0.0, double.infinity);
    } else if (product.id == 'prod_gi_rect_2x1') {
      const double wMm = 50.0;
      const double hMm = 25.0;
      kgPerMetre = ((wMm + hMm - 2 * thicknessMm) * thicknessMm * 0.0157)
          .clamp(0.0, double.infinity);
    } else {
      // Square pipes: MS Square, GI Square 1x1, GI Square 2x2
      double sideMm = product.id == 'prod_gi_sq_2x2' ? 50.0 : 25.0;
      if (sizeOpt?.detail != null &&
          double.tryParse(sizeOpt!.detail!) != null) {
        sideMm = double.parse(sizeOpt.detail!);
      }
      kgPerMetre = ((sideMm - thicknessMm) * thicknessMm * 0.0314)
          .clamp(0.0, double.infinity);
    }

    // 4. Length in metres & feet (supports standard lengths and custom Cut to length)
    double lengthInM = 6.10;
    double lengthInFt = 20.0;
    bool isCutToLength = false;
    if (lengthOpt != null) {
      if (lengthOpt.detail == 'custom' ||
          lengthOpt.label.toLowerCase().contains('cut')) {
        isCutToLength = true;
        lengthInFt = (state.length != null && state.length! > 0)
            ? state.length!
            : 0.0;
        lengthInM = lengthInFt * 0.3048;
      } else if (lengthOpt.detail != null &&
          double.tryParse(lengthOpt.detail!) != null) {
        lengthInM = double.parse(lengthOpt.detail!);
        lengthInFt = lengthInM / 0.3048;
      }
    }

    // 5. Weight & Price calculation
    final double weightPerPieceKg = kgPerMetre * lengthInM;
    final double totalWeightKg = qty * weightPerPieceKg;
    final double baseTotal = totalWeightKg * ratePerKg;
    final double gstAmt = baseTotal * gstPct / 100;
    final double totalWithGst = baseTotal + gstAmt;

    final rateKgFormatted = ratePerKg == ratePerKg.roundToDouble()
        ? ratePerKg.toInt().toString()
        : ratePerKg.toStringAsFixed(2);

    final ftStr = lengthInFt == lengthInFt.roundToDouble()
        ? lengthInFt.toInt().toString()
        : lengthInFt.toStringAsFixed(1);

    final String breakdownQtyText = isCutToLength
        ? '$qty ${qty == 1 ? 'cut' : 'cuts'} × ${totalWeightKg.toStringAsFixed(2)} kg ($ftStr ft / ${lengthInM.toStringAsFixed(2)} m)'
        : '$qty nos × ${totalWeightKg.toStringAsFixed(2)} kg (${lengthInM.toStringAsFixed(2)} m)';

    return ProductCalculationInfo(
      baseTotal: baseTotal,
      gstPercent: gstPct,
      gstAmount: gstAmt,
      totalWithGst: totalWithGst,
      appliedRate: ratePerKg,
      appliedRateUnit: 'Kg',
      headerRateString: 'rate ₹$rateKgFormatted/kg',
      breakdownItemText: product.name,
      breakdownQtyText: breakdownQtyText,
      rateCard: [
        MapEntry('per Kg', ratePerKg),
        MapEntry('per Nos', weightPerPieceKg * ratePerKg),
        MapEntry('per Metre', kgPerMetre * ratePerKg),
        MapEntry('per Tonne', ratePerKg * 1000),
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

      final double ratePerSqFt = ((gaugeOpt != null && gaugeOpt.rate > 0)
              ? gaugeOpt.rate + _brandDelta(vc, state)
              : ((brandOpt != null && brandOpt.rate > 0)
                  ? brandOpt.rate
                  : (state.customRate > 0 ? state.customRate : 35.0)))
          .clamp(1.0, double.infinity);

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

      final double ratePerKg = ((thickOpt != null && thickOpt.rate > 0)
              ? thickOpt.rate + _brandDelta(vc, state)
              : ((brandOpt != null && brandOpt.rate > 0)
                  ? brandOpt.rate
                  : (state.customRate > 0 ? state.customRate : 75.0)))
          .clamp(1.0, double.infinity);

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

      final double ratePerKg = ((sizeOpt != null && sizeOpt.rate > 0)
              ? sizeOpt.rate + _brandDelta(vc, state)
              : ((brandOpt != null && brandOpt.rate > 0)
                  ? brandOpt.rate
                  : (state.customRate > 0 ? state.customRate : 80.0)))
          .clamp(1.0, double.infinity);

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

    final double ratePerKg = ((diamOpt != null && diamOpt.rate > 0)
            ? diamOpt.rate + _brandDelta(vc, state)
            : ((brandOpt != null && brandOpt.rate > 0)
                ? brandOpt.rate
                : (state.customRate > 0 ? state.customRate : 76.0)))
        .clamp(1.0, double.infinity);

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

  // ──────────────────────────── 5. GENERIC (Sanitary, Hardware, Tiles) ─────
  static ProductCalculationInfo _calculateGeneric(
    CalculatorInputState state,
    Product product,
    ProductVariantConfig? vc,
    double gstPct,
    int qty,
  ) {
    final config = product.measurementConfiguration;
    final rate = state.customRate > 0 ? state.customRate : product.rate;
    const service = CalculationService();
    final res = service.calculate(
      product: product,
      quantity: qty,
      length: state.length ?? (config.requiresLength ? 10.0 : null),
      lengthUnit: state.lengthUnit,
      width: state.width ?? (config.requiresWidth ? 10.0 : null),
      widthUnit: state.widthUnit,
      weight: state.weight,
      weightUnit: state.weightUnit,
      rate: rate,
    );

    final baseTotal = res.totalAmount;
    final gstAmt = baseTotal * gstPct / 100;
    final totalWithGst = baseTotal + gstAmt;

    final rateFormatted = rate == rate.roundToDouble()
        ? rate.toInt().toString()
        : rate.toStringAsFixed(2);
    final unitLabel = product.pricingUnit;

    return ProductCalculationInfo(
      baseTotal: baseTotal,
      gstPercent: gstPct,
      gstAmount: gstAmt,
      totalWithGst: totalWithGst,
      appliedRate: rate,
      appliedRateUnit: unitLabel,
      headerRateString: 'rate ₹$rateFormatted/$unitLabel',
      breakdownItemText: product.name,
      breakdownQtyText: '$qty $unitLabel',
      rateCard: [
        MapEntry('per $unitLabel', rate),
      ],
    );
  }
}

