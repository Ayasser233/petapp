import 'dart:io';
import 'package:get/get.dart';
import 'package:petapp/features/store/data/repositories/order_repository.dart';
import 'package:petapp/features/store/models/order_model.dart';

class OrderController extends GetxController {
  final OrderRepository _repo = OrderRepository();

  final RxList<OrderListItemModel> orders = <OrderListItemModel>[].obs;
  final Rx<OrderDetailModel?> currentOrder = Rx(null);
  final RxList<OrderTrackingEventModel> trackingEvents = <OrderTrackingEventModel>[].obs;
  final RxBool isLoading = false.obs;
  final RxBool isLoadingMore = false.obs;
  final RxBool isActing = false.obs;
  final RxString? filterStatus = RxString('');

  int _page = 1;
  bool _hasNext = true;

  Future<void> loadOrders({bool reset = false, String? status}) async {
    if (reset) {
      _page = 1;
      _hasNext = true;
      orders.clear();
    }
    if (!_hasNext) return;
    if (_page == 1) {
      isLoading.value = true;
    } else {
      isLoadingMore.value = true;
    }
    try {
      final result = await _repo.getOrders(
        page: _page,
        status: status?.isEmpty == true ? null : status,
      );
      orders.addAll(result.items);
      _hasNext = result.hasNext;
      _page++;
    } catch (_) {
    } finally {
      isLoading.value = false;
      isLoadingMore.value = false;
    }
  }

  Future<void> loadOrderDetail(String id) async {
    isLoading.value = true;
    currentOrder.value = null;
    try {
      currentOrder.value = await _repo.getOrderDetail(id);
    } catch (_) {
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> loadTracking(String id) async {
    isLoading.value = true;
    trackingEvents.clear();
    try {
      trackingEvents.assignAll(await _repo.getOrderTracking(id));
    } catch (_) {
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> confirmDelivery(String id) async {
    isActing.value = true;
    try {
      final updated = await _repo.confirmDelivery(id);
      currentOrder.value = updated;
      Get.snackbar('Delivered!', 'Your order has been confirmed as delivered.',
          snackPosition: SnackPosition.BOTTOM);
    } on Exception catch (e) {
      final msg = e.toString();
      if (msg.contains('alreadyDelivered')) {
        Get.snackbar('Already Confirmed', 'You already confirmed delivery.',
            snackPosition: SnackPosition.BOTTOM);
      } else {
        Get.snackbar('Error', 'Could not confirm delivery.',
            snackPosition: SnackPosition.BOTTOM);
      }
    } finally {
      isActing.value = false;
    }
  }

  Future<void> uploadPaymentProof(String id, List<File> images) async {
    isActing.value = true;
    try {
      await _repo.uploadPaymentProof(id, images);
      Get.snackbar('Submitted', 'Payment proof uploaded successfully.',
          snackPosition: SnackPosition.BOTTOM);
      Get.back();
      await loadOrderDetail(id);
    } catch (_) {
      Get.snackbar('Error', 'Failed to upload payment proof.',
          snackPosition: SnackPosition.BOTTOM);
    } finally {
      isActing.value = false;
    }
  }
}
