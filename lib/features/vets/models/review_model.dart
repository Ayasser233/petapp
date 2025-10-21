class ReviewModel {
  final String id;
  final String vetId;
  final String userName;
  final String? userImage;
  final double rating;
  final String comment;
  final String date;
  final DateTime createdAt;

  ReviewModel({
    required this.id,
    required this.vetId,
    required this.userName,
    this.userImage,
    required this.rating,
    required this.comment,
    required this.date,
    required this.createdAt,
  });

  factory ReviewModel.fromJson(Map<String, dynamic> json) {
    return ReviewModel(
      id: json['id']?.toString() ?? '',
      vetId: json['vetId']?.toString() ?? json['vet_id']?.toString() ?? '',
      userName: json['userName']?.toString() ?? 
                json['user_name']?.toString() ?? 
                json['name']?.toString() ?? 
                'Anonymous',
      userImage: json['userImage']?.toString() ?? 
                 json['user_image']?.toString() ?? 
                 json['avatar']?.toString(),
      rating: (json['rating'] is int) 
          ? (json['rating'] as int).toDouble() 
          : (json['rating'] ?? 0.0).toDouble(),
      comment: json['comment']?.toString() ?? 
               json['review']?.toString() ?? 
               json['text']?.toString() ?? '',
      date: json['date']?.toString() ?? 
            json['createdAt']?.toString() ?? 
            json['created_at']?.toString() ?? 
            DateTime.now().toString(),
      createdAt: json['createdAt'] != null 
          ? DateTime.parse(json['createdAt'].toString())
          : (json['created_at'] != null 
              ? DateTime.parse(json['created_at'].toString())
              : DateTime.now()),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'vetId': vetId,
      'userName': userName,
      'userImage': userImage,
      'rating': rating,
      'comment': comment,
      'date': date,
      'createdAt': createdAt.toIso8601String(),
    };
  }

  /// Get star rating as integer (for UI)
  int get starRating => rating.round();

  /// Get formatted date
  String get formattedDate {
    final now = DateTime.now();
    final difference = now.difference(createdAt);

    if (difference.inDays == 0) {
      if (difference.inHours == 0) {
        return '${difference.inMinutes} minutes ago';
      }
      return '${difference.inHours} hours ago';
    } else if (difference.inDays < 7) {
      return '${difference.inDays} days ago';
    } else if (difference.inDays < 30) {
      return '${(difference.inDays / 7).floor()} weeks ago';
    } else if (difference.inDays < 365) {
      return '${(difference.inDays / 30).floor()} months ago';
    } else {
      return '${(difference.inDays / 365).floor()} years ago';
    }
  }

  /// Check if review is recent (within 7 days)
  bool get isRecent => DateTime.now().difference(createdAt).inDays <= 7;
}

class ReviewsResponse {
  final List<ReviewModel> reviews;
  final int total;
  final int page;
  final int limit;
  final int totalPages;

  ReviewsResponse({
    required this.reviews,
    required this.total,
    required this.page,
    required this.limit,
    required this.totalPages,
  });

  factory ReviewsResponse.fromJson(Map<String, dynamic> json) {
    return ReviewsResponse(
      reviews: (json['reviews'] as List<dynamic>?)
              ?.map((review) => ReviewModel.fromJson(review as Map<String, dynamic>))
              .toList() ??
          [],
      total: json['total'] ?? 0,
      page: json['page'] ?? 1,
      limit: json['limit'] ?? 10,
      totalPages: json['totalPages'] ?? 1,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'reviews': reviews.map((review) => review.toJson()).toList(),
      'total': total,
      'page': page,
      'limit': limit,
      'totalPages': totalPages,
    };
  }

  /// Check if there are more pages
  bool get hasMorePages => page < totalPages;

  /// Get average rating from all reviews
  double get averageRating {
    if (reviews.isEmpty) return 0.0;
    final sum = reviews.fold<double>(0.0, (sum, review) => sum + review.rating);
    return sum / reviews.length;
  }
}
