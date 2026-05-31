import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:myshelf/features/products/domain/entities/product.dart';
import 'package:myshelf/features/favorites/presentation/controllers/favorites_controller.dart';

import 'package:myshelf/features/cart/presentation/controllers/cart_controller.dart';

class ProductDetailsScreen extends ConsumerStatefulWidget {
  final Product product;

  const ProductDetailsScreen({
    super.key,
    required this.product,
  });

  @override
  ConsumerState<ProductDetailsScreen> createState() => _ProductDetailsScreenState();
}

class _ProductDetailsScreenState extends ConsumerState<ProductDetailsScreen> {
  final ScrollController _scrollController = ScrollController();
  double _scrollOffset = 0.0;
  bool _isAdded = false;

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(() {
      setState(() {
        _scrollOffset = _scrollController.offset;
      });
    });
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  void _triggerAddToCart() {
    ref.read(cartControllerProvider.notifier).addToCart(widget.product);

    setState(() {
      _isAdded = true;
    });

    // Reset indicator back to normal after 2 seconds
    Future.delayed(const Duration(seconds: 2), () {
      if (mounted) {
        setState(() {
          _isAdded = false;
        });
      }
    });
  }

  Map<String, String> _getSpecsForCategory(String category) {
    final cleanCat = category.toLowerCase().trim();
    if (cleanCat.contains('jewelery') || cleanCat.contains('jewelry')) {
      return {
        'Gemstone': 'Certified Authentic',
        'Base Metal': '24k Gold Plated',
        'Finish': 'Hand-polished',
        'Clasp': 'Jewelry Clasp',
      };
    } else if (cleanCat.contains('electronics')) {
      return {
        'Power Source': 'Rechargeable/USB',
        'Interface': 'Plug & Play',
        'Compatibility': 'Universal OS',
        'Tech Spec': 'Premium Grade',
      };
    } else {
      return {
        'Material': 'Premium Blend',
        'Fit Style': 'Tailored Fit',
        'Care': 'Professional Dry Clean',
        'Fabric Weight': 'Lightweight',
      };
    }
  }

