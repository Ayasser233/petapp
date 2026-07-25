import 'package:petapp/core/services/api_client.dart';
import 'package:petapp/core/utils/api_constants.dart';
import 'package:petapp/features/store/models/shipping_option_model.dart';
import 'package:petapp/features/store/models/checkout_result_model.dart';
import 'package:petapp/features/store/models/shipping_address_model.dart';
import 'package:get/get.dart';

class CheckoutRepository {
  ApiClient get _client => Get.find<ApiClient>();

  Future<List<ShippingOptionModel>> getShippingOptions() async {
    final res = await _client.get(ApiConstants.shippingOptionsEndpoint);
    final data = res.data['data'];
    final options = data['options'] as List<dynamic>? ?? (data is List ? data : []);
    return options
        .map((e) => ShippingOptionModel.fromJson(e as Map<String, dynamic>))
        .toList();
  }

  Future<InitiateCheckoutResultModel> initiateCheckout({
    required String paymentMethod,
    required String shippingMethodId,
    required ShippingAddressModel shippingAddress,
    String? customerEmail,
    String? customerNote,
  }) async {
    final res = await _client.post(
      ApiConstants.checkoutInitiateEndpoint,
      data: {
        'paymentMethod': paymentMethod,
        'shippingMethodId': shippingMethodId,
        'shippingAddress': shippingAddress.toCheckoutJson(),
        if (customerEmail != null && customerEmail.isNotEmpty)
          'customerEmail': customerEmail,
        if (customerNote != null && customerNote.isNotEmpty)
          'customerNote': customerNote,
      },
    );
    return InitiateCheckoutResultModel.fromJson(res.data as Map<String, dynamic>);
  }
}
