class ReviewModel {
  final String id;
  final String userId;
  final String orderId;
  final String productId;
  final int rating;
  final String title;
  final String? body;
  final bool isApproved;
  final String createdAt;

  const ReviewModel({
    required this.id,
    required this.userId,
    required this.orderId,
    required this.productId,
    required this.rating,
    required this.title,
    this.body,
    required this.isApproved,
    required this.createdAt,
  });

  factory ReviewModel.fromJson(Map<String, dynamic> json) {
    return ReviewModel(
      id: json['id'] as String,
      userId: json['userId'] as String,
      orderId: json['orderId'] as String,
      productId: json['productId'] as String,
      rating: json['rating'] as int,
      title: json['title'] as String,
      body: json['body'] as String?,
      isApproved: json['isApproved'] as bool? ?? false,
      createdAt: json['createdAt'] as String,
    );
  }
}

class ProductReviewsAggregate {
  final double? averageRating;
  final int totalCount;

  const ProductReviewsAggregate({this.averageRating, required this.totalCount});

  factory ProductReviewsAggregate.fromJson(Map<String, dynamic> json) {
    return ProductReviewsAggregate(
      averageRating: (json['averageRating'] as num?)?.toDouble(),
      totalCount: json['totalCount'] as int? ?? 0,
    );
  }
}

class ReviewsListResult {
  final List<ReviewModel> items;
  final ProductReviewsAggregate aggregate;
  final bool isReviewedByMe;

  const ReviewsListResult({
    required this.items,
    required this.aggregate,
    required this.isReviewedByMe,
  });

  factory ReviewsListResult.fromJson(Map<String, dynamic> json) {
    final data = json['data'] as Map<String, dynamic>? ?? json;
    return ReviewsListResult(
      items: (data['items'] as List<dynamic>?)
              ?.map((e) => ReviewModel.fromJson(e as Map<String, dynamic>))
              .toList() ??
          [],
      aggregate: ProductReviewsAggregate.fromJson(
          data['aggregate'] as Map<String, dynamic>? ?? {}),
      isReviewedByMe: data['isReviewedByMe'] as bool? ?? false,
    );
  }
}
