import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:petapp/core/utils/helper_functions.dart';
import 'package:petapp/core/utils/app_colors.dart';
import 'package:petapp/core/localization/app_localizations.dart';
import '../../models/vet_model.dart';
import '../../screens/vet_booking_screen.dart';
import '../vet_detail_screen_widgets/vet_global_discount_banner.dart';

class VetBookingSummary extends StatelessWidget {
  final VetBookingController controller;

  const VetBookingSummary({
    super.key,
    required this.controller,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = THelperFunctions.isDarkMode(context);
    final textColor = isDark ? Colors.white : Colors.black;
    final subTextColor = isDark ? Colors.grey[400] : Colors.grey[700];
    final cardColor = isDark ? Colors.grey[900] : Colors.white;

    // Get vet data from arguments
    final args = Get.arguments as Map<String, dynamic>?;
    final vetName = args?['vet']?['name'];
    final serviceName = args?['service'];
    final priceStr = args?['price'];
    final isEmergency = args?['isEmergency'] == true;

    // Parse discount from vet data
    VetDiscount? discount;
    if (args?['vet']?['discount'] != null) {
      final discountData = args!['vet']['discount'];
      if (discountData is VetDiscount) {
        discount = discountData;
      } else if (discountData is Map<String, dynamic>) {
        discount = VetDiscount.fromJson(discountData);
      }
    }

    // Parse price
    double originalPrice = 0.0;
    if (priceStr != null) {
      // Remove currency symbols and parse
      final cleanPrice = priceStr.toString().replaceAll(RegExp(r'[^\d.]'), '');
      originalPrice = double.tryParse(cleanPrice) ?? 0.0;
    }

    // Check for an app-level/global discount (applied across vets). 
    final rawGd = args?['vet']?['globalDiscount'];
    final globalDiscount = GlobalDiscount.tryParse(rawGd);

    // Calculate total discount and final price.
    // If both globalDiscount and vet discount exist, they are added together.
    double totalDiscountAmount = 0.0;
    
    final isEmergencyTime = THelperFunctions.isEmergencyTime();

    if (originalPrice > 0 && !isEmergencyTime && !isEmergency) {
      // 1. Calculate Vet Discount
      if (discount != null && discount.isActive) {
        totalDiscountAmount += discount.calculateDiscount(originalPrice);
      }
      
      // 2. Calculate Global Discount (only if not used)
      if (globalDiscount != null && !controller.globalDiscountAlreadyUsed.value) {
        if (globalDiscount.type == 'percentage') {
          totalDiscountAmount += originalPrice * (globalDiscount.value / 100);
        } else {
          totalDiscountAmount += globalDiscount.value;
        }
      }
    }

    double finalPrice = (originalPrice - totalDiscountAmount).clamp(0, double.infinity);

    // The outer widget itself doesn't directly read any Rx variables.
    // points redemption section below uses its own `Obx`. Wrapping this
    // entire card with `Obx` causes GetX to warn about improper usage, so we
    // return a normal widget tree and keep the inner reactive parts scoped
    // inside their own `Obx`.
    return Card(
      color: cardColor,
      elevation: isDark ? 8 : 4,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Show a prominent global discount banner when available and not already used
            Obx(() {
              if (globalDiscount != null && !controller.globalDiscountAlreadyUsed.value) {
                return Padding(
                  padding: const EdgeInsets.only(bottom: 12.0),
                  child: VetGlobalDiscountBanner(discount: globalDiscount),
                );
              }
              return const SizedBox.shrink();
            }),

            Text(
              AppLocalizations.of(context).bookingDetails,
              style: Theme.of(context).textTheme.titleLarge?.copyWith(
                    fontWeight: FontWeight.bold,
                    color: textColor,
                  ),
            ),
            const SizedBox(height: 16),
            _buildSummaryRow(
              context,
              Icons.local_hospital,
              AppLocalizations.of(context).vet,
              vetName,
              textColor,
              subTextColor,
            ),
            const SizedBox(height: 12),
            _buildSummaryRow(
              context,
              Icons.medical_services,
              AppLocalizations.of(context).service,
              serviceName,
              textColor,
              subTextColor,
            ),
            const SizedBox(height: 12),
            isEmergency
                ? _buildEmergencyPriceRow(context, priceStr, textColor, subTextColor)
                : Column(
                    children: [
                      // Price Breakdown
                      if (totalDiscountAmount > 0) ...[
                        _buildPriceRow(
                          context,
                          AppLocalizations.of(context).price,
                          '${originalPrice.toStringAsFixed(0)} EGP',
                          subTextColor,
                        ),
                        const SizedBox(height: 8),

                        // 1. Vet Discount
                        if (discount != null && discount.isActive)
                          _buildPriceRow(
                            context,
                            AppLocalizations.of(context).vetDiscount,
                            '- ${discount.calculateDiscount(originalPrice).toStringAsFixed(0)} EGP',
                            Colors.green,
                          ),

                        // 2. Global Discount
                        if (globalDiscount != null && !controller.globalDiscountAlreadyUsed.value)
                          _buildPriceRow(
                            context,
                            'Aleefy Discount',
                            '- ${(originalPrice * (globalDiscount.value / 100)).toStringAsFixed(0)} EGP',
                            Colors.green,
                          ),

                        const Padding(
                          padding: EdgeInsets.symmetric(vertical: 8.0),
                          child: Divider(height: 1),
                        ),
                      ],

                      // Final Total Row
                      Row(
                        children: [
                          Icon(Icons.attach_money, color: subTextColor, size: 20),
                          const SizedBox(width: 12),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  AppLocalizations.of(context).totalPrice,
                                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                                        color: subTextColor,
                                        fontWeight: FontWeight.bold,
                                      ),
                                ),
                                const SizedBox(height: 4),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text(
                                      '${finalPrice.toStringAsFixed(0)} EGP',
                                      style: Theme.of(context).textTheme.titleLarge?.copyWith(
                                            color: AppColors.orange,
                                            fontWeight: FontWeight.bold,
                                          ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),

            // Points redemption section
            const SizedBox(height: 16),
            const Divider(),
            const SizedBox(height: 12),
            _buildPointsRedemptionSection(
              context,
              originalPrice,
              textColor,
              subTextColor,
            ),

            // (Removed duplicate discount banner + breakdown — the prominent
            // `VetGlobalDiscountBanner` is shown above and the inline price row
            // already reflects the discounted amount. Keep points section only.)
          ],
        ),
      ),
    );

  }

  /// Build points redemption section
  Widget _buildPointsRedemptionSection(
    BuildContext context,
    double originalPrice,
    Color textColor,
    Color? subTextColor,
  ) {
    return Obx(() {
      final pointsToRedeem = controller.pointsToRedeem.value;
      final isValidating = controller.isValidatingPoints.value;
      final isValid = controller.isPointsValid.value;
      final validationMessage = controller.pointsValidationMessage.value;
      final pointsDetails = controller.pointsDetails.value;

      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Icon(Icons.stars, color: AppColors.orange, size: 20),
              const SizedBox(width: 8),
              Text(
                AppLocalizations.of(context).redeemPoints,
                style: Theme.of(context).textTheme.titleSmall?.copyWith(
                      fontWeight: FontWeight.bold,
                      color: textColor,
                    ),
              ),
            ],
          ),
          const SizedBox(height: 12),

          // Points balance display
          if (controller.currentPointsBalance.value > 0)
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: AppColors.orange.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(8),
                border: Border.all(
                  color: AppColors.orange.withValues(alpha: 0.3),
                  width: 1,
                ),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    '${AppLocalizations.of(context).availablePoints}:',
                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                          color: subTextColor,
                        ),
                  ),
                  Text(
                    '${controller.currentPointsBalance.value} ${AppLocalizations.of(context).pts}',
                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                          color: AppColors.orange,
                          fontWeight: FontWeight.bold,
                        ),
                  ),
                ],
              ),
            ),

          const SizedBox(height: 12),

          // Points input field
          TextField(
            keyboardType: TextInputType.number,
            decoration: InputDecoration(
              labelText: AppLocalizations.of(context).pointsToRedeem,
              hintText: AppLocalizations.of(context).enterPointsAmount,
              prefixIcon: const Icon(Icons.stars),
              suffixIcon: isValidating
                  ? const Padding(
                      padding: EdgeInsets.all(12.0),
                      child: SizedBox(
                        width: 20,
                        height: 20,
                        child: CircularProgressIndicator(strokeWidth: 2),
                      ),
                    )
                  : pointsToRedeem > 0 && isValid
                      ? const Icon(Icons.check_circle, color: Colors.green)
                      : null,
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8),
                borderSide: const BorderSide(color: AppColors.orange, width: 2),
              ),
            ),
            onChanged: (value) {
              final points = int.tryParse(value) ?? 0;
              controller.updatePointsToRedeem(points);
            },
          ),

          // Validation message
          if (validationMessage.isNotEmpty) ...[
            const SizedBox(height: 8),
            Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: isValid
                    ? Colors.green.withValues(alpha: 0.1)
                    : Colors.red.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(6),
              ),
              child: Row(
                children: [
                  Icon(
                    isValid ? Icons.check_circle : Icons.error,
                    size: 16,
                    color: isValid ? Colors.green : Colors.red,
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      validationMessage,
                      style: Theme.of(context).textTheme.bodySmall?.copyWith(
                            color: isValid ? Colors.green : Colors.red,
                          ),
                    ),
                  ),
                ],
              ),
            ),
          ],

          // Points discount breakdown
          if (isValid && pointsToRedeem > 0 && pointsDetails != null) ...[
            const SizedBox(height: 12),
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Colors.green.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(8),
                border: Border.all(
                  color: Colors.green.withValues(alpha: 0.3),
                  width: 1,
                ),
              ),
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        '${AppLocalizations.of(context).pointsDiscount}:',
                        style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                              color: Colors.green,
                              fontWeight: FontWeight.bold,
                            ),
                      ),
                      Text(
                        '- ${pointsDetails['discountAmount']?.toStringAsFixed(0) ?? '0'} EGP',
                        style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                              color: Colors.green,
                              fontWeight: FontWeight.bold,
                            ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        '${AppLocalizations.of(context).remainingBalance}:',
                        style: Theme.of(context).textTheme.bodySmall?.copyWith(
                              color: subTextColor,
                            ),
                      ),
                      Text(
                        '${pointsDetails['remainingBalance']} ${AppLocalizations.of(context).pts}',
                        style: Theme.of(context).textTheme.bodySmall?.copyWith(
                              color: subTextColor,
                            ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ],
      );
    });
  }

  /// Build emergency price row with red styling
  Widget _buildEmergencyPriceRow(
    BuildContext context,
    String price,
    Color textColor,
    Color? subTextColor,
  ) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
      decoration: BoxDecoration(
        color: Colors.red.withValues(alpha: 0.08),
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: Colors.red.withValues(alpha: 0.3)),
      ),
      child: Row(
        children: [
          const Icon(Icons.emergency, color: Colors.red, size: 20),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  AppLocalizations.of(context).emergencyFee,
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                        color: Colors.red.withValues(alpha: 0.8),
                      ),
                ),
                Text(
                  price,
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                        fontWeight: FontWeight.bold,
                        color: Colors.red,
                      ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  /// Build summary row
  Widget _buildSummaryRow(
    BuildContext context,
    IconData icon,
    String label,
    String value,
    Color textColor,
    Color? subTextColor,
  ) {
    return Row(
      children: [
        Icon(icon, color: subTextColor, size: 20),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                label,
                style: Theme.of(context).textTheme.bodySmall?.copyWith(
                      color: subTextColor,
                    ),
              ),
              Text(
                value,
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                      fontWeight: FontWeight.bold,
                      color: textColor,
                    ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  /// Build price detail row
  Widget _buildPriceRow(
    BuildContext context,
    String label,
    String value,
    Color? color,
  ) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          label,
          style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                color: color ?? Colors.grey[600],
              ),
        ),
        Text(
          value,
          style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                color: color ?? Colors.black,
                fontWeight: FontWeight.bold,
              ),
        ),
      ],
    );
  }
}
