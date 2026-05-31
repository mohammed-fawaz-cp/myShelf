import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../products/domain/entities/product.dart';
import '../../domain/models/cart_item.dart';
import '../../domain/repositories/i_cart_repository.dart';
import '../../data/repositories/cart_repository.dart';

class CartNotifier extends StateNotifier<List<CartItem>> {
  final ICartRepository _repository;

  CartNotifier(this._repository) : super([]) {
    _loadCart();
  }

  Future<void> _loadCart() async {
    final list = await _repository.getCart();
    state = list;
  }

  Future<void> addToCart(Product product) async {
    final index = state.indexWhere((item) => item.product.id == product.id);
    if (index != -1) {
      final updated = List<CartItem>.from(state);
      updated[index] = updated[index].copyWith(quantity: updated[index].quantity + 1);
      state = updated;
    } else {
      state = [...state, CartItem(product: product, quantity: 1)];
    }
    await _repository.saveCart(state);
  }

  Future<void> removeFromCart(int productId) async {
    state = state.where((item) => item.product.id != productId).toList();
    await _repository.saveCart(state);
  }

  Future<void> updateQuantity(int productId, int quantity) async {
    if (quantity <= 0) {
      await removeFromCart(productId);
      return;
    }
    state = state.map((item) {
      if (item.product.id == productId) {
        return item.copyWith(quantity: quantity);
      }
      return item;
    }).toList();
    await _repository.saveCart(state);
  }

  double get totalAmount => state.fold(0, (sum, item) => sum + item.total);
}

final cartControllerProvider = StateNotifierProvider<CartNotifier, List<CartItem>>((ref) {
  final repository = ref.watch(cartRepositoryProvider);
  return CartNotifier(repository);
});
