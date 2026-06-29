import 'package:petapp/features/store/models/shipping_address_model.dart';

class OrderListItemModel {
  final String id;
  final String status;
  final String paymentStatus;
  final String paymentMethod;
  final double subtotal;
  final double shippingAmount;
  final double discountAmount;
  final double totalAmount;
  final int itemCount;
  final String createdAt;

  const OrderListItemModel({
    required this.id,
    required this.status,
    required this.paymentStatus,
    required this.paymentMethod,
    required this.subtotal,
    required this.shippingAmount,
    required this.discountAmount,
    required this.totalAmount,
    required this.itemCount,
    required this.createdAt,
  });

  factory OrderListItemModel.fromJson(Map<String, dynamic> json) {
    return OrderListItemModel(
      id: json['id'] as String,
      status: json['status'] as String,
      paymentStatus: json['paymentStatus'] as String,
      paymentMethod: json['paymentMethod'] as String,
      subtotal: (json['subtotal'] as num).toDouble(),
      shippingAmount: (json['shippingAmount'] as num).toDouble(),
      discountAmount: (json['discountAmount'] as num?)?.toDouble() ?? 0,
      totalAmount: (json['totalAmount'] as num).toDouble(),
      itemCount: json['itemCount'] as int? ?? 0,
      createdAt: json['createdAt'] as String,
    );
  }
}

class OrderItemModel {
  final String id;
  final String? productId;
  final String? variantId;
  final String productTitle;
  final String? variantTitle;
  final int quantity;
  final double unitPrice;
  final double totalPrice;
  final dynamic product;

  const OrderItemModel({
    required this.id,
    this.productId,
    this.variantId,
    required this.productTitle,
    this.variantTitle,
    required this.quantity,
    required this.unitPrice,
    required this.totalPrice,
    this.product,
  });

  String? get imageUrl {
    if (product is Map<String, dynamic>) {
      return product['imageUrl'] as String?;
    }
    return null;
  }

  factory OrderItemModel.fromJson(Map<String, dynamic> json) {
    return OrderItemModel(
      id: json['id'] as String,
      productId: json['productId'] as String?,
      variantId: json['variantId'] as String?,
      productTitle: json['productTitle'] as String? ?? '',
      variantTitle: json['variantTitle'] as String?,
      quantity: json['quantity'] as int,
      unitPrice: (json['unitPrice'] as num).toDouble(),
      totalPrice: (json['totalPrice'] as num).toDouble(),
      product: json['product'],
    );
  }
}

class OrderDetailModel {
  final String id;
  final String status;
  final String paymentStatus;
  final String paymentMethod;
  final double subtotal;
  final double shippingAmount;
  final double discountAmount;
  final double totalAmount;
  final dynamic shippingAddress;
  final String createdAt;
  final List<OrderItemModel> items;

  const OrderDetailModel({
    required this.id,
    required this.status,
    required this.paymentStatus,
    required this.paymentMethod,
    required this.subtotal,
    required this.shippingAmount,
    required this.discountAmount,
    required this.totalAmount,
    this.shippingAddress,
    required this.createdAt,
    required this.items,
  });

  bool get canConfirmDelivery => status == 'shipped';
  bool get requiresPaymentProof =>
      (paymentMethod == 'vodafone_cash' || paymentMethod == 'instapay') &&
      paymentStatus == 'pending';

  ShippingAddressModel? get parsedShippingAddress {
    if (shippingAddress is Map<String, dynamic>) {
      try {
        return ShippingAddressModel.fromJson(shippingAddress as Map<String, dynamic>);
      } catch (_) {}
    }
    return null;
  }

  factory OrderDetailModel.fromJson(Map<String, dynamic> json) {
    final data = json['data'] as Map<String, dynamic>? ?? json;
    return OrderDetailModel(
      id: data['id'] as String,
      status: data['status'] as String,
      paymentStatus: data['paymentStatus'] as String,
      paymentMethod: data['paymentMethod'] as String,
      subtotal: (data['subtotal'] as num).toDouble(),
      shippingAmount: (data['shippingAmount'] as num).toDouble(),
      discountAmount: (data['discountAmount'] as num?)?.toDouble() ?? 0,
      totalAmount: (data['totalAmount'] as num).toDouble(),
      shippingAddress: data['shippingAddress'],
      createdAt: data['createdAt'] as String,
      items: (data['items'] as List<dynamic>?)
              ?.map((e) => OrderItemModel.fromJson(e as Map<String, dynamic>))
              .toList() ??
          [],
    );
  }
}

class OrderTrackingEventModel {
  final String id;
  final String status;
  final String? description;
  final String? location;
  final String createdAt;

  const OrderTrackingEventModel({
    required this.id,
    required this.status,
    this.description,
    this.location,
    required this.createdAt,
  });

  factory OrderTrackingEventModel.fromJson(Map<String, dynamic> json) {
    return OrderTrackingEventModel(
      id: json['id'] as String,
      status: json['status'] as String,
      description: json['description'] as String?,
      location: json['location'] as String?,
      createdAt: json['createdAt'] as String,
    );
  }
}

