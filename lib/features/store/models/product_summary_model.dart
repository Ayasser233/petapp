class ProductSummaryModel {
  final String id;
  final String? title;
  final String? handle;
  final String? status;
  final String? vendor;
  final String? productType;
  final List<String> tags;
  final double? minPrice;
  final String? imageUrl;
  // top-rated extras
  final double? averageRating;
  final int? reviewCount;
  // most-purchased extra
  final int? purchasedQuantity;

  const ProductSummaryModel({
    required this.id,
    this.title,
    this.handle,
    this.status,
    this.vendor,
    this.productType,
    this.tags = const [],
    this.minPrice,
    this.imageUrl,
    this.averageRating,
    this.reviewCount,
    this.purchasedQuantity,
  });

  factory ProductSummaryModel.fromJson(Map<String, dynamic> json) {
    return ProductSummaryModel(
      id: json['id'] as String,
      title: json['title'] as String?,
      handle: json['handle'] as String?,
      status: json['status'] as String?,
      vendor: json['vendor'] as String?,
      productType: json['productType'] as String?,
      tags: (json['tags'] as List<dynamic>?)?.map((e) => e.toString()).toList() ?? [],
      minPrice: (json['minPrice'] as num?)?.toDouble(),
      imageUrl: json['imageUrl'] as String?,
      averageRating: (json['averageRating'] as num?)?.toDouble(),
      reviewCount: json['reviewCount'] as int?,
      purchasedQuantity: json['purchasedQuantity'] as int?,
    );
  }
}
