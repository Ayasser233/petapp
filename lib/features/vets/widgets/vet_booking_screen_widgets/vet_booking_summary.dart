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
                    'Original Price:',
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
                    'Discount:',
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
                    'Final Price:',
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(
                          color: textColor,
                          fontWeight: FontWeight.bold,
                        ),
                  ),
                  Text(
                    '${finalPrice.toStringAsFixed(0)} EGP',
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
