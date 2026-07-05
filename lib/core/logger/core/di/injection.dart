// import 'package:get_it/get_it.dart';
// import '../transport/transport_repository.dart';
// import '../../features/notes/domain/notes_repository.dart';
// import '../../features/notes/data/notes_repository_impl.dart';
// import '../../features/rooms/domain/rooms_repository.dart';
// import '../../features/rooms/data/rooms_repository_impl.dart';
// import '../../features/dashboard/domain/dashboard_repository.dart';
// import '../../features/dashboard/data/dashboard_repository_impl.dart';

// final getIt = GetIt.instance;

// /// Called once from main() before runApp(). Notice the pattern: register
// /// the INTERFACE as the key, the IMPLEMENTATION as the value. Everywhere
// /// else in the app asks GetIt for `TransportRepository`, never for
// /// `MockTransportRepository` -- that indirection is what lets you swap
// /// the mock for the real Bluetooth-backed version later without
// /// touching a single call site.
// void setupDependencies() {
//   getIt.registerLazySingleton<TransportRepository>(() => MockTransportRepository());
//   getIt.registerLazySingleton<NotesRepository>(() => NotesRepositoryImpl());
//   getIt.registerLazySingleton<RoomsRepository>(() => RoomsRepositoryImpl());

//   getIt.registerLazySingleton<DashboardRepository>(
//     () => DashboardRepositoryImpl(
//       transport: getIt<TransportRepository>(),
//       notes: getIt<NotesRepository>(),
//       rooms: getIt<RoomsRepository>(),
//     ),
//   );
// }
