import 'package:get_it/get_it.dart';
import 'package:petapp/core/services/api_client.dart';
import 'package:petapp/core/services/error_handler_service.dart';
import 'package:petapp/core/services/auth_service.dart';
import 'package:petapp/core/services/connectivity_service.dart';
import 'package:petapp/core/services/token_service.dart';
import 'package:petapp/core/services/points_service.dart';
import 'package:petapp/core/services/notification_service.dart';
import 'package:petapp/features/auth/data/repositories/auth_repository.dart';
import 'package:petapp/features/auth/presentation/cubit/auth_cubit.dart';
import 'package:flutter/material.dart';
import 'package:petapp/features/pet/services/pet_api_service.dart';
import 'package:petapp/features/pet/data/repositories/pet_repository.dart';
import 'package:petapp/features/pet/controllers/pet_controller.dart';
import 'package:petapp/features/profile/controllers/profile_controller.dart';
import 'package:petapp/features/profile/data/repositories/profile_repository.dart';
import 'package:petapp/features/profile/data/repositories/voucher_repository.dart';

// Appointments - Clean Architecture
import 'package:petapp/features/appointments/data/datasources/appointment_remote_datasource.dart';
import 'package:petapp/features/appointments/data/repositories/appointment_repository_impl.dart';
import 'package:petapp/features/appointments/domain/repositories/appointment_repository.dart';
import 'package:petapp/features/appointments/domain/usecases/get_appointments_usecase.dart';
import 'package:petapp/features/appointments/domain/usecases/get_filtered_appointments_usecase.dart';
import 'package:petapp/features/appointments/domain/usecases/cancel_appointment_usecase.dart';
import 'package:petapp/features/appointments/domain/usecases/create_appointment_usecase.dart';
import 'package:petapp/features/appointments/domain/usecases/submit_review_usecase.dart';
import 'package:petapp/features/appointments/domain/usecases/complete_appointment_by_qr_usecase.dart';
import 'package:petapp/features/appointments/domain/usecases/validate_points_redemption_usecase.dart';
import 'package:petapp/features/appointments/presentation/cubit/appointments_cubit.dart';

// Vaccination - Clean Architecture
import 'package:petapp/features/vaccination/data/services/vaccination_api_service.dart';
import 'package:petapp/features/vaccination/data/repositories/vaccination_repository_impl.dart';
import 'package:petapp/features/vaccination/domain/repositories/vaccination_repository.dart';
import 'package:petapp/features/vaccination/domain/usecases/get_eligible_categories_usecase.dart';
import 'package:petapp/features/vaccination/domain/usecases/create_vaccination_series_usecase.dart';
import 'package:petapp/features/vaccination/domain/usecases/mark_dose_complete_usecase.dart';
import 'package:petapp/features/vaccination/domain/usecases/mark_annual_booster_complete_usecase.dart';
import 'package:petapp/features/vaccination/domain/usecases/delete_vaccination_series_usecase.dart';
import 'package:petapp/features/vaccination/domain/usecases/get_medical_sheet_usecase.dart';
import 'package:petapp/features/vaccination/presentation/cubit/vaccination_cubit.dart';

// Vets
import 'package:petapp/features/vets/services/vet_service.dart';
import 'package:get/get.dart' as getx;

final sl = GetIt.instance;

