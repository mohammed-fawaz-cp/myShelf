import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import '../controllers/product_list_controller.dart';
import 'package:myshelf/features/favorites/presentation/controllers/favorites_controller.dart';
import 'product_details_screen.dart';

class ShopView extends ConsumerWidget {
  const ShopView({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    final productsAsync = ref.watch(filteredProductsProvider);
    final favoriteIds = ref.watch(favoritesControllerProvider);
    final searchQuery = ref.watch(searchQueryProvider);

    return Scaffold(
      body: Column(
        children: [
          // Search Bar Section
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 16, 16, 8),
            child: TextField(
              onChanged: (value) => ref.read(searchQueryProvider.notifier).state = value,
              decoration: InputDecoration(
                hintText: 'Search masterpieces...',
                hintStyle: GoogleFonts.inter(
                  color: theme.colorScheme.onSurfaceVariant.withValues(alpha: 0.5),
                  fontSize: 14.0,
                ),
                prefixIcon: Icon(Icons.search, color: theme.colorScheme.secondary, size: 20),
                suffixIcon: searchQuery.isNotEmpty 
                  ? IconButton(
                      icon: const Icon(Icons.clear, size: 18),
                      onPressed: () => ref.read(searchQueryProvider.notifier).state = '',
                    )
                  : null,
                filled: true,
                fillColor: isDark 
                    ? theme.colorScheme.surfaceContainerHighest.withValues(alpha: 0.1) 
                    : theme.colorScheme.surfaceContainerHighest.withValues(alpha: 0.3),
                contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide.none,
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide(
                    color: theme.colorScheme.outlineVariant.withValues(alpha: 0.2),
                  ),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide(
                    color: theme.colorScheme.secondary.withValues(alpha: 0.5),
                  ),
                ),
              ),
            ),
          ),

          // Categories horizontal list (Optional, but adds to "perfect widget" feel)
          const _CategorySelector(),

          // Product Grid
          Expanded(
            child: productsAsync.when(
              data: (products) {
                if (products.isEmpty) {
                  return Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(Icons.search_off, size: 64, color: theme.colorScheme.outline),
                        const SizedBox(height: 16),
                        Text(
                          'No items match your search',
                          style: GoogleFonts.inter(
                            color: theme.colorScheme.onSurfaceVariant,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ],
                    ),
                  );
                }

                return GridView.builder(
                  padding: const EdgeInsets.fromLTRB(16, 8, 16, 100),
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    crossAxisSpacing: 16.0,
                    mainAxisSpacing: 24.0,
                    childAspectRatio: 0.65,
                  ),
                  itemCount: products.length,
                  itemBuilder: (context, index) {
                    final product = products[index];
                    final isFavorited = favoriteIds.contains(product.id);

                    return GestureDetector(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => ProductDetailsScreen(product: product),
                          ),
                        );
                      },
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Expanded(
                            child: Stack(
                              children: [
                                Container(
                                  width: double.infinity,
                                  decoration: BoxDecoration(
                                    color: Colors.white,
                                    borderRadius: BorderRadius.circular(16.0),
                                    boxShadow: [
                                      BoxShadow(
                                        color: Colors.black.withValues(alpha: 0.03),
                                        blurRadius: 10,
                                        offset: const Offset(0, 4),
                                      ),
                                    ],
                                  ),
                                  child: Hero(
                                    tag: 'shop-img-${product.id}',
                                    child: Padding(
                                      padding: const EdgeInsets.all(16.0),
                                      child: Image.network(
                                        product.image,
                                        fit: BoxFit.contain,
                                      ),
                                    ),
                                  ),
                                ),
                                Positioned(
                                  top: 8,
                                  right: 8,
                                  child: IconButton(
                                    icon: Icon(
                                      isFavorited ? Icons.favorite : Icons.favorite_border,
                                      color: isFavorited ? Colors.red : theme.colorScheme.primary,
                                      size: 20,
                                    ),
                                    onPressed: () {
                                      ref.read(favoritesControllerProvider.notifier).toggleFavorite(product.id);
                                    },
                                  ),
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(height: 12),
                          Text(
                            product.category.toUpperCase(),
                            style: GoogleFonts.inter(
                              fontSize: 9.0,
                              fontWeight: FontWeight.bold,
                              letterSpacing: 1.2,
                              color: theme.colorScheme.secondary,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            product.title,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: GoogleFonts.playfairDisplay(
                              fontSize: 15.0,
                              fontWeight: FontWeight.bold,
                              color: theme.colorScheme.primary,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            '\$${product.price.toStringAsFixed(2)}',
                            style: GoogleFonts.inter(
                              fontSize: 14.0,
                              fontWeight: FontWeight.w700,
                              color: theme.colorScheme.onSurface,
                            ),
                          ),
                        ],
                      ),
                    );
                  },
                );
              },
              loading: () => const Center(child: CircularProgressIndicator()),
              error: (err, stack) => Center(child: Text('Error: $err')),
            ),
          ),
        ],
      ),
    );
  }
}

class _CategorySelector extends ConsumerWidget {
  const _CategorySelector();

  String _capitalize(String s) => s.isEmpty ? s : s[0].toUpperCase() + s.substring(1);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final categoriesAsync = ref.watch(categoriesFutureProvider);
    final selectedCategory = ref.watch(selectedCategoryProvider);
    final theme = Theme.of(context);

    return categoriesAsync.when(
      data: (categories) => Container(
        height: 50,
        margin: const EdgeInsets.symmetric(vertical: 8),
        child: ListView.builder(
          scrollDirection: Axis.horizontal,
          padding: const EdgeInsets.symmetric(horizontal: 12),
          itemCount: categories.length,
          itemBuilder: (context, index) {
            final category = categories[index];
            final isSelected = category == selectedCategory;
            return Padding(
              padding: const EdgeInsets.symmetric(horizontal: 4),
              child: ChoiceChip(
                label: Text(
                  _capitalize(category),
                  style: GoogleFonts.inter(
                    fontSize: 12,
                    fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                    color: isSelected ? theme.colorScheme.onPrimary : theme.colorScheme.onSurface,
                  ),
                ),
                selected: isSelected,
                onSelected: (selected) {
                  if (selected) {
                    ref.read(selectedCategoryProvider.notifier).state = category;
                  }
                },
                selectedColor: theme.colorScheme.primary,
                backgroundColor: Colors.transparent,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20),
                  side: BorderSide(
                    color: isSelected ? theme.colorScheme.primary : theme.colorScheme.outlineVariant,
                  ),
                ),
                showCheckmark: false,
              ),
            );
          },
        ),
      ),
      loading: () => const SizedBox(height: 50),
      error: (_, stack) => const SizedBox.shrink(),
    );
  }
}
