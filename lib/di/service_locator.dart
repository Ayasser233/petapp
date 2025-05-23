import 'package:get_it/get_it.dart';
import 'package:petapp/core/services/api_client.dart';
import 'package:petapp/core/services/api_error_handler.dart';
import 'package:petapp/core/services/connectivity_service.dart';
import 'package:petapp/core/services/token_service.dart';
import 'package:petapp/features/auth/data/repositories/auth_repository.dart';
import 'package:petapp/features/auth/presentation/cubit/auth_cubit.dart';
import 'package:flutter/material.dart';

final sl = GetIt.instance;

Future<void> setupServiceLocator() async {
  // Core services
  final scaffoldMessengerKey = GlobalKey<ScaffoldMessengerState>();
  sl.registerSingleton(scaffoldMessengerKey);
  
  sl.registerLazySingleton(() => ApiErrorHandler(scaffoldMessengerKey: sl()));
  sl.registerLazySingleton(() => TokenService());
  sl.registerLazySingleton(() => ConnectivityService());
  
  sl.registerLazySingleton(() => ApiClient(
    errorHandler: sl(),
    tokenService: sl(),
    connectivityService: sl(),
  ));
  
  // Repositories
  sl.registerLazySingleton(() => AuthRepository(
    apiClient: sl(),
  ));
  
  // Cubits
  sl.registerFactory(() => AuthCubit(
    authRepository: sl(),
  ));
}