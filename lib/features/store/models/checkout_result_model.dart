class CheckoutPriceWarning {
  final String variantId;
  final double oldPrice;
  final double newPrice;

  const CheckoutPriceWarning({
    required this.variantId,
    required this.oldPrice,
    required this.newPrice,
  });

  factory CheckoutPriceWarning.fromJson(Map<String, dynamic> json) {
    return CheckoutPriceWarning(
      variantId: json['variantId'] as String,
      oldPrice: (json['oldPrice'] as num).toDouble(),
      newPrice: (json['newPrice'] as num).toDouble(),
    );
  }
}

class CheckoutSummaryItemModel {
  final String variantId;
  final String productId;
  final String? sku;
  final int quantity;
  final double unitPrice;
  final double lineTotal;
  final String? productTitle;
  final String? variantTitle;

  const CheckoutSummaryItemModel({
    required this.variantId,
    required this.productId,
    this.sku,
    required this.quantity,
    required this.unitPrice,
    required this.lineTotal,
    this.productTitle,
    this.variantTitle,
  });

  factory CheckoutSummaryItemModel.fromJson(Map<String, dynamic> json) {
    return CheckoutSummaryItemModel(
      variantId: json['variantId'] as String,
      productId: json['productId'] as String,
      sku: json['sku'] as String?,
      quantity: json['quantity'] as int,
      unitPrice: (json['unitPrice'] as num).toDouble(),
      lineTotal: (json['lineTotal'] as num).toDouble(),
      productTitle: json['productTitle'] as String?,
      variantTitle: json['variantTitle'] as String?,
    );
  }
}

class CheckoutSummaryModel {
  final List<CheckoutSummaryItemModel> items;
  final double subtotal;
  final double shippingAmount;
  final double discountAmount;
  final double totalAmount;
  final List<CheckoutPriceWarning> warnings;

  const CheckoutSummaryModel({
    required this.items,
    required this.subtotal,
    required this.shippingAmount,
    required this.discountAmount,
    required this.totalAmount,
    this.warnings = const [],
  });

  factory CheckoutSummaryModel.fromJson(Map<String, dynamic> json) {
    return CheckoutSummaryModel(
      items: (json['items'] as List<dynamic>?)
              ?.map((e) => CheckoutSummaryItemModel.fromJson(e as Map<String, dynamic>))
              .toList() ??
          [],
      subtotal: (json['subtotal'] as num).toDouble(),
      shippingAmount: (json['shippingAmount'] as num).toDouble(),
      discountAmount: (json['discountAmount'] as num?)?.toDouble() ?? 0,
      totalAmount: (json['totalAmount'] as num).toDouble(),
      warnings: (json['warnings'] as List<dynamic>?)
              ?.map((e) => CheckoutPriceWarning.fromJson(e as Map<String, dynamic>))
              .toList() ??
          [],
    );
  }
}

class InitiateCheckoutResultModel {
  final CheckoutSummaryModel summary;
  final String orderId;
  final String orderName;
  final String paymentMethod;
  final String financialStatus;

  const InitiateCheckoutResultModel({
    required this.summary,
    required this.orderId,
    required this.orderName,
    required this.paymentMethod,
    required this.financialStatus,
  });

  bool get requiresPaymentProof =>
      paymentMethod == 'vodafone_cash' || paymentMethod == 'instapay';

  factory InitiateCheckoutResultModel.fromJson(Map<String, dynamic> json) {
    final data = json['data'] as Map<String, dynamic>? ?? json;
    return InitiateCheckoutResultModel(
      summary: CheckoutSummaryModel.fromJson(data['summary'] as Map<String, dynamic>),
      orderId: data['orderId'] as String,
      orderName: data['orderName'] as String,
      paymentMethod: data['paymentMethod'] as String,
      financialStatus: data['financialStatus'] as String,
    );
  }
}
