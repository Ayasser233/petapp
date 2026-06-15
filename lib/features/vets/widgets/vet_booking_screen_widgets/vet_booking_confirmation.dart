import 'package:flutter/material.dart';
import 'package:qr_flutter/qr_flutter.dart';
import 'package:intl/intl.dart';
import 'dart:io';
import 'package:petapp/core/utils/app_colors.dart';
import 'package:get/get.dart';
import 'package:petapp/core/utils/helper_functions.dart';
import 'package:petapp/core/localization/app_localizations.dart';
import '../../screens/vet_booking_screen.dart';
import '../vet_detail_screen_widgets/vet_global_discount_banner.dart';

class VetBookingConfirmation extends StatelessWidget {
  final VetBookingController controller;

  const VetBookingConfirmation({
    super.key,
    required this.controller,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = THelperFunctions.isDarkMode(context);
    final textColor = isDark ? Colors.white : Colors.black;
    final formattedDate = DateFormat('EEEE, MMMM d, yyyy').format(controller.selectedDay.value);

    return SingleChildScrollView(
      padding: const EdgeInsets.all(24.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(
            Icons.check_circle,
            color: Colors.green,
            size: 80,
          ),
          const SizedBox(height: 24),
          Text(
            AppLocalizations.of(context).bookingConfirmed,
            style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                  fontWeight: FontWeight.bold,
                  color: textColor,
                ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 16),
          _buildBookingDetailsCard(context, formattedDate, isDark, textColor),
          const SizedBox(height: 24),
          if (controller.selectedPets.isNotEmpty) ...[
            _buildSelectedPets(context, textColor),
            const SizedBox(height: 24),
          ],
          _buildQRCodeSection(context, formattedDate, isDark, textColor),
          const SizedBox(height: 32),
          _buildDoneButton(context),
        ],
      ),
    );
  }

