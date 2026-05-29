import 'package:flutter_test/flutter_test.dart';
import 'package:myshelf/features/products/data/models/product_model.dart';

void main() {
  group('ProductModel JSON Parsing Tests', () {
    test('should successfully parse valid product JSON parameters', () {
      final json = {
        'id': 1,
        'title': 'Test Product',
        'price': 109.95,
        'description': 'A premium collection item.',
        'category': "men's clothing",
        'image': 'https://fakestoreapi.com/img/81fPKd.png',
        'rating': {
          'rate': 3.9,
          'count': 120,
        }
      };

      final model = ProductModel.fromJson(json);

      expect(model.id, 1);
      expect(model.title, 'Test Product');
      expect(model.price, 109.95);
      expect(model.description, 'A premium collection item.');
      expect(model.category, "men's clothing");
      expect(model.image, 'https://fakestoreapi.com/img/81fPKd.png');
      expect(model.ratingRate, 3.9);
      expect(model.ratingCount, 120);
    });

    test('should safely handle type coercions for price (int) and rating (null)', () {
      final json = {
        'id': '10', // String ID that needs parsing to int
        'title': 'Minimalist Lamp',
        'price': 1250, // int price that needs to convert to double
        'description': 'Warm gold glow.',
        'category': 'home decor',
        'image': 'https://example.com/lamp.png',
        'rating': null // null rating mapping
      };

      final model = ProductModel.fromJson(json);

      expect(model.id, 10);
      expect(model.price, 1250.0);
      expect(model.ratingRate, 0.0);
      expect(model.ratingCount, 0);
    });
  });
}
