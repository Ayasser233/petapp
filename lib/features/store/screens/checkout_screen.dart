import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:petapp/core/utils/app_colors.dart';
import 'package:petapp/features/store/controllers/cart_controller.dart';
import 'package:petapp/features/store/controllers/checkout_controller.dart';
import 'package:petapp/features/store/widgets/payment_method_tile.dart';

class CheckoutScreen extends StatelessWidget {
  const CheckoutScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final cartCtrl = Get.find<CartController>();
    final checkoutCtrl = Get.find<CheckoutController>();
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final noteCtrl = TextEditingController();

    return Scaffold(
      backgroundColor: isDark ? Colors.black : Colors.white,
      appBar: AppBar(
        backgroundColor: isDark ? Colors.black : Colors.white,
        elevation: 0,
        surfaceTintColor: Colors.transparent,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new_rounded, size: 20),
          onPressed: () => Get.back(),
        ),
        title: Text('Checkout',
            style: Theme.of(context).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold)),
      ),
      body: Obx(() {
        final address = checkoutCtrl.selectedAddress.value;
        final slot = checkoutCtrl.selectedDeliverySlot.value;
        final items = cartCtrl.items;

        return ListView(
          padding: const EdgeInsets.fromLTRB(20, 16, 20, 120),
          children: [
            // Deliver to card
            if (address != null) ...[
              _card(
                context: context,
                isDark: isDark,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Deliver to',
                        style: Theme.of(context).textTheme.bodyMedium?.copyWith(fontWeight: FontWeight.bold)),
                    const SizedBox(height: 8),
                    Row(children: [
                      const Icon(Icons.location_pin, color: AppColors.orange, size: 18),
                      const SizedBox(width: 6),
                      Expanded(child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(address.label,
                              style: Theme.of(context).textTheme.bodyMedium?.copyWith(fontWeight: FontWeight.bold)),
                          Text(address.fullLine,
                              style: Theme.of(context).textTheme.bodySmall?.copyWith(color: Colors.grey.shade600)),
                        ],
                      )),
                    ]),
                    if (slot.isNotEmpty) ...[
                      const SizedBox(height: 8),
                      Text('Delivery time',
                          style: Theme.of(context).textTheme.bodyMedium?.copyWith(fontWeight: FontWeight.bold)),
                      const SizedBox(height: 4),
                      Row(children: [
                        Icon(Icons.access_time_rounded, color: AppColors.orange, size: 18),
                        const SizedBox(width: 6),
                        Text(slot,
                            style: Theme.of(context).textTheme.bodyMedium?.copyWith(fontWeight: FontWeight.w500)),
                      ]),
                    ],
                  ],
                ),
              ),
              const SizedBox(height: 16),
            ],

            // Payment method
            _card(
              context: context,
              isDark: isDark,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  PaymentMethodTile(
                    value: 'cash_on_delivery',
                    label: 'Cash On Delivery',
                    icon: Icons.money_outlined,
                    selected: checkoutCtrl.selectedPaymentMethod.value == 'cash_on_delivery',
                    onTap: () => checkoutCtrl.setPaymentMethod('cash_on_delivery'),
                  ),
                  const SizedBox(height: 10),
                  PaymentMethodTile(
                    value: 'vodafone_cash',
                    label: 'Vodafone Cash',
                    icon: Icons.phone_android_outlined,
                    selected: checkoutCtrl.selectedPaymentMethod.value == 'vodafone_cash',
                    onTap: () => checkoutCtrl.setPaymentMethod('vodafone_cash'),
                  ),
                  const SizedBox(height: 10),
                  PaymentMethodTile(
                    value: 'instapay',
                    label: 'InstaPay',
                    icon: Icons.account_balance_wallet_outlined,
                    selected: checkoutCtrl.selectedPaymentMethod.value == 'instapay',
                    onTap: () => checkoutCtrl.setPaymentMethod('instapay'),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),

            // Items
            if (items.isNotEmpty) ...[
              SizedBox(
                height: 160,
                child: ListView.separated(
                  scrollDirection: Axis.horizontal,
                  itemCount: items.length,
                  separatorBuilder: (_, __) => const SizedBox(width: 12),
                  itemBuilder: (context, i) {
                    final item = items[i];
                    final img = item.productImageUrl;
                    return Column(
                      children: [
                        Stack(
                          children: [
                            ClipRRect(
                              borderRadius: BorderRadius.circular(10),
                              child: img != null
                                  ? Image.network(img, width: 110, height: 110, fit: BoxFit.cover,
                                      errorBuilder: (_, __, ___) => _imgPlaceholder())
                                  : _imgPlaceholder(),
                            ),
                            Positioned(
                              top: 6, right: 6,
                              child: Container(
                                width: 22, height: 22,
                                decoration: const BoxDecoration(color: AppColors.orange, shape: BoxShape.circle),
                                child: Center(
                                  child: Text('${item.quantity}',
                                      style: const TextStyle(color: Colors.white, fontSize: 11, fontWeight: FontWeight.bold)),
                                ),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 6),
                        SizedBox(
                          width: 110,
                          child: Text(item.productTitle ?? 'Product',
                              style: Theme.of(context).textTheme.bodySmall?.copyWith(fontWeight: FontWeight.w600),
                              maxLines: 2, overflow: TextOverflow.ellipsis, textAlign: TextAlign.center),
                        ),
                        Text('${item.lineTotal.toStringAsFixed(0)} EGP',
                            style: Theme.of(context).textTheme.bodySmall?.copyWith(fontWeight: FontWeight.bold)),
                      ],
                    );
                  },
                ),
              ),
              const SizedBox(height: 16),
            ],

            // Price breakdown
            _card(
              context: context,
              isDark: isDark,
              child: Column(
                children: [
                  _priceRow(context, 'Subtotal (${items.length} Items)',
                      '${cartCtrl.subtotal.toStringAsFixed(0)} EGP'),
                  const SizedBox(height: 8),
                  Obx(() {
                    final shipping = checkoutCtrl.selectedShippingOption.value;
                    return _priceRow(context, 'Shipping Fee',
                        shipping != null ? '${shipping.price.toStringAsFixed(0)} EGP' : '—');
                  }),
                  const Divider(height: 20),
                  Obx(() {
                    final shipping = checkoutCtrl.selectedShippingOption.value;
                    final total = cartCtrl.subtotal + (shipping?.price ?? 0);
                    return Column(
                      children: [
                        _priceRow(context, 'Total Amount', '${total.toStringAsFixed(0)} EGP', bold: true),
                        const SizedBox(height: 2),
                        Align(
                          alignment: Alignment.centerLeft,
                          child: Text('Inclusive Of VAT',
                              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                                    color: Colors.grey.shade500, fontStyle: FontStyle.italic)),
                        ),
                      ],
                    );
                  }),
                ],
              ),
            ),
            const SizedBox(height: 16),

            // Promo code (UI only)
            Row(
              children: [
                Expanded(
                  child: Container(
                    decoration: BoxDecoration(
                      color: isDark ? AppColors.lightblack : Colors.grey.shade100,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 4),
                    child: Row(
                      children: [
                        Icon(Icons.discount_outlined, color: Colors.grey.shade500, size: 18),
                        const SizedBox(width: 8),
                        Expanded(
                          child: TextField(
                            decoration: InputDecoration(
                              hintText: 'Do you have a promo code?',
                              hintStyle: TextStyle(color: Colors.grey.shade500, fontSize: 13),
                              border: InputBorder.none,
                              contentPadding: EdgeInsets.zero,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(width: 10),
                TextButton(
                  onPressed: () {},
                  style: TextButton.styleFrom(
                    backgroundColor: Colors.grey.shade200,
                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                  ),
                  child: const Text('Apply', style: TextStyle(color: Colors.black87, fontWeight: FontWeight.w600)),
                ),
              ],
            ),
            const SizedBox(height: 16),

            // Order notes
            Text('Order Notes',
                style: Theme.of(context).textTheme.titleSmall?.copyWith(fontWeight: FontWeight.bold)),
            const SizedBox(height: 8),
            TextField(
              controller: noteCtrl,
              onChanged: (v) => checkoutCtrl.customerNote.value = v,
              maxLines: 4,
              decoration: InputDecoration(
                hintText: 'Notes',
                hintStyle: TextStyle(color: Colors.grey.shade500),
                filled: true,
                fillColor: isDark ? AppColors.lightblack : Colors.grey.shade100,
                border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12), borderSide: BorderSide.none),
                focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: const BorderSide(color: AppColors.orange, width: 1.5)),
              ),
            ),
          ],
        );
      }),
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.fromLTRB(20, 0, 20, 36),
        child: Obx(() {
          final loading = checkoutCtrl.isPlacingOrder.value;
          return ElevatedButton(
            onPressed: loading ? null : checkoutCtrl.initiateCheckout,
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.orange,
              foregroundColor: Colors.white,
              padding: const EdgeInsets.symmetric(vertical: 16),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
              elevation: 0,
            ),
            child: loading
                ? const SizedBox(height: 20, width: 20,
                    child: CircularProgressIndicator(strokeWidth: 2, color: Colors.white))
                : const Text('Pay Now', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
          );
        }),
      ),
    );
  }

  Widget _card({required BuildContext context, required bool isDark, required Widget child}) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: isDark ? AppColors.lightblack : Colors.grey.shade50,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: Colors.grey.shade200),
      ),
      child: child,
    );
  }

  Widget _priceRow(BuildContext context, String label, String value, {bool bold = false}) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(label,
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  color: Colors.grey.shade600,
                  fontWeight: bold ? FontWeight.bold : FontWeight.normal)),
        Text(value,
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  fontWeight: bold ? FontWeight.bold : FontWeight.w500)),
      ],
    );
  }

  Widget _imgPlaceholder() => Container(
        width: 110, height: 110,
        color: AppColors.storeCardBg,
        child: const Icon(Icons.pets, color: AppColors.lightorange, size: 36));
}
