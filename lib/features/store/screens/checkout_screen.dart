import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:petapp/core/services/review_service.dart';
import 'package:petapp/core/utils/app_colors.dart';
import 'package:petapp/features/store/controllers/cart_controller.dart';

class CheckoutScreen extends StatelessWidget {
  const CheckoutScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final CartController cartCtrl = Get.find<CartController>();
    final isDark = Theme.of(context).brightness == Brightness.dark;

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
        title: Text(
          'Checkout',
          style: Theme.of(context)
              .textTheme
              .titleLarge
              ?.copyWith(fontWeight: FontWeight.bold),
        ),
      ),
      body: Obx(() {
        return ListView(
          padding: const EdgeInsets.fromLTRB(20, 16, 20, 120),
          children: [
            // Order summary card
            _sectionCard(
              context: context,
              isDark: isDark,
              title: 'Order Summary',
              child: Column(
                children: cartCtrl.items.map((item) {
                  return Padding(
                    padding: const EdgeInsets.symmetric(vertical: 6),
                    child: Row(
                      children: [
                        ClipRRect(
                          borderRadius: BorderRadius.circular(8),
                          child: Image.network(
                            item.product.image,
                            width: 50,
                            height: 50,
                            fit: BoxFit.cover,
                            errorBuilder: (_, __, ___) => Container(
                              width: 50,
                              height: 50,
                              color: AppColors.storeCardBg,
                              child: const Icon(Icons.pets,
                                  color: AppColors.lightorange, size: 20),
                            ),
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                item.product.name,
                                style: Theme.of(context)
                                    .textTheme
                                    .bodyMedium
                                    ?.copyWith(fontWeight: FontWeight.w600),
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                              ),
                              Text(
                                'Qty: ${item.quantity}',
                                style: Theme.of(context)
                                    .textTheme
                                    .bodySmall
                                    ?.copyWith(color: Colors.grey),
                              ),
                            ],
                          ),
                        ),
                        Text(
                          '${item.totalPrice.toStringAsFixed(0)} EGP',
                          style: Theme.of(context)
                              .textTheme
                              .bodyMedium
                              ?.copyWith(fontWeight: FontWeight.bold),
                        ),
                      ],
                    ),
                  );
                }).toList(),
              ),
            ),
            const SizedBox(height: 16),

            // Delivery address
            _sectionCard(
              context: context,
              isDark: isDark,
              title: 'Delivery Address',
              trailing: TextButton(
                onPressed: () => Get.back(),
                child: const Text('Change',
                    style: TextStyle(color: AppColors.orange)),
              ),
              child: Row(
                children: [
                  const Icon(Icons.location_pin,
                      color: AppColors.orange, size: 20),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'El Salam, Cairo',
                          style: Theme.of(context)
                              .textTheme
                              .bodyMedium
                              ?.copyWith(fontWeight: FontWeight.bold),
                        ),
                        Text(
                          'Al Obour Street, Cairo, 11788, Egypt',
                          style: Theme.of(context)
                              .textTheme
                              .bodySmall
                              ?.copyWith(color: Colors.grey),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),

            // Payment method
            _sectionCard(
              context: context,
              isDark: isDark,
              title: 'Payment Method',
              child: Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: AppColors.storeCardBg,
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: const Icon(Icons.payments_outlined,
                        color: AppColors.orange, size: 22),
                  ),
                  const SizedBox(width: 12),
                  Text(
                    'Cash on Delivery',
                    style: Theme.of(context)
                        .textTheme
                        .bodyMedium
                        ?.copyWith(fontWeight: FontWeight.w600),
                  ),
                  const Spacer(),
                  const Icon(Icons.check_circle,
                      color: AppColors.orange, size: 20),
                ],
              ),
            ),
            const SizedBox(height: 16),

            // Price breakdown
            _sectionCard(
              context: context,
              isDark: isDark,
              title: 'Price Details',
              child: Column(
                children: [
                  _priceRow(context, 'Subtotal (${cartCtrl.items.length} items)',
                      '${cartCtrl.subtotal.toStringAsFixed(0)} EGP'),
                  const SizedBox(height: 8),
                  _priceRow(context, 'Shipping Fee', 'Free'),
                  const SizedBox(height: 8),
                  _priceRow(context, 'Discount',
                      '-${cartCtrl.discount.toStringAsFixed(0)} EGP',
                      valueColor: Colors.red),
                  const Divider(height: 20),
                  _priceRow(
                    context,
                    'Total',
                    '${cartCtrl.total.toStringAsFixed(0)} EGP',
                    isBold: true,
                  ),
                ],
              ),
            ),
          ],
        );
      }),
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.fromLTRB(20, 0, 20, 36),
        child: ElevatedButton(
          onPressed: () => _placeOrder(context, cartCtrl),
          style: ElevatedButton.styleFrom(
            backgroundColor: AppColors.orange,
            foregroundColor: Colors.white,
            padding: const EdgeInsets.symmetric(vertical: 16),
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(30)),
            elevation: 0,
          ),
          child: const Text(
            'PLACE ORDER',
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 16,
              letterSpacing: 0.5,
            ),
          ),
        ),
      ),
    );
  }

  void _placeOrder(BuildContext context, CartController cartCtrl) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(Icons.check_circle_rounded,
                color: Colors.green, size: 60),
            const SizedBox(height: 12),
            const Text(
              'Order Placed!',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            Text(
              'Your order has been placed successfully. We\'ll notify you when it\'s on the way.',
              textAlign: TextAlign.center,
              style: TextStyle(color: Colors.grey.shade600),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () {
              cartCtrl.clear();
              // Mark positive action for review prompting
              ReviewService.markMeaningfulActionCompleted();
              Get.until((route) => route.settings.name == '/home');
              // Prompt shortly after navigating back home
              Future.delayed(const Duration(seconds: 2), () {
                final ctx = Get.context;
                if (ctx != null) ReviewService.maybePromptForReview(ctx);
              });
            },
            child: const Text('Back to Home',
                style: TextStyle(color: AppColors.orange)),
          ),
        ],
      ),
    );
  }

  Widget _sectionCard({
    required BuildContext context,
    required bool isDark,
    required String title,
    required Widget child,
    Widget? trailing,
  }) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: isDark ? AppColors.lightblack : Colors.white,
        borderRadius: BorderRadius.circular(14),
        boxShadow: [
          if (!isDark)
            BoxShadow(
              color: Colors.grey.withValues(alpha: 0.1),
              blurRadius: 8,
              offset: const Offset(0, 2),
            ),
        ],
        border: isDark ? null : Border.all(color: Colors.grey.shade100),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(title,
                  style: Theme.of(context).textTheme.titleSmall?.copyWith(
                        fontWeight: FontWeight.bold,
                      )),
              if (trailing != null) trailing,
            ],
          ),
          const Divider(height: 16),
          child,
        ],
      ),
    );
  }

  Widget _priceRow(BuildContext context, String label, String value,
      {bool isBold = false, Color? valueColor}) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(label,
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  color: Colors.grey.shade600,
                  fontWeight: isBold ? FontWeight.bold : FontWeight.normal,
                )),
        Text(value,
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  fontWeight: isBold ? FontWeight.bold : FontWeight.w500,
                  color: valueColor,
                )),
      ],
    );
  }
}
