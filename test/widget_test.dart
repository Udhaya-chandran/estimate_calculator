import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:estimate_calculator/app/app.dart';
import 'package:estimate_calculator/data/mock/categories.dart';
import 'package:estimate_calculator/data/mock/products.dart';
import 'package:estimate_calculator/features/calculator/presentation/providers/calculator_provider.dart';
import 'package:estimate_calculator/features/calculator/presentation/screens/product_calculator_screen.dart';
import 'package:estimate_calculator/features/categories/presentation/widgets/category_card.dart';
import 'package:estimate_calculator/features/products/presentation/screens/product_selection_screen.dart' as estimate_products;
import 'package:estimate_calculator/features/splash/presentation/screens/splash_screen.dart';
import 'package:estimate_calculator/shared/widgets/bottom_estimate_bar.dart';

void main() {
  testWidgets('App smoke test - loads Dashboard successfully', (WidgetTester tester) async {
    await tester.pumpWidget(
      const ProviderScope(
        child: HardwareEstimationApp(),
      ),
    );

    await tester.pumpAndSettle();

    expect(find.text('25+ YEARS OF EXCELLENCE'), findsOneWidget);
    expect(find.text('Steels'), findsOneWidget);
    expect(find.text('Roofing Sheets'), findsOneWidget);
    expect(find.text('Cements'), findsOneWidget);
    expect(find.text('Pipes & Fittings'), findsOneWidget);
    expect(find.text('TMT Bars'), findsOneWidget);
  });

  testWidgets('Splash screen displays branding and loader', (WidgetTester tester) async {
    await tester.pumpWidget(
      const MaterialApp(
        home: SplashScreen(duration: Duration(seconds: 1)),
      ),
    );

    await tester.pump();

    expect(find.text('25+ YEARS OF TRUST & EXCELLENCE'), findsOneWidget);
    expect(find.text('Loading Building Materials Catalog...'), findsOneWidget);
    expect(find.byType(CircularProgressIndicator), findsOneWidget);

    await tester.pump(const Duration(seconds: 1));
  });

  testWidgets('BottomEstimateBar fits within 320px screen width without overflow', (WidgetTester tester) async {
    tester.view.physicalSize = const Size(320, 640);
    tester.view.devicePixelRatio = 1.0;
    addTearDown(tester.view.resetPhysicalSize);

    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          bottomNavigationBar: BottomEstimateBar(
            itemCount: 4,
            totalAmount: 45750.0,
            actionLabel: 'Estimate Summary',
            secondaryActionLabel: 'Add Products',
            onSecondaryAction: () {},
            onViewEstimate: () {},
          ),
        ),
      ),
    );

    await tester.pumpAndSettle();

    final err = tester.takeException();
    if (err != null) {
      // ignore: avoid_print
      print('ERROR DETAILS: $err');
    }
    expect(err, isNull);
  });

  testWidgets('CategoryCard fits in 156x166 grid cell without overflow', (WidgetTester tester) async {
    tester.view.physicalSize = const Size(320, 640);
    tester.view.devicePixelRatio = 1.0;
    addTearDown(tester.view.resetPhysicalSize);

    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: SizedBox(
            width: 156,
            height: 166,
            child: CategoryCard(
              category: mockCategories.first,
              onTap: () {},
            ),
          ),
        ),
      ),
    );

    await tester.pumpAndSettle();

    final err = tester.takeException();
    expect(err, isNull);
  });

  testWidgets('ProductSelectionScreen displays subcategory filter pills and filters products', (WidgetTester tester) async {
    await tester.pumpWidget(
      const ProviderScope(
        child: MaterialApp(
          home: estimate_products.ProductSelectionScreen(),
        ),
      ),
    );

    await tester.pumpAndSettle();

    expect(find.text('FILTER'), findsOneWidget);
    expect(find.text('All categories'), findsOneWidget);
    expect(find.text('TMT Bars'), findsWidgets);
    expect(find.text('Structural'), findsWidgets);
    expect(find.text('Flat Products'), findsWidgets);

    // Tap on Structural filter pill
    await tester.tap(find.text('Structural').first);
    await tester.pumpAndSettle();

    // Verify MS Angle is displayed
    expect(find.text('MS Angle (40x40mm)'), findsOneWidget);
  });

  testWidgets('ProductCalculatorScreen loads Roofing Sheet calculator correctly', (WidgetTester tester) async {
    final roofingProduct = mockProducts.firstWhere((p) => p.id == 'prod_gi_plain_roofing_sheet');

    final container = ProviderContainer();
    container.read(calculatorProvider.notifier).initForProduct(roofingProduct);

    await tester.pumpWidget(
      UncontrolledProviderScope(
        container: container,
        child: const MaterialApp(
          home: ProductCalculatorScreen(),
        ),
      ),
    );

    await tester.pumpAndSettle();

    // Check header and pill variants
    expect(find.text('GI Plain Roofing Sheet'), findsWidgets);
    expect(find.text('JSW GI'), findsWidgets);
    expect(find.text('Z80 (80 g/m²)'), findsWidgets);
    expect(find.text('0.47 mm'), findsWidgets);
    expect(find.text('3 ft (0.91 m)'), findsWidgets);
    expect(find.text('10 ft'), findsWidgets);

    // Check Live estimate details matching reference screenshot
    expect(find.text('1 sq ft × 0.343 kg/sq ft'), findsOneWidget);
    expect(find.text('₹62 / Kg'), findsOneWidget);
    expect(find.text('₹25.08'), findsOneWidget);
    expect(find.text('₹3.83'), findsOneWidget);

    // Check rate card values
    expect(find.text('per Sq Ft'), findsOneWidget);
    expect(find.text('₹21.25'), findsOneWidget);
    expect(find.text('per Nos'), findsOneWidget);
    expect(find.text('₹675.8'), findsOneWidget);
    expect(find.text('per Kg'), findsOneWidget);
    expect(find.text('₹62'), findsOneWidget);
    expect(find.text('per Metre'), findsOneWidget);
    expect(find.text('₹209.17'), findsOneWidget);
  });

  testWidgets('ProductCalculatorScreen loads SS Pipe calculator correctly', (WidgetTester tester) async {
    final pipeProduct = mockProducts.firstWhere((p) => p.id == 'prod_ss_pipe');

    final container = ProviderContainer();
    container.read(calculatorProvider.notifier).initForProduct(pipeProduct);

    await tester.pumpWidget(
      UncontrolledProviderScope(
        container: container,
        child: const MaterialApp(
          home: ProductCalculatorScreen(),
        ),
      ),
    );

    await tester.pumpAndSettle();

    // Check header and pill variants
    expect(find.text('SS Pipe (202 / 304 / 316)'), findsWidgets);
    expect(find.text('SS 202'), findsWidgets);
    expect(find.text('1/2" (15 mm)'), findsWidgets);
    expect(find.text('6 m'), findsWidgets);

    // Check Live estimate details matching reference screenshot
    expect(find.text('1 m'), findsOneWidget);
    expect(find.text('₹173.16 / Metre'), findsOneWidget);
    expect(find.text('₹204.33'), findsOneWidget);
    expect(find.text('₹31.17'), findsOneWidget);

    // Check rate card values
    expect(find.text('per Metre'), findsOneWidget);
    expect(find.text('₹173.16'), findsOneWidget);
    expect(find.text('per Nos'), findsOneWidget);
    expect(find.text('₹1,038.96'), findsOneWidget);
  });

  testWidgets('ProductCalculatorScreen loads TMT Bar Fe 500D calculator correctly', (WidgetTester tester) async {
    final tmtProduct = mockProducts.firstWhere((p) => p.id == 'prod_tmt_rod');

    final container = ProviderContainer();
    container.read(calculatorProvider.notifier).initForProduct(tmtProduct);

    await tester.pumpWidget(
      UncontrolledProviderScope(
        container: container,
        child: const MaterialApp(
          home: ProductCalculatorScreen(),
        ),
      ),
    );

    await tester.pumpAndSettle();

    expect(find.text('TMT Bar — Fe 500D'), findsWidgets);
    expect(find.text('Tata Tiscon'), findsWidgets);
    expect(find.text('6 mm'), findsWidgets);
    expect(find.text('12 m (standard)'), findsWidgets);

    // Dynamic IS 1786 calculation check (6mm at 12m: 2.667 kg, rate ₹76/kg)
    expect(find.text('1 nos × 2.667 kg (12 m)'), findsOneWidget);
    expect(find.text('₹76 / Kg'), findsOneWidget);
    expect(find.text('₹239.15'), findsOneWidget);
    expect(find.text('₹36.48'), findsOneWidget);

    // Rate card check
    expect(find.text('per Nos'), findsOneWidget);
    expect(find.text('per Metre'), findsOneWidget);
    expect(find.text('per Kg'), findsOneWidget);
    expect(find.text('per Tonnes'), findsOneWidget);
    expect(find.text('₹76,000'), findsOneWidget);
  });

  testWidgets('ProductCalculatorScreen loads OPC 53 Grade Cement calculator correctly', (WidgetTester tester) async {
    final cementProduct = mockProducts.firstWhere((p) => p.id == 'prod_opc_cement');

    final container = ProviderContainer();
    container.read(calculatorProvider.notifier).initForProduct(cementProduct);

    await tester.pumpWidget(
      UncontrolledProviderScope(
        container: container,
        child: const MaterialApp(
          home: ProductCalculatorScreen(),
        ),
      ),
    );

    await tester.pumpAndSettle();

    expect(find.text('OPC 53 Grade Cement'), findsWidgets);
    expect(find.text('UltraTech'), findsWidgets);
    expect(find.text('1 bags'), findsOneWidget);
    expect(find.text('₹385 / Bags'), findsOneWidget);
    expect(find.text('₹454.3'), findsOneWidget);
    expect(find.text('₹69.3'), findsOneWidget);

    // Rate card check
    expect(find.text('per Bags'), findsOneWidget);
    expect(find.text('₹385'), findsOneWidget);
    expect(find.text('per Tonnes'), findsOneWidget);
    expect(find.text('₹7,700'), findsOneWidget);
  });

  testWidgets('ProductCalculatorScreen loads MS Steel Plate calculator correctly', (WidgetTester tester) async {
    final plateProduct = mockProducts.firstWhere((p) => p.id == 'prod_steel_plate');

    final container = ProviderContainer();
    container.read(calculatorProvider.notifier).initForProduct(plateProduct);

    await tester.pumpWidget(
      UncontrolledProviderScope(
        container: container,
        child: const MaterialApp(
          home: ProductCalculatorScreen(),
        ),
      ),
    );

    await tester.pumpAndSettle();

    expect(find.text('MS Steel Plate (6mm)'), findsWidgets);
    expect(find.text('SAIL'), findsWidgets);
    expect(find.text('6 mm'), findsWidgets);
    expect(find.text('4 × 8 ft (1.22 × 2.44 m)'), findsWidgets);

    // Rate card check
    expect(find.text('per Nos'), findsOneWidget);
    expect(find.text('per Sq Ft'), findsOneWidget);
    expect(find.text('per Kg'), findsOneWidget);
    expect(find.text('per Tonnes'), findsOneWidget);
  });
}
