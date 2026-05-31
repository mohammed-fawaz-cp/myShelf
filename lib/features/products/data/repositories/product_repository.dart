import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/error/failures.dart';
import '../../domain/entities/product.dart';
import '../../domain/repositories/i_product_repository.dart';
import '../datasources/product_remote_data_source.dart';
import '../datasources/product_local_data_source.dart';

class ProductRepositoryImpl implements IProductRepository {
  final IProductRemoteDataSource _remoteDataSource;
  final IProductLocalDataSource _localDataSource;

  ProductRepositoryImpl(this._remoteDataSource, this._localDataSource);

  @override
  Future<List<Product>> getProducts() async {
    try {
      final products = await _remoteDataSource.getProducts();
      await _localDataSource.cacheProducts(products);
      return products;
    } catch (e) {
      final localProducts = await _localDataSource.getProducts();
      if (localProducts.isNotEmpty) {
        return localProducts;
      }
      return Future.error(ServerFailure('Unable to load products. Please check your network connection: $e'));
    }
  }

  @override
  Future<List<String>> getCategories() async {
    try {
      final categories = await _remoteDataSource.getCategories();
      await _localDataSource.cacheCategories(categories);
      return categories;
    } catch (e) {
      final localCategories = await _localDataSource.getCategories();
      if (localCategories.isNotEmpty) {
        return localCategories;
      }
      return Future.error(ServerFailure('Unable to load categories: $e'));
    }
  }
}

final productRepositoryProvider = Provider<IProductRepository>((ref) {
  final remoteDataSource = ref.watch(productRemoteDataSourceProvider);
  final localDataSource = ref.watch(productLocalDataSourceProvider);
  return ProductRepositoryImpl(remoteDataSource, localDataSource);
});
