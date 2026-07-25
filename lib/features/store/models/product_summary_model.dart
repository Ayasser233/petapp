import 'package:petapp/core/utils/api_constants.dart';

class ProductSummaryModel {
  final String id;
  final String? title;
  final String? description;
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
    this.description,
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

  Map<String, dynamic> toJson() => {
        'id': id,
        'title': title,
        'description': description,
        'handle': handle,
        'status': status,
        'vendor': vendor,
        'productType': productType,
        'tags': tags,
        'minPrice': minPrice,
        'imageUrl': imageUrl,
        'averageRating': averageRating,
        'reviewCount': reviewCount,
        'purchasedQuantity': purchasedQuantity,
      };

  factory ProductSummaryModel.fromJson(Map<String, dynamic> json) {
    // API may return 'description' or 'body_html'; strip HTML tags for preview
    String? rawDesc =
        json['description'] as String? ?? json['body_html'] as String?;
    if (rawDesc != null) {
      rawDesc = rawDesc.replaceAll(RegExp(r'<[^>]+>'), '').trim();
      if (rawDesc.isEmpty) rawDesc = null;
    }
    return ProductSummaryModel(
      id: json['id'] as String,
      title: json['title'] as String?,
      description: rawDesc,
      handle: json['handle'] as String?,
      status: json['status'] as String?,
      vendor: json['vendor'] as String?,
      productType: json['productType'] as String?,
      tags: (json['tags'] as List<dynamic>?)
              ?.map((e) => e.toString())
              .toList() ??
          [],
      minPrice: (json['minPrice'] as num?)?.toDouble(),
      imageUrl: _extractImageUrl(json),
      averageRating: (json['averageRating'] as num?)?.toDouble(),
      reviewCount: json['reviewCount'] as int?,
      purchasedQuantity: json['purchasedQuantity'] as int?,
    );
  }

  /// Extracts an image URL from the API response, handling multiple
  /// possible shapes the backend may use:
  ///   • imageUrl: "https://..."                  (direct string)
  ///   • image: { src: "..." } or { url: "..." }  (Shopify object)
  ///   • featuredImage: { src/url } or string     (alternative naming)
  ///   • images: [{ src: "..." }, ...]            (array)
  ///   • thumbnail: "https://..."                 (thumbnail key)
  static String? _extractImageUrl(Map<String, dynamic> json) {
    // 1. Direct string key "imageUrl"
    final direct = json['imageUrl'] as String?;
    if (direct != null && direct.isNotEmpty) return ApiConstants.fixImageUrl(direct);

    // 2. Nested object: { "image": { "src": "..." } }
    final imageObj = json['image'];
    if (imageObj is Map) {
      final src = (imageObj['src'] ?? imageObj['url']) as String?;
      if (src != null && src.isNotEmpty) return ApiConstants.fixImageUrl(src);
    }

    // 3. featuredImage — object or plain string
    final featured = json['featuredImage'];
    if (featured is Map) {
      final src = (featured['src'] ?? featured['url']) as String?;
      if (src != null && src.isNotEmpty) return ApiConstants.fixImageUrl(src);
    }
    if (featured is String && featured.isNotEmpty) return ApiConstants.fixImageUrl(featured);

    // 4. images array: [{ "src": "..." }]
    final images = json['images'];
    if (images is List && images.isNotEmpty) {
      final first = images.first;
      if (first is Map) {
        final src = (first['src'] ?? first['url']) as String?;
        if (src != null && src.isNotEmpty) return ApiConstants.fixImageUrl(src);
      }
      if (first is String && first.isNotEmpty) return ApiConstants.fixImageUrl(first);
    }

    // 5. thumbnail or thumb
    final thumb = (json['thumbnail'] ?? json['thumb']) as String?;
    if (thumb != null && thumb.isNotEmpty) return ApiConstants.fixImageUrl(thumb);

    return null;
  }
}