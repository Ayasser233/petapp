import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:petapp/core/utils/app_colors.dart';
import 'package:petapp/features/store/data/repositories/cart_repository.dart';
import 'package:petapp/features/store/models/cart_model.dart';

class CartController extends GetxController {
  final CartRepository _repo = CartRepository();

  final Rx<CartModel> _cart = CartModel.empty().obs;
  final RxBool isLoading = false.obs;

  CartModel get cart => _cart.value;
  List<CartItemApiModel> get items => _cart.value.items;
  bool get isEmpty => _cart.value.isEmpty;
  int get itemCount => _cart.value.itemCount;
  double get subtotal => _cart.value.subtotal;

  @override
  void onInit() {
    super.onInit();
    fetchCart();
  }

  Future<void> fetchCart() async {
    isLoading.value = true;
    try {
      _cart.value = await _repo.getCart();
    } catch (_) {
      _cart.value = CartModel.empty();
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> addItem({required String variantId, String? productId, int quantity = 1}) async {
    try {
      _cart.value = await _repo.addItem(variantId: variantId, productId: productId, quantity: quantity);
    } on Exception catch (e) {
      final msg = e.toString();
      if (msg.contains('stockInsufficient')) {
        Get.snackbar('Out of Stock', 'Not enough stock available.',
            backgroundColor: Colors.red.shade100,
            colorText: Colors.red.shade800,
            snackPosition: SnackPosition.BOTTOM);
      } else if (msg.contains('variantNotFound')) {
        Get.snackbar('Error', 'Product variant not found.',
            backgroundColor: Colors.red.shade100,
            colorText: Colors.red.shade800,
            snackPosition: SnackPosition.BOTTOM);
      } else {
        rethrow;
      }
    }
  }

  Future<void> updateItem(String variantId, int quantity) async {
    try {
      _cart.value = await _repo.updateItem(variantId, quantity: quantity);
    } on Exception catch (e) {
      final msg = e.toString();
      if (msg.contains('stockInsufficient')) {
        Get.snackbar('Out of Stock', 'Not enough stock available.',
            backgroundColor: Colors.red.shade100,
            colorText: Colors.red.shade800,
            snackPosition: SnackPosition.BOTTOM);
      } else {
        rethrow;
      }
    }
  }

  Future<void> removeItem(String variantId) async {
    try {
      _cart.value = await _repo.removeItem(variantId);
    } catch (_) {}
  }

  Future<void> increment(String variantId) async {
    final item = items.firstWhereOrNull((e) => e.variantId == variantId);
    if (item == null) return;
    await updateItem(variantId, item.quantity + 1);
  }

  Future<void> decrement(String variantId) async {
    final item = items.firstWhereOrNull((e) => e.variantId == variantId);
    if (item == null) return;
    if (item.quantity <= 1) {
      await removeItem(variantId);
    } else {
      await updateItem(variantId, item.quantity - 1);
    }
  }

  Future<void> clear() async {
    try {
      _cart.value = await _repo.clearCart();
    } catch (_) {
      _cart.value = CartModel.empty();
    }
  }

  bool isInCart(String variantId) => items.any((e) => e.variantId == variantId);
  int quantityOf(String variantId) => items.firstWhereOrNull((e) => e.variantId == variantId)?.quantity ?? 0;

  Widget buildBadge() {
    return Obx(() {
      if (itemCount == 0) return const SizedBox.shrink();
      return Positioned(
        top: 6,
        right: 6,
        child: Container(
          width: 16,
          height: 16,
          decoration: const BoxDecoration(color: AppColors.orange, shape: BoxShape.circle),
          child: Center(
            child: Text('$itemCount',
                style: const TextStyle(color: Colors.white, fontSize: 9, fontWeight: FontWeight.bold)),
          ),
        ),
      );
    });
  }
}