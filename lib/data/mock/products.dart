import 'package:flutter/material.dart';
import '../../core/utils/unit_converter.dart';
import '../../features/calculator/domain/entities/measurement_configuration.dart';
import '../../features/calculator/domain/entities/measurement_type.dart';
import '../../features/calculator/domain/entities/product_variant.dart';
import '../../shared/models/product.dart';

final List<Product> mockProducts = [
  // ================= 1. SANITARY & BATHWARE =================
  Product(
    id: 'prod_sanitary_commode',
    categoryId: 'cat_sanitary',
    name: 'Wall-Hung Commode',
    brand: 'Jaquar',
    measurementType: MeasurementType.quantityOnly,
    pricingUnit: 'set',
    rate: 8500.0,
    measurementConfiguration: MeasurementConfiguration.quantityOnly(
      quantityLabel: 'Number of Commodes (Sets)',
      standardUnitLabel: 'sets',
    ),
    description: 'Premium ceramic rimless wall-hung water closet with dual-flush fitting and slow-falling UF seat.',
    imageUrl: 'https://images.unsplash.com/photo-1584622650111-993a426fbf0a?auto=format&fit=crop&w=600&q=80',
    icon: Icons.wc_outlined,
  ),
  Product(
    id: 'prod_sanitary_mixer',
    categoryId: 'cat_sanitary',
    name: 'Basin Mixer Faucet',
    brand: 'Grohe',
    measurementType: MeasurementType.quantityOnly,
    pricingUnit: 'piece',
    rate: 2450.0,
    measurementConfiguration: MeasurementConfiguration.quantityOnly(
      quantityLabel: 'Number of Faucets',
      standardUnitLabel: 'pcs',
    ),
    description: 'Solid brass body hot and cold mixer faucet with SilkMove ceramic cartridge and chrome finish.',
    imageUrl: 'https://images.unsplash.com/photo-1590490360182-c33d57733427?auto=format&fit=crop&w=600&q=80',
    icon: Icons.water_damage_outlined,
  ),
  Product(
    id: 'prod_sanitary_sink',
    categoryId: 'cat_sanitary',
    name: 'Kitchen Sink (Double)',
    brand: 'Franke',
    measurementType: MeasurementType.quantityOnly,
    pricingUnit: 'piece',
    rate: 4800.0,
    measurementConfiguration: MeasurementConfiguration.quantityOnly(
      quantityLabel: 'Number of Sinks',
      standardUnitLabel: 'pcs',
    ),
    description: '304-grade anti-scratch satin finish double bowl sink with sound-deadening insulation pads.',
    imageUrl: 'https://images.unsplash.com/photo-1556911220-e15b29be8c8f?auto=format&fit=crop&w=600&q=80',
    icon: Icons.countertops_outlined,
  ),
  Product(
    id: 'prod_sanitary_shower',
    categoryId: 'cat_sanitary',
    name: 'Rain Shower Set',
    brand: 'Jaquar',
    measurementType: MeasurementType.quantityOnly,
    pricingUnit: 'set',
    rate: 3200.0,
    measurementConfiguration: MeasurementConfiguration.quantityOnly(
      quantityLabel: 'Number of Shower Sets',
      standardUnitLabel: 'sets',
    ),
    description: 'Ultra-slim stainless steel rain shower head with silicon self-cleaning nozzles and 15-inch wall arm.',
    imageUrl: 'https://images.unsplash.com/photo-1620626011761-996317b8d101?auto=format&fit=crop&w=600&q=80',
    icon: Icons.shower_outlined,
  ),
  Product(
    id: 'prod_sanitary_basin',
    categoryId: 'cat_sanitary',
    name: 'Vanity Wash Basin',
    brand: 'Kohler',
    measurementType: MeasurementType.quantityOnly,
    pricingUnit: 'piece',
    rate: 3900.0,
    measurementConfiguration: MeasurementConfiguration.quantityOnly(
      quantityLabel: 'Number of Basins',
      standardUnitLabel: 'pcs',
    ),
    description: 'Modern rectangular vessel wash basin with glazed stain-resistant porcelain coating.',
    imageUrl: 'https://images.unsplash.com/photo-1584622781564-1d987f7333c1?auto=format&fit=crop&w=600&q=80',
    icon: Icons.wash_outlined,
  ),

  // ================= 2. HARDWARE & TOOLS =================
  Product(
    id: 'prod_door_hinges',
    categoryId: 'cat_hardware',
    name: 'SS Door Hinges (5")',
    brand: 'Godrej',
    measurementType: MeasurementType.quantityOnly,
    pricingUnit: 'piece',
    rate: 140.0,
    measurementConfiguration: MeasurementConfiguration.quantityOnly(
      quantityLabel: 'Number of Hinges',
      standardUnitLabel: 'pcs',
    ),
    description: 'Corrosion proof stainless steel ball bearing door hinges tested for 200,000 cycles.',
    imageUrl: 'https://images.unsplash.com/photo-1581244277943-fe4a9c777189?auto=format&fit=crop&w=600&q=80',
    icon: Icons.door_front_door_outlined,
  ),
  Product(
    id: 'prod_door_handles',
    categoryId: 'cat_hardware',
    name: 'Brass Mortise Handle',
    brand: 'Dorset',
    measurementType: MeasurementType.quantityOnly,
    pricingUnit: 'set',
    rate: 850.0,
    measurementConfiguration: MeasurementConfiguration.quantityOnly(
      quantityLabel: 'Number of Handle Sets',
      standardUnitLabel: 'sets',
    ),
    description: 'Architectural grade satin brass lever lock handle with heavy double turn brass deadbolt lock.',
    imageUrl: 'https://images.unsplash.com/photo-1517646287270-a5a9ca602e5c?auto=format&fit=crop&w=600&q=80',
    icon: Icons.hardware_outlined,
  ),
  Product(
    id: 'prod_fastener_screws',
    categoryId: 'cat_hardware',
    name: 'Roof Screws (Box)',
    brand: 'Unbrako',
    measurementType: MeasurementType.quantityOnly,
    pricingUnit: 'box',
    rate: 220.0,
    measurementConfiguration: MeasurementConfiguration.quantityOnly(
      quantityLabel: 'Number of Boxes',
      standardUnitLabel: 'boxes',
    ),
    description: 'Hardened zinc-plated roof fastening screws with leakproof EPDM washer seal.',
    imageUrl: 'https://images.unsplash.com/photo-1504148455328-c376907d081c?auto=format&fit=crop&w=600&q=80',
    icon: Icons.build_circle_outlined,
  ),
  Product(
    id: 'prod_padlock_yale',
    categoryId: 'cat_hardware',
    name: 'Yale Padlock (60mm)',
    brand: 'Yale',
    measurementType: MeasurementType.quantityOnly,
    pricingUnit: 'piece',
    rate: 650.0,
    measurementConfiguration: MeasurementConfiguration.quantityOnly(
      quantityLabel: 'Number of Padlocks',
      standardUnitLabel: 'pcs',
    ),
    description: 'Heavy duty all-weather brass padlock with drill-resistant boron carbide shackle.',
    imageUrl: 'https://images.unsplash.com/photo-1558002038-1055907df827?auto=format&fit=crop&w=600&q=80',
    icon: Icons.lock_outline_rounded,
  ),

  // ================= 3. STEEL & METALS =================
  Product(
    id: 'prod_tmt_rod',
    categoryId: 'cat_steel',
    subCategory: 'TMT Bars',
    name: 'TMT Bar — Fe 500D',
    brand: 'Tata Tiscon',
    measurementType: MeasurementType.weightBased,
    pricingUnit: 'kg',
    rate: 76.0,
    measurementConfiguration: MeasurementConfiguration.weightBased(
      quantityLabel: 'Number of Bars',
      standardUnitLabel: 'kg',
      defaultWeightUnit: WeightUnit.kilograms,
    ),
    description: 'IS 1786 reinforcement bar. Sold per kg. Cut to site length available.',
    imageUrl: 'https://s75ml08aciksg.space.mcode.io/assets/img/img-steels.jpg',
    icon: Icons.line_weight_rounded,
    variantConfig: ProductVariantConfig(
      gstPercent: 18.0,
      cuttingChargeNote: 'Cutting charge ₹3 per piece, applied on cut lengths only.',
      howCalculatedText:
          'Weight is the IS 1786 theoretical weight (D² ÷ 162 kg/m). Per-kg billing settles on the weighbridge reading.',
      variantGroups: [
        ProductVariantGroup(
          title: 'Brand',
          options: [
            ProductVariantOption(label: 'Tata Tiscon', rate: 76.0),
            ProductVariantOption(label: 'JSW Neosteel', rate: 73.0),
            ProductVariantOption(label: 'SAIL SeQR', rate: 70.0),
            ProductVariantOption(label: 'Jindal Panther', rate: 68.0),
            ProductVariantOption(label: 'Kamdhenu Nxt', rate: 66.0),
          ],
        ),
        ProductVariantGroup(
          title: 'Diameter',
          options: [
            ProductVariantOption(label: '6 mm', rate: 76.0, detail: '0.222 kg/m'),
            ProductVariantOption(label: '8 mm', rate: 76.0, detail: '0.395 kg/m'),
            ProductVariantOption(label: '10 mm', rate: 74.0, detail: '0.617 kg/m'),
            ProductVariantOption(label: '12 mm', rate: 72.0, detail: '0.888 kg/m'),
            ProductVariantOption(label: '16 mm', rate: 74.0, detail: '1.580 kg/m'),
            ProductVariantOption(label: '20 mm', rate: 64.0, detail: '2.467 kg/m'),
            ProductVariantOption(label: '25 mm', rate: 64.0, detail: '3.854 kg/m'),
            ProductVariantOption(label: '32 mm', rate: 62.0, detail: '6.313 kg/m'),
          ],
        ),
        ProductVariantGroup(
          title: 'Length',
          options: [
            ProductVariantOption(label: '12 m (standard)', rate: 76.0, detail: '12 m'),
            ProductVariantOption(label: '40 ft / 12.19 m', rate: 76.0, detail: '12.19 m'),
            ProductVariantOption(label: 'Cut to site length', rate: 76.0, detail: 'custom'),
          ],
        ),
      ],
    ),
  ),
  Product(
    id: 'prod_ms_angle',
    categoryId: 'cat_steel',
    subCategory: 'Structural',
    name: 'MS Angle (40x40mm)',
    brand: 'Jindal Steel',
    measurementType: MeasurementType.weightBased,
    pricingUnit: 'kg',
    rate: 80.0,
    measurementConfiguration: MeasurementConfiguration.weightBased(
      quantityLabel: 'Number of Pieces',
      standardUnitLabel: 'kg',
      defaultWeightUnit: WeightUnit.kilograms,
    ),
    description: 'Hot-rolled structural mild steel angle for fabrications, sheds, and gates.',
    imageUrl: 'https://images.unsplash.com/photo-1518709268805-4e9042af9f23?auto=format&fit=crop&w=600&q=80',
    icon: Icons.architecture_rounded,
    variantConfig: ProductVariantConfig(
      gstPercent: 18.0,
      howCalculatedText:
          'Weight per metre from IS 2062 standard tables. Billing on actual weighbridge reading.\n\n'
          'GST 18% on structural steel (HSN 7216).',
      disclaimer: 'Estimate only. Rates change daily. Confirm with store before purchase. Rate sheet dated 2026-11-20.',
      orderUnitLabels: ['Nos', 'Metre', 'Kg', 'Tonnes'],
      variantGroups: [
        ProductVariantGroup(
          title: 'Brand',
          options: [
            ProductVariantOption(label: 'Jindal Steel', rate: 80.0, rateUnit: 'kg'),
            ProductVariantOption(label: 'SAIL', rate: 76.0, rateUnit: 'kg'),
            ProductVariantOption(label: 'JSW', rate: 78.0, rateUnit: 'kg'),
          ],
        ),
        ProductVariantGroup(
          title: 'Size',
          options: [
            ProductVariantOption(label: '25×25×3 mm', rate: 72.0, detail: '1.11 kg/m', rateUnit: 'kg'),
            ProductVariantOption(label: '40×40×5 mm', rate: 80.0, detail: '2.97 kg/m', rateUnit: 'kg'),
            ProductVariantOption(label: '50×50×5 mm', rate: 80.0, detail: '3.80 kg/m', rateUnit: 'kg'),
            ProductVariantOption(label: '65×65×6 mm', rate: 78.0, detail: '5.80 kg/m', rateUnit: 'kg'),
            ProductVariantOption(label: '75×75×8 mm', rate: 76.0, detail: '8.90 kg/m', rateUnit: 'kg'),
          ],
        ),
        ProductVariantGroup(
          title: 'Length',
          options: [
            ProductVariantOption(label: '6 m (standard)', rate: 0.0, detail: '6'),
            ProductVariantOption(label: '12 m', rate: 0.0, detail: '12'),
            ProductVariantOption(label: 'Cut to length', rate: 0.0, detail: '6'),
          ],
        ),
      ],
    ),
  ),
  Product(
    id: 'prod_steel_plate',
    categoryId: 'cat_steel',
    subCategory: 'Flat Products',
    name: 'MS Steel Plate (6mm)',
    brand: 'SAIL',
    measurementType: MeasurementType.weightBased,
    pricingUnit: 'kg',
    rate: 75.0,
    measurementConfiguration: MeasurementConfiguration.weightBased(
      quantityLabel: 'Number of Plates',
      standardUnitLabel: 'kg',
      defaultWeightUnit: WeightUnit.kilograms,
    ),
    description: 'High tensile carbon steel plate for base plates, column supports and brackets.',
    imageUrl: 'https://images.unsplash.com/photo-1535813547-99c456a41d4a?auto=format&fit=crop&w=600&q=80',
    icon: Icons.crop_portrait_rounded,
    variantConfig: ProductVariantConfig(
      gstPercent: 18.0,
      pricingUnitLabel: 'kg',
      orderUnitLabels: ['Nos', 'Sq Ft', 'Kg', 'Tonnes'],
      howCalculatedText:
          'Weight = thickness (mm) × 7.85 kg/m². Standard plate density 7.85 g/cm³.\n\n'
          'GST 18% on hot-rolled plates (HSN 7208).',
      disclaimer: 'Estimate only. Rates change daily. Confirm with store before purchase. Rate sheet dated 2026-11-20.',
      variantGroups: [
        ProductVariantGroup(
          title: 'Brand',
          options: [
            ProductVariantOption(label: 'SAIL', rate: 75.0, rateUnit: 'kg'),
            ProductVariantOption(label: 'Jindal Steel', rate: 76.0, rateUnit: 'kg'),
            ProductVariantOption(label: 'Tata Steel', rate: 78.0, rateUnit: 'kg'),
          ],
        ),
        ProductVariantGroup(
          title: 'Thickness',
          options: [
            ProductVariantOption(label: '6 mm', rate: 75.0, detail: '6', rateUnit: 'kg'),
            ProductVariantOption(label: '8 mm', rate: 75.0, detail: '8', rateUnit: 'kg'),
            ProductVariantOption(label: '10 mm', rate: 74.0, detail: '10', rateUnit: 'kg'),
            ProductVariantOption(label: '12 mm', rate: 74.0, detail: '12', rateUnit: 'kg'),
            ProductVariantOption(label: '16 mm', rate: 76.0, detail: '16', rateUnit: 'kg'),
            ProductVariantOption(label: '20 mm', rate: 78.0, detail: '20', rateUnit: 'kg'),
          ],
        ),
        ProductVariantGroup(
          title: 'Size',
          options: [
            ProductVariantOption(label: '4 × 8 ft (1.22 × 2.44 m)', rate: 0.0, detail: '32'),
            ProductVariantOption(label: '5 × 10 ft (1.52 × 3.05 m)', rate: 0.0, detail: '50'),
            ProductVariantOption(label: '5 × 20 ft (1.52 × 6.10 m)', rate: 0.0, detail: '100'),
          ],
        ),
      ],
    ),
  ),
  Product(
    id: 'prod_wire_mesh',
    categoryId: 'cat_steel',
    subCategory: 'TMT Bars',
    name: 'GI Wire Mesh (Roll)',
    brand: 'Tata Wiron',
    measurementType: MeasurementType.areaBased,
    pricingUnit: 'sq.ft',
    rate: 35.0,
    measurementConfiguration: MeasurementConfiguration.areaBased(
      quantityLabel: 'Number of Rolls / Cuts',
      standardUnitLabel: 'sq.ft',
      defaultLengthUnit: LengthUnit.feet,
      defaultWidthUnit: LengthUnit.feet,
    ),
    description: 'Galvanized iron welded fencing and foundation reinforcement mesh.',
    imageUrl: 'https://images.unsplash.com/photo-1589939705384-5185137a7f0f?auto=format&fit=crop&w=600&q=80',
    icon: Icons.grid_3x3_rounded,
    variantConfig: ProductVariantConfig(
      gstPercent: 18.0,
      pricingUnitLabel: 'sq ft',
      orderUnitLabels: ['Rolls', 'Sq Ft', 'Metre'],
      howCalculatedText:
          'Rate per square foot based on wire gauge and roll dimensions.\n\n'
          'GST 18% on galvanized wire mesh (HSN 7314).',
      disclaimer: 'Estimate only. Rates change daily. Confirm with store before purchase. Rate sheet dated 2026-11-20.',
      variantGroups: [
        ProductVariantGroup(
          title: 'Brand',
          options: [
            ProductVariantOption(label: 'Tata Wiron', rate: 35.0, rateUnit: 'sq ft'),
            ProductVariantOption(label: 'Jindal', rate: 32.0, rateUnit: 'sq ft'),
            ProductVariantOption(label: 'Kamdhenu', rate: 30.0, rateUnit: 'sq ft'),
          ],
        ),
        ProductVariantGroup(
          title: 'Mesh Size & Gauge',
          options: [
            ProductVariantOption(label: '1" × 1" (16 Gauge)', rate: 35.0, detail: '16G', rateUnit: 'sq ft'),
            ProductVariantOption(label: '2" × 2" (14 Gauge)', rate: 42.0, detail: '14G', rateUnit: 'sq ft'),
            ProductVariantOption(label: '3" × 3" (12 Gauge)', rate: 50.0, detail: '12G', rateUnit: 'sq ft'),
            ProductVariantOption(label: '1/2" × 1/2" (18 Gauge)', rate: 48.0, detail: '18G', rateUnit: 'sq ft'),
          ],
        ),
        ProductVariantGroup(
          title: 'Roll Size',
          options: [
            ProductVariantOption(label: '3 ft × 50 ft (150 sq ft)', rate: 0.0, detail: '150'),
            ProductVariantOption(label: '4 ft × 50 ft (200 sq ft)', rate: 0.0, detail: '200'),
            ProductVariantOption(label: '4 ft × 100 ft (400 sq ft)', rate: 0.0, detail: '400'),
          ],
        ),
      ],
    ),
  ),

  // ================= 4. PIPES & PLUMBING =================
  Product(
    id: 'prod_ss_pipe',
    categoryId: 'cat_pipes',
    subCategory: 'Round Pipes',
    name: 'SS Pipe (202 / 304 / 316)',
    brand: 'Saudi Steels',
    measurementType: MeasurementType.lengthBased,
    pricingUnit: 'metre',
    rate: 173.16,
    measurementConfiguration: MeasurementConfiguration.lengthBased(
      quantityLabel: 'Quantity',
      standardUnitLabel: 'm',
      defaultUnit: LengthUnit.metres,
    ),
    description: 'Stainless steel seamless and welded pipe for fittings and water lines.',
    imageUrl: 'https://images.unsplash.com/photo-1541888946425-d0fbb18f15f7?auto=format&fit=crop&w=600&q=80',
    icon: Icons.water_drop_outlined,
    variantConfig: const ProductVariantConfig(
      pricingUnitLabel: 'metre',
      orderUnitLabels: ['Metre', 'Nos'],
      howCalculatedText:
          'Rate is per running metre. Grade 316 carries a premium over 304.\n\nGST 18%.',
      gstPercent: 18.0,
      disclaimer:
          'Estimate only. Not a confirmed order — rates move daily, stock is subject to availability and final weight is settled on the weighbridge. Rate sheet dated 2026-11-20.',
      variantGroups: [
        ProductVariantGroup(
          title: 'Grade',
          options: [
            ProductVariantOption(label: 'SS 202', rate: 173.16, rateUnit: 'metre'),
            ProductVariantOption(label: 'SS 304', rate: 285.0, rateUnit: 'metre'),
            ProductVariantOption(label: 'SS 316', rate: 519.75, rateUnit: 'metre'),
          ],
        ),
        ProductVariantGroup(
          title: 'Size',
          options: [
            ProductVariantOption(label: '1/2" (15 mm)', rate: 173.16, rateUnit: 'metre', detail: '0.5'),
            ProductVariantOption(label: '3/4" (20 mm)', rate: 240.24, rateUnit: 'metre', detail: '0.75'),
            ProductVariantOption(label: '1" (25 mm)', rate: 340.86, rateUnit: 'metre', detail: '1.0'),
            ProductVariantOption(label: '1½" (32 mm)', rate: 474.24, rateUnit: 'metre', detail: '1.5'),
            ProductVariantOption(label: '2" (40 mm)', rate: 638.82, rateUnit: 'metre', detail: '2.0'),
          ],
        ),
        ProductVariantGroup(
          title: 'Length',
          options: [
            ProductVariantOption(label: '6 m', rate: 0.0, detail: '6'),
            ProductVariantOption(label: '12 m', rate: 0.0, detail: '12'),
          ],
        ),
      ],
    ),
  ),
  Product(
    id: 'prod_pvc_pipe',
    categoryId: 'cat_pipes',
    subCategory: 'PVC & CPVC',
    name: 'PVC Pipe (4 Inch)',
    brand: 'Supreme Pipes',
    measurementType: MeasurementType.lengthBased,
    pricingUnit: 'foot',
    rate: 25.0,
    measurementConfiguration: MeasurementConfiguration.lengthBased(
      quantityLabel: 'Number of Pipes',
      standardUnitLabel: 'ft',
      defaultUnit: LengthUnit.feet,
    ),
    description: 'Heavy gauge Schedule 40 pressure pipe for water drainage and sewage lines.',
    imageUrl: 'https://images.unsplash.com/photo-1541888946425-d0fbb18f15f7?auto=format&fit=crop&w=600&q=80',
    icon: Icons.shower_outlined,
    variantConfig: const ProductVariantConfig(
      pricingUnitLabel: 'foot',
      orderUnitLabels: ['Metre', 'Nos', 'Feet'],
      howCalculatedText:
          'Price per running foot/metre based on Schedule class.\n\n'
          'GST 18% on PVC pipes (HSN 3917).',
      gstPercent: 18.0,
      disclaimer: 'Estimate only. Rates subject to manufacturer revision. Rate sheet dated 2026-11-20.',
      variantGroups: [
        ProductVariantGroup(
          title: 'Brand',
          options: [
            ProductVariantOption(label: 'Supreme Pipes', rate: 25.0, rateUnit: 'ft'),
            ProductVariantOption(label: 'Astral Pipes', rate: 28.0, rateUnit: 'ft'),
            ProductVariantOption(label: 'Finolex', rate: 26.0, rateUnit: 'ft'),
            ProductVariantOption(label: 'Ashirvad', rate: 27.0, rateUnit: 'ft'),
          ],
        ),
        ProductVariantGroup(
          title: 'Class',
          options: [
            ProductVariantOption(label: 'Schedule 40 (4 kg/cm²)', rate: 25.0, rateUnit: 'ft'),
            ProductVariantOption(label: 'Schedule 80 (6 kg/cm²)', rate: 32.0, rateUnit: 'ft'),
            ProductVariantOption(label: 'Drainage (2.5 kg/cm²)', rate: 20.0, rateUnit: 'ft'),
          ],
        ),
        ProductVariantGroup(
          title: 'Size',
          options: [
            ProductVariantOption(label: '2" (63 mm)', rate: 16.0, rateUnit: 'ft', detail: '2'),
            ProductVariantOption(label: '3" (90 mm)', rate: 21.0, rateUnit: 'ft', detail: '3'),
            ProductVariantOption(label: '4" (110 mm)', rate: 25.0, rateUnit: 'ft', detail: '4'),
            ProductVariantOption(label: '6" (160 mm)', rate: 45.0, rateUnit: 'ft', detail: '6'),
          ],
        ),
        ProductVariantGroup(
          title: 'Length',
          options: [
            ProductVariantOption(label: '10 ft (3.05 m)', rate: 0.0, detail: '3.05'),
            ProductVariantOption(label: '20 ft (6.10 m)', rate: 0.0, detail: '6.10'),
          ],
        ),
      ],
    ),
  ),
  Product(
    id: 'prod_cpvc_pipe',
    categoryId: 'cat_pipes',
    subCategory: 'PVC & CPVC',
    name: 'CPVC Pipe (1 Inch)',
    brand: 'Astral Pipes',
    measurementType: MeasurementType.lengthBased,
    pricingUnit: 'foot',
    rate: 48.0,
    measurementConfiguration: MeasurementConfiguration.lengthBased(
      quantityLabel: 'Number of Pipes',
      standardUnitLabel: 'ft',
      defaultUnit: LengthUnit.feet,
    ),
    description: 'High temperature resistant SDR-11 potable water supply pipe for bathrooms & kitchens.',
    imageUrl: 'https://images.unsplash.com/photo-1585704032915-c3400ca199e7?auto=format&fit=crop&w=600&q=80',
    icon: Icons.water_drop_outlined,
    variantConfig: const ProductVariantConfig(
      pricingUnitLabel: 'foot',
      orderUnitLabels: ['Metre', 'Nos', 'Feet'],
      howCalculatedText:
          'SDR-11 pressure pipes rated up to 93°C for hot and cold water plumbing.\n\n'
          'GST 18% on CPVC pipes (HSN 3917).',
      gstPercent: 18.0,
      disclaimer: 'Estimate only. Rates subject to manufacturer revision. Rate sheet dated 2026-11-20.',
      variantGroups: [
        ProductVariantGroup(
          title: 'Brand',
          options: [
            ProductVariantOption(label: 'Astral Pipes', rate: 48.0, rateUnit: 'ft'),
            ProductVariantOption(label: 'Supreme', rate: 45.0, rateUnit: 'ft'),
            ProductVariantOption(label: 'Ashirvad', rate: 47.0, rateUnit: 'ft'),
          ],
        ),
        ProductVariantGroup(
          title: 'Pressure Class',
          options: [
            ProductVariantOption(label: 'SDR 11 (Class 1)', rate: 48.0, rateUnit: 'ft'),
            ProductVariantOption(label: 'SDR 13.5 (Class 2)', rate: 40.0, rateUnit: 'ft'),
          ],
        ),
        ProductVariantGroup(
          title: 'Size',
          options: [
            ProductVariantOption(label: '1/2" (15 mm)', rate: 24.0, rateUnit: 'ft', detail: '0.5'),
            ProductVariantOption(label: '3/4" (20 mm)', rate: 35.0, rateUnit: 'ft', detail: '0.75'),
            ProductVariantOption(label: '1" (25 mm)', rate: 48.0, rateUnit: 'ft', detail: '1.0'),
            ProductVariantOption(label: '1.5" (40 mm)', rate: 85.0, rateUnit: 'ft', detail: '1.5'),
            ProductVariantOption(label: '2" (50 mm)', rate: 130.0, rateUnit: 'ft', detail: '2.0'),
          ],
        ),
        ProductVariantGroup(
          title: 'Length',
          options: [
            ProductVariantOption(label: '10 ft (3.05 m)', rate: 0.0, detail: '3.05'),
            ProductVariantOption(label: '16.4 ft (5.0 m)', rate: 0.0, detail: '5.0'),
          ],
        ),
      ],
    ),
  ),
  Product(
    id: 'prod_ms_square_pipe',
    categoryId: 'cat_pipes',
    subCategory: 'GI Square',
    name: 'MS Square Pipe',
    brand: 'Apollo Pipes',
    measurementType: MeasurementType.lengthBased,
    pricingUnit: 'foot',
    rate: 68.0,
    measurementConfiguration: MeasurementConfiguration.lengthBased(
      quantityLabel: 'Number of Pipes',
      standardUnitLabel: 'ft',
      defaultUnit: LengthUnit.feet,
    ),
    description: 'Structural square box pipe for balcony railings, staircases and roof trusses.',
    imageUrl: 'https://images.unsplash.com/photo-1581092160607-ee22621dd758?auto=format&fit=crop&w=600&q=80',
    icon: Icons.square_outlined,
    variantConfig: const ProductVariantConfig(
      pricingUnitLabel: 'foot',
      orderUnitLabels: ['Metre', 'Nos', 'Feet'],
      howCalculatedText:
          'Structural hollow section rates per running foot/metre based on gauge and dimension.\n\n'
          'GST 18% on hollow pipes (HSN 7306).',
      gstPercent: 18.0,
      disclaimer: 'Estimate only. Rates move daily with steel market. Rate sheet dated 2026-11-20.',
      variantGroups: [
        ProductVariantGroup(
          title: 'Brand',
          options: [
            ProductVariantOption(label: 'Apollo Pipes', rate: 68.0, rateUnit: 'ft'),
            ProductVariantOption(label: 'Tata Structura', rate: 74.0, rateUnit: 'ft'),
            ProductVariantOption(label: 'Saudi Steels', rate: 64.0, rateUnit: 'ft'),
            ProductVariantOption(label: 'Jindal', rate: 66.0, rateUnit: 'ft'),
          ],
        ),
        ProductVariantGroup(
          title: 'Thickness & Gauge',
          options: [
            ProductVariantOption(label: '16 Gauge (1.6 mm)', rate: 68.0, rateUnit: 'ft'),
            ProductVariantOption(label: '14 Gauge (2.0 mm)', rate: 82.0, rateUnit: 'ft'),
            ProductVariantOption(label: '12 Gauge (2.6 mm)', rate: 104.0, rateUnit: 'ft'),
          ],
        ),
        ProductVariantGroup(
          title: 'Size',
          options: [
            ProductVariantOption(label: '1" × 1" (25×25 mm)', rate: 52.0, rateUnit: 'ft', detail: '25'),
            ProductVariantOption(label: '1.5" × 1.5" (38×38 mm)', rate: 68.0, rateUnit: 'ft', detail: '38'),
            ProductVariantOption(label: '2" × 2" (50×50 mm)', rate: 98.0, rateUnit: 'ft', detail: '50'),
          ],
        ),
        ProductVariantGroup(
          title: 'Length',
          options: [
            ProductVariantOption(label: '20 ft (6.10 m)', rate: 0.0, detail: '6.10'),
            ProductVariantOption(label: '10 ft (3.05 m)', rate: 0.0, detail: '3.05'),
          ],
        ),
      ],
    ),
  ),
  // GI Round Pipes (From Technical Specification Chart)
  Product(
    id: 'prod_gi_round_1inch',
    categoryId: 'cat_pipes',
    subCategory: 'GI Round',
    name: 'GI Round Pipe 1"',
    brand: 'Saudi Steels',
    measurementType: MeasurementType.lengthBased,
    pricingUnit: 'foot',
    rate: 65.0,
    measurementConfiguration: MeasurementConfiguration.lengthBased(
      quantityLabel: 'Number of Pipes',
      standardUnitLabel: 'ft',
      defaultUnit: LengthUnit.feet,
    ),
    description: '1 Inch (25 NB) • 14 Gauge (2.0mm). Galvanized rust-resistant round pipe.',
    imageUrl: 'https://s75ml08aciksg.space.mcode.io/assets/img/img-pipes.jpg',
    icon: Icons.album_outlined,
    variantConfig: const ProductVariantConfig(
      pricingUnitLabel: 'foot',
      orderUnitLabels: ['Metre', 'Nos', 'Feet'],
      howCalculatedText:
          'Price per running foot. Standard length 20 ft (6.1 m). Shorter cuts may attract cutting charges.\n\n'
          'GST 18% on galvanized pipes (HSN 7306).',
      gstPercent: 18.0,
      disclaimer: 'Estimate only. Rates move daily. Final settle on weighbridge. Rate sheet dated 2026-11-20.',
      variantGroups: [
        ProductVariantGroup(
          title: 'Brand',
          options: [
            ProductVariantOption(label: 'Saudi Steels', rate: 65.0, rateUnit: 'ft'),
            ProductVariantOption(label: 'Tata Pipes', rate: 72.0, rateUnit: 'ft'),
            ProductVariantOption(label: 'Jindal Star', rate: 68.0, rateUnit: 'ft'),
            ProductVariantOption(label: 'Apollo', rate: 64.0, rateUnit: 'ft'),
          ],
        ),
        ProductVariantGroup(
          title: 'Class',
          options: [
            ProductVariantOption(label: 'Medium (B Class)', rate: 65.0, rateUnit: 'ft'),
            ProductVariantOption(label: 'Light (A Class)', rate: 58.0, rateUnit: 'ft'),
            ProductVariantOption(label: 'Heavy (C Class)', rate: 74.0, rateUnit: 'ft'),
          ],
        ),
        ProductVariantGroup(
          title: 'Size',
          options: [
            ProductVariantOption(label: '1/2" (15 NB)', rate: 42.0, rateUnit: 'ft', detail: '15'),
            ProductVariantOption(label: '3/4" (20 NB)', rate: 52.0, rateUnit: 'ft', detail: '20'),
            ProductVariantOption(label: '1" (25 NB)', rate: 65.0, rateUnit: 'ft', detail: '25'),
            ProductVariantOption(label: '1.5" (40 NB)', rate: 90.0, rateUnit: 'ft', detail: '40'),
            ProductVariantOption(label: '2" (50 NB)', rate: 110.0, rateUnit: 'ft', detail: '50'),
          ],
        ),
        ProductVariantGroup(
          title: 'Length',
          options: [
            ProductVariantOption(label: '20 ft (6.10 m)', rate: 0.0, detail: '6.10'),
            ProductVariantOption(label: '10 ft (3.05 m)', rate: 0.0, detail: '3.05'),
          ],
        ),
      ],
    ),
  ),
  Product(
    id: 'prod_gi_round_2inch',
    categoryId: 'cat_pipes',
    subCategory: 'GI Round',
    name: 'GI Round Pipe 2"',
    brand: 'Saudi Steels',
    measurementType: MeasurementType.lengthBased,
    pricingUnit: 'foot',
    rate: 110.0,
    measurementConfiguration: MeasurementConfiguration.lengthBased(
      quantityLabel: 'Number of Pipes',
      standardUnitLabel: 'ft',
      defaultUnit: LengthUnit.feet,
    ),
    description: '2 Inch (50 NB) • 14 Gauge (2.0mm). Galvanized rust-resistant round pipe.',
    imageUrl: 'https://s75ml08aciksg.space.mcode.io/assets/img/img-pipes.jpg',
    icon: Icons.album_outlined,
    variantConfig: const ProductVariantConfig(
      pricingUnitLabel: 'foot',
      orderUnitLabels: ['Metre', 'Nos', 'Feet'],
      howCalculatedText:
          'Price per running foot. Standard length 20 ft (6.1 m).\n\n'
          'GST 18% on galvanized pipes (HSN 7306).',
      gstPercent: 18.0,
      disclaimer: 'Estimate only. Rates move daily. Final settle on weighbridge. Rate sheet dated 2026-11-20.',
      variantGroups: [
        ProductVariantGroup(
          title: 'Brand',
          options: [
            ProductVariantOption(label: 'Saudi Steels', rate: 110.0, rateUnit: 'ft'),
            ProductVariantOption(label: 'Tata Pipes', rate: 122.0, rateUnit: 'ft'),
            ProductVariantOption(label: 'Jindal Star', rate: 115.0, rateUnit: 'ft'),
            ProductVariantOption(label: 'Apollo', rate: 108.0, rateUnit: 'ft'),
          ],
        ),
        ProductVariantGroup(
          title: 'Class',
          options: [
            ProductVariantOption(label: 'Medium (B Class)', rate: 110.0, rateUnit: 'ft'),
            ProductVariantOption(label: 'Light (A Class)', rate: 98.0, rateUnit: 'ft'),
            ProductVariantOption(label: 'Heavy (C Class)', rate: 125.0, rateUnit: 'ft'),
          ],
        ),
        ProductVariantGroup(
          title: 'Length',
          options: [
            ProductVariantOption(label: '20 ft (6.10 m)', rate: 0.0, detail: '6.10'),
            ProductVariantOption(label: '10 ft (3.05 m)', rate: 0.0, detail: '3.05'),
          ],
        ),
      ],
    ),
  ),
  // GI Square and Rectangle Pipes (From Technical Specification Chart)
  Product(
    id: 'prod_gi_sq_1x1',
    categoryId: 'cat_pipes',
    subCategory: 'GI Square',
    name: 'GI Square Pipe 1"x1"',
    brand: 'Saudi Steels',
    measurementType: MeasurementType.lengthBased,
    pricingUnit: 'foot',
    rate: 58.0,
    measurementConfiguration: MeasurementConfiguration.lengthBased(
      quantityLabel: 'Number of Pipes',
      standardUnitLabel: 'ft',
      defaultUnit: LengthUnit.feet,
    ),
    description: '1" × 1" (25×25mm) • 16 Gauge (1.6mm). Galvanized hollow square pipe.',
    imageUrl: 'https://s75ml08aciksg.space.mcode.io/assets/img/img-steels.jpg',
    icon: Icons.crop_square_rounded,
    variantConfig: const ProductVariantConfig(
      pricingUnitLabel: 'foot',
      orderUnitLabels: ['Metre', 'Nos', 'Feet'],
      howCalculatedText:
          'Galvanized hollow section rates per running foot/metre based on gauge and dimension.\n\n'
          'GST 18% on hollow pipes (HSN 7306).',
      gstPercent: 18.0,
      disclaimer: 'Estimate only. Rates move daily. Final settle on weighbridge. Rate sheet dated 2026-11-20.',
      variantGroups: [
        ProductVariantGroup(
          title: 'Brand',
          options: [
            ProductVariantOption(label: 'Saudi Steels', rate: 58.0, rateUnit: 'ft'),
            ProductVariantOption(label: 'Apollo Pipes', rate: 62.0, rateUnit: 'ft'),
            ProductVariantOption(label: 'Tata Structura', rate: 66.0, rateUnit: 'ft'),
          ],
        ),
        ProductVariantGroup(
          title: 'Gauge',
          options: [
            ProductVariantOption(label: '16 Gauge (1.6 mm)', rate: 58.0, rateUnit: 'ft'),
            ProductVariantOption(label: '14 Gauge (2.0 mm)', rate: 70.0, rateUnit: 'ft'),
          ],
        ),
        ProductVariantGroup(
          title: 'Length',
          options: [
            ProductVariantOption(label: '20 ft (6.10 m)', rate: 0.0, detail: '6.10'),
            ProductVariantOption(label: '10 ft (3.05 m)', rate: 0.0, detail: '3.05'),
          ],
        ),
      ],
    ),
  ),
  Product(
    id: 'prod_gi_rect_2x1',
    categoryId: 'cat_pipes',
    subCategory: 'GI Square',
    name: 'GI Rect Pipe 2"x1"',
    brand: 'Saudi Steels',
    measurementType: MeasurementType.lengthBased,
    pricingUnit: 'foot',
    rate: 78.0,
    measurementConfiguration: MeasurementConfiguration.lengthBased(
      quantityLabel: 'Number of Pipes',
      standardUnitLabel: 'ft',
      defaultUnit: LengthUnit.feet,
    ),
    description: '2" × 1" (50×25mm) • 16 Gauge (1.6mm). Galvanized hollow rectangular pipe.',
    imageUrl: 'https://s75ml08aciksg.space.mcode.io/assets/img/img-steels.jpg',
    icon: Icons.crop_landscape_rounded,
    variantConfig: const ProductVariantConfig(
      pricingUnitLabel: 'foot',
      orderUnitLabels: ['Metre', 'Nos', 'Feet'],
      howCalculatedText:
          'Galvanized hollow section rates per running foot/metre based on gauge and dimension.\n\n'
          'GST 18% on hollow pipes (HSN 7306).',
      gstPercent: 18.0,
      disclaimer: 'Estimate only. Rates move daily. Final settle on weighbridge. Rate sheet dated 2026-11-20.',
      variantGroups: [
        ProductVariantGroup(
          title: 'Brand',
          options: [
            ProductVariantOption(label: 'Saudi Steels', rate: 78.0, rateUnit: 'ft'),
            ProductVariantOption(label: 'Apollo Pipes', rate: 82.0, rateUnit: 'ft'),
            ProductVariantOption(label: 'Tata Structura', rate: 88.0, rateUnit: 'ft'),
          ],
        ),
        ProductVariantGroup(
          title: 'Gauge',
          options: [
            ProductVariantOption(label: '16 Gauge (1.6 mm)', rate: 78.0, rateUnit: 'ft'),
            ProductVariantOption(label: '14 Gauge (2.0 mm)', rate: 94.0, rateUnit: 'ft'),
          ],
        ),
        ProductVariantGroup(
          title: 'Length',
          options: [
            ProductVariantOption(label: '20 ft (6.10 m)', rate: 0.0, detail: '6.10'),
            ProductVariantOption(label: '10 ft (3.05 m)', rate: 0.0, detail: '3.05'),
          ],
        ),
      ],
    ),
  ),
  Product(
    id: 'prod_gi_sq_2x2',
    categoryId: 'cat_pipes',
    subCategory: 'GI Square',
    name: 'GI Square Pipe 2"x2"',
    brand: 'Saudi Steels',
    measurementType: MeasurementType.lengthBased,
    pricingUnit: 'foot',
    rate: 115.0,
    measurementConfiguration: MeasurementConfiguration.lengthBased(
      quantityLabel: 'Number of Pipes',
      standardUnitLabel: 'ft',
      defaultUnit: LengthUnit.feet,
    ),
    description: '2" × 2" (50×50mm) • 16 Gauge (1.6mm). Galvanized hollow square pipe.',
    imageUrl: 'https://s75ml08aciksg.space.mcode.io/assets/img/img-steels.jpg',
    icon: Icons.crop_square_rounded,
    variantConfig: const ProductVariantConfig(
      pricingUnitLabel: 'foot',
      orderUnitLabels: ['Metre', 'Nos', 'Feet'],
      howCalculatedText:
          'Galvanized hollow section rates per running foot/metre based on gauge and dimension.\n\n'
          'GST 18% on hollow pipes (HSN 7306).',
      gstPercent: 18.0,
      disclaimer: 'Estimate only. Rates move daily. Final settle on weighbridge. Rate sheet dated 2026-11-20.',
      variantGroups: [
        ProductVariantGroup(
          title: 'Brand',
          options: [
            ProductVariantOption(label: 'Saudi Steels', rate: 115.0, rateUnit: 'ft'),
            ProductVariantOption(label: 'Apollo Pipes', rate: 122.0, rateUnit: 'ft'),
            ProductVariantOption(label: 'Tata Structura', rate: 130.0, rateUnit: 'ft'),
          ],
        ),
        ProductVariantGroup(
          title: 'Gauge',
          options: [
            ProductVariantOption(label: '16 Gauge (1.6 mm)', rate: 115.0, rateUnit: 'ft'),
            ProductVariantOption(label: '14 Gauge (2.0 mm)', rate: 138.0, rateUnit: 'ft'),
          ],
        ),
        ProductVariantGroup(
          title: 'Length',
          options: [
            ProductVariantOption(label: '20 ft (6.10 m)', rate: 0.0, detail: '6.10'),
            ProductVariantOption(label: '10 ft (3.05 m)', rate: 0.0, detail: '3.05'),
          ],
        ),
      ],
    ),
  ),

  // ================= 5. TILES & CERAMICS =================
  Product(
    id: 'prod_floor_tiles',
    categoryId: 'cat_tiles',
    name: 'Floor Tiles (2x2 ft)',
    brand: 'Kajaria',
    measurementType: MeasurementType.areaBased,
    pricingUnit: 'sq.ft',
    rate: 50.0,
    measurementConfiguration: MeasurementConfiguration.areaBased(
      quantityLabel: 'Number of Boxes / Rooms',
      standardUnitLabel: 'sq.ft',
      defaultLengthUnit: LengthUnit.feet,
      defaultWidthUnit: LengthUnit.feet,
    ),
    description: 'Stain-resistant double charge polished vitrified tiles for halls and bedrooms.',
    imageUrl: 'https://images.unsplash.com/photo-1581858726788-75bc0f6a952d?auto=format&fit=crop&w=600&q=80',
    icon: Icons.grid_view_rounded,
  ),
  Product(
    id: 'prod_wall_tiles',
    categoryId: 'cat_tiles',
    name: 'Wall Tiles (1x1.5 ft)',
    brand: 'Somany',
    measurementType: MeasurementType.areaBased,
    pricingUnit: 'sq.ft',
    rate: 65.0,
    measurementConfiguration: MeasurementConfiguration.areaBased(
      quantityLabel: 'Number of Boxes',
      standardUnitLabel: 'sq.ft',
      defaultLengthUnit: LengthUnit.feet,
      defaultWidthUnit: LengthUnit.feet,
    ),
    description: 'Premium glaze water-resistant decorative kitchen & bathroom wall tiles.',
    imageUrl: 'https://images.unsplash.com/photo-1527515637462-cff94eecc1ac?auto=format&fit=crop&w=600&q=80',
    icon: Icons.dashboard_outlined,
  ),

  // ================= 6. CEMENT & CONSTRUCTION =================
  Product(
    id: 'prod_ppc_cement',
    categoryId: 'cat_cement',
    subCategory: 'PPC Cement',
    name: 'PPC Grade Cement',
    brand: 'UltraTech',
    measurementType: MeasurementType.quantityOnly,
    pricingUnit: 'bag',
    rate: 380.0,
    measurementConfiguration: MeasurementConfiguration.quantityOnly(
      quantityLabel: 'Number of Bags (50 kg each)',
      standardUnitLabel: 'bags',
    ),
    description: 'Portland Pozzolana Cement, 50 kg bag. Also billed per tonne (20 bags).',
    imageUrl: 'https://images.unsplash.com/photo-1590069261209-f8e9b8642343?auto=format&fit=crop&w=600&q=80',
    icon: Icons.domain_outlined,
    variantConfig: ProductVariantConfig(
      gstPercent: 18.0,
      pricingUnitLabel: 'bags',
      orderUnitLabels: ['Bags', 'Tonnes'],
      unitsPerTonne: 20.0,
      howCalculatedText: '1 tonne = 20 bags of 50 kg.',
      cuttingChargeNote: 'GST 18% on cement (HSN 2523).',
      disclaimer: 'Estimate only. Rates change daily based on plant dispatch. '
          'Confirm with store before purchase. Rate sheet dated 2026-11-23.',
      variantGroups: [
        ProductVariantGroup(
          title: 'Brand',
          options: [
            ProductVariantOption(label: 'UltraTech', rate: 380.0, rateUnit: '/bags'),
            ProductVariantOption(label: 'JSW Cement', rate: 368.0, rateUnit: '/bags'),
            ProductVariantOption(label: 'ACC', rate: 358.0, rateUnit: '/bags'),
            ProductVariantOption(label: 'Ambuja', rate: 372.0, rateUnit: '/bags'),
            ProductVariantOption(label: 'Dalmia', rate: 362.0, rateUnit: '/bags'),
            ProductVariantOption(label: 'Shree', rate: 352.0, rateUnit: '/bags'),
            ProductVariantOption(label: 'Ramco', rate: 348.0, rateUnit: '/bags'),
          ],
        ),
      ],
    ),
  ),
  Product(
    id: 'prod_readymix_plaster',
    categoryId: 'cat_cement',
    subCategory: 'PPC Cement',
    name: 'Polymer Wall Plaster',
    brand: 'Birla White',
    measurementType: MeasurementType.quantityOnly,
    pricingUnit: 'bag',
    rate: 290.0,
    measurementConfiguration: MeasurementConfiguration.quantityOnly(
      quantityLabel: 'Number of Bags (40 kg each)',
      standardUnitLabel: 'bags',
    ),
    description: 'Polymer cement plaster, 40 kg bag. Ready to apply, water resistant.',
    imageUrl: 'https://images.unsplash.com/photo-1581094288338-2314dddb7ece?auto=format&fit=crop&w=600&q=80',
    icon: Icons.format_paint_outlined,
    variantConfig: ProductVariantConfig(
      gstPercent: 18.0,
      pricingUnitLabel: 'bags',
      orderUnitLabels: ['Bags', 'Tonnes'],
      unitsPerTonne: 25.0, // 40 kg bags → 25 bags/tonne
      howCalculatedText: '1 tonne = 25 bags of 40 kg.',
      cuttingChargeNote: 'GST 18% on cement products (HSN 2523).',
      disclaimer: 'Estimate only. Rates change daily. Confirm with store before purchase.',
      variantGroups: [
        ProductVariantGroup(
          title: 'Brand',
          options: [
            ProductVariantOption(label: 'Birla White', rate: 290.0, rateUnit: '/bags'),
            ProductVariantOption(label: 'Dr Fixit', rate: 310.0, rateUnit: '/bags'),
            ProductVariantOption(label: 'Walplast', rate: 275.0, rateUnit: '/bags'),
            ProductVariantOption(label: 'Ultratech', rate: 295.0, rateUnit: '/bags'),
          ],
        ),
      ],
    ),
  ),
  Product(
    id: 'prod_opc_cement',
    categoryId: 'cat_cement',
    subCategory: 'OPC 53',
    name: 'OPC 53 Grade Cement',
    brand: 'UltraTech',
    measurementType: MeasurementType.quantityOnly,
    pricingUnit: 'bag',
    rate: 385.0,
    measurementConfiguration: MeasurementConfiguration.quantityOnly(
      quantityLabel: 'Number of Bags (50 kg each)',
      standardUnitLabel: 'bags',
    ),
    description: 'Ordinary Portland Cement, 50 kg bag. Also billed per tonne (20 bags).',
    imageUrl: 'https://images.unsplash.com/photo-1504307651254-35680f356dfd?auto=format&fit=crop&w=600&q=80',
    icon: Icons.domain_add_outlined,
    variantConfig: ProductVariantConfig(
      gstPercent: 18.0,
      pricingUnitLabel: 'bags',
      orderUnitLabels: ['Bags', 'Tonnes'],
      unitsPerTonne: 20.0,
      howCalculatedText: '1 tonne = 20 bags of 50 kg.',
      cuttingChargeNote: 'GST 18% on cement (HSN 2523).',
      disclaimer: 'Estimate only. Rates change daily based on plant dispatch. '
          'Confirm with store before purchase. Rate sheet dated 2026-11-23.',
      variantGroups: [
        ProductVariantGroup(
          title: 'Brand',
          options: [
            ProductVariantOption(label: 'UltraTech', rate: 385.0, rateUnit: '/bags'),
            ProductVariantOption(label: 'JSW Cement', rate: 372.0, rateUnit: '/bags'),
            ProductVariantOption(label: 'ACC', rate: 360.0, rateUnit: '/bags'),
            ProductVariantOption(label: 'Ambuja', rate: 374.0, rateUnit: '/bags'),
            ProductVariantOption(label: 'Dalmia', rate: 368.0, rateUnit: '/bags'),
            ProductVariantOption(label: 'Shree', rate: 356.0, rateUnit: '/bags'),
            ProductVariantOption(label: 'Ramco', rate: 352.0, rateUnit: '/bags'),
          ],
        ),
      ],
    ),
  ),
  Product(
    id: 'prod_white_cement',
    categoryId: 'cat_cement',
    subCategory: 'White Cement',
    name: 'White Cement Wall Putty',
    brand: 'Birla White',
    measurementType: MeasurementType.quantityOnly,
    pricingUnit: 'bag',
    rate: 560.0,
    measurementConfiguration: MeasurementConfiguration.quantityOnly(
      quantityLabel: 'Number of Bags (25 kg each)',
      standardUnitLabel: 'bags',
    ),
    description: 'White portland cement wall putty, 25 kg bag. For smooth interior finish.',
    imageUrl: 'https://images.unsplash.com/photo-1589939705384-5185137a7f0f?auto=format&fit=crop&w=600&q=80',
    icon: Icons.format_paint_outlined,
    variantConfig: ProductVariantConfig(
      gstPercent: 18.0,
      pricingUnitLabel: 'bags',
      orderUnitLabels: ['Bags', 'Tonnes'],
      unitsPerTonne: 40.0, // 25 kg bags → 40 bags/tonne
      howCalculatedText: '1 tonne = 40 bags of 25 kg.',
      cuttingChargeNote: 'GST 18% on white cement products (HSN 2523).',
      disclaimer: 'Estimate only. Rates change daily. Confirm with store before purchase.',
      variantGroups: [
        ProductVariantGroup(
          title: 'Brand',
          options: [
            ProductVariantOption(label: 'Birla White', rate: 560.0, rateUnit: '/bags'),
            ProductVariantOption(label: 'JK White', rate: 540.0, rateUnit: '/bags'),
            ProductVariantOption(label: 'Berger Putty', rate: 520.0, rateUnit: '/bags'),
            ProductVariantOption(label: 'Asian Paints', rate: 530.0, rateUnit: '/bags'),
          ],
        ),
      ],
    ),
  ),

  // ================= 7. ROOFING MATERIALS =================
  Product(
    id: 'prod_gi_plain_roofing_sheet',
    categoryId: 'cat_roofing',
    subCategory: 'GI Plain',
    name: 'GI Plain Roofing Sheet',
    brand: 'JSW GI',
    measurementType: MeasurementType.areaBased,
    pricingUnit: 'sq.ft',
    rate: 62.0,
    measurementConfiguration: MeasurementConfiguration.areaBased(
      quantityLabel: 'Quantity',
      standardUnitLabel: 'sq.ft',
      defaultLengthUnit: LengthUnit.feet,
      defaultWidthUnit: LengthUnit.feet,
    ),
    description: 'Galvanised plain sheet for roofing and cladding.',
    imageUrl: 'https://images.unsplash.com/photo-1632759145351-1d592919f522?auto=format&fit=crop&w=600&q=80',
    icon: Icons.roofing_outlined,
    variantConfig: const ProductVariantConfig(
      pricingUnitLabel: 'sq ft',
      orderUnitLabels: ['Sq Ft', 'Nos', 'Kg', 'Metre'],
      howCalculatedText:
          'Coating grade changes the rate per kg — a heavier zinc coat costs more.\n\n'
          'Weight = thickness × 7.85 kg/m². One ₹/kg rate therefore serves kg, sq ft and piece billing.\n\n'
          '6% wastage allowance included in piece and metre calculations.\n\n'
          'GST 18%.',
      gstPercent: 18.0,
      disclaimer: 'Estimate only. Not a confirmed order — rates move daily, stock is subject to availability and final weight is settled on the weighbridge. Rate sheet dated 2026-11-20.',
      variantGroups: [
        ProductVariantGroup(
          title: 'Brand',
          options: [
            ProductVariantOption(label: 'JSW GI', rate: 62.0, rateUnit: 'kg'),
            ProductVariantOption(label: 'Tata GI', rate: 66.0, rateUnit: 'kg'),
            ProductVariantOption(label: 'AMNS', rate: 60.0, rateUnit: 'kg'),
            ProductVariantOption(label: 'Jindal', rate: 63.0, rateUnit: 'kg'),
          ],
        ),
        ProductVariantGroup(
          title: 'Zinc coating',
          options: [
            ProductVariantOption(label: 'Z80 (80 g/m²)', rate: 62.0, rateUnit: 'kg'),
            ProductVariantOption(label: 'Z100 (100 g/m²)', rate: 64.0, rateUnit: 'kg'),
            ProductVariantOption(label: 'Z120 (120 g/m²)', rate: 67.0, rateUnit: 'kg'),
          ],
        ),
        ProductVariantGroup(
          title: 'Thickness (BMT)',
          options: [
            ProductVariantOption(label: '0.47 mm', rate: 0.0),
            ProductVariantOption(label: '0.50 mm', rate: 0.0),
            ProductVariantOption(label: '0.40 mm', rate: 0.0),
            ProductVariantOption(label: '0.60 mm', rate: 0.0),
          ],
        ),
        ProductVariantGroup(
          title: 'Width',
          options: [
            ProductVariantOption(label: '3 ft (0.91 m)', rate: 0.0, detail: '3'),
            ProductVariantOption(label: '3.5 ft (1.06 m)', rate: 0.0, detail: '3.5'),
            ProductVariantOption(label: '4 ft (1.22 m)', rate: 0.0, detail: '4'),
          ],
        ),
        ProductVariantGroup(
          title: 'Length',
          options: [
            ProductVariantOption(label: '10 ft', rate: 0.0, detail: '10'),
            ProductVariantOption(label: '12 ft', rate: 0.0, detail: '12'),
            ProductVariantOption(label: '8 ft', rate: 0.0, detail: '8'),
            ProductVariantOption(label: '6 ft', rate: 0.0, detail: '6'),
          ],
        ),
      ],
    ),
  ),
  Product(
    id: 'prod_color_coated_sheet',
    categoryId: 'cat_roofing',
    subCategory: 'Colour Coated',
    name: 'Tata Durashine Roofing Sheet',
    brand: 'Tata Bluescope',
    measurementType: MeasurementType.areaBased,
    pricingUnit: 'sq.ft',
    rate: 78.0,
    measurementConfiguration: MeasurementConfiguration.areaBased(
      quantityLabel: 'Quantity',
      standardUnitLabel: 'sq.ft',
      defaultLengthUnit: LengthUnit.feet,
      defaultWidthUnit: LengthUnit.feet,
    ),
    description: 'High tensile aesthetic colour coated trapezoidal profile roofing sheet.',
    imageUrl: 'https://s75ml08aciksg.space.mcode.io/assets/img/img-roofing.jpg',
    icon: Icons.roofing_outlined,
    variantConfig: const ProductVariantConfig(
      pricingUnitLabel: 'sq ft',
      orderUnitLabels: ['Sq Ft', 'Nos', 'Kg', 'Metre'],
      howCalculatedText:
          'Coating grade changes the rate per kg — a heavier zinc coat costs more.\n\n'
          'Weight = thickness × 7.85 kg/m². One ₹/kg rate therefore serves kg, sq ft and piece billing.\n\n'
          '6% wastage allowance included in piece and metre calculations.\n\n'
          'GST 18%.',
      gstPercent: 18.0,
      disclaimer: 'Estimate only. Not a confirmed order — rates move daily, stock is subject to availability and final weight is settled on the weighbridge. Rate sheet dated 2026-11-20.',
      variantGroups: [
        ProductVariantGroup(
          title: 'Brand',
          options: [
            ProductVariantOption(label: 'Tata Bluescope', rate: 78.0, rateUnit: 'kg'),
            ProductVariantOption(label: 'JSW Colour', rate: 75.0, rateUnit: 'kg'),
            ProductVariantOption(label: 'Essar Steels', rate: 73.0, rateUnit: 'kg'),
          ],
        ),
        ProductVariantGroup(
          title: 'Zinc coating',
          options: [
            ProductVariantOption(label: 'AZ150 (150 g/m²)', rate: 78.0, rateUnit: 'kg'),
            ProductVariantOption(label: 'AZ100 (100 g/m²)', rate: 74.0, rateUnit: 'kg'),
          ],
        ),
        ProductVariantGroup(
          title: 'Thickness (BMT)',
          options: [
            ProductVariantOption(label: '0.47 mm', rate: 0.0),
            ProductVariantOption(label: '0.50 mm', rate: 0.0),
            ProductVariantOption(label: '0.60 mm', rate: 0.0),
          ],
        ),
        ProductVariantGroup(
          title: 'Width',
          options: [
            ProductVariantOption(label: '3.5 ft (1.06 m)', rate: 0.0, detail: '3.5'),
            ProductVariantOption(label: '4 ft (1.22 m)', rate: 0.0, detail: '4'),
          ],
        ),
        ProductVariantGroup(
          title: 'Length',
          options: [
            ProductVariantOption(label: '10 ft', rate: 0.0, detail: '10'),
            ProductVariantOption(label: '12 ft', rate: 0.0, detail: '12'),
            ProductVariantOption(label: '14 ft', rate: 0.0, detail: '14'),
            ProductVariantOption(label: '8 ft', rate: 0.0, detail: '8'),
          ],
        ),
      ],
    ),
  ),
  Product(
    id: 'prod_color_tile_sheet',
    categoryId: 'cat_roofing',
    subCategory: 'Colour Coated',
    name: 'Mangalore Tile Profile Sheet',
    brand: 'Jindal Steel',
    measurementType: MeasurementType.areaBased,
    pricingUnit: 'sq.ft',
    rate: 85.0,
    measurementConfiguration: MeasurementConfiguration.areaBased(
      quantityLabel: 'Quantity',
      standardUnitLabel: 'sq.ft',
      defaultLengthUnit: LengthUnit.feet,
      defaultWidthUnit: LengthUnit.feet,
    ),
    description: 'Terracotta red step-tile profile sheet for residential roofs and verandas.',
    imageUrl: 'https://images.unsplash.com/photo-1632759145351-1d592919f522?auto=format&fit=crop&w=600&q=80',
    icon: Icons.roofing_outlined,
    variantConfig: const ProductVariantConfig(
      pricingUnitLabel: 'sq ft',
      orderUnitLabels: ['Sq Ft', 'Nos', 'Kg', 'Metre'],
      howCalculatedText:
          'Coating grade changes the rate per kg — a heavier zinc coat costs more.\n\n'
          'Weight = thickness × 7.85 kg/m². One ₹/kg rate therefore serves kg, sq ft and piece billing.\n\n'
          '6% wastage allowance included in piece and metre calculations.\n\n'
          'GST 18%.',
      gstPercent: 18.0,
      disclaimer: 'Estimate only. Not a confirmed order — rates move daily, stock is subject to availability and final weight is settled on the weighbridge. Rate sheet dated 2026-11-20.',
      variantGroups: [
        ProductVariantGroup(
          title: 'Brand',
          options: [
            ProductVariantOption(label: 'Jindal Steel', rate: 85.0, rateUnit: 'kg'),
            ProductVariantOption(label: 'Tata Bluescope', rate: 88.0, rateUnit: 'kg'),
            ProductVariantOption(label: 'JSW Colouron', rate: 86.0, rateUnit: 'kg'),
          ],
        ),
        ProductVariantGroup(
          title: 'Zinc coating',
          options: [
            ProductVariantOption(label: 'AZ150 (150 g/m²)', rate: 85.0, rateUnit: 'kg'),
            ProductVariantOption(label: 'AZ100 (100 g/m²)', rate: 82.0, rateUnit: 'kg'),
          ],
        ),
        ProductVariantGroup(
          title: 'Thickness (BMT)',
          options: [
            ProductVariantOption(label: '0.45 mm', rate: 0.0),
            ProductVariantOption(label: '0.50 mm', rate: 0.0),
            ProductVariantOption(label: '0.60 mm', rate: 0.0),
          ],
        ),
        ProductVariantGroup(
          title: 'Width',
          options: [
            ProductVariantOption(label: '3.5 ft (1.06 m)', rate: 0.0, detail: '3.5'),
            ProductVariantOption(label: '4 ft (1.22 m)', rate: 0.0, detail: '4'),
          ],
        ),
        ProductVariantGroup(
          title: 'Length',
          options: [
            ProductVariantOption(label: '8 ft', rate: 0.0, detail: '8'),
            ProductVariantOption(label: '10 ft', rate: 0.0, detail: '10'),
            ProductVariantOption(label: '12 ft', rate: 0.0, detail: '12'),
            ProductVariantOption(label: '16 ft', rate: 0.0, detail: '16'),
          ],
        ),
      ],
    ),
  ),
  Product(
    id: 'prod_color_roof_sheet',
    categoryId: 'cat_roofing',
    subCategory: 'Galvalume',
    name: 'Bare Galvalume Sheet (0.5mm)',
    brand: 'Jindal Steel',
    measurementType: MeasurementType.areaBased,
    pricingUnit: 'sq.ft',
    rate: 72.0,
    measurementConfiguration: MeasurementConfiguration.areaBased(
      quantityLabel: 'Quantity',
      standardUnitLabel: 'sq.ft',
      defaultLengthUnit: LengthUnit.feet,
      defaultWidthUnit: LengthUnit.feet,
    ),
    description: 'Corrugated bare Galvalume alloy coated steel sheet with 4x rust resistance.',
    imageUrl: 'https://images.unsplash.com/photo-1632759145351-1d592919f522?auto=format&fit=crop&w=600&q=80',
    icon: Icons.roofing_outlined,
    variantConfig: const ProductVariantConfig(
      pricingUnitLabel: 'sq ft',
      orderUnitLabels: ['Sq Ft', 'Nos', 'Kg', 'Metre'],
      howCalculatedText:
          'Coating grade changes the rate per kg.\n\n'
          'Weight = thickness × 7.85 kg/m². One ₹/kg rate serves kg, sq ft and piece billing.\n\n'
          '6% wastage allowance included in piece and metre calculations.\n\n'
          'GST 18%.',
      gstPercent: 18.0,
      disclaimer: 'Estimate only. Not a confirmed order — rates move daily, stock is subject to availability and final weight is settled on the weighbridge. Rate sheet dated 2026-11-20.',
      variantGroups: [
        ProductVariantGroup(
          title: 'Brand',
          options: [
            ProductVariantOption(label: 'Jindal Steel', rate: 72.0, rateUnit: 'kg'),
            ProductVariantOption(label: 'Tata Shaktee', rate: 75.0, rateUnit: 'kg'),
            ProductVariantOption(label: 'JSW Vishwas', rate: 70.0, rateUnit: 'kg'),
          ],
        ),
        ProductVariantGroup(
          title: 'Zinc coating',
          options: [
            ProductVariantOption(label: 'AZ150 (150 g/m²)', rate: 72.0, rateUnit: 'kg'),
            ProductVariantOption(label: 'AZ70 (70 g/m²)', rate: 68.0, rateUnit: 'kg'),
          ],
        ),
        ProductVariantGroup(
          title: 'Thickness (BMT)',
          options: [
            ProductVariantOption(label: '0.40 mm', rate: 0.0),
            ProductVariantOption(label: '0.47 mm', rate: 0.0),
            ProductVariantOption(label: '0.50 mm', rate: 0.0),
            ProductVariantOption(label: '0.60 mm', rate: 0.0),
          ],
        ),
        ProductVariantGroup(
          title: 'Width',
          options: [
            ProductVariantOption(label: '3 ft (0.91 m)', rate: 0.0, detail: '3'),
            ProductVariantOption(label: '3.5 ft (1.06 m)', rate: 0.0, detail: '3.5'),
            ProductVariantOption(label: '4 ft (1.22 m)', rate: 0.0, detail: '4'),
          ],
        ),
        ProductVariantGroup(
          title: 'Length',
          options: [
            ProductVariantOption(label: '8 ft', rate: 0.0, detail: '8'),
            ProductVariantOption(label: '10 ft', rate: 0.0, detail: '10'),
            ProductVariantOption(label: '12 ft', rate: 0.0, detail: '12'),
            ProductVariantOption(label: '14 ft', rate: 0.0, detail: '14'),
          ],
        ),
      ],
    ),
  ),
  Product(
    id: 'prod_polycarb_sheet',
    categoryId: 'cat_roofing',
    subCategory: 'Polycarbonate',
    name: 'Polycarbonate Skylight Sheet',
    brand: 'Tuflite',
    measurementType: MeasurementType.areaBased,
    pricingUnit: 'sq.ft',
    rate: 110.0,
    measurementConfiguration: MeasurementConfiguration.areaBased(
      quantityLabel: 'Quantity',
      standardUnitLabel: 'sq.ft',
      defaultLengthUnit: LengthUnit.feet,
      defaultWidthUnit: LengthUnit.feet,
    ),
    description: 'UV protected lightweight transparent skylight sheet for terraces & daylighting.',
    imageUrl: 'https://images.unsplash.com/photo-1513694203232-719a280e022f?auto=format&fit=crop&w=600&q=80',
    icon: Icons.wb_sunny_outlined,
    variantConfig: const ProductVariantConfig(
      pricingUnitLabel: 'sq ft',
      orderUnitLabels: ['Sq Ft', 'Nos', 'Metre'],
      howCalculatedText:
          'Architectural polycarbonate sheets billed per sq.ft.\n\n'
          '5% cutting allowance included for full sheets.\n\n'
          'GST 18% (HSN 3920).',
      gstPercent: 18.0,
      disclaimer: 'Estimate only. Rates subject to manufacturer revision. Rate sheet dated 2026-11-20.',
      variantGroups: [
        ProductVariantGroup(
          title: 'Brand',
          options: [
            ProductVariantOption(label: 'Tuflite', rate: 110.0, rateUnit: 'sq ft'),
            ProductVariantOption(label: 'Lexan', rate: 125.0, rateUnit: 'sq ft'),
            ProductVariantOption(label: 'Gallina', rate: 105.0, rateUnit: 'sq ft'),
          ],
        ),
        ProductVariantGroup(
          title: 'Profile',
          options: [
            ProductVariantOption(label: 'Profiled Corrugated', rate: 110.0, rateUnit: 'sq ft'),
            ProductVariantOption(label: 'Multiwall 6mm', rate: 145.0, rateUnit: 'sq ft'),
            ProductVariantOption(label: 'Solid 2mm', rate: 160.0, rateUnit: 'sq ft'),
          ],
        ),
        ProductVariantGroup(
          title: 'Thickness',
          options: [
            ProductVariantOption(label: '1.5 mm', rate: 0.0),
            ProductVariantOption(label: '2.0 mm', rate: 0.0),
            ProductVariantOption(label: '3.0 mm', rate: 0.0),
          ],
        ),
        ProductVariantGroup(
          title: 'Width',
          options: [
            ProductVariantOption(label: '3 ft (0.91 m)', rate: 0.0, detail: '3'),
            ProductVariantOption(label: '4 ft (1.22 m)', rate: 0.0, detail: '4'),
          ],
        ),
        ProductVariantGroup(
          title: 'Length',
          options: [
            ProductVariantOption(label: '8 ft', rate: 0.0, detail: '8'),
            ProductVariantOption(label: '10 ft', rate: 0.0, detail: '10'),
            ProductVariantOption(label: '12 ft', rate: 0.0, detail: '12'),
          ],
        ),
      ],
    ),
  ),
];
