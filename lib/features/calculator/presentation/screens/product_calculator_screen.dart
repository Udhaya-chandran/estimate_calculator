import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:estimate_calculator/app/theme/app_colors.dart';
import 'package:estimate_calculator/features/calculator/domain/entities/product_variant.dart';
import 'package:estimate_calculator/features/calculator/domain/services/product_calculation_helper.dart';
import 'package:estimate_calculator/features/estimates/presentation/providers/estimate_provider.dart';
import 'package:estimate_calculator/shared/widgets/app_header.dart';
import '../providers/calculator_provider.dart';

// ─── Palette ───────────────────────────────────────────────────────
const _activePill = Color(0xFF8A0000);
const _pillBg     = Color(0xFFF4F4F6);
const _pillBorder = Color(0xFFE5E7EB);
const _sectionLbl = Color(0xFF8A92A6);
const _pageBg     = Color(0xFFF3F4F6);
const _darkTxt    = Color(0xFF111827);
const _mutedTxt   = Color(0xFF6B7280);

// Default unit tabs for steel/pipes
const _defaultOrderUnits = ['Nos', 'Metre', 'Kg', 'Tonnes'];

class ProductCalculatorScreen extends ConsumerStatefulWidget {
  const ProductCalculatorScreen({super.key});

  @override
  ConsumerState<ProductCalculatorScreen> createState() =>
      _ProductCalculatorScreenState();
}

