import 'package:petapp/core/utils/api_constants.dart';

class ProductVariantModel {
  final String id;
  final String? title;
  final double price;
  final double? compareAtPrice;
  final String? sku;
  final String? option1;
  final String? option2;
  final String? option3;
  final int? inventoryQuantity;
  final String inventoryPolicy; // "deny" | "continue"
  final double? weight;
  final String? weightUnit;

  const ProductVariantModel({
    required this.id,
    this.title,
    required this.price,
    this.compareAtPrice,
    this.sku,
    this.option1,
    this.option2,
    this.option3,
    this.inventoryQuantity,
    this.inventoryPolicy = 'continue',
    this.weight,
    this.weightUnit,
  });

  bool get isInStock {
    if (inventoryPolicy == 'continue') return true;
    return (inventoryQuantity ?? 0) > 0;
  }

  factory ProductVariantModel.fromJson(Map<String, dynamic> json) {
    return ProductVariantModel(
      id: json['id'] as String,
      title: json['title'] as String?,
      price: (json['price'] as num).toDouble(),
      compareAtPrice: (json['compare_at_price'] as num?)?.toDouble(),
      sku: json['sku'] as String?,
      option1: json['option1'] as String?,
      option2: json['option2'] as String?,
      option3: json['option3'] as String?,
      inventoryQuantity: json['inventory_quantity'] as int?,
      inventoryPolicy: json['inventory_policy'] as String? ?? 'continue',
      weight: (json['weight'] as num?)?.toDouble(),
      weightUnit: json['weight_unit'] as String?,
    );
  }
}

class ProductImageModel {
  final String id;
  final String src;
  final String? alt;
  final int position;
  final List<String> variantIds;

  const ProductImageModel({
    required this.id,
    required this.src,
    this.alt,
    required this.position,
    this.variantIds = const [],
  });

  factory ProductImageModel.fromJson(Map<String, dynamic> json) {
    return ProductImageModel(
      id: json['id'] as String,
      src: ApiConstants.fixImageUrl(json['src'] as String) ?? '',
      alt: json['alt'] as String?,
      position: json['position'] as int? ?? 0,
      variantIds: (json['variant_ids'] as List<dynamic>?)
              ?.map((e) => e.toString())
              .toList() ??
          [],
    );
  }
}

class ReviewsSummary {
  final double? averageRating;
  final int approvedCount;

  const ReviewsSummary({this.averageRating, required this.approvedCount});

  factory ReviewsSummary.fromJson(Map<String, dynamic> json) {
    return ReviewsSummary(
      averageRating: (json['averageRating'] as num?)?.toDouble(),
      approvedCount: json['approvedCount'] as int? ?? 0,
    );
  }
}

class ProductDetailModel {
  final String id;
  final String? title;
  final String? description;
  final String? vendor;
  final String? productType;
  final String? handle;
  final String status;
  final List<String> tags;
  final dynamic options;
  final List<ProductVariantModel> variants;
  final List<ProductImageModel> images;
  final ReviewsSummary? reviews;

  const ProductDetailModel({
    required this.id,
    this.title,
    this.description,
    this.vendor,
    this.productType,
    this.handle,
    this.status = 'active',
    this.tags = const [],
    this.options,
    this.variants = const [],
    this.images = const [],
    this.reviews,
  });

  String? get primaryImageUrl =>
      images.isNotEmpty ? images.first.src : null;

  factory ProductDetailModel.fromJson(Map<String, dynamic> json) {
    final productJson = json['product'] as Map<String, dynamic>? ?? json;
    return ProductDetailModel(
      id: productJson['id'] as String,
      title: productJson['title'] as String?,
      description: productJson['description'] as String?,
      vendor: productJson['vendor'] as String?,
      productType: productJson['product_type'] as String?,
      handle: productJson['handle'] as String?,
      status: productJson['status'] as String? ?? 'active',
      tags: (productJson['tags'] as List<dynamic>?)
              ?.map((e) => e.toString())
              .toList() ??
          [],
      options: productJson['options'],
      variants: (productJson['variants'] as List<dynamic>?)
              ?.map((e) => ProductVariantModel.fromJson(e as Map<String, dynamic>))
              .toList() ??
          [],
      images: (productJson['images'] as List<dynamic>?)
              ?.map((e) => ProductImageModel.fromJson(e as Map<String, dynamic>))
              .toList() ??
          [],
      reviews: json['reviews'] != null
          ? ReviewsSummary.fromJson(json['reviews'] as Map<String, dynamic>)
          : null,
    );
  }
}
