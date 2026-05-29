import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/error/failures.dart';
import '../../domain/entities/product.dart';
import '../../domain/repositories/i_product_repository.dart';
import '../datasources/product_remote_data_source.dart';

class ProductRepositoryImpl implements IProductRepository {
  final IProductRemoteDataSource _remoteDataSource;

  ProductRepositoryImpl(this._remoteDataSource);

  @override
  Future<List<Product>> getProducts() async {
    try {
      final products = await _remoteDataSource.getProducts();
      return products;
    } catch (e) {
      return Future.error(ServerFailure('Unable to load products. Please check your network connection: $e'));
    }
  }

  @override
  Future<List<String>> getCategories() async {
    try {
      final categories = await _remoteDataSource.getCategories();
      return categories;
    } catch (e) {
      return Future.error(ServerFailure('Unable to load categories: $e'));
    }
  }
}

final productRepositoryProvider = Provider<IProductRepository>((ref) {
  final remoteDataSource = ref.watch(productRemoteDataSourceProvider);
  return ProductRepositoryImpl(remoteDataSource);
});
