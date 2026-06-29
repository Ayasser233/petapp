import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:petapp/core/localization/app_localizations.dart';
import 'package:petapp/core/utils/app_colors.dart';
import 'package:petapp/core/routes/routes.dart';
import 'package:petapp/features/store/controllers/checkout_controller.dart';
import 'package:petapp/features/store/models/shipping_address_model.dart';

enum DeliveryMethod { shipping, pickUp }

class DeliveryScreen extends StatefulWidget {
  const DeliveryScreen({super.key});

  @override
  State<DeliveryScreen> createState() => _DeliveryScreenState();
}

class _DeliveryScreenState extends State<DeliveryScreen> {
  DeliveryMethod _selected = DeliveryMethod.shipping;

  @override
  Widget build(BuildContext context) {
    final checkoutCtrl = Get.find<CheckoutController>();
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
        title: Text(l10n.delivery,
            style: Theme.of(context).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold)),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(l10n.selectDeliveryMethod,
                style: Theme.of(context).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold)),
            const SizedBox(height: 16),
            _buildMethodCard(
              context: context,
              icon: Icons.local_shipping_outlined,
              title: l10n.shipping,
              subtitle: l10n.deliveredToAddress,
              method: DeliveryMethod.shipping,
              isDark: isDark,
            ),
            const SizedBox(height: 12),
            _buildMethodCard(
              context: context,
              icon: Icons.storefront_outlined,
              title: l10n.pickUp,
              subtitle: l10n.pickUpFromStore,
              method: DeliveryMethod.pickUp,
              isDark: isDark,
            ),
            const SizedBox(height: 28),
            if (_selected == DeliveryMethod.shipping) ...[
              Obx(() {
                final addresses = checkoutCtrl.savedAddresses;
                if (addresses.isEmpty) {
                  return _buildNoAddress(context);
                }
                return _buildAddressList(context, checkoutCtrl, addresses, isDark);
              }),
            ],
            const Spacer(),
            Obx(() {
              final canContinue = _selected == DeliveryMethod.pickUp ||
                  checkoutCtrl.selectedAddress.value != null;
              return SizedBox(
                width: double.infinity,
                  child: ElevatedButton(
                    onPressed: canContinue ? () => Get.toNamed(AppRoutes.scheduleOrder) : null,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.orange,
                      disabledBackgroundColor: Colors.grey.shade300,
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
                      elevation: 0,
                    ),
                    child: Text(l10n.continueText,
                        style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                  ),
              );
            }),
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }

  Widget _buildMethodCard({
    required BuildContext context,
    required IconData icon,
    required String title,
    required String subtitle,
    required DeliveryMethod method,
    required bool isDark,
  }) {
    final isSelected = _selected == method;
    return GestureDetector(
      onTap: () => setState(() => _selected = method),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 18),
        decoration: BoxDecoration(
          color: isSelected
              ? AppColors.orange.withValues(alpha: 0.12)
              : isDark ? AppColors.lightblack : Colors.white,
          borderRadius: BorderRadius.circular(14),
          border: Border.all(
            color: isSelected ? AppColors.orange : Colors.grey.shade200,
            width: isSelected ? 1.5 : 1,
          ),
          boxShadow: [
            if (!isDark)
              BoxShadow(color: Colors.grey.withValues(alpha: 0.08), blurRadius: 8, offset: const Offset(0, 2)),
          ],
        ),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: isSelected ? AppColors.orange.withValues(alpha: 0.15) : Colors.grey.shade100,
                shape: BoxShape.circle,
              ),
              child: Icon(icon, size: 22, color: isSelected ? AppColors.orange : Colors.grey.shade600),
            ),
            const SizedBox(width: 14),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(title,
                      style: Theme.of(context).textTheme.bodyLarge?.copyWith(fontWeight: FontWeight.bold)),
                  const SizedBox(height: 2),
                  Text(subtitle,
                      style: Theme.of(context).textTheme.bodySmall?.copyWith(
                            color: isSelected ? AppColors.orange : Colors.grey.shade600, fontSize: 12)),
                ],
              ),
            ),
            if (isSelected) const Icon(Icons.check_circle, color: AppColors.orange, size: 22),
          ],
        ),
      ),
    );
  }

  Widget _buildNoAddress(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    return Column(
      children: [
        const Icon(Icons.location_on_rounded, size: 90, color: AppColors.orange),
        const SizedBox(height: 16),
        Text(l10n.noDeliveryAddress,
            style: Theme.of(context).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold)),
        const SizedBox(height: 8),
        Text(l10n.addFirstAddressMessage,
            style: Theme.of(context).textTheme.bodySmall?.copyWith(color: Colors.grey),
            textAlign: TextAlign.center),
        const SizedBox(height: 24),
        SizedBox(
          width: double.infinity,
          child: ElevatedButton(
            onPressed: () => Get.toNamed(AppRoutes.addAddress),
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.orange,
              foregroundColor: Colors.white,
              padding: const EdgeInsets.symmetric(vertical: 16),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
              elevation: 0,
            ),
            child: Text(l10n.addAddress, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 15)),
          ),
        ),
      ],
    );
  }

  Widget _buildAddressList(BuildContext context, CheckoutController ctrl,
      List<ShippingAddressModel> addresses, bool isDark) {
    final l10n = AppLocalizations.of(context);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(l10n.addAnotherAddress,
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(fontWeight: FontWeight.bold)),
            TextButton(
              onPressed: () => Get.toNamed(AppRoutes.addAddress),
              child: Text('+ ${l10n.addAddress}', style: const TextStyle(color: AppColors.orange)),
            ),
          ],
        ),
        ...addresses.map((addr) {
          final isSelected = ctrl.selectedAddress.value == addr;
          return GestureDetector(
            onTap: () => ctrl.selectAddress(addr),
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 200),
              margin: const EdgeInsets.only(bottom: 10),
              padding: const EdgeInsets.all(14),
              decoration: BoxDecoration(
                color: isDark ? AppColors.lightblack : Colors.grey.shade100,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(
                  color: isSelected ? AppColors.orange : Colors.transparent,
                  width: isSelected ? 1.5 : 1,
                ),
              ),
              child: Row(
                children: [
                  Icon(Icons.location_pin, color: AppColors.orange, size: 20),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(addr.label,
                            style: Theme.of(context)
                                .textTheme
                                .bodyLarge
                                ?.copyWith(fontWeight: FontWeight.bold)),
                        const SizedBox(height: 2),
                        Text(addr.fullLine,
                            style: Theme.of(context)
                                .textTheme
                                .bodySmall
                                ?.copyWith(color: Colors.grey.shade600)),
                      ],
                    ),
                  ),
                  if (isSelected) const Icon(Icons.check_circle, color: AppColors.orange, size: 18),
                ],
              ),
            ),
          );
        }),
      ],
    );
  }
}