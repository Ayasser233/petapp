
class ApiConstants {
  // API URLs
  static const String apiBaseUrl = 'https://alefy-backend.vercel.app';
  static const String fallbackApiBaseUrl = 'https://alefy-backup-api.vercel.app';
  
  // Timeouts
  static const Duration connectionTimeout = Duration(seconds: 10);
  static const Duration receiveTimeout = Duration(seconds: 10);
  static const Duration sendTimeout = Duration(seconds: 10);
  
  // API Health Check
  static const String healthEndpoint = '/api/health';
  
  // Auth Endpoints
  static const String authEndpoint = '/api/auth';
  static const String registerEndpoint = '/api/auth/register';
  static const String loginEndpoint = '/api/auth/login';
  static const String logoutEndpoint = '/api/auth/logout';
  static const String profileEndpoint = '/api/auth/profile';
  static const String verifyEmailEndpoint = '/api/auth/verify-email';
  static const String resendVerificationEndpoint = '/api/auth/resend-verification';
  static const String forgotPasswordEndpoint = '/api/auth/forgot-password';
  static const String resetPasswordEndpoint = '/api/auth/reset-password';
  
  // Pet Endpoints
  static const String petsEndpoint = '/api/pets';
  static String petDetailEndpoint(String id) => '/api/pets/$id';
  
  // Symptoms Endpoints
  static const String symptomsEndpoint = '/api/symptoms';
  static String petTypeSymptomEndpoint(String petType) => '/api/symptoms/$petType';
  
  // Clinic/Vet Endpoints
  static const String clinicsEndpoint = '/api/clinics';
  static String clinicDetailEndpoint(String id) => '/api/clinics/$id';
  static const String veterinariansEndpoint = '/api/veterinarians';
  static String veterinarianDetailEndpoint(String id) => '/api/veterinarians/$id';
  
  // Appointment Endpoints
  static const String appointmentsEndpoint = '/api/appointments';
  static String appointmentDetailEndpoint(String id) => '/api/appointments/$id';
  
  // Media Endpoints
  static const String uploadsEndpoint = '/api/uploads';
  static const String petModelsEndpoint = '/api/models';
  
  // User Endpoints
  static const String usersEndpoint = '/api/users';
  static String userDetailEndpoint(String id) => '/api/users/$id';
  
  // Cache durations
  static const Duration shortCacheDuration = Duration(minutes: 5);
  static const Duration mediumCacheDuration = Duration(hours: 1);
  static const Duration longCacheDuration = Duration(days: 1);
}