Future<void> setupServiceLocator() async {
  // Core services
  final scaffoldMessengerKey = GlobalKey<ScaffoldMessengerState>();
  sl.registerSingleton(scaffoldMessengerKey);

  sl.registerLazySingleton(() => ErrorHandlerService());
  sl.registerLazySingleton(() => TokenService());
  sl.registerLazySingleton(() => ConnectivityService());

  // Register AuthService
  sl.registerLazySingleton(() => AuthService(tokenService: sl()));

  sl.registerLazySingleton(() => ApiClient(
        errorHandler: sl(),
        tokenService: sl(),
        connectivityService: sl(),
      ));

  // Points Service
  sl.registerLazySingleton(() => PointsService(
        errorHandler: sl(),
        tokenService: sl(),
        connectivityService: sl(),
      ));

  // Notification Service
  sl.registerLazySingleton(() => NotificationService(
        apiClient: sl(),
        authService: sl(),
      ));

  // Repositories
  sl.registerLazySingleton(() => AuthRepository(
        apiClient: sl(),
      ));

  // Pet Feature
  sl.registerLazySingleton(() => PetApiService(apiClient: sl()));
  sl.registerLazySingleton(() => PetRepository(apiService: sl()));
  sl.registerFactory(() => PetController(
        repository: sl(),
      ));

  // Profile
  sl.registerLazySingleton<ProfileRepository>(
    () => ProfileRepository(apiClient: sl()),
  );

  sl.registerLazySingleton<ProfileController>(
    () => ProfileController(profileRepository: sl()),
  );

  // Voucher (no longer needs ApiClient - uses static data)
  sl.registerLazySingleton<VoucherRepository>(
    () => VoucherRepository(),
  );

  // Vets Feature
  final vetService = VetService();
  sl.registerLazySingleton<VetService>(() => vetService);
  // Also register with GetX for Get.find() support
  getx.Get.put<VetService>(vetService);

  // Appointments Feature - Clean Architecture
  // Data sources
  sl.registerLazySingleton<AppointmentRemoteDataSource>(
    () => AppointmentRemoteDataSource(sl()),
  );

  // Repositories
  sl.registerLazySingleton<AppointmentRepository>(
    () => AppointmentRepositoryImpl(remoteDataSource: sl()),
  );

  // Use cases
  sl.registerLazySingleton(() => GetAppointmentsUseCase(sl()));
  sl.registerLazySingleton(() => GetFilteredAppointmentsUseCase(sl()));
  sl.registerLazySingleton(() => CancelAppointmentUseCase(sl()));
  sl.registerLazySingleton(() => CreateAppointmentUseCase(sl()));
  sl.registerLazySingleton(() => SubmitReviewUseCase(sl()));
  sl.registerLazySingleton(() => CompleteAppointmentByQrUseCase(sl()));
  sl.registerLazySingleton(() => ValidatePointsRedemptionUseCase(sl()));

  // Vaccination Feature - Clean Architecture
  // Services
  sl.registerLazySingleton<VaccinationApiService>(
    () => VaccinationApiService(apiClient: sl()),
  );

  // Repositories
  sl.registerLazySingleton<VaccinationRepository>(
    () => VaccinationRepositoryImpl(apiService: sl()),
  );

  // Use cases
  sl.registerLazySingleton(() => GetEligibleCategoriesUsecase(sl()));
  sl.registerLazySingleton(() => CreateVaccinationSeriesUsecase(sl()));
  sl.registerLazySingleton(() => MarkDoseCompleteUsecase(sl()));
  sl.registerLazySingleton(() => MarkAnnualBoosterCompleteUsecase(sl()));
  sl.registerLazySingleton(() => DeleteVaccinationSeriesUsecase(sl()));
  sl.registerLazySingleton(() => GetMedicalSheetUsecase(sl()));

  // Cubits
  sl.registerFactory(() => AuthCubit(
        authRepository: sl(),
        tokenService: sl(),
      ));

  sl.registerFactory(() => AppointmentsCubit(
        getAppointmentsUseCase: sl(),
        cancelAppointmentUseCase: sl(),
        createAppointmentUseCase: sl(),
        submitReviewUseCase: sl(),
        completeAppointmentByQrUseCase: sl(),
      ));

  sl.registerFactory(() => VaccinationCubit(
        getEligibleCategoriesUsecase: sl(),
        createVaccinationSeriesUsecase: sl(),
        markDoseCompleteUsecase: sl(),
        markAnnualBoosterCompleteUsecase: sl(),
        deleteVaccinationSeriesUsecase: sl(),
        getMedicalSheetUsecase: sl(),
      ));
}
