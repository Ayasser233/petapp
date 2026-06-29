class ShippingOptionModel {
  final String methodId;
  final String title;
  final String? description;
  final double price;

  const ShippingOptionModel({
    required this.methodId,
    required this.title,
    this.description,
    required this.price,
  });

  factory ShippingOptionModel.fromJson(Map<String, dynamic> json) {
    return ShippingOptionModel(
      methodId: json['methodId'] as String,
      title: json['title'] as String,
      description: json['description'] as String?,
      price: (json['price'] as num).toDouble(),
    );
  }
}
