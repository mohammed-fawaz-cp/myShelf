import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/network/dio_client.dart';
import '../models/product_model.dart';

abstract class IProductRemoteDataSource {
  Future<List<ProductModel>> getProducts();
  Future<List<String>> getCategories();
}

class ProductRemoteDataSourceImpl implements IProductRemoteDataSource {
  final Dio _dio;

  ProductRemoteDataSourceImpl(this._dio);

  @override
  Future<List<ProductModel>> getProducts() async {
    try {
      final response = await _dio.get('products');
      if (response.statusCode == 200) {
        final list = response.data as List;
        return list.map((item) => ProductModel.fromJson(item as Map<String, dynamic>)).toList();
      } else {
        throw DioException(
          requestOptions: response.requestOptions,
          response: response,
          message: 'Failed to fetch products from server: ${response.statusCode}',
        );
      }
    } catch (e) {
      rethrow;
    }
  }

  @override
  Future<List<String>> getCategories() async {
    try {
      final response = await _dio.get('products/categories');
      if (response.statusCode == 200) {
        final list = response.data as List;
        return list.map((item) => item.toString()).toList();
      } else {
        throw DioException(
          requestOptions: response.requestOptions,
          response: response,
          message: 'Failed to fetch categories from server: ${response.statusCode}',
        );
      }
    } catch (e) {
      rethrow;
    }
  }
}

final productRemoteDataSourceProvider = Provider<IProductRemoteDataSource>((ref) {
  final dio = ref.watch(dioProvider);
  return ProductRemoteDataSourceImpl(dio);
});
