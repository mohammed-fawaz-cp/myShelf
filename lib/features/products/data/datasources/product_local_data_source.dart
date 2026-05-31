import 'dart:convert';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../../../core/theme/theme_provider.dart';
import '../models/product_model.dart';

abstract class IProductLocalDataSource {
  Future<List<ProductModel>> getProducts();
  Future<void> cacheProducts(List<ProductModel> products);
  Future<List<String>> getCategories();
  Future<void> cacheCategories(List<String> categories);
}

class ProductLocalDataSourceImpl implements IProductLocalDataSource {
  final SharedPreferences _prefs;
  static const _productsKey = 'cached_products';
  static const _categoriesKey = 'cached_categories';

  ProductLocalDataSourceImpl(this._prefs);

  @override
  Future<List<ProductModel>> getProducts() async {
    final jsonString = _prefs.getString(_productsKey);
    if (jsonString != null) {
      final List decoded = jsonDecode(jsonString);
      return decoded.map((item) => ProductModel.fromJson(item)).toList();
    }
    return [];
  }

  @override
  Future<void> cacheProducts(List<ProductModel> products) async {
    final jsonString = jsonEncode(products.map((p) => p.toJson()).toList());
    await _prefs.setString(_productsKey, jsonString);
  }

  @override
  Future<List<String>> getCategories() async {
    return _prefs.getStringList(_categoriesKey) ?? [];
  }

  @override
  Future<void> cacheCategories(List<String> categories) async {
    await _prefs.setStringList(_categoriesKey, categories);
  }
}

final productLocalDataSourceProvider = Provider<IProductLocalDataSource>((ref) {
  final prefs = ref.watch(sharedPreferencesProvider);
  return ProductLocalDataSourceImpl(prefs);
});
