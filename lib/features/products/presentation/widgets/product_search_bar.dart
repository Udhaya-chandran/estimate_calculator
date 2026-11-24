import 'package:flutter/material.dart';
import '../../../../app/theme/app_colors.dart';

class ProductSearchBar extends StatelessWidget {
  final TextEditingController controller;
  final ValueChanged<String> onChanged;
  final VoidCallback onClear;

  const ProductSearchBar({
    super.key,
    required this.controller,
    required this.onChanged,
    required this.onClear,
  });

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: controller,
      onChanged: onChanged,
      style: const TextStyle(fontSize: 14, color: AppColors.primaryText),
      decoration: InputDecoration(
        hintText: 'Search products by name, brand or unit...',
        hintStyle: const TextStyle(color: AppColors.hintText, fontSize: 14),
        prefixIcon: const Icon(Icons.search_rounded, color: AppColors.secondaryText, size: 20),
        suffixIcon: controller.text.isNotEmpty
            ? IconButton(
                icon: const Icon(Icons.clear_rounded, size: 18, color: AppColors.secondaryText),
                onPressed: onClear,
              )
            : null,
        filled: true,
        fillColor: AppColors.surface,
        isDense: true,
        contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: AppColors.border, width: 1),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: AppColors.primaryRed, width: 1.5),
        ),
      ),
    );
  }
}

