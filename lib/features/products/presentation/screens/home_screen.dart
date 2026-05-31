import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:myshelf/core/theme/theme_provider.dart';
import 'package:myshelf/features/auth/presentation/controllers/auth_controller.dart';
import 'package:myshelf/features/favorites/presentation/screens/favorites_screen.dart';
import 'package:myshelf/features/favorites/presentation/controllers/favorites_controller.dart';
import 'package:myshelf/features/cart/presentation/screens/cart_screen.dart';
import 'package:myshelf/features/cart/presentation/controllers/cart_controller.dart';
import 'shop_view.dart';
import 'dashboard_view.dart';

class HomeScreen extends ConsumerStatefulWidget {
  const HomeScreen({super.key});

  @override
  ConsumerState<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends ConsumerState<HomeScreen> {
  int _currentIndex = 0;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    final favCount = ref.watch(favoritesControllerProvider).length;
    final cartCount = ref.watch(cartControllerProvider).length;

    // Tab content views
    final List<Widget> children = [
      const DashboardView(),
      const ShopView(),
      CartScreen(
        onExplore: () {
          setState(() {
            _currentIndex = 0;
          });
        },
      ),
      FavoritesScreen(
        onExploreArrivals: () {
          setState(() {
            _currentIndex = 0;
          });
        },
      ),
      _buildProfileScreen(context),
    ];

    return Scaffold(
      drawer: _buildDrawer(context),
      appBar: AppBar(
        backgroundColor: theme.colorScheme.surface.withValues(alpha: 0.8),
        elevation: 0,
        scrolledUnderElevation: 0,
        flexibleSpace: ClipRect(
          child: BackdropFilter(
            filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
            child: Container(color: Colors.transparent),
          ),
        ),
        title: Text(
          'myShelf',
          style: GoogleFonts.playfairDisplay(
            fontSize: 24.0,
            fontWeight: FontWeight.bold,
            color: theme.colorScheme.primary,
            letterSpacing: -0.5,
          ),
        ),
        centerTitle: true,
        leading: Builder(
          builder: (context) => IconButton(
            icon: Icon(Icons.menu, color: theme.colorScheme.primary),
            onPressed: () => Scaffold.of(context).openDrawer(),
          ),
        ),
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(1.0),
          child: Container(
            color: theme.colorScheme.outlineVariant.withValues(alpha: 0.3),
            height: 1.0,
          ),
        ),
      ),
      body: Stack(
        children: [
          // Body content
          children[_currentIndex],

          // Glassmorphic Custom Bottom Navigation Bar
          Positioned(
            left: 0,
            right: 0,
            bottom: 0,
            child: SafeArea(
              top: false,
              child: Container(
                margin: const EdgeInsets.all(16.0),
                height: 72.0,
                decoration: BoxDecoration(
                  color: isDark 
                      ? theme.colorScheme.surface.withValues(alpha: 0.7) 
                      : Colors.white.withValues(alpha: 0.7),
                  borderRadius: BorderRadius.circular(24.0),
                  border: Border.all(
                    color: theme.colorScheme.outlineVariant.withValues(alpha: 0.2),
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withValues(alpha: isDark ? 0.3 : 0.05),
                      blurRadius: 20.0,
                      offset: const Offset(0, -4),
                    ),
                  ],
                ),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(24.0),
                  child: BackdropFilter(
                    filter: ImageFilter.blur(sigmaX: 12.0, sigmaY: 12.0),
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 12.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                          _buildNavItem(0, Icons.home_outlined, Icons.home, 'Home', theme),
                          _buildNavItem(1, Icons.storefront, Icons.storefront, 'Shop', theme),
                          _buildNavItem(2, Icons.shopping_bag_outlined, Icons.shopping_bag, 'Cart', theme, badgeCount: cartCount),
                          _buildNavItem(3, Icons.favorite_border, Icons.favorite, 'Saved', theme, badgeCount: favCount),
                          _buildNavItem(4, Icons.person_outline, Icons.person, 'Profile', theme),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildNavItem(int index, IconData outlineIcon, IconData filledIcon, String label, ThemeData theme, {int badgeCount = 0}) {
    final isSelected = _currentIndex == index;
    final isDark = theme.brightness == Brightness.dark;

    final activeColor = isDark ? theme.colorScheme.primary : theme.colorScheme.secondary;
    final inactiveColor = theme.colorScheme.onSurfaceVariant.withValues(alpha: 0.7);

    return GestureDetector(
      onTap: () {
        setState(() {
          _currentIndex = index;
        });
      },
      behavior: HitTestBehavior.opaque,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 300),
        padding: const EdgeInsets.symmetric(horizontal: 12.0, vertical: 8.0),
        decoration: isSelected
            ? BoxDecoration(
                color: theme.colorScheme.secondary.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(20.0),
              )
            : null,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Stack(
              clipBehavior: Clip.none,
              children: [
                Icon(
                  isSelected ? filledIcon : outlineIcon,
                  color: isSelected ? activeColor : inactiveColor,
                  size: 22.0,
                ),
                if (badgeCount > 0)
                  Positioned(
                    top: -4,
                    right: -6,
                    child: Container(
                      padding: const EdgeInsets.all(4.0),
                      decoration: const BoxDecoration(
                        color: Colors.red,
                        shape: BoxShape.circle,
                      ),
                      constraints: const BoxConstraints(
                        minWidth: 16.0,
                        minHeight: 16.0,
                      ),
                      child: Text(
                        badgeCount.toString(),
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 9.0,
                          fontWeight: FontWeight.bold,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ),
                  ),
              ],
            ),
            const SizedBox(height: 4.0),
            Text(
              label.toUpperCase(),
              style: GoogleFonts.inter(
                fontSize: 9.0,
                fontWeight: isSelected ? FontWeight.w700 : FontWeight.w500,
                letterSpacing: 1.0,
                color: isSelected ? activeColor : inactiveColor,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDummyScreen({
    required String title,
    required String subtitle,
    required IconData icon,
    required BuildContext context,
  }) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              width: 100.0,
              height: 100.0,
              decoration: BoxDecoration(
                color: isDark
                    ? theme.colorScheme.surfaceContainerHighest.withValues(alpha: 0.1)
                    : theme.colorScheme.surfaceContainerHighest.withValues(alpha: 0.3),
                shape: BoxShape.circle,
                border: Border.all(
                  color: theme.colorScheme.outlineVariant.withValues(alpha: 0.3),
                ),
              ),
              child: Icon(
                icon,
                color: theme.colorScheme.secondary,
                size: 36.0,
              ),
            ),
            const SizedBox(height: 24.0),
            Text(
              title,
              style: GoogleFonts.playfairDisplay(
                fontSize: 24.0,
                fontWeight: FontWeight.w600,
                color: theme.colorScheme.primary,
              ),
            ),
            const SizedBox(height: 8.0),
            Text(
              subtitle,
              style: GoogleFonts.inter(
                fontSize: 14.0,
                color: theme.colorScheme.onSurfaceVariant,
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildProfileScreen(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    final favCount = ref.watch(favoritesControllerProvider).length;

    return Center(
      child: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 48.0),
        child: Column(
          children: [
            // User Avatar Grid
            Container(
              width: 96.0,
              height: 96.0,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(
                  color: theme.colorScheme.secondary,
                  width: 2.0,
                ),
                color: theme.colorScheme.secondary.withValues(alpha: 0.1),
              ),
              child: Icon(
                Icons.person,
                size: 48.0,
                color: theme.colorScheme.secondary,
              ),
            ),
            const SizedBox(height: 16.0),
            Text(
              'Premium Collector',
              style: GoogleFonts.playfairDisplay(
                fontSize: 24.0,
                fontWeight: FontWeight.w600,
                color: theme.colorScheme.primary,
              ),
            ),
            const SizedBox(height: 4.0),
            Text(
              'collector@myshelf.com',
              style: GoogleFonts.inter(
                fontSize: 14.0,
                color: theme.colorScheme.onSurfaceVariant,
              ),
            ),
            const SizedBox(height: 32.0),

            // User Bento spec
            Container(
              padding: const EdgeInsets.all(20.0),
              decoration: BoxDecoration(
                color: isDark
                    ? theme.colorScheme.surfaceContainerHighest.withValues(alpha: 0.15)
                    : Colors.white,
                borderRadius: BorderRadius.circular(16.0),
                border: Border.all(
                  color: theme.colorScheme.outlineVariant.withOpacity(0.2),
                ),
              ),
              child: Column(
                children: [
                  _buildProfileSpecItem(
                    Icons.stars,
                    'Membership Tier',
                    'Royal Platinum',
                    theme,
                  ),
                  const Divider(height: 24.0),
                  _buildProfileSpecItem(
                    Icons.favorite_rounded,
                    'Saved Masterpieces',
                    '$favCount items',
                    theme,
                  ),
                  const Divider(height: 24.0),
                  _buildProfileSpecItem(
                    Icons.lock_clock,
                    'Account Established',
                    'May 2026',
                    theme,
                  ),
                ],
              ),
            ),
            const SizedBox(height: 32.0),

            // Logout Action Button
            OutlinedButton.icon(
              onPressed: () {
                ref.read(authControllerProvider.notifier).logout();
              },
              style: OutlinedButton.styleFrom(
                side: BorderSide(color: theme.colorScheme.error),
                padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 12.0),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(24.0),
                ),
              ),
              icon: Icon(Icons.logout, color: theme.colorScheme.error, size: 16.0),
              label: Text(
                'Sign Out',
                style: GoogleFonts.inter(
                  color: theme.colorScheme.error,
                  fontWeight: FontWeight.w600,
                  fontSize: 13.0,
                ),
              ),
            ),
            const SizedBox(height: 80.0), // Margin bottom nav
          ],
        ),
      ),
    );
  }

  Widget _buildProfileSpecItem(IconData icon, String title, String value, ThemeData theme) {
    return Row(
      children: [
        Icon(icon, color: theme.colorScheme.secondary, size: 20.0),
        const SizedBox(width: 12.0),
        Expanded(
          child: Text(
            title,
            style: GoogleFonts.inter(
              fontSize: 14.0,
              color: theme.colorScheme.onSurfaceVariant,
            ),
          ),
        ),
        Text(
          value,
          style: GoogleFonts.inter(
            fontSize: 14.0,
            fontWeight: FontWeight.w600,
            color: theme.colorScheme.primary,
          ),
        ),
      ],
    );
  }

  Widget _buildDrawer(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = ref.watch(themeProvider) == ThemeMode.dark;

    return Drawer(
      backgroundColor: theme.scaffoldBackgroundColor,
      child: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Drawer Header
            Padding(
              padding: const EdgeInsets.all(24.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'myShelf',
                    style: GoogleFonts.playfairDisplay(
                      fontSize: 32.0,
                      fontWeight: FontWeight.bold,
                      color: theme.colorScheme.primary,
                    ),
                  ),
                  const SizedBox(height: 8.0),
                  Text(
                    'Curated luxury at your fingertips.',
                    style: GoogleFonts.inter(
                      fontSize: 12.0,
                      color: theme.colorScheme.onSurfaceVariant,
                    ),
                  ),
                ],
              ),
            ),
            const Divider(),

            // Theme Switcher Tile
            ListTile(
              leading: Icon(
                isDark ? Icons.light_mode : Icons.dark_mode,
                color: theme.colorScheme.secondary,
              ),
              title: Text(
                isDark ? 'Light Appearance' : 'Dark Appearance',
                style: GoogleFonts.inter(fontWeight: FontWeight.w500),
              ),
              trailing: Switch(
                value: isDark,
                activeThumbColor: theme.colorScheme.primary,
                onChanged: (_) {
                  ref.read(themeProvider.notifier).toggleTheme();
                },
              ),
            ),

            const Spacer(),
            const Divider(),

            // Logout Footer
            ListTile(
              leading: Icon(Icons.logout, color: theme.colorScheme.error),
              title: Text(
                'Log Out',
                style: GoogleFonts.inter(
                  color: theme.colorScheme.error,
                  fontWeight: FontWeight.w600,
                ),
              ),
              onTap: () {
                Navigator.pop(context); // Close drawer
                ref.read(authControllerProvider.notifier).logout();
              },
            ),
            const SizedBox(height: 16.0),
          ],
        ),
      ),
    );
  }
}
