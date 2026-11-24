import 'package:flutter/material.dart';
import '../../shared/models/category.dart';

const List<Category> mockCategories = [
  Category(
    id: 'cat_steel',
    name: 'Steels',
    subtitle: 'TMT, structural & flat steel',
    icon: Icons.shield_outlined,
    productCount: 4,
    imageUrl: 'https://s75ml08aciksg.space.mcode.io/assets/img/img-steels.jpg',
    subcategories: {
      'TMT Bars': 2,
      'Structural': 1,
      'Flat Products': 1,
    },
  ),
  Category(
    id: 'cat_roofing',
    name: 'Roofing Sheets',
    subtitle: 'Colour coated & Galvalume',
    icon: Icons.roofing_outlined,
    productCount: 4,
    imageUrl: 'https://s75ml08aciksg.space.mcode.io/assets/img/img-roofing.jpg',
    subcategories: {
      'Colour Coated': 2,
      'Galvalume': 1,
      'GI Plain': 1,
    },
  ),
  Category(
    id: 'cat_cement',
    name: 'Cements',
    subtitle: 'OPC, PPC & White Cement',
    icon: Icons.domain_outlined,
    productCount: 4,
    imageUrl: 'https://s75ml08aciksg.space.mcode.io/assets/img/img-cements.jpg',
    subcategories: {
      'PPC Cement': 2,
      'OPC 53': 1,
      'White Cement': 1,
    },
  ),
  Category(
    id: 'cat_pipes',
    name: 'Pipes & Fittings',
    subtitle: 'GI, PVC & CPVC Tubes',
    icon: Icons.water_drop_outlined,
    productCount: 7,
    imageUrl: 'https://s75ml08aciksg.space.mcode.io/assets/img/img-pipes.jpg',
    subcategories: {
      'Round Pipes': 3,
      'GI Square': 3,
      'PVC & CPVC': 2,
    },
  ),
];
