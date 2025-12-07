import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:petapp/core/utils/helper_functions.dart';
import 'package:petapp/core/utils/app_colors.dart';
import 'package:petapp/core/localization/app_localizations.dart';
import '../../models/vet_model.dart';
import '../../screens/vet_booking_screen.dart';

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

    // Calculate discount amount and final price
    double discountAmount = 0.0;
    double finalPrice = originalPrice;
    if (discount != null && discount.isActive && originalPrice > 0) {
      discountAmount = discount.calculateDiscount(originalPrice);
      finalPrice = originalPrice - discountAmount;
    }

    return Obx(() {
      // Get points discount from controller
      final pointsDiscount = controller.pointsDiscountAmount.value;
      final totalDiscount = discountAmount + pointsDiscount;
      final finalPriceWithPoints = finalPrice - pointsDiscount;

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
            _buildSummaryRow(
              context,
              Icons.attach_money,
              AppLocalizations.of(context).price,
              priceStr,
              textColor,
              subTextColor,
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

            // Discount information
            if (discount != null && discount.isActive && discountAmount > 0) ...[
              const SizedBox(height: 16),
              const Divider(),
              const SizedBox(height: 12),

              // Discount banner
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [
                      Colors.red.shade50,
                      Colors.orange.shade50,
                    ],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(
                    color: Colors.red.shade200,
                    width: 1,
                  ),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Icon(
                          Icons.local_offer,
                          color: Colors.red.shade700,
                          size: 20,
                        ),
                        const SizedBox(width: 8),
                        Text(
                          discount.title,
                          style: Theme.of(context).textTheme.titleSmall?.copyWith(
                                fontWeight: FontWeight.bold,
                                color: Colors.red.shade700,
                              ),
                        ),
                        const Spacer(),
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 8,
                            vertical: 4,
                          ),
                          decoration: BoxDecoration(
                            color: Colors.red.shade700,
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Text(
                            discount.formattedDiscount,
                            style: Theme.of(context).textTheme.bodySmall?.copyWith(
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 11,
                                ),
                          ),
                        ),
                      ],
                    ),
                    if (discount.description.isNotEmpty) ...[
                      const SizedBox(height: 4),
                      Text(
                        discount.description,
                        style: Theme.of(context).textTheme.bodySmall?.copyWith(
                              color: Colors.grey[700],
                            ),
                      ),
                    ],
                  ],
                ),
              ),

              const SizedBox(height: 12),

              // Price breakdown
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    '${AppLocalizations.of(context).originalPrice}:',
                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                          color: subTextColor,
                        ),
                  ),
                  Text(
                    '${originalPrice.toStringAsFixed(0)} EGP',
                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                          color: subTextColor,
                          decoration: TextDecoration.lineThrough,
                        ),
                  ),
                ],
              ),
              const SizedBox(height: 8),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    '${AppLocalizations.of(context).discount}:',
                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                          color: Colors.green,
                        ),
                  ),
                  Text(
                    '- ${discountAmount.toStringAsFixed(0)} EGP',
                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                          color: Colors.green,
                          fontWeight: FontWeight.bold,
                        ),
                  ),
                ],
              ),
              const SizedBox(height: 8),
              const Divider(),
              const SizedBox(height: 8),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    '${AppLocalizations.of(context).finalPrice}:',
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(
                          color: textColor,
                          fontWeight: FontWeight.bold,
                        ),
                  ),
                  Text(
                    '${finalPriceWithPoints.toStringAsFixed(0)} EGP',
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(
                          color: AppColors.orange,
                          fontWeight: FontWeight.bold,
                        ),
                  ),
                ],
              ),
            ],
          ],
        ),
      ),
    );
    }); // Close Obx
  }

  /// Build points redemption section
  Widget _buildPointsRedemptionSection(
    BuildContext context,
    double originalPrice,
    Color textColor,
    Color? subTextColor,
  ) {
    return Obx(() {
      final currentBalance = controller.currentPointsBalance.value;
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
          if (pointsDetails != null && pointsDetails['currentBalance'] != null)
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
                    '${pointsDetails['currentBalance']} ${AppLocalizations.of(context).pts}',
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
}
