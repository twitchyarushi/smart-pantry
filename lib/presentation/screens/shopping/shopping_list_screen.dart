import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:smart_pantry/core/widgets/widgets.dart';
import 'package:smart_pantry/features/shopping/data/models/shopping_item.dart';
import 'package:smart_pantry/features/shopping/presentation/providers/shopping_providers.dart';

final shoppingItemsProvider = FutureProvider<List<ShoppingItem>>((ref) async {
  final useCase = ref.watch(loadShoppingItemsUseCaseProvider);
  return useCase.call();
});

class ShoppingListScreen extends ConsumerWidget {
  const ShoppingListScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final asyncItems = ref.watch(shoppingItemsProvider);

    return Scaffold(
      appBar: AppBar(title: const Text('Shopping List')),
      body: asyncItems.when(
        data: (items) {
          if (items.isEmpty) {
            return const EmptyStateView(
              message: 'No shopping items yet',
              icon: Icons.shopping_cart_outlined,
            );
          }
          return ListView.builder(
            padding: const EdgeInsets.all(16),
            itemCount: items.length,
            itemBuilder: (context, index) {
              final item = items[index];
              return _ShoppingItemCard(item: item);
            },
          );
        },
        loading: () => const LoadingSkeleton(),
        error: (_, __) => ErrorStateView(
          message: 'Could not load shopping items - tap to retry',
          actionLabel: 'Retry',
          onAction: () => ref.invalidate(shoppingItemsProvider),
        ),
      ),
    );
  }
}

class _ShoppingItemCard extends StatelessWidget {
  const _ShoppingItemCard({required this.item});

  final ShoppingItem item;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return AppCard(
      child: Row(
        children: [
          CircleAvatar(
            backgroundColor: theme.colorScheme.primaryContainer,
            foregroundColor: theme.colorScheme.onPrimaryContainer,
            child: const Icon(Icons.shopping_basket_outlined),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(item.name, style: theme.textTheme.titleMedium),
                const SizedBox(height: 8),
                Wrap(
                  spacing: 8,
                  runSpacing: 8,
                  children: [
                    AppChip(label: '${item.quantity} ${item.unit}'),
                    if (item.note != null && item.note!.isNotEmpty)
                      AppChip(label: item.note!, icon: Icons.notes_outlined),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
