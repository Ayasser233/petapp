import 'package:petapp/core/services/api_client.dart';
import 'package:petapp/core/utils/api_constants.dart';
import 'package:petapp/features/store/models/cart_model.dart';
import 'package:get/get.dart';

class CartRepository {
  ApiClient get _client => Get.find<ApiClient>();

  Future<CartModel> getCart() async {
    final res = await _client.get(ApiConstants.cartEndpoint);
    return CartModel.fromJson(res.data as Map<String, dynamic>);
  }

  Future<CartModel> addItem({
    required String variantId,
    String? productId,
    int quantity = 1,
  }) async {
    final res = await _client.post(
      ApiConstants.cartItemsEndpoint,
      data: {
        'variantId': variantId,
        if (productId != null) 'productId': productId,
        'quantity': quantity,
      },
    );
    return CartModel.fromJson(res.data as Map<String, dynamic>);
  }

  Future<CartModel> updateItem(String variantId, {required int quantity}) async {
    final res = await _client.patch(
      ApiConstants.cartItemEndpoint(variantId),
      data: {'quantity': quantity},
    );
    return CartModel.fromJson(res.data as Map<String, dynamic>);
  }

  Future<CartModel> removeItem(String variantId) async {
    final res = await _client.delete(ApiConstants.cartItemEndpoint(variantId));
    return CartModel.fromJson(res.data as Map<String, dynamic>);
  }

  Future<CartModel> clearCart() async {
    final res = await _client.delete(ApiConstants.cartEndpoint);
    return CartModel.fromJson(res.data as Map<String, dynamic>);
  }
}
