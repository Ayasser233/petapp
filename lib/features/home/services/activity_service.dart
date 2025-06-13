import '../models/vet_activity.dart';

class ActivityService {
  static final ActivityService _instance = ActivityService._internal();
  factory ActivityService() => _instance;
  ActivityService._internal();

  // Sample data - in real app this would come from API/database
  List<VetActivity> _activities = [
    VetActivity(
      id: '1',
      vetName: 'Sarah Johnson',
      clinicName: 'PetCare Clinic',
      appointmentDate: 'Dec 15, 2024',
      appointmentTime: '10:00 AM',
      serviceType: 'Regular Checkup',
      petName: 'Max',
      status: 'upcoming',
      type: 'checkup',
      duration: '30 minutes',
      fee: 75.00,
      notes: 'Annual health checkup and vaccination review',
    ),
    VetActivity(
      id: '2',
      vetName: 'Michael Chen',
      clinicName: 'Animal Hospital Plus',
      appointmentDate: 'Dec 10, 2024',
      appointmentTime: '2:30 PM',
      serviceType: 'Vaccination',
      petName: 'Bella',
      status: 'completed',
      type: 'vaccination',
      duration: '20 minutes',
      fee: 120.00,
      notes: 'Rabies and DHPP vaccination completed successfully',
    ),
    VetActivity(
      id: '3',
      vetName: 'Emily Rodriguez',
      clinicName: 'Gentle Paws Clinic',
      appointmentDate: 'Dec 5, 2024',
      appointmentTime: '11:15 AM',
      serviceType: 'Dental Cleaning',
      petName: 'Charlie',
      status: 'cancelled',
      type: 'dental',
      duration: '45 minutes',
      fee: 200.00,
      notes: 'Cancelled due to scheduling conflict',
    ),
    VetActivity(
      id: '4',
      vetName: 'David Wilson',
      clinicName: 'City Veterinary Center',
      appointmentDate: 'Dec 20, 2024',
      appointmentTime: '3:00 PM',
      serviceType: 'Surgery Consultation',
      petName: 'Luna',
      status: 'upcoming',
      type: 'surgery',
      duration: '60 minutes',
      fee: 150.00,
      notes: 'Pre-surgical examination and discussion',
    ),
    VetActivity(
      id: '5',
      vetName: 'Lisa Thompson',
      clinicName: 'Happy Tails Clinic',
      appointmentDate: 'Nov 28, 2024',
      appointmentTime: '9:45 AM',
      serviceType: 'Grooming & Health Check',
      petName: 'Rocky',
      status: 'completed',
      type: 'grooming',
      duration: '90 minutes',
      fee: 85.00,
      notes: 'Full grooming service with basic health assessment',
    ),
  ];

  List<VetActivity> getAllActivities() => _activities;

  List<VetActivity> getFilteredActivities(String filter) {
    if (filter.toLowerCase() == 'all') return _activities;
    return _activities.where((activity) => 
        activity.status.toLowerCase() == filter.toLowerCase()).toList();
  }

  Future<void> cancelActivity(String id) async {
    // Simulate API call
    await Future.delayed(const Duration(milliseconds: 500));
    
    final index = _activities.indexWhere((activity) => activity.id == id);
    if (index != -1) {
      _activities[index] = _activities[index].copyWith(status: 'cancelled');
    }
  }

  Future<void> updateActivity(VetActivity updatedActivity) async {
    // Simulate API call
    await Future.delayed(const Duration(milliseconds: 500));
    
    final index = _activities.indexWhere((activity) => activity.id == updatedActivity.id);
    if (index != -1) {
      _activities[index] = updatedActivity;
    }
  }
}