import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../domain/entities/product.dart';
import '../../domain/usecases/get_products.dart';
import '../../domain/usecases/get_categories.dart';

// Provider to fetch all products from repository
final productsFutureProvider = FutureProvider<List<Product>>((ref) async {
  final getProducts = ref.watch(getProductsUseCaseProvider);
  return getProducts();
});

// Provider to fetch categories and prepend 'All' for the UI chips
final categoriesFutureProvider = FutureProvider<List<String>>((ref) async {
  final getCategories = ref.watch(getCategoriesUseCaseProvider);
  final categories = await getCategories();
  
  // Normalize category titles for display (e.g. capitalize first letter of each word)
  final normalized = categories.map((c) {
    if (c.isEmpty) return c;
    return c; // We'll keep the original API values for matching, but format display in UI
  }).toList();

  return ['All', ...normalized];
});

// Provider for the currently active category filter
final selectedCategoryProvider = StateProvider<String>((ref) => 'All');

// Provider that dynamically filters the product list based on the active category
final filteredProductsProvider = Provider<AsyncValue<List<Product>>>((ref) {
  final productsAsync = ref.watch(productsFutureProvider);
  final selectedCategory = ref.watch(selectedCategoryProvider);

  return productsAsync.whenData((products) {
    if (selectedCategory == 'All') {
      return products;
    }
    // API returns lowercase categories, so we compare case-insensitively
    return products.where((product) =>
      product.category.trim().toLowerCase() == selectedCategory.trim().toLowerCase()
    ).toList();
  });
});
