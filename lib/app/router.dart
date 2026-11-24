import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../features/calculator/presentation/screens/product_calculator_screen.dart';
import '../features/categories/presentation/screens/categories_screen.dart';
import '../features/dashboard/presentation/screens/dashboard_screen.dart';
import '../features/estimates/presentation/screens/estimate_list_screen.dart';
import '../features/estimates/presentation/screens/estimate_summary_screen.dart';
import '../features/products/presentation/screens/product_selection_screen.dart';
import '../features/splash/presentation/screens/splash_screen.dart';

final GoRouter appRouter = GoRouter(
  initialLocation: '/splash',
  routes: [
    GoRoute(
      path: '/splash',
      name: 'splash',
      builder: (context, state) => const SplashScreen(),
    ),
    GoRoute(
      path: '/',
      name: 'dashboard',
      builder: (context, state) => const DashboardScreen(),
    ),
    GoRoute(
      path: '/categories',
      name: 'categories',
      builder: (context, state) => const CategoriesScreen(),
    ),
    GoRoute(
      path: '/products',
      name: 'products',
      builder: (context, state) => const ProductSelectionScreen(),
    ),
    GoRoute(
      path: '/calculator',
      name: 'calculator',
      builder: (context, state) => const ProductCalculatorScreen(),
    ),
    GoRoute(
      path: '/estimate-list',
      name: 'estimate-list',
      builder: (context, state) => const EstimateListScreen(),
    ),
    GoRoute(
      path: '/estimate-summary',
      name: 'estimate-summary',
      builder: (context, state) => const EstimateSummaryScreen(),
    ),
  ],
  errorBuilder: (context, state) => Scaffold(
    body: Center(
      child: Text('Page not found: ${state.uri}'),
    ),
  ),
);
