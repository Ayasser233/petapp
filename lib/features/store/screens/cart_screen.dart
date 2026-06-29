import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:petapp/core/localization/app_localizations.dart';
import 'package:petapp/core/utils/app_colors.dart';
import 'package:petapp/core/routes/routes.dart';
import 'package:petapp/features/store/controllers/cart_controller.dart';
import 'package:petapp/features/store/models/cart_model.dart';
import 'package:petapp/features/store/widgets/payment_summary_widget.dart';
import 'package:petapp/features/store/widgets/quantity_stepper.dart';

class CartScreen extends StatelessWidget {
  const CartScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final CartController cartCtrl = Get.find<CartController>();
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
        title: Text(l10n.myCart,
            style: Theme.of(context).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold)),
      ),
      body: Obx(() {
        if (cartCtrl.isLoading.value) {
          return const Center(child: CircularProgressIndicator(color: AppColors.orange));
        }
        if (cartCtrl.isEmpty) return _buildEmptyCart(context);
        return _buildFilledCart(context, cartCtrl, isDark);
      }),    );
  }

  Widget _buildEmptyCart(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Stack(alignment: Alignment.center, children: [
            Container(
              width: 160, height: 140,
              decoration: const BoxDecoration(color: Colors.transparent),
              child: CustomPaint(painter: _CartPainter()),
            ),
          ]),
          const SizedBox(height: 20),
          Text(l10n.cartEmpty,
              style: Theme.of(context)
                  .textTheme
                  .titleMedium
                  ?.copyWith(fontWeight: FontWeight.bold, fontSize: 18)),
          const SizedBox(height: 8),
          Text(l10n.cartEmptyMessage,
              style: Theme.of(context).textTheme.bodySmall?.copyWith(color: Colors.grey),
              textAlign: TextAlign.center),
          const SizedBox(height: 32),
          ElevatedButton(
            onPressed: () => Get.toNamed(AppRoutes.store),
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.orange,
              foregroundColor: Colors.white,
              padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 14),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
              elevation: 0,
            ),
            child: Text(l10n.browseStore, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 15)),
          ),
        ],
      ),
    );
  }

  Widget _buildFilledCart(BuildContext context, CartController cartCtrl, bool isDark) {
    return ListView(
      padding: const EdgeInsets.fromLTRB(16, 16, 16, 120),
      children: [
        ...cartCtrl.items.map((item) => _buildCartItem(context, item, cartCtrl, isDark)),
        const SizedBox(height: 24),
        PaymentSummaryWidget(
          subtotal: cartCtrl.subtotal,
          discount: 0,
          total: cartCtrl.subtotal,
          itemCount: cartCtrl.items.length,
          onCheckout: () => Get.toNamed(AppRoutes.delivery),
        ),
      ],
    );
  }

  Widget _buildCartItem(BuildContext context, CartItemApiModel item, CartController cartCtrl, bool isDark) {
    final imageUrl = item.productImageUrl;
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(10),
            child: imageUrl != null
                ? Image.network(imageUrl, width: 80, height: 90, fit: BoxFit.cover,
                    errorBuilder: (_, __, ___) => _imagePlaceholder())
                : _imagePlaceholder(),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(item.productTitle ?? 'Product',
                              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                                    fontWeight: FontWeight.bold, fontSize: 13),
                              maxLines: 2, overflow: TextOverflow.ellipsis),
                          if (item.variantTitle != null)
                            Text(item.variantTitle!,
                                style: Theme.of(context).textTheme.bodySmall?.copyWith(
                                      color: Colors.grey.shade600, fontSize: 11),
                                maxLines: 1, overflow: TextOverflow.ellipsis),
                        ],
                      ),
                    ),
                    const SizedBox(width: 8),
                    Obx(() => QuantityStepper(
                          quantity: cartCtrl.quantityOf(item.variantId),
                          onIncrement: () => cartCtrl.increment(item.variantId),
                          onDecrement: () => cartCtrl.decrement(item.variantId),
                          compact: true,
                        )),
                  ],
                ),
                const SizedBox(height: 6),
                Text('${item.lineTotal.toStringAsFixed(0)} EGP',
                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                          fontWeight: FontWeight.bold, fontSize: 14)),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _imagePlaceholder() => Container(
        width: 80, height: 90,
        color: AppColors.storeCardBg,
        child: const Icon(Icons.pets, color: AppColors.lightorange),
      );
}

class _CartPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final fillPaint = Paint()..color = const Color(0xFFF5C518)..style = PaintingStyle.fill;
    final strokePaint = Paint()..color = const Color(0xFF3D5A80)..style = PaintingStyle.stroke..strokeWidth = 5..strokeCap = StrokeCap.round;
    final wheelPaint = Paint()..color = const Color(0xFF3D5A80)..style = PaintingStyle.fill;
    final cx = size.width / 2;
    final bodyRect = RRect.fromRectAndRadius(Rect.fromLTWH(cx - 55, 30, 110, 65), const Radius.circular(10));
    canvas.drawRRect(bodyRect, fillPaint);
    final stripePaint = Paint()..color = Colors.white.withValues(alpha: 0.7)..style = PaintingStyle.stroke..strokeWidth = 4..strokeCap = StrokeCap.round;
    for (int i = 0; i < 5; i++) {
      final x = cx - 38 + i * 20.0;
      canvas.drawLine(Offset(x, 40), Offset(x, 85), stripePaint);
    }
    final path = Path()..moveTo(cx - 58, 62)..lineTo(cx - 70, 20)..lineTo(cx - 85, 20);
    canvas.drawPath(path, strokePaint);
    canvas.drawLine(Offset(cx - 55, 95), Offset(cx + 55, 95), strokePaint);
    canvas.drawCircle(Offset(cx - 30, 115), 14, wheelPaint);
    canvas.drawCircle(Offset(cx + 30, 115), 14, wheelPaint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}