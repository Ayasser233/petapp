import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:petapp/core/utils/app_colors.dart';
import 'package:petapp/core/utils/helper_functions.dart';
import 'package:petapp/core/localization/app_localizations.dart';
import 'package:petapp/features/pet/controllers/pet_controller.dart';
import 'package:petapp/features/pet/models/pet_model.dart';
import '../widgets/clinic_booking_screen_widgets/hospital_booking_header.dart';
import '../widgets/clinic_booking_screen_widgets/hospital_booking_calendar.dart';
import '../widgets/clinic_booking_screen_widgets/hospital_booking_time_slots.dart';
import '../widgets/clinic_booking_screen_widgets/hospital_booking_pet_selection.dart';
import '../widgets/clinic_booking_screen_widgets/hospital_booking_confirmation.dart';
import '../widgets/clinic_booking_screen_widgets/hospital_booking_summary.dart';

class HospitalBookingController extends GetxController {
  // Booking state
  final Rx<DateTime> selectedDay = DateTime.now().obs;
  final Rx<DateTime> focusedDay = DateTime.now().obs;
  final RxString selectedTimeSlot = ''.obs;
  final RxList<PetModel> selectedPets = <PetModel>[].obs;
  final RxBool isBookingConfirmed = false.obs;
  final RxString bookingReference = ''.obs;
  final RxBool isLoading = false.obs;

  // Pet controller
  late final PetController petController;

  // Time slots
  final List<String> morningSlots = ['09:00 AM', '10:00 AM', '11:00 AM'];
  final List<String> afternoonSlots = ['01:00 PM', '02:00 PM', '03:00 PM', '04:00 PM'];
  final List<String> eveningSlots = ['05:00 PM', '06:00 PM', '07:00 PM'];

  @override
  void onInit() {
    super.onInit();
    _initializePetController();
  }

  /// Initialize pet controller
  void _initializePetController() {
    if (!Get.isRegistered<PetController>()) {
      petController = Get.put(PetController());
    } else {
      petController = Get.find<PetController>();
    }
  }

  /// Update selected day
  void updateSelectedDay(DateTime day) {
    selectedDay.value = day;
    focusedDay.value = day;
    selectedTimeSlot.value = ''; // Reset time slot when date changes
  }

  /// Update selected time slot
  void updateTimeSlot(String timeSlot) {
    selectedTimeSlot.value = timeSlot;
  }

  /// Add pet to selection
  void addPetToSelection(PetModel pet) {
    if (!selectedPets.any((p) => p.id == pet.id)) {
      selectedPets.add(pet);
    }
  }

  /// Remove pet from selection
  void removePetFromSelection(PetModel pet) {
    selectedPets.removeWhere((p) => p.id == pet.id);
  }

  /// Toggle pet selection
  void togglePetSelection(PetModel pet) {
    if (selectedPets.any((p) => p.id == pet.id)) {
      removePetFromSelection(pet);
    } else {
      addPetToSelection(pet);
    }
  }

  /// Check if pet is selected
  bool isPetSelected(PetModel pet) {
    return selectedPets.any((p) => p.id == pet.id);
  }

  /// Confirm booking
  Future<void> confirmBooking() async {
    if (selectedTimeSlot.value.isEmpty) {
      Get.snackbar(
        AppLocalizations.of(Get.context!).error,
        AppLocalizations.of(Get.context!).pleaseSelectTimeSlot,
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
      return;
    }

    try {
      isLoading.value = true;

      // Generate booking reference
      final now = DateTime.now();
      final bookingRef = 'PET${now.millisecondsSinceEpoch.toString().substring(7)}';

      // Simulate API call
      await Future.delayed(const Duration(seconds: 2));

      bookingReference.value = bookingRef;
      isBookingConfirmed.value = true;

      _showSuccessMessage();
    } catch (e) {
      Get.snackbar(
        AppLocalizations.of(Get.context!).error,
        AppLocalizations.of(Get.context!).bookingFailed,
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
    } finally {
      isLoading.value = false;
    }
  }

  /// Show success message
  void _showSuccessMessage() {
    Get.snackbar(
      AppLocalizations.of(Get.context!).success,
      AppLocalizations.of(Get.context!).bookingConfirmed,
      snackPosition: SnackPosition.TOP,
      backgroundColor: Colors.green,
      colorText: Colors.white,
      icon: const Icon(Icons.check_circle, color: Colors.white),
      duration: const Duration(seconds: 3),
    );
  }

  /// Reset booking
  void resetBooking() {
    selectedDay.value = DateTime.now();
    focusedDay.value = DateTime.now();
    selectedTimeSlot.value = '';
    selectedPets.clear();
    isBookingConfirmed.value = false;
    bookingReference.value = '';
  }

  /// Get available time slots for selected day
  List<String> getAvailableTimeSlots(String period) {
    switch (period.toLowerCase()) {
      case 'morning':
        return morningSlots;
      case 'afternoon':
        return afternoonSlots;
      case 'evening':
        return eveningSlots;
      default:
        return [];
    }
  }
}

class HospitalBookingScreen extends StatelessWidget {
  const HospitalBookingScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(HospitalBookingController());
    final isDark = THelperFunctions.isDarkMode(context);

    return Scaffold(
      backgroundColor: isDark ? Colors.black : Colors.white,
      appBar: HospitalBookingHeader(controller: controller),
      body: Obx(() => controller.isBookingConfirmed.value
          ? HospitalBookingConfirmation(controller: controller)
          : _buildBookingView(context, controller)),
    );
  }

  /// Build booking view
  Widget _buildBookingView(BuildContext context, HospitalBookingController controller) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Booking summary
          HospitalBookingSummary(controller: controller),
          
          const SizedBox(height: 24),
          
          // Calendar
          HospitalBookingCalendar(controller: controller),
          
          const SizedBox(height: 24),
          
          // Time slots
          HospitalBookingTimeSlots(controller: controller),
          
          const SizedBox(height: 24),
          
          // Pet selection
          HospitalBookingPetSelection(controller: controller),
          
          const SizedBox(height: 24),
          
          // Confirm button
          _buildConfirmButton(context, controller),
        ],
      ),
    );
  }

  /// Build confirm button
  Widget _buildConfirmButton(BuildContext context, HospitalBookingController controller) {
    return Obx(() => SizedBox(
          width: double.infinity,
          child: ElevatedButton(
            onPressed: controller.selectedTimeSlot.value.isEmpty || controller.isLoading.value
                ? null
                : controller.confirmBooking,
            style: ElevatedButton.styleFrom(
              padding: const EdgeInsets.symmetric(vertical: 16),
              backgroundColor: AppColors.orange,
              disabledBackgroundColor: Colors.grey,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
            child: controller.isLoading.value
                ? const SizedBox(
                    width: 20,
                    height: 20,
                    child: CircularProgressIndicator(
                      color: Colors.white,
                      strokeWidth: 2,
                    ),
                  )
                : Text(
                    AppLocalizations.of(context).confirmBooking,
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                        ),
                  ),
          ),
        ));
  }
}
