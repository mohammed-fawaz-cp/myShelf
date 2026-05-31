import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../domain/repositories/i_cart_repository.dart';
import '../datasources/cart_local_data_source.dart';
import '../../domain/models/cart_item.dart';

class CartRepositoryImpl implements ICartRepository {
  final ICartLocalDataSource _localDataSource;

  CartRepositoryImpl(this._localDataSource);

  @override
  Future<List<CartItem>> getCart() async {
    return _localDataSource.getCart();
  }

  @override
  Future<void> saveCart(List<CartItem> items) async {
    await _localDataSource.saveCart(items);
  }
}

final cartRepositoryProvider = Provider<ICartRepository>((ref) {
  final localDataSource = ref.watch(cartLocalDataSourceProvider);
  return CartRepositoryImpl(localDataSource);
});
