import 'package:get/get.dart';
import 'package:petapp/core/routes/routes.dart';
import 'package:petapp/features/store/data/repositories/checkout_repository.dart';
import 'package:petapp/features/store/models/shipping_address_model.dart';
import 'package:petapp/features/store/models/shipping_option_model.dart';
import 'package:petapp/features/store/controllers/cart_controller.dart';

class CheckoutController extends GetxController {
  final CheckoutRepository _repo = CheckoutRepository();

  final RxList<ShippingOptionModel> shippingOptions = <ShippingOptionModel>[].obs;
  final Rx<ShippingOptionModel?> selectedShippingOption = Rx(null);

  final RxList<ShippingAddressModel> savedAddresses = <ShippingAddressModel>[].obs;
  final Rx<ShippingAddressModel?> selectedAddress = Rx(null);

  /// "cash_on_delivery" | "vodafone_cash" | "instapay"
  final RxString selectedPaymentMethod = 'cash_on_delivery'.obs;

  /// e.g. "Tomorrow, 1:00 PM"
  final RxString selectedDeliverySlot = ''.obs;

  final RxString customerNote = ''.obs;
  final RxBool isLoading = false.obs;
  final RxBool isPlacingOrder = false.obs;

  @override
  void onInit() {
    super.onInit();
    loadShippingOptions();
  }

  Future<void> loadShippingOptions() async {
    isLoading.value = true;
    try {
      final opts = await _repo.getShippingOptions();
      shippingOptions.assignAll(opts);
      if (opts.isNotEmpty && selectedShippingOption.value == null) {
        selectedShippingOption.value = opts.first;
      }
    } catch (_) {
    } finally {
      isLoading.value = false;
    }
  }

  void addAddress(ShippingAddressModel address) {
    savedAddresses.add(address);
    selectedAddress.value = address;
  }

  void selectAddress(ShippingAddressModel address) {
    selectedAddress.value = address;
  }

  void selectShippingOption(ShippingOptionModel opt) {
    selectedShippingOption.value = opt;
  }

  void setPaymentMethod(String method) {
    selectedPaymentMethod.value = method;
  }

  void setDeliverySlot(String slot) {
    selectedDeliverySlot.value = slot;
  }

  Future<void> initiateCheckout() async {
    final address = selectedAddress.value;
    final shipping = selectedShippingOption.value;
    if (address == null || shipping == null) {
      Get.snackbar('Error', 'Please select an address and shipping option.',
          snackPosition: SnackPosition.BOTTOM);
      return;
    }

    isPlacingOrder.value = true;
    try {
      String note = customerNote.value.trim();
      if (selectedDeliverySlot.value.isNotEmpty) {
        final slotNote = 'Preferred delivery: ${selectedDeliverySlot.value}';
        note = note.isEmpty ? slotNote : '$slotNote\n$note';
      }

      final result = await _repo.initiateCheckout(
        paymentMethod: selectedPaymentMethod.value,
        shippingMethodId: shipping.methodId,
        shippingAddress: address,
        customerNote: note.isEmpty ? null : note,
      );

      // Clear the cart
      try {
        Get.find<CartController>().fetchCart();
      } catch (_) {}

      Get.toNamed(AppRoutes.orderConfirmation, arguments: result);
    } on Exception catch (e) {
      final msg = e.toString();
      if (msg.contains('cartEmpty')) {
        Get.snackbar('Cart Empty', 'Your cart is empty.',
            snackPosition: SnackPosition.BOTTOM);
        Get.until((r) => r.settings.name == AppRoutes.store);
      } else if (msg.contains('stockInsufficient')) {
        Get.snackbar('Stock Issue', 'Some items are no longer available.',
            snackPosition: SnackPosition.BOTTOM);
        Get.toNamed(AppRoutes.cart);
      } else {
        Get.snackbar('Error', 'Failed to place order. Please try again.',
            snackPosition: SnackPosition.BOTTOM);
      }
    } finally {
      isPlacingOrder.value = false;
    }
  }
}
