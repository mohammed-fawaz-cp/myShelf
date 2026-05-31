import '../../../products/domain/entities/product.dart';

class CartItem {
  final Product product;
  final int quantity;

  const CartItem({
    required this.product,
    required this.quantity,
  });

  CartItem copyWith({
    Product? product,
    int? quantity,
  }) {
    return CartItem(
      product: product ?? this.product,
      quantity: quantity ?? this.quantity,
    );
  }

  double get total => product.price * quantity;

  Map<String, dynamic> toJson() {
    return {
      'product': {
        'id': product.id,
        'title': product.title,
        'price': product.price,
        'description': product.description,
        'category': product.category,
        'image': product.image,
        'ratingRate': product.ratingRate,
        'ratingCount': product.ratingCount,
      },
      'quantity': quantity,
    };
  }

  factory CartItem.fromJson(Map<String, dynamic> json) {
    final p = json['product'] as Map<String, dynamic>;
    return CartItem(
      product: Product(
        id: p['id'],
        title: p['title'],
        price: (p['price'] as num).toDouble(),
        description: p['description'],
        category: p['category'],
        image: p['image'],
        ratingRate: (p['ratingRate'] as num).toDouble(),
        ratingCount: p['ratingCount'],
      ),
      quantity: json['quantity'],
    );
  }
}