  IconData _getIconForSpec(String specTitle) {
    switch (specTitle) {
      case 'Gemstone':
        return Icons.diamond_outlined;
      case 'Base Metal':
        return Icons.auto_awesome;
      case 'Finish':
        return Icons.brush_outlined;
      case 'Clasp':
        return Icons.lock_outline;
      case 'Power Source':
        return Icons.battery_charging_full_outlined;
      case 'Interface':
        return Icons.settings_input_hdmi;
      case 'Compatibility':
        return Icons.devices;
      case 'Tech Spec':
        return Icons.memory;
      case 'Material':
        return Icons.texture;
      case 'Fit Style':
        return Icons.checkroom;
      case 'Care':
        return Icons.dry_cleaning_outlined;
      case 'Fabric Weight':
        return Icons.line_weight;
      default:
        return Icons.info_outline;
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    final favoriteIds = ref.watch(favoritesControllerProvider);
    final isFavorited = favoriteIds.contains(widget.product.id);

    final specs = _getSpecsForCategory(widget.product.category);

    // Calculate background image scale & shift for parallax effect
    final imageHeight = 480.0;
    final imageScale = 1.0 + (_scrollOffset > 0 ? _scrollOffset * 0.0008 : 0.0);
    final imageTranslationY = _scrollOffset > 0 ? _scrollOffset * 0.2 : 0.0;

    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: Padding(
          padding: const EdgeInsets.all(8.0),
          child: CircleAvatar(
            backgroundColor: isDark ? Colors.black54 : Colors.white60,
            child: IconButton(
              icon: Icon(Icons.arrow_back, color: theme.colorScheme.primary),
              onPressed: () => Navigator.pop(context),
            ),
          ),
        ),
        actions: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: CircleAvatar(
              backgroundColor: isDark ? Colors.black54 : Colors.white60,
              child: IconButton(
                icon: Icon(
                  isFavorited ? Icons.favorite : Icons.favorite_border,
                  color: isFavorited ? Colors.red : theme.colorScheme.primary,
                ),
                onPressed: () {
                  ref.read(favoritesControllerProvider.notifier).toggleFavorite(widget.product.id);
                },
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: CircleAvatar(
              backgroundColor: isDark ? Colors.black54 : Colors.white60,
              child: IconButton(
                icon: Icon(Icons.share, color: theme.colorScheme.primary),
                onPressed: () {},
              ),
            ),
          ),
        ],
      ),
      body: Stack(
        children: [
          // Sticky Parallax Image background
          Positioned(
            top: -imageTranslationY,
            left: 0,
            right: 0,
            height: imageHeight,
            child: Transform.scale(
              scale: imageScale,
              child: Container(
                color: isDark ? Colors.black12 : Colors.white,
                padding: const EdgeInsets.only(top: 80.0, bottom: 40.0, left: 16.0, right: 16.0),
                child: Image.network(
                  widget.product.image,
                  fit: BoxFit.contain,
                ),
              ),
            ),
          ),

          // Scrollable Content
          SingleChildScrollView(
            controller: _scrollController,
            physics: const AlwaysScrollableScrollPhysics(),
            child: Column(
              children: [
                // Top transparent spacing to align overlay card
                SizedBox(height: imageHeight - 60.0),

                // Slidable spec sheet panel (Glassmorphic)
                Container(
                  width: double.infinity,
                  decoration: BoxDecoration(
                    color: isDark 
                        ? theme.colorScheme.surface.withValues(alpha: 0.85) 
                        : Colors.white.withValues(alpha: 0.85),
                    borderRadius: const BorderRadius.only(
                      topLeft: Radius.circular(40.0),
                      topRight: Radius.circular(40.0),
                    ),
                    border: Border.all(
                      color: theme.colorScheme.secondary.withValues(alpha: 0.15),
                      width: 0.5,
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withValues(alpha: isDark ? 0.4 : 0.08),
                        blurRadius: 30.0,
                        offset: const Offset(0, -10),
                      ),
                    ],
                  ),
                  child: ClipRRect(
                    borderRadius: const BorderRadius.only(
                      topLeft: Radius.circular(40.0),
                      topRight: Radius.circular(40.0),
                    ),
                    child: BackdropFilter(
                      filter: ImageFilter.blur(sigmaX: 16.0, sigmaY: 16.0),
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 12.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            // Pull handle affordance
                            Center(
                              child: Container(
                                width: 48.0,
                                height: 4.0,
                                margin: const EdgeInsets.only(bottom: 24.0),
                                decoration: BoxDecoration(
                                  color: theme.colorScheme.outlineVariant.withValues(alpha: 0.3),
                                  borderRadius: BorderRadius.circular(2.0),
                                ),
                              ),
                            ),

                            // Header details
                            Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        widget.product.category.toUpperCase(),
                                        style: GoogleFonts.inter(
                                          fontSize: 10.0,
                                          fontWeight: FontWeight.w600,
                                          letterSpacing: 1.5,
                                          color: theme.colorScheme.secondary,
                                        ),
                                      ),
                                      const SizedBox(height: 6.0),
                                      Text(
                                        widget.product.title,
                                        style: GoogleFonts.playfairDisplay(
                                          fontSize: 24.0,
                                          fontWeight: FontWeight.bold,
                                          color: theme.colorScheme.primary,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                const SizedBox(width: 16.0),
                                Text(
                                  '\$${widget.product.price.toStringAsFixed(2)}',
                                  style: GoogleFonts.inter(
                                    fontSize: 22.0,
                                    fontWeight: FontWeight.w700,
                                    color: theme.colorScheme.secondary,
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 12.0),

                            // Review Ratings
                            Row(
                              children: [
                                Row(
                                  children: List.generate(5, (index) {
                                    final rate = widget.product.ratingRate;
                                    if (rate >= index + 1) {
                                      return Icon(Icons.star, color: theme.colorScheme.secondary, size: 14.0);
                                    } else if (rate >= index + 0.5) {
                                      return Icon(Icons.star_half, color: theme.colorScheme.secondary, size: 14.0);
                                    } else {
                                      return Icon(Icons.star_border, color: theme.colorScheme.secondary, size: 14.0);
                                    }
                                  }),
                                ),
                                const SizedBox(width: 8.0),
                                Text(
                                  '(${widget.product.ratingCount} Reviews)',
                                  style: GoogleFonts.inter(
                                    fontSize: 12.0,
                                    color: theme.colorScheme.onSurfaceVariant,
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 24.0),

                            // Spec tag chips
                            Wrap(
                              spacing: 8.0,
                              runSpacing: 8.0,
                              children: [
                                _buildChip('Exclusive Selection', theme),
                                _buildChip('Free Express Delivery', theme),
                                _buildChip('5-Year Warranty', theme),
                              ],
                            ),
                            const SizedBox(height: 32.0),

                            // Description
                            Text(
                              'DESCRIPTION',
                              style: GoogleFonts.inter(
                                fontSize: 11.0,
                                fontWeight: FontWeight.bold,
                                letterSpacing: 2.0,
                                color: theme.colorScheme.primary,
                              ),
                            ),
                            const SizedBox(height: 12.0),
                            Text(
                              widget.product.description,
                              style: GoogleFonts.inter(
                                fontSize: 14.0,
                                color: theme.colorScheme.onSurfaceVariant,
                                height: 1.6,
                              ),
                            ),
                            const SizedBox(height: 32.0),

                            // Bento spec grid
                            Text(
                              'SPECIFICATIONS',
                              style: GoogleFonts.inter(
                                fontSize: 11.0,
                                fontWeight: FontWeight.bold,
                                letterSpacing: 2.0,
                                color: theme.colorScheme.primary,
                              ),
                            ),
                            const SizedBox(height: 16.0),
                            GridView.builder(
                              shrinkWrap: true,
                              physics: const NeverScrollableScrollPhysics(),
                              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                                crossAxisCount: 2,
                                crossAxisSpacing: 16.0,
                                mainAxisSpacing: 16.0,
                                childAspectRatio: 1.6,
                              ),
                              itemCount: specs.length,
                              itemBuilder: (context, index) {
                                final title = specs.keys.elementAt(index);
                                final value = specs[title]!;
                                return Container(
                                  padding: const EdgeInsets.all(16.0),
                                  decoration: BoxDecoration(
                                    color: isDark
                                        ? theme.colorScheme.surfaceContainerHighest.withValues(alpha: 0.1)
                                        : theme.colorScheme.surfaceContainerHighest.withValues(alpha: 0.3),
                                    borderRadius: BorderRadius.circular(16.0),
                                    border: Border.all(
                                      color: theme.colorScheme.outlineVariant.withValues(alpha: 0.2),
                                    ),
                                  ),
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Icon(
                                        _getIconForSpec(title),
                                        color: theme.colorScheme.secondary,
                                        size: 18.0,
                                      ),
                                      const Spacer(),
                                      Text(
                                        title.toUpperCase(),
                                        style: GoogleFonts.inter(
                                          fontSize: 9.0,
                                          fontWeight: FontWeight.w600,
                                          letterSpacing: 1.0,
                                          color: theme.colorScheme.onSurfaceVariant,
                                        ),
                                      ),
                                      const SizedBox(height: 2.0),
                                      Text(
                                        value,
                                        style: GoogleFonts.inter(
                                          fontSize: 13.0,
                                          fontWeight: FontWeight.bold,
                                          color: theme.colorScheme.primary,
                                        ),
                                      ),
                                    ],
                                  ),
                                );
                              },
                            ),
                            const SizedBox(height: 120.0), // Spacer for Floating Button
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),

          // Custom animated FAB button in bottom-right
          Positioned(
            bottom: 24.0,
            right: 24.0,
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 300),
              height: 56.0,
              decoration: BoxDecoration(
                color: _isAdded 
                    ? Colors.green.shade600 
                    : theme.colorScheme.primary,
                borderRadius: BorderRadius.circular(28.0),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.2),
                    blurRadius: 10.0,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              child: InkWell(
                onTap: _triggerAddToCart,
                borderRadius: BorderRadius.circular(28.0),
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 24.0),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        _isAdded ? 'ADDED!' : 'ADD TO CART',
                        style: GoogleFonts.inter(
                          fontSize: 12.0,
                          fontWeight: FontWeight.w600,
                          letterSpacing: 1.5,
                          color: _isAdded 
                              ? Colors.white 
                              : theme.colorScheme.onPrimary,
                        ),
                      ),
                      const SizedBox(width: 12.0),
                      Container(
                        width: 32.0,
                        height: 32.0,
                        decoration: BoxDecoration(
                          color: _isAdded 
                              ? Colors.green.shade700 
                              : theme.colorScheme.secondary,
                          shape: BoxShape.circle,
                        ),
                        child: Icon(
                          _isAdded ? Icons.check : Icons.shopping_bag_outlined,
                          color: Colors.white,
                          size: 16.0,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildChip(String label, ThemeData theme) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12.0, vertical: 6.0),
      decoration: BoxDecoration(
        color: theme.colorScheme.secondary.withValues(alpha: 0.08),
        border: Border.all(
          color: theme.colorScheme.secondary.withValues(alpha: 0.2),
          width: 0.5,
        ),
        borderRadius: BorderRadius.circular(20.0),
      ),
      child: Text(
        label,
        style: GoogleFonts.inter(
          fontSize: 11.0,
          fontWeight: FontWeight.w500,
          color: theme.colorScheme.secondary,
        ),
      ),
    );
  }
}
