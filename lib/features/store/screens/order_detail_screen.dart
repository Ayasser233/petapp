import 'package:flutter/material.dart';
import 'package:petapp/core/widgets/auth_network_image.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:petapp/core/localization/app_localizations.dart';
import 'package:petapp/core/utils/app_colors.dart';
import 'package:petapp/core/routes/routes.dart';
import 'package:petapp/features/store/controllers/order_controller.dart';
import 'package:petapp/features/store/widgets/order_status_badge.dart';

class OrderDetailScreen extends StatefulWidget {
  const OrderDetailScreen({super.key});

  @override
  State<OrderDetailScreen> createState() => _OrderDetailScreenState();
}

class _OrderDetailScreenState extends State<OrderDetailScreen> {
  late final OrderController _ctrl;
  late final String _orderId;

  @override
  void initState() {
    super.initState();
    _orderId = Get.arguments as String;
    _ctrl = Get.find<OrderController>();
    // Defer until after the first frame so reactive `.value` changes
    // don't fire while Flutter is still building the widget tree.
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _ctrl.loadOrderDetail(_orderId);
    });
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final l10n = AppLocalizations.of(context);
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
        title: Text(l10n.orderDetail,
            style: Theme.of(context).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold)),
      ),
      body: Obx(() {
        if (_ctrl.isLoading.value) {
          return const Center(child: CircularProgressIndicator(color: AppColors.orange));
        }
        final order = _ctrl.currentOrder.value;
        if (order == null) {
          return Center(child: Text(l10n.orderNotFound));
        }
        String dateStr = '';
        try {
          dateStr = DateFormat('MMM d, y – h:mm a').format(DateTime.parse(order.createdAt).toLocal());
        } catch (_) {}

        return ListView(
          padding: const EdgeInsets.fromLTRB(20, 16, 20, 120),
          children: [
            // Header
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text('#${order.id.substring(0, 8).toUpperCase()}',
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold)),
                OrderStatusBadge(status: order.status),
              ],
            ),
            const SizedBox(height: 4),
            Text(dateStr, style: TextStyle(color: isDark ? Colors.grey.shade400 : Colors.grey.shade600, fontSize: 13)),
            const SizedBox(height: 16),

            // Items
            ...order.items.map((item) {
              final img = item.imageUrl;
              return Container(
                margin: const EdgeInsets.only(bottom: 12),
                child: Row(
                  children: [
                    ClipRRect(
                      borderRadius: BorderRadius.circular(10),
                      child: img != null
                          ? AuthNetworkImage(
                              url: img,
                              width: 64,
                              height: 64,
                              fit: BoxFit.cover,
                              errorWidget: () => _imgPh(),
                            )
                          : _imgPh(),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(item.productTitle,
                              style: Theme.of(context).textTheme.bodyMedium?.copyWith(fontWeight: FontWeight.w600),
                              maxLines: 2, overflow: TextOverflow.ellipsis),
                          if (item.variantTitle != null)
                            Text(item.variantTitle!,
                                style: Theme.of(context).textTheme.bodySmall?.copyWith(
                                    color: isDark ? Colors.grey.shade400 : Colors.grey.shade600)),
                          Text('${l10n.qty}: ${item.quantity}',
                              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                                  color: isDark ? Colors.grey.shade500 : Colors.grey)),
                        ],
                      ),
                    ),
                    Text('${item.totalPrice.toStringAsFixed(0)} EGP',
                        style: Theme.of(context).textTheme.bodyMedium?.copyWith(fontWeight: FontWeight.bold)),
                  ],
                ),
              );
            }),

            Divider(height: 24, color: isDark ? Colors.grey.shade700 : null),

            // Price breakdown
            _priceRow(context, l10n.subtotal, '${order.subtotal.toStringAsFixed(0)} EGP', isDark: isDark),
            const SizedBox(height: 6),
            _priceRow(context, l10n.shippingFee, '${order.shippingAmount.toStringAsFixed(0)} EGP', isDark: isDark),
            const SizedBox(height: 6),
            _priceRow(context, l10n.total, '${order.totalAmount.toStringAsFixed(0)} EGP', bold: true, isDark: isDark),

            const SizedBox(height: 16),

            // Shipping address
            if (order.parsedShippingAddress != null) ...[
              Text(l10n.shippingAddress,
                  style: Theme.of(context).textTheme.titleSmall?.copyWith(fontWeight: FontWeight.bold)),
              const SizedBox(height: 8),
              Container(
                padding: const EdgeInsets.all(14),
                decoration: BoxDecoration(
                  color: isDark ? AppColors.lightblack : Colors.grey.shade100,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Row(
                  children: [
                    const Icon(Icons.location_pin, color: AppColors.orange, size: 18),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(order.parsedShippingAddress!.label,
                              style: Theme.of(context).textTheme.bodyMedium?.copyWith(fontWeight: FontWeight.bold)),
                          Text(order.parsedShippingAddress!.fullLine,
                              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                                  color: isDark ? Colors.grey.shade400 : Colors.grey.shade600)),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 16),
            ],

            // Action buttons
            Row(
              children: [
                Expanded(
                  child: OutlinedButton.icon(
                    onPressed: () => Get.toNamed(AppRoutes.orderTracking, arguments: _orderId),
                    style: OutlinedButton.styleFrom(
                      side: const BorderSide(color: AppColors.orange),
                      padding: const EdgeInsets.symmetric(vertical: 12),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                    ),
                    icon: const Icon(Icons.track_changes_rounded, color: AppColors.orange, size: 18),
                    label: Text(l10n.track, style: const TextStyle(color: AppColors.orange)),
                  ),
                ),
                if (order.requiresPaymentProof) ...[
                  const SizedBox(width: 10),
                  Expanded(
                    child: ElevatedButton.icon(
                      onPressed: () => Get.toNamed(AppRoutes.paymentProof, arguments: _orderId),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.orange,
                        foregroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(vertical: 12),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                        elevation: 0,
                      ),
                      icon: const Icon(Icons.upload_outlined, size: 18),
                      label: Text(l10n.uploadProof),
                    ),
                  ),
                ],
              ],
            ),

            if (order.canConfirmDelivery) ...[
              const SizedBox(height: 12),
              Obx(() => SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: _ctrl.isActing.value
                          ? null
                          : () => _ctrl.confirmDelivery(_orderId),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.green,
                        foregroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(vertical: 14),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
                        elevation: 0,
                      ),
                      child: _ctrl.isActing.value
                          ? const SizedBox(height: 20, width: 20,
                              child: CircularProgressIndicator(strokeWidth: 2, color: Colors.white))
                          : Text(l10n.confirmDelivery,
                              style: const TextStyle(fontWeight: FontWeight.bold)),
                    ),
                  )),
            ],
          ],
        );
      }),
    );
  }

  Widget _priceRow(BuildContext context, String label, String value, {bool bold = false, required bool isDark}) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(label,
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  color: isDark ? Colors.grey.shade400 : Colors.grey.shade600,
                  fontWeight: bold ? FontWeight.bold : FontWeight.normal)),
        Text(value,
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  fontWeight: bold ? FontWeight.bold : FontWeight.w500)),
      ],
    );
  }

  Widget _imgPh() => Container(
        width: 64, height: 64,
        color: AppColors.storeCardBg,
        child: const Icon(Icons.pets, color: AppColors.lightorange));
}
