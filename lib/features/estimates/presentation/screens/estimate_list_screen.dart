import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../../app/theme/app_colors.dart';
import '../../../../core/widgets/empty_state_view.dart';
import '../../../../shared/widgets/app_header.dart';
import '../../../../shared/widgets/bottom_estimate_bar.dart';
import '../../../calculator/presentation/providers/calculator_provider.dart';
import '../providers/estimate_provider.dart';
import '../widgets/estimate_item_tile.dart';

class EstimateListScreen extends ConsumerWidget {
  const EstimateListScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final estimate = ref.watch(estimateProvider);
    final items = estimate.items;
    final subtotal = estimate.subtotal;

    return Scaffold(
      appBar: AppHeader(
        title: 'Estimate Items',
        subtitle: estimate.estimateId,
        showBackButton: true,
        onBack: () => context.canPop() ? context.pop() : context.go('/'),
        actions: [
          if (items.isNotEmpty)
            TextButton(
              onPressed: () {
                _showClearConfirmationDialog(context, ref);
              },
              child: const Text('Clear All', style: TextStyle(color: AppColors.primaryRed)),
            ),
        ],
      ),
      body: items.isEmpty
          ? EmptyStateView(
              icon: Icons.add_shopping_cart_rounded,
              title: 'Estimate is Empty',
              description: 'Select products from categories and enter measurements to build your estimate.',
              buttonText: 'Add First Product',
              onButtonPressed: () => context.go('/categories'),
            )
          : ListView.separated(
              padding: const EdgeInsets.all(16),
              itemCount: items.length,
              separatorBuilder: (_, _) => const SizedBox(height: 12),
              itemBuilder: (context, index) {
                final item = items[index];
                return EstimateItemTile(
                  item: item,
                  onEdit: () {
                    // Load into calculator in editing mode
                    ref.read(calculatorProvider.notifier).initForProduct(
                          item.product,
                          existingItem: item,
                        );
                    context.push('/calculator');
                  },
                  onDelete: () {
                    ref.read(estimateProvider.notifier).removeItem(item.id);
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text('${item.product.name} removed'),
                        duration: const Duration(seconds: 2),
                        behavior: SnackBarBehavior.floating,
                      ),
                    );
                  },
                );
              },
            ),
      bottomNavigationBar: BottomEstimateBar(
        itemCount: items.length,
        totalAmount: subtotal,
        actionLabel: 'Estimate Summary',
        secondaryActionLabel: 'Add Products',
        onSecondaryAction: () => context.go('/categories'),
        onViewEstimate: () => context.push('/estimate-summary'),
      ),
    );
  }

  void _showClearConfirmationDialog(BuildContext context, WidgetRef ref) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Clear Current Estimate?'),
        content: const Text('This will remove all items from this estimation session.'),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: const Text('Cancel', style: TextStyle(color: AppColors.secondaryText)),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.primaryRed,
              foregroundColor: Colors.white,
            ),
            onPressed: () {
              ref.read(estimateProvider.notifier).startNewEstimate();
              Navigator.pop(ctx);
            },
            child: const Text('Clear All'),
          ),
        ],
      ),
    );
  }
}
