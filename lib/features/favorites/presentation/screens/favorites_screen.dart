import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:myshelf/features/products/presentation/controllers/product_list_controller.dart';
import 'package:myshelf/features/products/presentation/screens/product_details_screen.dart';

import '../controllers/favorites_controller.dart';

class FavoritesScreen extends ConsumerWidget {
  final VoidCallback onExploreArrivals;

  const FavoritesScreen({
    super.key,
    required this.onExploreArrivals,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    final favoriteIds = ref.watch(favoritesControllerProvider);
    final productsAsync = ref.watch(productsFutureProvider);

    return Scaffold(
      body: SafeArea(
        child: productsAsync.when(
          data: (products) {
            final favoriteProducts = products.where((p) => favoriteIds.contains(p.id)).toList();

            if (favoriteProducts.isEmpty) {
              return _buildEmptyState(context, theme);
            }

            return ListView(
              padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 16.0),
              children: [
                // Header
                const SizedBox(height: 8.0),
                Text(
                  'My Collection',
                  style: GoogleFonts.playfairDisplay(
                    fontSize: 32.0,
                    fontWeight: FontWeight.w700,
                    color: theme.colorScheme.primary,
                  ),
                ),
                const SizedBox(height: 4.0),
                Text(
                  'A curated selection of your most coveted pieces.',
                  style: GoogleFonts.inter(
                    fontSize: 14.0,
                    color: theme.colorScheme.onSurfaceVariant,
                  ),
                ),
                const SizedBox(height: 32.0),

                // Favorites Items
                ListView.builder(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemCount: favoriteProducts.length,
                  itemBuilder: (context, index) {
                    final product = favoriteProducts[index];

                    return Padding(
                      padding: const EdgeInsets.only(bottom: 16.0),
                      child: GestureDetector(
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => ProductDetailsScreen(product: product),
                            ),
                          );
                        },
                        child: Container(
                          padding: const EdgeInsets.all(12.0),
                          decoration: BoxDecoration(
                            color: isDark
                                ? theme.colorScheme.surfaceVariant.withOpacity(0.15)
                                : Colors.white.withOpacity(0.7),
                            borderRadius: BorderRadius.circular(16.0),
                            border: Border.all(
                              color: theme.colorScheme.outlineVariant.withOpacity(0.2),
                            ),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black.withOpacity(isDark ? 0.2 : 0.03),
                                blurRadius: 10.0,
                                offset: const Offset(0, 4),
                              ),
                            ],
                          ),
                          child: Row(
                            children: [
                              // Product Thumbnail
                              Container(
                                width: 88.0,
                                height: 88.0,
                                decoration: BoxDecoration(
                                  color: isDark
                                      ? theme.colorScheme.surface.withOpacity(0.5)
                                      : theme.colorScheme.surfaceVariant.withOpacity(0.3),
                                  borderRadius: BorderRadius.circular(12.0),
                                ),
                                child: Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Image.network(
                                    product.image,
                                    fit: BoxFit.contain,
                                  ),
                                ),
                              ),
                              const SizedBox(width: 16.0),

                              // Info Details
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      product.category.toUpperCase(),
                                      style: GoogleFonts.inter(
                                        fontSize: 10.0,
                                        fontWeight: FontWeight.w600,
                                        letterSpacing: 1.0,
                                        color: theme.colorScheme.onSurfaceVariant,
                                      ),
                                    ),
                                    const SizedBox(height: 4.0),
                                    Text(
                                      product.title,
                                      maxLines: 1,
                                      overflow: TextOverflow.ellipsis,
                                      style: GoogleFonts.playfairDisplay(
                                        fontSize: 18.0,
                                        fontWeight: FontWeight.w600,
                                        color: theme.colorScheme.primary,
                                      ),
                                    ),
                                    const SizedBox(height: 6.0),
                                    Text(
                                      '\$${product.price.toStringAsFixed(2)}',
                                      style: GoogleFonts.inter(
                                        fontSize: 15.0,
                                        fontWeight: FontWeight.w600,
                                        color: theme.colorScheme.secondary,
                                      ),
                                    ),
                                  ],
                                ),
                              ),

                              // Remove button
                              IconButton(
                                icon: const Icon(
                                  Icons.favorite,
                                  color: Colors.red,
                                ),
                                onPressed: () {
                                  ref
                                      .read(favoritesControllerProvider.notifier)
                                      .toggleFavorite(product.id);
                                },
                              ),
                            ],
                          ),
                        ),
                      ),
                    );
                  },
                ),
                const SizedBox(height: 120.0), // Margin for bottom navigation
              ],
            );
          },
          error: (err, stack) => Center(
            child: Text(
              'Failed to load favorites: $err',
              style: GoogleFonts.inter(color: theme.colorScheme.error),
            ),
          ),
          loading: () => const Center(
            child: CircularProgressIndicator(),
          ),
        ),
      ),
    );
  }

  Widget _buildEmptyState(BuildContext context, ThemeData theme) {
    final isDark = theme.brightness == Brightness.dark;

    return Padding(
      padding: const EdgeInsets.all(24.0),
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Auto Awesome circular badge
            Container(
              width: 140.0,
              height: 140.0,
              decoration: BoxDecoration(
                color: isDark
                    ? theme.colorScheme.surfaceVariant.withOpacity(0.1)
                    : theme.colorScheme.surfaceVariant.withOpacity(0.3),
                shape: BoxShape.circle,
                border: Border.all(
                  color: theme.colorScheme.secondary.withOpacity(0.3),
                  width: 1.0,
                ),
              ),
              child: Icon(
                Icons.auto_awesome,
                color: theme.colorScheme.secondary,
                size: 48.0,
              ),
            ),
            const SizedBox(height: 32.0),

            // Text Titles
            Text(
              'Your collection is waiting for its first piece.',
              style: GoogleFonts.playfairDisplay(
                fontSize: 20.0,
                fontWeight: FontWeight.w600,
                color: theme.colorScheme.primary,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 12.0),
            Text(
              'Discover our latest arrivals and curate a space that reflects your unique taste.',
              style: GoogleFonts.inter(
                fontSize: 14.0,
                color: theme.colorScheme.onSurfaceVariant,
                height: 1.5,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 32.0),

            // Action Button
            ElevatedButton(
              onPressed: onExploreArrivals,
              style: ElevatedButton.styleFrom(
                backgroundColor: theme.colorScheme.primary,
                foregroundColor: theme.colorScheme.onPrimary,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(24.0),
                ),
                padding: const EdgeInsets.symmetric(horizontal: 32.0, vertical: 14.0),
                elevation: 2.0,
              ),
              child: Text(
                'EXPLORE ARRIVALS',
                style: GoogleFonts.inter(
                  fontSize: 12.0,
                  fontWeight: FontWeight.w600,
                  letterSpacing: 1.5,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