  /// Build booking details card
  Widget _buildBookingDetailsCard(
    BuildContext context,
    String formattedDate,
    bool isDark,
    Color textColor,
  ) {
    // Extract price and global discount from route arguments so the receipt
    // reflects any global discount applied at checkout.
    final args = Get.arguments as Map<String, dynamic>?;
    final priceStr = args?['price'] ?? args?['vet']?['consultationFee'];
    double originalPrice = 0.0;
    if (priceStr != null) {
      final cleanPrice = priceStr.toString().replaceAll(RegExp(r'[^\d.]'), '');
      originalPrice = double.tryParse(cleanPrice) ?? 0.0;
    }

    final rawGd = args?['vet']?['globalDiscount'];
    final globalDiscount = GlobalDiscount.tryParse(rawGd);
    double globalDiscountAmount = 0.0;
    double priceAfterGlobal = originalPrice;
    if (globalDiscount != null && originalPrice > 0) {
      priceAfterGlobal = globalDiscount.discountedPrice(originalPrice);
      globalDiscountAmount = (originalPrice - priceAfterGlobal).clamp(0, double.infinity);
    }

    // Points discount (if user redeemed points)
    final pointsDiscount = controller.pointsDiscountAmount.value;
    final finalPrice = (priceAfterGlobal - pointsDiscount).clamp(0, double.infinity);

    return Card(
      elevation: isDark ? 8 : 4,
      color: isDark ? Colors.grey[900] : Colors.white,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            _buildBookingDetail(
              context,
              AppLocalizations.of(context).date,
              formattedDate,
              textColor,
            ),
            const Divider(),
            _buildBookingDetail(
              context,
              AppLocalizations.of(context).time,
              controller.selectedTimeSlot.value,
              textColor,
            ),
            const Divider(),
            _buildBookingDetail(
              context,
              AppLocalizations.of(context).reference,
              controller.bookingReference.value,
              textColor,
            ),
            if (controller.selectedPets.isNotEmpty) ...[
              const Divider(),
              _buildPetsDetail(context, textColor),
            ],
            // Price breakdown (show when there is a price)
            if (originalPrice > 0) ...[
              const Divider(),
              const SizedBox(height: 8),
              // Original price / discounted (global) / points / final
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    AppLocalizations.of(context).price,
                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                          color: Colors.grey,
                        ),
                  ),
                  Text(
                    '${originalPrice.toStringAsFixed(0)} EGP',
                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                          color: textColor,
                          decoration: globalDiscount != null ? TextDecoration.lineThrough : null,
                        ),
                  ),
                ],
              ),
              if (globalDiscount != null && globalDiscountAmount > 0) ...[
                const SizedBox(height: 8),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      AppLocalizations.of(context).discount,
                      style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                            color: Colors.green,
                          ),
                    ),
                    Text(
                      '- ${globalDiscountAmount.toStringAsFixed(0)} EGP',
                      style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                            color: Colors.green,
                            fontWeight: FontWeight.bold,
                          ),
                    ),
                  ],
                ),
              ],
              if (pointsDiscount > 0) ...[
                const SizedBox(height: 8),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      AppLocalizations.of(context).pointsDiscount,
                      style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                            color: Colors.green,
                          ),
                    ),
                    Text(
                      '- ${pointsDiscount.toStringAsFixed(0)} EGP',
                      style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                            color: Colors.green,
                            fontWeight: FontWeight.bold,
                          ),
                    ),
                  ],
                ),
              ],
              const SizedBox(height: 8),
              const Divider(),
              const SizedBox(height: 8),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    AppLocalizations.of(context).finalPrice,
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

  /// Build booking detail row
  Widget _buildBookingDetail(
    BuildContext context,
    String label,
    String value,
    Color textColor,
  ) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: Theme.of(context).textTheme.titleMedium?.copyWith(
                  color: Colors.grey,
                ),
          ),
          Text(
            value,
            style: Theme.of(context).textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.bold,
                  color: textColor,
                ),
          ),
        ],
      ),
    );
  }

  /// Build pets detail
  Widget _buildPetsDetail(BuildContext context, Color textColor) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            AppLocalizations.of(context).pets,
            style: Theme.of(context).textTheme.titleMedium?.copyWith(
                  color: Colors.grey,
                ),
          ),
          Expanded(
            child: Text(
              controller.selectedPets.map((p) => p.name).join(', '),
              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                    color: textColor,
                  ),
              textAlign: TextAlign.right,
            ),
          ),
        ],
      ),
    );
  }

  /// Build selected pets section
  Widget _buildSelectedPets(BuildContext context, Color textColor) {
    return Column(
      children: [
        Text(
          AppLocalizations.of(context).petsForThisVisit,
          style: Theme.of(context).textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.bold,
                color: textColor,
              ),
        ),
        const SizedBox(height: 16),
        SizedBox(
          height: 100,
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            itemCount: controller.selectedPets.length,
            itemBuilder: (context, index) {
              final pet = controller.selectedPets[index];
              return Container(
                width: 80,
                margin: const EdgeInsets.only(right: 12),
                child: Column(
                  children: [
                    CircleAvatar(
                      radius: 30,
                      backgroundImage: pet.image.startsWith('assets/')
                          ? AssetImage(pet.image) as ImageProvider
                          : FileImage(File(pet.image)),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      pet.name,
                      style: Theme.of(context).textTheme.bodySmall?.copyWith(
                            fontWeight: FontWeight.bold,
                            color: textColor,
                          ),
                      textAlign: TextAlign.center,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                ),
              );
            },
          ),
        ),
      ],
    );
  }

  /// Build QR code section
  Widget _buildQRCodeSection(
    BuildContext context,
    String formattedDate,
    bool isDark,
    Color textColor,
  ) {
    return Column(
      children: [
        Text(
          AppLocalizations.of(context).showQRCodeAtVet,
          style: Theme.of(context).textTheme.titleMedium?.copyWith(
                color: textColor,
              ),
          textAlign: TextAlign.center,
        ),
        const SizedBox(height: 16),
        Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(16),
            boxShadow: [
              BoxShadow(
                color: Colors.grey.withValues(alpha: 0.3),
                spreadRadius: 2,
                blurRadius: 5,
                offset: const Offset(0, 3),
              ),
            ],
          ),
          child: QrImageView(
            data: 'PETAPP_BOOKING_${controller.bookingReference.value}|$formattedDate|${controller.selectedTimeSlot.value}|${controller.selectedPets.map((p) => p.id).join(',')}',
            version: QrVersions.auto,
            size: 200,
            backgroundColor: Colors.white,
            errorStateBuilder: (context, error) {
              return Center(
                child: Text(
                  AppLocalizations.of(context).qrCodeError,
                  textAlign: TextAlign.center,
                  style: Theme.of(context).textTheme.bodyMedium,
                ),
              );
            },
          ),
        ),
      ],
    );
  }

  /// Build done button
  Widget _buildDoneButton(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      child: ElevatedButton(
        onPressed: () => Navigator.of(context).pop(),
        style: ElevatedButton.styleFrom(
          padding: const EdgeInsets.symmetric(vertical: 16),
          backgroundColor: AppColors.orange,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
        ),
        child: Text(
          AppLocalizations.of(context).done,
          style: Theme.of(context).textTheme.titleMedium?.copyWith(
                color: Colors.white,
                fontWeight: FontWeight.bold,
              ),
        ),
      ),
    );
  }
}