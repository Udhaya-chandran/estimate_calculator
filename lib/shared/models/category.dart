import 'package:flutter/material.dart';

class Category {
  final String id;
  final String name;
  final IconData icon;
  final String? subtitle;
  final String description;
  final int productCount;
  final String? imageUrl;
  final Map<String, int> subcategories;

  const Category({
    required this.id,
    required this.name,
    required this.icon,
    this.subtitle,
    this.description = '',
    this.productCount = 0,
    this.imageUrl,
    this.subcategories = const {},
  });

  Category copyWith({
    String? id,
    String? name,
    IconData? icon,
    String? subtitle,
    String? description,
    int? productCount,
    String? imageUrl,
    Map<String, int>? subcategories,
  }) {
    return Category(
      id: id ?? this.id,
      name: name ?? this.name,
      icon: icon ?? this.icon,
      subtitle: subtitle ?? this.subtitle,
      description: description ?? this.description,
      productCount: productCount ?? this.productCount,
      imageUrl: imageUrl ?? this.imageUrl,
      subcategories: subcategories ?? this.subcategories,
    );
  }
}
