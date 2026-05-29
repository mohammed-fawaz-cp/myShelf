import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../repositories/i_product_repository.dart';
import '../../data/repositories/product_repository.dart';

class GetCategories {
  final IProductRepository _repository;

  GetCategories(this._repository);

  Future<List<String>> call() {
    return _repository.getCategories();
  }
}

final getCategoriesUseCaseProvider = Provider<GetCategories>((ref) {
  final repository = ref.watch(productRepositoryProvider);
  return GetCategories(repository);
});
