/// A selectable variant option for a product (brand, diameter, length, etc.)
class ProductVariantOption {
  final String label;    // e.g. "6 mm", "12 m (standard)", "Tata Tiscon"
  final double rate;     // Rate per base unit for this variant
  final String? detail;  // e.g. "12.19 m" or "standard"
  final String? rateUnit; // e.g. "/bags", "/kg" — shown next to rate in pill

  const ProductVariantOption({
    required this.label,
    required this.rate,
    this.detail,
    this.rateUnit,
  });
}

/// Configuration for a variant group shown as pill selectors on the calculator
class ProductVariantGroup {
  final String title;                       // e.g. "Brand", "Diameter", "Length"
  final List<ProductVariantOption> options;

  const ProductVariantGroup({
    required this.title,
    required this.options,
  });
}

/// Extended metadata for products with multi-variant pickers.
/// Covers steel, cement, pipes, roofing, etc.
class ProductVariantConfig {
  final List<ProductVariantGroup> variantGroups;
  final String howCalculatedText;
  final double gstPercent;
  final String? cuttingChargeNote;

  /// Order-unit tab labels shown below the quantity input.
  /// Steel: ['Nos', 'Metre', 'Kg', 'Tonnes']
  /// Cement: ['Bags', 'Tonnes']
  /// Roofing: ['Sq.ft', 'Sheets']
  final List<String> orderUnitLabels;

  /// Base pricing unit label used in the Live Estimate card
  /// (e.g. 'Bags', 'kg', 'sq.ft').
  final String pricingUnitLabel;

  /// How many base units make one tonne (for the rate-card).
  /// Cement 50 kg bags → 20 bags/tonne. Steel → 1000 kg/tonne.
  final double unitsPerTonne;

  /// Disclaimer text shown below the Add button (product-specific).
  final String? disclaimer;

  const ProductVariantConfig({
    required this.variantGroups,
    this.howCalculatedText = '',
    this.gstPercent = 18.0,
    this.cuttingChargeNote,
    this.orderUnitLabels = const ['Nos', 'Metre', 'Kg', 'Tonnes'],
    this.pricingUnitLabel = 'kg',
    this.unitsPerTonne = 1000.0,
    this.disclaimer,
  });
}
