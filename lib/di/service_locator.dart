import 'package:get_it/get_it.dart';
import 'package:petapp/core/services/api_client.dart';
import 'package:petapp/core/services/error_handler_service.dart';
import 'package:petapp/core/services/auth_service.dart';
import 'package:petapp/core/services/connectivity_service.dart';
import 'package:petapp/core/services/token_service.dart';
import 'package:petapp/features/auth/data/repositories/auth_repository.dart';
import 'package:petapp/features/auth/presentation/cubit/auth_cubit.dart';
import 'package:flutter/material.dart';
import 'package:petapp/features/pet/services/pet_api_service.dart';
import 'package:petapp/features/pet/repositories/pet_repository.dart';
import 'package:petapp/features/pet/controllers/pet_controller.dart';
import 'package:petapp/features/profile/controller/profile_controller.dart';
import 'package:petapp/features/profile/data/repositories/profile_repository.dart';

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
  
  // Repositories
  sl.registerLazySingleton(() => AuthRepository(
    apiClient: sl(),
  ));
  
  // Pet Feature
  sl.registerLazySingleton(() => PetApiService());
  sl.registerLazySingleton(() => PetRepository(
    apiService: sl(),
  ));
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
  
  // Cubits
  sl.registerFactory(() => AuthCubit(
    authRepository: sl(),
  ));
}