class _ProductCalculatorScreenState
    extends ConsumerState<ProductCalculatorScreen> {
  final _qtyCtrl = TextEditingController(text: '1');

  @override
  void dispose() {
    _qtyCtrl.dispose();
    super.dispose();
  }

  // ─── Root ────────────────────────────────────────────────────────
  @override
  Widget build(BuildContext context) {
    final state   = ref.watch(calculatorProvider);
    final product = state.product;

    if (product == null) {
      return Scaffold(
        appBar: const AppHeader(title: 'Calculator', showBackButton: true),
        body: const Center(child: Text('No product selected.')),
      );
    }

    final vc        = product.variantConfig;
    final isEditing = state.isEditing;

    return Scaffold(
      backgroundColor: _pageBg,
      appBar: AppHeader(
        title: isEditing ? 'Edit Item' : 'Product Calculator',
        subtitle: product.name,
        showBackButton: true,
        onBack: () => context.canPop() ? context.pop() : context.go('/products'),
      ),
      body: LayoutBuilder(
        builder: (context, constraints) {
          final isWide = constraints.maxWidth >= 768;

          final breadcrumbs = Wrap(
            children: [
              _crumb('All categories', active: true,
                  onTap: () => context.go('/dashboard')),
              _sep(),
              if (product.subCategory != null) ...[
                _crumb(
                  _categoryLabel(product.categoryId),
                  active: true,
                  onTap: () => context.go('/products'),
                ),
                _sep(),
                _crumb(product.subCategory!),
                _sep(),
              ],
              _crumb(product.name),
            ],
          );

          final productCard = _card(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  product.name,
                  style: const TextStyle(
                    fontSize: 17,
                    fontWeight: FontWeight.w900,
                    color: _darkTxt,
                    letterSpacing: -0.3,
                  ),
                ),
                if (product.description != null) ...[
                  const SizedBox(height: 4),
                  Text(
                    product.description!,
                    style: const TextStyle(
                        fontSize: 11.5, color: _mutedTxt, height: 1.35),
                  ),
                ],
              ],
            ),
          );

          final variantCards = (vc != null)
              ? vc.variantGroups
                  .map((g) => Padding(
                        padding: const EdgeInsets.only(bottom: 10),
                        child: _buildVariantGroup(g, state, vc),
                      ))
                  .toList()
              : <Widget>[];

          final quantityCard = _buildQuantityCard(state, vc);

          final howCard = (vc != null && vc.howCalculatedText.isNotEmpty)
              ? _buildHowCard(vc)
              : null;

          final estimateCard = _buildLiveEstimate(state, product);
          final addBtn = _buildAddButton(state, isEditing);

          if (isWide) {
            return SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  breadcrumbs,
                  const SizedBox(height: 12),
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Left Column: Product Info, Variants, Quantity, How Calculated
                      Expanded(
                        flex: 6,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            productCard,
                            const SizedBox(height: 10),
                            ...variantCards,
                            quantityCard,
                            if (howCard != null) ...[
                              const SizedBox(height: 10),
                              howCard,
                            ],
                          ],
                        ),
                      ),
                      const SizedBox(width: 16),
                      // Right Column: Live Estimate & Add Button
                      Expanded(
                        flex: 4,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            estimateCard,
                            const SizedBox(height: 14),
                            addBtn,
                          ],
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 28),
                ],
              ),
            );
          }

          // Mobile stacked layout
          return SingleChildScrollView(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                breadcrumbs,
                const SizedBox(height: 10),
                productCard,
                const SizedBox(height: 10),
                ...variantCards,
                quantityCard,
                const SizedBox(height: 10),
                if (howCard != null) ...[
                  howCard,
                  const SizedBox(height: 10),
                ],
                estimateCard,
                const SizedBox(height: 16),
                addBtn,
                const SizedBox(height: 28),
              ],
            ),
          );
        },
      ),
    );
  }

  // ─── Shared card shell ───────────────────────────────────────────
  Widget _card({required Widget child, EdgeInsets? padding}) {
    return Container(
      width: double.infinity,
      padding: padding ?? const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: const Color(0xFFE5E7EB), width: 1),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.025),
            blurRadius: 6,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: child,
    );
  }

  // ─── Variant Group Card ──────────────────────────────────────────
  Widget _buildVariantGroup(
      ProductVariantGroup group, CalculatorInputState state,
      ProductVariantConfig vc) {
    final selIdx = state.selectedVariantIndices[group.title] ?? 0;
    final safeIdx = selIdx < group.options.length ? selIdx : 0;
    final selOpt  = group.options[safeIdx];
    final isCementBrand = vc.pricingUnitLabel == 'bags';
    final isTwoPerRow = group.title.toLowerCase().contains('diameter') ||
                        group.title.toLowerCase().contains('size');

    return _card(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(group.title,
                  style: const TextStyle(
                      fontSize: 12.5, fontWeight: FontWeight.w700, color: _darkTxt)),
              Text(
                selOpt.label,
                style: const TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                    color: AppColors.primaryRed),
              ),
            ],
          ),
          const SizedBox(height: 9),
          LayoutBuilder(
            builder: (context, constraints) {
              final itemWidth = isTwoPerRow
                  ? (constraints.maxWidth - 8) / 2
                  : null;

              return Wrap(
                spacing: 7,
                runSpacing: 7,
                children: group.options.asMap().entries.map((e) {
                  final idx   = e.key;
                  final opt   = e.value;
                  final isSel = idx == safeIdx;
                  return GestureDetector(
                    onTap: () => ref
                        .read(calculatorProvider.notifier)
                        .selectVariantOption(group.title, idx),
                    child: AnimatedContainer(
                      duration: const Duration(milliseconds: 140),
                      width: itemWidth,
                      alignment: isTwoPerRow ? Alignment.center : null,
                      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                      decoration: BoxDecoration(
                        color: isSel ? _activePill : _pillBg,
                        borderRadius: BorderRadius.circular(18),
                        border: Border.all(
                          color: isSel ? _activePill : _pillBorder,
                          width: 1.1,
                        ),
                      ),
                      child: FittedBox(
                        fit: BoxFit.scaleDown,
                        child: RichText(
                          text: TextSpan(children: [
                            TextSpan(
                              text: opt.label,
                              style: TextStyle(
                                fontSize: 11.5,
                                fontWeight: FontWeight.w700,
                                color: isSel ? Colors.white : _darkTxt,
                              ),
                            ),
                            if (opt.rate > 0)
                              TextSpan(
                                text: isCementBrand
                                    ? '  ₹${opt.rate.toInt()}/${opt.rateUnit ?? vc.pricingUnitLabel}'
                                    : (opt.rateUnit != null
                                        ? '  ₹${opt.rate == opt.rate.roundToDouble() ? opt.rate.toInt() : opt.rate.toStringAsFixed(2)}/${opt.rateUnit}'
                                        : '  ₹${opt.rate == opt.rate.roundToDouble() ? opt.rate.toInt() : opt.rate.toStringAsFixed(2)}/kg'),
                                style: TextStyle(
                                  fontSize: 10.5,
                                  fontWeight: FontWeight.w500,
                                  color: isSel
                                      ? Colors.white.withValues(alpha: 0.80)
                                      : _mutedTxt,
                                ),
                              ),
                          ]),
                        ),
                      ),
                    ),
                  );
                }).toList(),
              );
            },
          ),
        ],
      ),
    );
  }

  // ─── Quantity + Unit-Tab Card ────────────────────────────────────
  Widget _buildQuantityCard(CalculatorInputState state, ProductVariantConfig? vc) {
    final unitLabels = vc?.orderUnitLabels ?? _defaultOrderUnits;

    return _card(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: const [
              Text('Quantity',
                  style: TextStyle(
                      fontSize: 12.5, fontWeight: FontWeight.w700, color: _darkTxt)),
              Text('Order in the unit you buy in',
                  style: TextStyle(
                      fontSize: 11,
                      color: AppColors.primaryRed,
                      fontWeight: FontWeight.w600)),
            ],
          ),
          const SizedBox(height: 9),

          // Quantity input in its own row
          Container(
            width: 100,
            height: 38,
            decoration: BoxDecoration(
              color: Colors.white,
              border: Border.all(color: const Color(0xFFD1D5DB), width: 1.2),
              borderRadius: BorderRadius.circular(8),
            ),
            alignment: Alignment.centerLeft,
            padding: const EdgeInsets.symmetric(horizontal: 12),
            child: TextField(
              controller: _qtyCtrl,
              keyboardType: const TextInputType.numberWithOptions(decimal: true),
              style: const TextStyle(
                  fontSize: 14, fontWeight: FontWeight.w700, color: _darkTxt),
              decoration: const InputDecoration(
                isDense: true,
                contentPadding: EdgeInsets.zero,
                border: InputBorder.none,
              ),
              onChanged: (v) {
                final n = int.tryParse(v) ?? 1;
                ref.read(calculatorProvider.notifier).updateQuantity(n);
              },
            ),
          ),

          const SizedBox(height: 9),

          // Unit segmented tabs in another row below
          Container(
            height: 36,
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(8),
              border: Border.all(color: const Color(0xFFD1D5DB), width: 1.1),
            ),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(7),
              child: Row(
                children: unitLabels.asMap().entries.map((e) {
                  final idx = e.key;
                  final label = e.value;
                  final isSel = idx == state.orderUnitIndex;
                  return Expanded(
                    child: GestureDetector(
                      onTap: () => ref
                          .read(calculatorProvider.notifier)
                          .setOrderUnitIndex(idx),
                      behavior: HitTestBehavior.opaque,
                      child: Container(
                        height: double.infinity,
                        alignment: Alignment.center,
                        decoration: BoxDecoration(
                          color: isSel ? const Color(0xFFFDF2F2) : Colors.white,
                          border: idx > 0
                              ? const Border(
                                  left: BorderSide(
                                      color: Color(0xFFE5E7EB), width: 1))
                              : null,
                        ),
                        child: FittedBox(
                          fit: BoxFit.scaleDown,
                          child: Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 4),
                            child: Text(
                              label,
                              style: TextStyle(
                                fontSize: 12,
                                fontWeight: isSel ? FontWeight.w800 : FontWeight.w600,
                                color: isSel ? AppColors.primaryRed : _darkTxt,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                  );
                }).toList(),
              ),
            ),
          ),
        ],
      ),
    );
  }

  // ─── HOW THIS IS CALCULATED card ────────────────────────────────
  Widget _buildHowCard(ProductVariantConfig vc) {
    final paras = vc.howCalculatedText
        .split('\n\n')
        .where((s) => s.trim().isNotEmpty)
        .toList();

    return _card(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'HOW THIS IS CALCULATED',
            style: TextStyle(
                fontSize: 9.5,
                fontWeight: FontWeight.w800,
                color: _sectionLbl,
                letterSpacing: 1.0),
          ),
          const SizedBox(height: 8),
          for (int i = 0; i < paras.length; i++) ...[
            if (i > 0) const _Div(),
            Text(paras[i].trim(),
                style: const TextStyle(fontSize: 11.5, color: _darkTxt, height: 1.4)),
          ],
          if (vc.cuttingChargeNote != null) ...[
            const _Div(),
            Text(vc.cuttingChargeNote!,
                style: const TextStyle(fontSize: 11.5, color: _darkTxt, height: 1.4)),
          ],
        ],
      ),
    );
  }

  // ─── Live Estimate card ──────────────────────────────────────────
  Widget _buildLiveEstimate(CalculatorInputState state, dynamic product) {
    final info = ProductCalculationHelper.calculate(state, product);

    return _card(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text('Live estimate',
                  style: TextStyle(
                      fontSize: 13,
                      fontWeight: FontWeight.w700,
                      color: _darkTxt)),
              Text(info.headerRateString,
                  style: const TextStyle(fontSize: 11, color: _mutedTxt)),
            ],
          ),
          const SizedBox(height: 8),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: Text(
                  product.name as String,
                  style: const TextStyle(
                      fontSize: 12,
                      color: _darkTxt,
                      fontWeight: FontWeight.w500),
                  overflow: TextOverflow.ellipsis,
                ),
              ),
              const SizedBox(width: 8),
              Text(
                info.breakdownQtyText,
                style: const TextStyle(
                    fontSize: 11.5,
                    fontWeight: FontWeight.w700,
                    color: _darkTxt),
              ),
            ],
          ),
          const SizedBox(height: 5),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text('Rate applied',
                  style: TextStyle(fontSize: 11, color: _mutedTxt)),
              Text(
                '₹${info.appliedRate == info.appliedRate.roundToDouble() ? info.appliedRate.toInt() : info.appliedRate.toStringAsFixed(2)} / ${info.appliedRateUnit}',
                style: const TextStyle(
                    fontSize: 11.5,
                    color: _darkTxt,
                    fontWeight: FontWeight.w600),
              ),
            ],
          ),
          const _Div(),

          // ESTIMATED TOTAL (GST-inclusive)
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.baseline,
            textBaseline: TextBaseline.alphabetic,
            children: [
              const Text('ESTIMATED TOTAL',
                  style: TextStyle(
                      fontSize: 9.5,
                      fontWeight: FontWeight.w800,
                      color: _sectionLbl,
                      letterSpacing: 0.9)),
              Text(
                _formatNum(info.totalWithGst),
                style: const TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.w900,
                  color: AppColors.primaryRed,
                  letterSpacing: -0.4,
                ),
              ),
            ],
          ),
          const SizedBox(height: 3),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text('GST ${info.gstPercent.toInt()}%',
                  style: const TextStyle(fontSize: 11, color: _mutedTxt)),
              Text(_formatNum(info.gstAmount),
                  style: const TextStyle(fontSize: 11, color: _mutedTxt)),
            ],
          ),
          const _Div(),

          // RATE CARD FOR THIS VARIANT
          const Text('RATE CARD FOR THIS VARIANT',
              style: TextStyle(
                  fontSize: 9.5,
                  fontWeight: FontWeight.w800,
                  color: _sectionLbl,
                  letterSpacing: 1.0)),
          const SizedBox(height: 8),
          for (final entry in info.rateCard)
            _rateRow(entry.key, entry.value),
        ],
      ),
    );
  }

  // ─── Helpers ─────────────────────────────────────────────────────
  String _addCommas(String numStr) {
    final parts = numStr.split('.');
    final intPart = parts[0];
    final decPart = parts.length > 1 ? '.${parts[1]}' : '';
    final reg = RegExp(r'(\d+?)(?=(\d{3})+(?!\d))');
    final formattedInt = intPart.replaceAllMapped(reg, (m) => '${m[1]},');
    return '$formattedInt$decPart';
  }

  String _formatNum(double val) {
    final s2 = val.toStringAsFixed(2);
    if (s2.endsWith('.00')) {
      return '₹${_addCommas(val.toStringAsFixed(1))}';
    }
    if (s2.endsWith('0')) {
      return '₹${_addCommas(val.toStringAsFixed(1))}';
    }
    return '₹${_addCommas(s2)}';
  }

  Widget _rateRow(String label, double val) {
    String formatted;
    if (val == val.roundToDouble()) {
      formatted = '₹${_addCommas(val.toInt().toString())}';
    } else {
      final s2 = val.toStringAsFixed(2);
      if (s2.endsWith('0')) {
        formatted = '₹${_addCommas(val.toStringAsFixed(1))}';
      } else {
        formatted = '₹${_addCommas(s2)}';
      }
    }
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 3),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label, style: const TextStyle(fontSize: 12, color: _mutedTxt)),
          Text(
            formatted,
            style: const TextStyle(
                fontSize: 12, fontWeight: FontWeight.w700, color: _darkTxt),
          ),
        ],
      ),
    );
  }

  String _categoryLabel(String categoryId) {
    switch (categoryId) {
      case 'cat_steel':
        return 'Steels';
      case 'cat_roofing':
        return 'Roofing Sheets';
      case 'cat_cement':
        return 'Cements';
      case 'cat_pipes':
        return 'Pipes & Fittings';
      default:
        return categoryId.replaceAll('cat_', '').capitalize();
    }
  }

  // ─── Add to Estimate button ──────────────────────────────────────
  Widget _buildAddButton(CalculatorInputState state, bool isEditing) {
    final product = state.product;
    if (product == null) return const SizedBox.shrink();
    final info = ProductCalculationHelper.calculate(state, product);
    final vc = product.variantConfig;
    final totalWithGst = info.totalWithGst;
    final disclaimer = vc?.disclaimer ??
        'Estimate only. Not a confirmed order — rates move daily, '
            'stock is subject to availability and final weight is settled '
            'on the weighbridge.';

    return Column(
      children: [
        SizedBox(
          width: double.infinity,
          height: 46,
          child: ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor:
                  totalWithGst > 0 ? AppColors.primaryRed : const Color(0xFFBDBDBD),
              foregroundColor: Colors.white,
              elevation: 0,
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10)),
            ),
            onPressed: totalWithGst > 0
                ? () {
                    ref.read(estimateProvider.notifier).saveCurrentCalculatorItem(state);
                    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                      backgroundColor: AppColors.deepRed,
                      behavior: SnackBarBehavior.floating,
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10)),
                      content: Row(children: [
                        const Icon(Icons.check_circle_rounded,
                            color: Colors.white, size: 20),
                        const SizedBox(width: 10),
                        Expanded(
                          child: Text(
                            isEditing
                                ? '${state.product!.name} updated!'
                                : '${state.product!.name} added to estimate!',
                            style: const TextStyle(fontWeight: FontWeight.w600),
                          ),
                        ),
                      ]),
                      duration: const Duration(seconds: 2),
                    ));
                    if (isEditing) {
                      context.canPop() ? context.pop() : context.go('/estimate-list');
                    } else {
                      context.go('/estimate-list');
                    }
                  }
                : null,
            child: Text(
              isEditing ? 'Update Estimate' : 'Add to estimate list',
              style: const TextStyle(
                  fontSize: 14, fontWeight: FontWeight.w700, letterSpacing: 0.2),
            ),
          ),
        ),
        const SizedBox(height: 8),
        Text(
          disclaimer,
          textAlign: TextAlign.center,
          style: const TextStyle(fontSize: 10.5, color: _mutedTxt, height: 1.4),
        ),
      ],
    );
  }

  // ─── Breadcrumb helpers ──────────────────────────────────────────
  Widget _crumb(String text, {bool active = false, VoidCallback? onTap}) =>
      GestureDetector(
        onTap: onTap,
        child: Text(
          text,
          style: TextStyle(
            fontSize: 11.5,
            fontWeight: FontWeight.w600,
            color: active ? AppColors.primaryRed : _mutedTxt,
          ),
        ),
      );

  Widget _sep() => const Padding(
        padding: EdgeInsets.symmetric(horizontal: 4),
        child: Text('/', style: TextStyle(fontSize: 11.5, color: Color(0xFFD1D5DB))),
      );
}

// ─── Shared thin divider ─────────────────────────────────────────────────────
class _Div extends StatelessWidget {
  const _Div();
  @override
  Widget build(BuildContext context) => const Padding(
        padding: EdgeInsets.symmetric(vertical: 12),
        child: Divider(height: 1, color: Color(0xFFE5E7EB)),
      );
}

// ─── String capitalize ───────────────────────────────────────────────────────
extension _Cap on String {
  String capitalize() => isEmpty ? this : '${this[0].toUpperCase()}${substring(1)}';
}
