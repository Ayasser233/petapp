import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:petapp/core/utils/app_colors.dart';
import 'package:petapp/core/routes/routes.dart';

enum DeliveryMethod { shipping, pickUp }

class DeliveryScreen extends StatefulWidget {
  const DeliveryScreen({super.key});

  @override
  State<DeliveryScreen> createState() => _DeliveryScreenState();
}

class _DeliveryScreenState extends State<DeliveryScreen> {
  DeliveryMethod _selected = DeliveryMethod.shipping;

  // Mock address — in production this would come from user profile / address book
  static const _mockAddress = _AddressData(
    label: 'El Salam, Cairo',
    full: 'Al Obour Street, Cairo, 11788, Egypt',
  );
  bool _hasAddress = false; // toggle to true once "Add Address" is tapped

  @override
  Widget build(BuildContext context) {
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
          'Delivery',
          style: Theme.of(context)
              .textTheme
              .titleLarge
              ?.copyWith(fontWeight: FontWeight.bold),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Select delivery method',
              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
            ),
            const SizedBox(height: 16),

            // Shipping option
            _buildMethodCard(
              context: context,
              icon: Icons.local_shipping_outlined,
              title: 'Shipping',
              subtitle: 'Delivered to your address',
              method: DeliveryMethod.shipping,
              isDark: isDark,
            ),
            const SizedBox(height: 12),

            // Pick up option
            _buildMethodCard(
              context: context,
              icon: Icons.storefront_outlined,
              title: 'Pick Up',
              subtitle: 'Pick up your order from the store',
              method: DeliveryMethod.pickUp,
              isDark: isDark,
            ),

            const SizedBox(height: 28),

            // Address section — only relevant when shipping is selected
            if (_selected == DeliveryMethod.shipping) ...[
              if (!_hasAddress) _buildNoAddress(context) else _buildAddressCard(context, _mockAddress, isDark),
            ],

            const Spacer(),

            // CTA
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: (_selected == DeliveryMethod.shipping && !_hasAddress)
                    ? null
                    : () => Get.toNamed(AppRoutes.checkout),
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.orange,
                  disabledBackgroundColor: Colors.grey.shade300,
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(30)),
                  elevation: 0,
                ),
                child: const Text(
                  'Continue',
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                ),
              ),
            ),
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
              : isDark
                  ? AppColors.lightblack
                  : Colors.white,
          borderRadius: BorderRadius.circular(14),
          border: Border.all(
            color: isSelected ? AppColors.orange : Colors.grey.shade200,
            width: isSelected ? 1.5 : 1,
          ),
          boxShadow: [
            if (!isDark)
              BoxShadow(
                color: Colors.grey.withValues(alpha: 0.08),
                blurRadius: 8,
                offset: const Offset(0, 2),
              ),
          ],
        ),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: isSelected
                    ? AppColors.orange.withValues(alpha: 0.15)
                    : Colors.grey.shade100,
                shape: BoxShape.circle,
              ),
              child: Icon(icon,
                  size: 22,
                  color: isSelected ? AppColors.orange : Colors.grey.shade600),
            ),
            const SizedBox(width: 14),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(title,
                      style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                            fontWeight: FontWeight.bold,
                          )),
                  const SizedBox(height: 2),
                  Text(subtitle,
                      style: Theme.of(context).textTheme.bodySmall?.copyWith(
                            color: isSelected
                                ? AppColors.orange
                                : Colors.grey.shade600,
                            fontSize: 12,
                          )),
                ],
              ),
            ),
            if (isSelected)
              const Icon(Icons.check_circle, color: AppColors.orange, size: 22),
          ],
        ),
      ),
    );
  }

  Widget _buildNoAddress(BuildContext context) {
    return Column(
      children: [
        const SizedBox(height: 16),
        const Icon(Icons.location_on_rounded,
            size: 90, color: AppColors.orange),
        const SizedBox(height: 16),
        Text(
          'No delivery address yet',
          style: Theme.of(context)
              .textTheme
              .titleMedium
              ?.copyWith(fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 8),
        Text(
          "Add your first address so we know where to deliver your pet's goodies",
          style: Theme.of(context)
              .textTheme
              .bodySmall
              ?.copyWith(color: Colors.grey),
          textAlign: TextAlign.center,
        ),
        const SizedBox(height: 24),
        SizedBox(
          width: double.infinity,
          child: ElevatedButton(
            onPressed: () {
              // In production, navigate to add address flow.
              // Here we mock it by setting _hasAddress = true.
              setState(() => _hasAddress = true);
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.orange,
              foregroundColor: Colors.white,
              padding: const EdgeInsets.symmetric(vertical: 16),
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(30)),
              elevation: 0,
            ),
            child: const Text(
              'Add Address',
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildAddressCard(BuildContext context, _AddressData address, bool isDark) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        TextButton(
          onPressed: () {},
          child: Text(
            'Add another address?',
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  fontWeight: FontWeight.bold,
                  color: AppColors.lightblack,
                ),
          ),
        ),
        const SizedBox(height: 8),
        Container(
          width: double.infinity,
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: isDark ? AppColors.lightblack : Colors.grey.shade100,
            borderRadius: BorderRadius.circular(14),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  const Icon(Icons.location_pin,
                      color: AppColors.orange, size: 20),
                  const SizedBox(width: 6),
                  Text(
                    address.label,
                    style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                  ),
                ],
              ),
              const SizedBox(height: 6),
              Text(
                address.full,
                style: Theme.of(context).textTheme.bodySmall?.copyWith(
                      color: Colors.grey.shade600,
                    ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class _AddressData {
  final String label;
  final String full;
  const _AddressData({required this.label, required this.full});
}
