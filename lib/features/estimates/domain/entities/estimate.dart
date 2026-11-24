import 'estimate_item.dart';

class Estimate {
  final String id;
  final DateTime createdAt;
  final List<EstimateItem> items;
  final double subtotal;
  final double discount;
  final double finalAmount;
  final String? customerName;
  final String? customerPhone;

  const Estimate({
    required this.id,
    required this.createdAt,
    required this.items,
    required this.subtotal,
    required this.discount,
    required this.finalAmount,
    this.customerName,
    this.customerPhone,
  });

  Estimate copyWith({
    String? id,
    DateTime? createdAt,
    List<EstimateItem>? items,
    double? subtotal,
    double? discount,
    double? finalAmount,
    String? customerName,
    String? customerPhone,
  }) {
    return Estimate(
      id: id ?? this.id,
      createdAt: createdAt ?? this.createdAt,
      items: items ?? this.items,
      subtotal: subtotal ?? this.subtotal,
      discount: discount ?? this.discount,
      finalAmount: finalAmount ?? this.finalAmount,
      customerName: customerName ?? this.customerName,
      customerPhone: customerPhone ?? this.customerPhone,
    );
  }
}
