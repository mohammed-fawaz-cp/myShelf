import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:myshelf/features/products/presentation/controllers/product_list_controller.dart';
import 'package:myshelf/features/favorites/presentation/controllers/favorites_controller.dart';
import 'product_details_screen.dart';

class DashboardView extends ConsumerWidget {
  const DashboardView({super.key});

  // Capitalize category names for display
  String _capitalizeCategory(String category) {
    if (category.isEmpty) return category;
    return category.split(' ').map((word) {
      if (word.isEmpty) return word;
      return word[0].toUpperCase() + word.substring(1);
    }).join(' ');
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    final categoriesAsync = ref.watch(categoriesFutureProvider);
    final selectedCategory = ref.watch(selectedCategoryProvider);
    final productsAsync = ref.watch(filteredProductsProvider);
    final favoriteIds = ref.watch(favoritesControllerProvider);

    return SingleChildScrollView(
      padding: const EdgeInsets.only(bottom: 120.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(height: 16.0),

          // 1. Hero Editorial Section
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(16.0),
              child: Stack(
                children: [
                  Container(
                    height: 380.0,
                    width: double.infinity,
                    decoration: BoxDecoration(
                      color: isDark ? Colors.black26 : Colors.black12,
                    ),
                    child: Image.network(
                      'https://lh3.googleusercontent.com/aida-public/AB6AXuB0w5unW8xuphfkEPFVsNHKGxW8tTPmWKVnS0o-baSXdto45IZyrJicdxSKrgTgSSU8SHHwMJDDUVfOOokQr6G2qh6YGYIRlHeYnkMnGnwLEgBXB3KFTBHFjJFnAr4qRzqc647o_TE-5jWVH4d98JMSnh7m_rmuH1muwR50ZAHZ7EpcX7d6TTYbxHPVed8qnzeuvjRoicwJdHqEP0fbhQvU-qyvkaVHQNztWTWggfdZizlquhmm_6SxwRzPAaAgVTPMb7SH5QEJ__DL',
                      fit: BoxFit.cover,
                    ),
                  ),
                  Positioned.fill(
                    child: Container(
                      decoration: const BoxDecoration(
                        gradient: LinearGradient(
                          colors: [Colors.black54, Colors.black12, Colors.transparent],
                          begin: Alignment.bottomCenter,
                          end: Alignment.topCenter,
                        ),
                      ),
                    ),
                  ),
                  Positioned(
                    left: 20.0,
                    right: 20.0,
                    bottom: 24.0,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'SUMMER 2026',
                          style: GoogleFonts.inter(
                            fontSize: 12.0,
                            fontWeight: FontWeight.w600,
                            letterSpacing: 3.0,
                            color: const Color(0xFFE6E3D2),
                          ),
                        ),
                        const SizedBox(height: 8.0),
                        Text(
                          'Timeless Elegance',
                          style: GoogleFonts.playfairDisplay(
                            fontSize: 32.0,
                            fontWeight: FontWeight.w700,
                            color: Colors.white,
                          ),
                        ),
                        const SizedBox(height: 16.0),
                        ElevatedButton(
                          onPressed: () {},
                          style: ElevatedButton.styleFrom(
                            backgroundColor: theme.colorScheme.primary,
                            foregroundColor: theme.colorScheme.onPrimary,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8.0),
                            ),
                            padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 12.0),
                          ),
                          child: Text(
                            'Explore Collection',
                            style: GoogleFonts.inter(
                              fontSize: 13.0,
                              fontWeight: FontWeight.w600,
                              letterSpacing: 1.0,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 24.0),

          // 2. Category Chips Section
          categoriesAsync.when(
            data: (categories) => SizedBox(
              height: 40.0,
              child: ListView.builder(
                scrollDirection: Axis.horizontal,
                padding: const EdgeInsets.symmetric(horizontal: 16.0),
                itemCount: categories.length,
                itemBuilder: (context, index) {
                  final cat = categories[index];
                  final isSelected = cat == selectedCategory;
                  final displayName = cat == 'All' ? 'All' : _capitalizeCategory(cat);

                  return Padding(
                    padding: const EdgeInsets.only(right: 8.0),
                    child: ChoiceChip(
                      label: Text(displayName),
                      selected: isSelected,
                      onSelected: (selected) {
                        if (selected) {
                          ref.read(selectedCategoryProvider.notifier).state = cat;
                        }
                      },
                      labelStyle: GoogleFonts.inter(
                        fontSize: 13.0,
                        fontWeight: FontWeight.w600,
                        color: isSelected
                            ? theme.colorScheme.onPrimary
                            : theme.colorScheme.onSurfaceVariant,
                      ),
                      selectedColor: theme.colorScheme.primary,
                      backgroundColor: isDark
                          ? theme.colorScheme.surfaceContainerHighest.withValues(alpha: 0.3)
                          : theme.colorScheme.surfaceContainerHighest.withValues(alpha: 0.5),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20.0),
                        side: BorderSide(
                          color: isSelected
                              ? theme.colorScheme.primary
                              : theme.colorScheme.outlineVariant.withValues(alpha: 0.5),
                          width: 1.0,
                        ),
                      ),
                      showCheckmark: false,
                    ),
                  );
                },
              ),
            ),
            error: (err, stack) => const SizedBox.shrink(),
            loading: () => const SizedBox(
              height: 40.0,
              child: Center(
                child: SizedBox(
                  width: 20.0,
                  height: 20.0,
                  child: CircularProgressIndicator(strokeWidth: 2.0),
                ),
              ),
            ),
          ),
          const SizedBox(height: 24.0),

          // 3. Product Grid
          productsAsync.when(
            data: (products) {
              if (products.isEmpty) {
                return Padding(
                  padding: const EdgeInsets.all(32.0),
                  child: Center(
                    child: Text(
                      'No products found.',
                      style: GoogleFonts.inter(color: theme.colorScheme.onSurfaceVariant),
                    ),
                  ),
                );
              }

              return Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16.0),
                child: GridView.builder(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
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
                          // Card Image and heart button
                          Expanded(
                            child: Stack(
                              children: [
                                Container(
                                  width: double.infinity,
                                  decoration: BoxDecoration(
                                    color: isDark
                                        ? theme.colorScheme.surfaceContainerHighest.withValues(alpha: 0.2)
                                        : theme.colorScheme.surfaceContainerHighest.withValues(alpha: 0.4),
                                    borderRadius: BorderRadius.circular(12.0),
                                    border: Border.all(
                                      color: theme.colorScheme.outlineVariant.withValues(alpha: 0.2),
                                    ),
                                  ),
                                  child: Hero(
                                    tag: 'product-img-${product.id}',
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
                                  top: 8.0,
                                  right: 8.0,
                                  child: Container(
                                    decoration: BoxDecoration(
                                      color: isDark
                                          ? theme.colorScheme.surface.withValues(alpha: 0.8)
                                          : Colors.white.withValues(alpha: 0.8),
                                      shape: BoxShape.circle,
                                    ),
                                    child: IconButton(
                                      icon: AnimatedSwitcher(
                                        duration: const Duration(milliseconds: 300),
                                        transitionBuilder: (child, animation) {
                                          return ScaleTransition(
                                            scale: animation,
                                            child: child,
                                          );
                                        },
                                        child: Icon(
                                          isFavorited ? Icons.favorite : Icons.favorite_border,
                                          key: ValueKey<bool>(isFavorited),
                                          color: isFavorited ? Colors.red : theme.colorScheme.primary,
                                          size: 18.0,
                                        ),
                                      ),
                                      onPressed: () {
                                        ref
                                            .read(favoritesControllerProvider.notifier)
                                            .toggleFavorite(product.id);
                                      },
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(height: 8.0),

                          // Category
                          Text(
                            product.category.toUpperCase(),
                            style: GoogleFonts.inter(
                              fontSize: 9.0,
                              fontWeight: FontWeight.w600,
                              letterSpacing: 1.5,
                              color: theme.colorScheme.secondary,
                            ),
                          ),
                          const SizedBox(height: 4.0),

                          // Product Title
                          Text(
                            product.title,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: GoogleFonts.playfairDisplay(
                              fontSize: 15.0,
                              fontWeight: FontWeight.w600,
                              color: theme.colorScheme.onSurface,
                            ),
                          ),
                          const SizedBox(height: 2.0),

                          // Price
                          Text(
                            '\$${product.price.toStringAsFixed(2)}',
                            style: GoogleFonts.inter(
                              fontSize: 14.0,
                              fontWeight: FontWeight.w700,
                              color: isDark ? theme.colorScheme.secondary : theme.colorScheme.onSurface,
                            ),
                          ),
                        ],
                      ),
                    );
                  },
                ),
              );
            },
            error: (err, stack) => Padding(
              padding: const EdgeInsets.all(32.0),
              child: Center(
                child: Column(
                  children: [
                    Text(
                      'Failed to load products.',
                      style: GoogleFonts.inter(color: theme.colorScheme.error),
                    ),
                    const SizedBox(height: 8.0),
                    ElevatedButton(
                      onPressed: () => ref.refresh(productsFutureProvider),
                      child: const Text('Retry'),
                    ),
                  ],
                ),
              ),
            ),
            loading: () => const Padding(
              padding: EdgeInsets.symmetric(vertical: 64.0),
              child: Center(
                child: CircularProgressIndicator(),
              ),
            ),
          ),
          const SizedBox(height: 40.0),

          // 4. Newsletter Bento Card
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            child: Container(
              padding: const EdgeInsets.all(24.0),
              decoration: BoxDecoration(
                color: isDark
                    ? theme.colorScheme.surfaceContainerHighest.withValues(alpha: 0.3)
                    : theme.colorScheme.surfaceContainerLow,
                borderRadius: BorderRadius.circular(16.0),
                border: Border.all(
                  color: theme.colorScheme.outlineVariant.withValues(alpha: 0.3),
                ),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Text(
                    'Join the Inner Circle',
                    style: GoogleFonts.playfairDisplay(
                      fontSize: 24.0,
                      fontWeight: FontWeight.bold,
                      color: theme.colorScheme.onSurface,
                    ),
                  ),
                  const SizedBox(height: 8.0),
                  Text(
                    'Receive exclusive access to new arrivals and private seasonal events.',
                    style: GoogleFonts.inter(
                      fontSize: 13.0,
                      color: theme.colorScheme.onSurfaceVariant,
                      height: 1.4,
                    ),
                  ),
                  const SizedBox(height: 20.0),
                  TextField(
                    decoration: InputDecoration(
                      hintText: 'Email Address',
                      hintStyle: GoogleFonts.inter(
                        color: theme.colorScheme.onSurfaceVariant.withValues(alpha: 0.5),
                        fontSize: 13.0,
                      ),
                      filled: true,
                      fillColor: theme.colorScheme.surface,
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8.0),
                        borderSide: BorderSide(
                          color: theme.colorScheme.outlineVariant,
                        ),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8.0),
                        borderSide: BorderSide(
                          color: theme.colorScheme.primary,
                        ),
                      ),
                      contentPadding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 12.0),
                    ),
                  ),
                  const SizedBox(height: 12.0),
                  ElevatedButton(
                    onPressed: () {},
                    style: ElevatedButton.styleFrom(
                      backgroundColor: theme.colorScheme.primary,
                      foregroundColor: theme.colorScheme.onPrimary,
                      padding: const EdgeInsets.symmetric(vertical: 14.0),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8.0),
                      ),
                    ),
                    child: Text(
                      'Subscribe',
                      style: GoogleFonts.inter(
                        fontWeight: FontWeight.w600,
                        letterSpacing: 1.0,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
