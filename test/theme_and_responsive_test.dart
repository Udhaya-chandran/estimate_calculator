import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:estimate_calculator/app/app.dart';
import 'package:estimate_calculator/app/theme/app_colors.dart';
import 'package:estimate_calculator/app/theme/theme_provider.dart';
import 'package:estimate_calculator/app/theme/theme_toggle_button.dart';
import 'package:estimate_calculator/data/mock/products.dart';
import 'package:estimate_calculator/shared/models/product.dart';
import 'package:estimate_calculator/features/calculator/presentation/providers/calculator_provider.dart';
import 'package:estimate_calculator/features/calculator/presentation/screens/product_calculator_screen.dart';
import 'package:estimate_calculator/features/estimates/domain/entities/estimate_item.dart';
import 'package:estimate_calculator/features/estimates/presentation/providers/estimate_provider.dart';
import 'package:estimate_calculator/features/estimates/presentation/screens/estimate_summary_screen.dart';

class _MockCalculatorNotifier extends CalculatorNotifier {
  final Product initialProduct;
  _MockCalculatorNotifier(this.initialProduct);

  @override
  CalculatorInputState build() {
    return CalculatorInputState(
      product: initialProduct,
      customRate: initialProduct.rate,
    );
  }
}

class _MockEstimateNotifier extends EstimateNotifier {
  final List<EstimateItem> initialItems;
  _MockEstimateNotifier(this.initialItems);

