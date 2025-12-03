import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:petapp/core/utils/app_colors.dart';
import 'package:petapp/core/utils/helper_functions.dart';
import 'package:petapp/core/localization/app_localizations.dart';
import 'package:petapp/features/pet/controllers/pet_controller.dart';
import 'package:petapp/features/pet/models/pet_model.dart';
import 'package:petapp/features/appointments/domain/usecases/create_appointment_usecase.dart';
import 'package:petapp/di/service_locator.dart';
import '../models/time_slot_model.dart';
import '../services/vet_service.dart';
import '../widgets/vet_booking_screen_widgets/vet_booking_header.dart';
import '../widgets/vet_booking_screen_widgets/vet_booking_calendar.dart';
import '../widgets/vet_booking_screen_widgets/vet_booking_time_slots.dart';
import '../widgets/vet_booking_screen_widgets/vet_booking_pet_selection.dart';
import '../widgets/vet_booking_screen_widgets/vet_booking_confirmation.dart';
import '../widgets/vet_booking_screen_widgets/vet_booking_summary.dart';

class VetBookingController extends GetxController {
  // Services
  final VetService _vetService = VetService();
  final CreateAppointmentUseCase _createAppointmentUseCase =
      sl<CreateAppointmentUseCase>();

  // Booking state
  final Rx<DateTime> selectedDay = DateTime.now().obs;
  final Rx<DateTime> focusedDay = DateTime.now().obs;
  final RxString selectedTimeSlot = ''.obs;
  final RxString selectedTimeSlotId =
      ''.obs; // Store the slot ID for API booking
  final RxList<PetModel> selectedPets = <PetModel>[].obs;
  final RxBool isBookingConfirmed = false.obs;
  final RxString bookingReference = ''.obs;
  final RxBool isLoading = false.obs;
  final RxBool isLoadingTimeSlots = false.obs;

  // Pet controller
  late final PetController petController;

  // Vet ID from route arguments
  String? vetId;

  // Time slots from API
  final RxList<TimeSlotModel> availableTimeSlots = <TimeSlotModel>[].obs;
  final RxList<TimeSlotModel> morningSlots = <TimeSlotModel>[].obs;
  final RxList<TimeSlotModel> afternoonSlots = <TimeSlotModel>[].obs;
  final RxList<TimeSlotModel> eveningSlots = <TimeSlotModel>[].obs;

  @override
  void onInit() {
    super.onInit();
    _initializePetController();
    _getVetIdFromArguments();
    _fetchTimeSlots();
  }

  /// Initialize pet controller
  void _initializePetController() {
    if (!Get.isRegistered<PetController>()) {
      petController = Get.put(PetController());
    } else {
      petController = Get.find<PetController>();
    }
  }

  /// Get vet ID from route arguments
  void _getVetIdFromArguments() {
    final args = Get.arguments as Map<String, dynamic>?;
    vetId = args?['vet']?['id']?.toString();
  }

  /// Fetch available time slots from API
  Future<void> _fetchTimeSlots() async {
    if (vetId == null || vetId!.isEmpty) {
      return;
    }

    try {
      isLoadingTimeSlots.value = true;

      final slots =
          await _vetService.getVetTimeSlots(vetId!, selectedDay.value);

      availableTimeSlots.value = slots;
      _categorizeTimeSlots(slots);

    } catch (e) {
      Get.snackbar(
        'Error',
        'Failed to load available time slots',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red.withValues(alpha: 0.8),
        colorText: Colors.white,
        margin: const EdgeInsets.only(left: 16, right: 16, bottom: 16),
        icon: const Icon(Icons.error_outline, color: Colors.white, size: 24),
        duration: const Duration(seconds: 4),
      );
    } finally {
      isLoadingTimeSlots.value = false;
    }
  }

  /// Categorize time slots by time of day
  void _categorizeTimeSlots(List<TimeSlotModel> slots) {
    morningSlots.clear();
    afternoonSlots.clear();
    eveningSlots.clear();

    for (final slot in slots) {

      // Skip slots that are not bookable or have expired
      if (!slot.isBookableForDate(selectedDay.value)) {
        continue;
      }

      final timeOfDay = TimeSlotModel.getTimeOfDay(slot.startTime);

      switch (timeOfDay) {
        case 'Morning':
          morningSlots.add(slot);
          break;
        case 'Afternoon':
          afternoonSlots.add(slot);
          break;
        case 'Evening':
          eveningSlots.add(slot);
          break;
      }
    }

  }

