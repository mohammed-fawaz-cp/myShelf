import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../entities/product.dart';
import '../repositories/i_product_repository.dart';
import '../../data/repositories/product_repository.dart';

class GetProducts {
  final IProductRepository _repository;

  GetProducts(this._repository);

  Future<List<Product>> call() {
    return _repository.getProducts();
  }
}

final getProductsUseCaseProvider = Provider<GetProducts>((ref) {
  final repository = ref.watch(productRepositoryProvider);
  return GetProducts(repository);
});
