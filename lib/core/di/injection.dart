import 'package:get_it/get_it.dart';
import 'package:peerly/core/database/onboarding_status_service.dart';
import 'package:peerly/core/database/secure_storage_service.dart';
import 'package:peerly/features/dashboard/data/dashboard_repository_impl.dart';
import 'package:peerly/features/dashboard/domain/dashboard_repository.dart';
import 'package:peerly/features/notes/data/notes_repository_impl.dart';
import 'package:peerly/features/notes/domain/notes_repository.dart';
import 'package:peerly/features/rooms/data/rooms_repository.dart';
import 'package:peerly/features/rooms/domain/rooms_repository_impl.dart';
import '../network/dio_client.dart';
import '../network/connectivity_service.dart';
import '../transport/transport_repository.dart';
import '../../features/auth/domain/repositories/auth_repository.dart';
import '../../features/auth/data/datasources/auth_remote_datasource.dart';
import '../../features/auth/data/repositories/auth_repository_impl.dart';

final getIt = GetIt.instance;

/// Called once from main() before runApp(). Notice the pattern: register
/// the INTERFACE as the key, the IMPLEMENTATION as the value. Everywhere
/// else in the app asks GetIt for `TransportRepository`, never for
/// `MockTransportRepository` -- that indirection is what lets you swap
/// the mock for the real Bluetooth-backed version later without
/// touching a single call site.
void setupDependencies() {
  // Core / cross-cutting
  getIt.registerLazySingleton<OnboardingStatusService>(() => OnboardingStatusService());
  getIt.registerLazySingleton<SecureStorageService>(() => SecureStorageService());
  getIt.registerLazySingleton<ConnectivityService>(() => ConnectivityService());
  getIt.registerLazySingleton<DioClient>(() => DioClient());

  // Transport
  getIt.registerLazySingleton<TransportRepository>(() => MockTransportRepository());

  // Notes / Rooms (stubs, used by DashboardRepositoryImpl's aggregation)
  getIt.registerLazySingleton<NotesRepository>(() => NotesRepositoryImpl());
  getIt.registerLazySingleton<RoomsRepository>(() => RoomsRepositoryImpl());

  // Dashboard
  getIt.registerLazySingleton<DashboardRepository>(
    () => DashboardRepositoryImpl(
      transport: getIt<TransportRepository>(),
      notes: getIt<NotesRepository>(),
      rooms: getIt<RoomsRepository>(),
    ),
  );

  // Auth
  getIt.registerLazySingleton<AuthRemoteDataSource>(
    () => AuthRemoteDataSource(getIt<DioClient>()),
  );
  getIt.registerLazySingleton<AuthRepository>(
    () => AuthRepositoryImpl(
      remote: getIt<AuthRemoteDataSource>(),
      connectivity: getIt<ConnectivityService>(),
      secureStorage: getIt<SecureStorageService>(),
    ),
  );
}
