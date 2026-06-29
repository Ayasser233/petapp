import 'package:get/get.dart';
import 'package:petapp/features/store/data/repositories/review_repository.dart';
import 'package:petapp/features/store/models/review_model.dart';

class ReviewController extends GetxController {
  final ReviewRepository _repo = ReviewRepository();

  final RxList<ReviewModel> reviews = <ReviewModel>[].obs;
  final Rx<ProductReviewsAggregate?> aggregate = Rx(null);
  final RxBool isReviewedByMe = false.obs;
  final RxBool isLoading = false.obs;
  final RxBool isSubmitting = false.obs;

  Future<void> loadReviews(String productId) async {
    isLoading.value = true;
    try {
      final result = await _repo.getReviews(productId);
      reviews.assignAll(result.items);
      aggregate.value = result.aggregate;
      isReviewedByMe.value = result.isReviewedByMe;
    } catch (_) {
    } finally {
      isLoading.value = false;
    }
  }

  Future<bool> submitReview({
    required String productId,
    required String orderId,
    required int rating,
    required String title,
    String? body,
  }) async {
    isSubmitting.value = true;
    try {
      final review = await _repo.createReview(productId,
          orderId: orderId, rating: rating, title: title, body: body);
      reviews.insert(0, review);
      isReviewedByMe.value = true;
      Get.snackbar('Review Submitted', 'Thank you for your feedback!',
          snackPosition: SnackPosition.BOTTOM);
      Get.back();
      return true;
    } on Exception catch (e) {
      final msg = e.toString();
      if (msg.contains('alreadyReviewed')) {
        Get.snackbar('Already Reviewed', 'You already reviewed this product.',
            snackPosition: SnackPosition.BOTTOM);
        isReviewedByMe.value = true;
      } else if (msg.contains('orderMustBeDelivered')) {
        Get.snackbar('Order Not Delivered', 'Your order must be delivered first.',
            snackPosition: SnackPosition.BOTTOM);
      } else {
        Get.snackbar('Error', 'Failed to submit review.',
            snackPosition: SnackPosition.BOTTOM);
      }
      return false;
    } finally {
      isSubmitting.value = false;
    }
  }
}
