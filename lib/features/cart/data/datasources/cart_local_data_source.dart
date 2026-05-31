import 'dart:convert';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../../../core/theme/theme_provider.dart';
import '../../domain/models/cart_item.dart';

abstract class ICartLocalDataSource {
  List<CartItem> getCart();
  Future<void> saveCart(List<CartItem> items);
}

class CartLocalDataSourceImpl implements ICartLocalDataSource {
  final SharedPreferences _prefs;
  static const _cartKey = 'shopping_cart_items';

  CartLocalDataSourceImpl(this._prefs);

  @override
  List<CartItem> getCart() {
    final list = _prefs.getStringList(_cartKey) ?? [];
    return list.map((itemStr) => CartItem.fromJson(jsonDecode(itemStr))).toList();
  }

  @override
  Future<void> saveCart(List<CartItem> items) async {
    final list = items.map((item) => jsonEncode(item.toJson())).toList();
    await _prefs.setStringList(_cartKey, list);
  }
}

final cartLocalDataSourceProvider = Provider<ICartLocalDataSource>((ref) {
  final prefs = ref.watch(sharedPreferencesProvider);
  return CartLocalDataSourceImpl(prefs);
});
