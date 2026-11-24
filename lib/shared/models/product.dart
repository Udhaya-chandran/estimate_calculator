import 'package:flutter/material.dart';
import '../../features/calculator/domain/entities/measurement_configuration.dart';
import '../../features/calculator/domain/entities/measurement_type.dart';
import '../../features/calculator/domain/entities/product_variant.dart';

class Product {
  final String id;
  final String categoryId;
  final String? subCategory;
  final String name;
  final String brand;
  final MeasurementType measurementType;
  final String pricingUnit; // e.g. 'foot', 'sq.ft', 'bag', 'kg', 'piece', 'set'
  final double rate;
  final MeasurementConfiguration measurementConfiguration;
  final String? description;
  final String? imageUrl;
  final IconData? icon;
  /// Extended variant config for products with multi-selector UI (steel rods, pipes, etc.)
  final ProductVariantConfig? variantConfig;

  const Product({
    required this.id,
    required this.categoryId,
    this.subCategory,
    required this.name,
    required this.brand,
    required this.measurementType,
    required this.pricingUnit,
    required this.rate,
    required this.measurementConfiguration,
    this.description,
    this.imageUrl,
    this.icon,
    this.variantConfig,
  });

  Product copyWith({
    String? id,
    String? categoryId,
    String? subCategory,
    String? name,
    String? brand,
    MeasurementType? measurementType,
    String? pricingUnit,
    double? rate,
    MeasurementConfiguration? measurementConfiguration,
    String? description,
    String? imageUrl,
    IconData? icon,
    ProductVariantConfig? variantConfig,
  }) {
    return Product(
      id: id ?? this.id,
      categoryId: categoryId ?? this.categoryId,
      subCategory: subCategory ?? this.subCategory,
      name: name ?? this.name,
      brand: brand ?? this.brand,
      measurementType: measurementType ?? this.measurementType,
      pricingUnit: pricingUnit ?? this.pricingUnit,
      rate: rate ?? this.rate,
      measurementConfiguration: measurementConfiguration ?? this.measurementConfiguration,
      description: description ?? this.description,
      imageUrl: imageUrl ?? this.imageUrl,
      icon: icon ?? this.icon,
      variantConfig: variantConfig ?? this.variantConfig,
    );
  }
}
