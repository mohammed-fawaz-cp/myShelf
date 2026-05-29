import '../../domain/entities/product.dart';

abstract class IProductRepository {
  Future<List<Product>> getProducts();
  Future<List<String>> getCategories();
}
