import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:petapp/core/localization/app_localizations.dart';
import 'package:petapp/core/utils/app_colors.dart';
import 'package:petapp/core/routes/routes.dart';
import 'package:petapp/features/store/models/checkout_result_model.dart';

class OrderConfirmationScreen extends StatelessWidget {
  const OrderConfirmationScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final result = Get.arguments as InitiateCheckoutResultModel;
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final l10n = AppLocalizations.of(context);

    return Scaffold(
      backgroundColor: isDark ? Colors.black : Colors.white,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(Icons.check_circle_rounded, color: Colors.green, size: 80),
              const SizedBox(height: 20),
              Text(l10n.orderPlaced,
                  style: Theme.of(context).textTheme.headlineSmall?.copyWith(fontWeight: FontWeight.bold)),
              const SizedBox(height: 8),
              Text(result.orderName,
                  style: Theme.of(context).textTheme.titleLarge?.copyWith(
                        color: AppColors.orange, fontWeight: FontWeight.bold)),
              const SizedBox(height: 16),
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: isDark ? AppColors.lightblack : Colors.grey.shade100,
                  borderRadius: BorderRadius.circular(14),
                ),
                child: Column(
                  children: [
                    _row(context, l10n.subtotal,
                        '${result.summary.subtotal.toStringAsFixed(0)} EGP', isDark: isDark),
                    const SizedBox(height: 6),
                    _row(context, l10n.shipping,
                        '${result.summary.shippingAmount.toStringAsFixed(0)} EGP', isDark: isDark),
                    const Divider(height: 16),
                    _row(context, l10n.total,
                        '${result.summary.totalAmount.toStringAsFixed(0)} EGP',
                        bold: true, isDark: isDark),
                  ],
                ),
              ),
              if (result.summary.warnings.isNotEmpty) ...[
                const SizedBox(height: 12),
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: isDark ? Colors.amber.shade900.withValues(alpha: 0.3) : Colors.amber.shade50,
                    borderRadius: BorderRadius.circular(10),
                    border: Border.all(color: Colors.amber.shade200),
                  ),
                  child: Row(
                    children: [
                      const Icon(Icons.warning_amber_rounded, color: Colors.amber, size: 18),
                      const SizedBox(width: 8),
                      Expanded(
                        child: Text(
                          l10n.pricesChanged,
                          style: TextStyle(color: isDark ? Colors.amber.shade200 : Colors.amber.shade800, fontSize: 13),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
              const SizedBox(height: 32),
              if (result.requiresPaymentProof) ...[
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton.icon(
                    onPressed: () =>
                        Get.toNamed(AppRoutes.paymentProof, arguments: result.orderId),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.orange,
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(vertical: 14),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
                      elevation: 0,
                    ),
                    icon: const Icon(Icons.upload_outlined),
                    label: Text(l10n.uploadPaymentProof,
                        style: const TextStyle(fontWeight: FontWeight.bold)),
                  ),
                ),
                const SizedBox(height: 12),
              ],
              SizedBox(
                width: double.infinity,
                child: OutlinedButton.icon(
                  onPressed: () =>
                      Get.toNamed(AppRoutes.orderDetail, arguments: result.orderId),
                  style: OutlinedButton.styleFrom(
                    side: const BorderSide(color: AppColors.orange),
                    padding: const EdgeInsets.symmetric(vertical: 14),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
                  ),
                  icon: const Icon(Icons.track_changes_rounded, color: AppColors.orange),
                  label: Text(l10n.trackOrder,
                      style: const TextStyle(color: AppColors.orange, fontWeight: FontWeight.bold)),
                ),
              ),
              const SizedBox(height: 12),
              TextButton(
                onPressed: () => Get.until((r) => r.settings.name == AppRoutes.home),
                child: Text(l10n.backToHome,
                    style: TextStyle(color: isDark ? Colors.grey.shade400 : Colors.grey, fontWeight: FontWeight.w500)),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _row(BuildContext context, String label, String value, {bool bold = false, required bool isDark}) {
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
}