  /// Update selected day and fetch new time slots
  void updateSelectedDay(DateTime day) {
    selectedDay.value = day;
    focusedDay.value = day;
    selectedTimeSlot.value = ''; // Reset time slot when date changes
    selectedTimeSlotId.value = '';
    _fetchTimeSlots(); // Fetch new time slots for selected date
  }

  /// Update selected time slot
  void updateTimeSlot(TimeSlotModel slot) {
    selectedTimeSlot.value = slot.displayTime;
    selectedTimeSlotId.value = slot.id;
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
    // Validate time slot
    if (selectedTimeSlotId.value.isEmpty) {
      Get.snackbar(
        AppLocalizations.of(Get.context!).error,
        AppLocalizations.of(Get.context!).pleaseSelectTimeSlot,
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
      return;
    }

    // Pet selection is now optional - no validation needed

    try {
      isLoading.value = true;

      // Create appointment using Clean Architecture use case
      final result = await _createAppointmentUseCase(
        CreateAppointmentParams(
          slotId: selectedTimeSlotId.value,
          appointmentDate: selectedDay.value,
          petId: selectedPets.isNotEmpty ? selectedPets.first.id : null,
          reasonForVisit: 'Regular checkup', // You can make this dynamic
          pointsToUse: null, // Don't send if not using points
          couponCode: null, // Don't send if no coupon
        ),
      );

      result.fold(
        // Error case
        (failure) {
          Get.snackbar(
            AppLocalizations.of(Get.context!).error,
            failure.message,
            snackPosition: SnackPosition.BOTTOM,
            backgroundColor: Colors.red.withValues(alpha: 0.8),
            colorText: Colors.white,
            margin: const EdgeInsets.only(left: 16, right: 16, bottom: 16),
            icon:
                const Icon(Icons.error_outline, color: Colors.white, size: 24),
            duration: const Duration(seconds: 4),
          );
        },
        // Success case
        (appointment) {
          // Store the appointment ID as booking reference
          bookingReference.value = appointment.id;

          _showSuccessMessage();

          // Navigate to appointments screen immediately
          Future.delayed(const Duration(milliseconds: 500), () {
            Get.offAllNamed('/appointments');
          });
        },
      );
    } catch (e) {
      Get.snackbar(
        AppLocalizations.of(Get.context!).error,
        AppLocalizations.of(Get.context!).bookingFailed,
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red.withValues(alpha: 0.8),
        colorText: Colors.white,
        margin: const EdgeInsets.only(left: 16, right: 16, bottom: 16),
        icon: const Icon(Icons.error_outline, color: Colors.white, size: 24),
        duration: const Duration(seconds: 4),
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
      snackPosition: SnackPosition.BOTTOM,
      backgroundColor: Colors.green.withValues(alpha: 0.8),
      colorText: Colors.white,
      margin: const EdgeInsets.only(left: 16, right: 16, bottom: 16),
      icon:
          const Icon(Icons.check_circle_outline, color: Colors.white, size: 24),
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
  List<TimeSlotModel> getAvailableTimeSlots(String period) {
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

  /// Check if a time slot is selected
  bool isTimeSlotSelected(TimeSlotModel slot) {
    return selectedTimeSlotId.value == slot.id;
  }
}

class VetBookingScreen extends StatelessWidget {
  const VetBookingScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(VetBookingController());
    final isDark = THelperFunctions.isDarkMode(context);

    return Scaffold(
      backgroundColor: isDark ? Colors.black : Colors.white,
      appBar: VetBookingHeader(controller: controller),
      body: Obx(() => controller.isBookingConfirmed.value
          ? VetBookingConfirmation(controller: controller)
          : _buildBookingView(context, controller)),
    );
  }

  /// Build booking view
  Widget _buildBookingView(
      BuildContext context, VetBookingController controller) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Booking summary
          VetBookingSummary(controller: controller),

          const SizedBox(height: 24),

          // Calendar
          VetBookingCalendar(controller: controller),

          const SizedBox(height: 24),

          // Time slots
          VetBookingTimeSlots(controller: controller),

          const SizedBox(height: 24),

          // Pet selection
          VetBookingPetSelection(controller: controller),

          const SizedBox(height: 24),

          // Confirm button
          _buildConfirmButton(context, controller),
        ],
      ),
    );
  }

  /// Build confirm button
  Widget _buildConfirmButton(
      BuildContext context, VetBookingController controller) {
    return Obx(() => SizedBox(
          width: double.infinity,
          child: ElevatedButton(
            onPressed: controller.selectedTimeSlot.value.isEmpty ||
                    controller.isLoading.value
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
