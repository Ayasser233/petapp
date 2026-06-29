import 'package:petapp/core/services/api_client.dart';
import 'package:petapp/core/utils/api_constants.dart';
import 'package:petapp/features/store/models/review_model.dart';
import 'package:get/get.dart';

class ReviewRepository {
  ApiClient get _client => Get.find<ApiClient>();

  Future<ReviewsListResult> getReviews(String productId, {int page = 1, int limit = 20}) async {
    final res = await _client.get(
      ApiConstants.productReviewsEndpoint(productId),
      queryParameters: {'page': page, 'limit': limit},
    );
    return ReviewsListResult.fromJson(res.data as Map<String, dynamic>);
  }

  Future<ReviewModel> createReview(
    String productId, {
    required String orderId,
    required int rating,
    required String title,
    String? body,
  }) async {
    final res = await _client.post(
      ApiConstants.productReviewsEndpoint(productId),
      data: {
        'orderId': orderId,
        'rating': rating,
        'title': title,
        if (body != null && body.isNotEmpty) 'body': body,
      },
    );
    final data = res.data['data'] as Map<String, dynamic>;
    return ReviewModel.fromJson(data);
  }
}
