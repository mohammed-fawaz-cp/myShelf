import '../models/cart_item.dart';

abstract class ICartRepository {
  Future<List<CartItem>> getCart();
  Future<void> saveCart(List<CartItem> items);
}