  @override
  EstimateState build() {
    return EstimateState(
      estimateId: 'EST-TEST-001',
      createdAt: DateTime.now(),
      items: initialItems,
    );
  }
}

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  group('ThemeModeNotifier & Persistence Unit Tests', () {
    test('Default mode is light mode when no preference stored', () {
      SharedPreferences.setMockInitialValues({});
      final container = ProviderContainer();
      addTearDown(container.dispose);

      final mode = container.read(themeModeProvider);
      expect(mode, ThemeMode.light);
    });

    test('Initializes with dark mode when preference is dark', () async {
      SharedPreferences.setMockInitialValues({'app_theme_mode': 'dark'});
      final prefs = await SharedPreferences.getInstance();

      final container = ProviderContainer(
        overrides: [
          sharedPreferencesProvider.overrideWithValue(prefs),
        ],
      );
      addTearDown(container.dispose);

      final mode = container.read(themeModeProvider);
      expect(mode, ThemeMode.dark);
    });

    test('Toggling theme switches between light and dark and persists', () async {
      SharedPreferences.setMockInitialValues({});
      final prefs = await SharedPreferences.getInstance();

      final container = ProviderContainer(
        overrides: [
          sharedPreferencesProvider.overrideWithValue(prefs),
        ],
      );
      addTearDown(container.dispose);

      expect(container.read(themeModeProvider), ThemeMode.light);

      await container.read(themeModeProvider.notifier).toggleTheme();
      expect(container.read(themeModeProvider), ThemeMode.dark);
      expect(prefs.getString('app_theme_mode'), 'dark');

      await container.read(themeModeProvider.notifier).toggleTheme();
      expect(container.read(themeModeProvider), ThemeMode.light);
      expect(prefs.getString('app_theme_mode'), 'light');
    });
  });

  group('Dark/Light Theme UI & ThemeToggleButton Tests', () {
    testWidgets('App renders correctly in dark mode', (WidgetTester tester) async {
      SharedPreferences.setMockInitialValues({'app_theme_mode': 'dark'});
      final prefs = await SharedPreferences.getInstance();

      await tester.pumpWidget(
        ProviderScope(
          overrides: [
            sharedPreferencesProvider.overrideWithValue(prefs),
          ],
          child: const HardwareEstimationApp(),
        ),
      );

      await tester.pumpAndSettle();

      final element = tester.element(find.byType(Scaffold).first);
      expect(Theme.of(element).brightness, Brightness.dark);
      expect(element.isDarkMode, isTrue);
      expect(element.colors.background, AppColors.darkBackground);
    });

    testWidgets('Tapping ThemeToggleButton toggles mode', (WidgetTester tester) async {
      SharedPreferences.setMockInitialValues({});
      final prefs = await SharedPreferences.getInstance();

      await tester.pumpWidget(
        ProviderScope(
          overrides: [
            sharedPreferencesProvider.overrideWithValue(prefs),
          ],
          child: const HardwareEstimationApp(),
        ),
      );

      await tester.pumpAndSettle();

      final elementBefore = tester.element(find.byType(Scaffold).first);
      expect(elementBefore.isDarkMode, isFalse);

      final toggleBtn = find.byType(ThemeToggleButton);
      expect(toggleBtn, findsWidgets);

      await tester.tap(toggleBtn.first);
      await tester.pumpAndSettle();

      final elementAfter = tester.element(find.byType(Scaffold).first);
      expect(elementAfter.isDarkMode, isTrue);
    });
  });

  group('Responsive Layout Tests across Devices & Orientations', () {
    testWidgets('Dashboard renders on small phone (320x568) without overflow', (WidgetTester tester) async {
      tester.view.physicalSize = const Size(320, 568);
      tester.view.devicePixelRatio = 1.0;
      addTearDown(tester.view.resetPhysicalSize);

      await tester.pumpWidget(
        const ProviderScope(
          child: HardwareEstimationApp(),
        ),
      );

      await tester.pumpAndSettle();
      expect(tester.takeException(), isNull);
    });

    testWidgets('Dashboard renders in Landscape orientation (800x400) without overflow', (WidgetTester tester) async {
      tester.view.physicalSize = const Size(800, 400);
      tester.view.devicePixelRatio = 1.0;
      addTearDown(tester.view.resetPhysicalSize);

      await tester.pumpWidget(
        const ProviderScope(
          child: HardwareEstimationApp(),
        ),
      );

      await tester.pumpAndSettle();
      expect(tester.takeException(), isNull);
    });

    testWidgets('Dashboard renders on Tablet / Desktop (1024x768) with 4-column grid', (WidgetTester tester) async {
      tester.view.physicalSize = const Size(1024, 768);
      tester.view.devicePixelRatio = 1.0;
      addTearDown(tester.view.resetPhysicalSize);

      await tester.pumpWidget(
        const ProviderScope(
          child: HardwareEstimationApp(),
        ),
      );

      await tester.pumpAndSettle();
      expect(tester.takeException(), isNull);

      final gridView = tester.widget<GridView>(find.byType(GridView).first);
      final delegate = gridView.gridDelegate as SliverGridDelegateWithFixedCrossAxisCount;
      expect(delegate.crossAxisCount, 4);
    });

    testWidgets('ProductCalculatorScreen renders 2-column layout on wide screens', (WidgetTester tester) async {
      tester.view.physicalSize = const Size(900, 700);
      tester.view.devicePixelRatio = 1.0;
      addTearDown(tester.view.resetPhysicalSize);

      final product = mockProducts.firstWhere((p) => p.id == 'prod_gi_plain_roofing_sheet');

      await tester.pumpWidget(
        ProviderScope(
          overrides: [
            calculatorProvider.overrideWith(() => _MockCalculatorNotifier(product)),
          ],
          child: const MaterialApp(
            home: ProductCalculatorScreen(),
          ),
        ),
      );

      await tester.pumpAndSettle();
      expect(tester.takeException(), isNull);
      expect(find.text('Live estimate'), findsOneWidget);
    });

    testWidgets('EstimateSummaryScreen renders 2-column layout on wide screen', (WidgetTester tester) async {
      tester.view.physicalSize = const Size(1000, 800);
      tester.view.devicePixelRatio = 1.0;
      addTearDown(tester.view.resetPhysicalSize);

      final product = mockProducts.first;
      final testItem = EstimateItem(
        id: 'test_item_1',
        product: product,
        quantity: 5,
        calculatedQuantity: 5.0,
        standardUnit: 'set',
        totalAmount: 42500,
        rateSnapshot: 8500,
        breakdown: '5 sets @ ₹8500 / set',
      );

      await tester.pumpWidget(
        ProviderScope(
          overrides: [
            estimateProvider.overrideWith(() => _MockEstimateNotifier([testItem])),
          ],
          child: const MaterialApp(
            home: EstimateSummaryScreen(),
          ),
        ),
      );

      await tester.pumpAndSettle();
      expect(tester.takeException(), isNull);
      expect(find.text('Calculation Summary'), findsOneWidget);
      expect(find.text('Product Cost Breakdown'), findsOneWidget);
    });
  });
}
