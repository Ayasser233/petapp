class CartItemApiModel {
  final String variantId;
  final String productId;
  final int quantity;
  final double unitPrice;
  final double lineTotal;
  final dynamic product; // enriched product data on read

  const CartItemApiModel({
    required this.variantId,
    required this.productId,
    required this.quantity,
    required this.unitPrice,
    required this.lineTotal,
    this.product,
  });

  String? get productTitle {
    if (product is Map<String, dynamic>) {
      return product['title'] as String?;
    }
    return null;
  }

  String? get productImageUrl {
    if (product is Map<String, dynamic>) {
      return product['imageUrl'] as String?;
    }
    return null;
  }

  String? get variantTitle {
    if (product is Map<String, dynamic>) {
      final variants = product['variants'];
      if (variants is List && variants.isNotEmpty) {
        for (final v in variants) {
          if (v is Map<String, dynamic> && v['id'] == variantId) {
            return v['title'] as String?;
          }
        }
      }
    }
    return null;
  }

  factory CartItemApiModel.fromJson(Map<String, dynamic> json) {
    return CartItemApiModel(
      variantId: json['variantId'] as String,
      productId: json['productId'] as String,
      quantity: json['quantity'] as int,
      unitPrice: (json['unitPrice'] as num).toDouble(),
      lineTotal: (json['lineTotal'] as num).toDouble(),
      product: json['product'],
    );
  }
}

class CartModel {
  final String? cartId;
  final List<CartItemApiModel> items;
  final double subtotal;
  final String? updatedAt;

  const CartModel({
    this.cartId,
    required this.items,
    required this.subtotal,
    this.updatedAt,
  });

  bool get isEmpty => items.isEmpty;
  int get itemCount => items.fold(0, (sum, e) => sum + e.quantity);

  factory CartModel.empty() => const CartModel(items: [], subtotal: 0);

  factory CartModel.fromJson(Map<String, dynamic> json) {
    final data = json['data'] as Map<String, dynamic>? ?? json;
    return CartModel(
      cartId: data['cartId'] as String?,
      items: (data['items'] as List<dynamic>?)
              ?.map((e) => CartItemApiModel.fromJson(e as Map<String, dynamic>))
              .toList() ??
          [],
      subtotal: (data['subtotal'] as num?)?.toDouble() ?? 0.0,
      updatedAt: data['updatedAt'] as String?,
    );
  }
}
