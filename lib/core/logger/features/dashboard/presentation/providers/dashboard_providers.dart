// import 'package:flutter_riverpod/flutter_riverpod.dart';
// import '../../../../core/di/injection.dart';
// import '../../domain/dashboard_repository.dart';
// import '../state/dashboard_state.dart';

// /// Bridges GetIt (where the repository lives) into Riverpod (where the
// /// UI reads state from). This is the only line in the whole feature
// /// where GetIt appears -- everything downstream uses plain Riverpod.
// final dashboardRepositoryProvider = Provider<DashboardRepository>((ref) {
//   return getIt<DashboardRepository>();
// });

// /// The ViewModel. It depends ONLY on DashboardRepository -- it has never
// /// heard of Isar, Dio, flutter_nearby_connections, or the Notes and
// /// Rooms features directly. That boundary is the entire reason changes
// /// to how activity is fetched never touch this file.
// class DashboardController extends AsyncNotifier<DashboardState> {
//   @override
//   Future<DashboardState> build() async {
//     final repo = ref.watch(dashboardRepositoryProvider);
//     final activity = await repo.getActivityFeed();
//     final peers = await repo.watchNearbyPeers().first;
//     return DashboardState(nearbyPeers: peers, activityFeed: activity);

//     // Note: a production version would also keep listening to the peer
//     // stream via ref.listen() so newly discovered peers appear without
//     // a manual refresh. Left out here to keep the example easy to follow.
//   }

//   /// Called by pull-to-refresh on the screen.
//   Future<void> refresh() async {
//     ref.invalidateSelf();
//     await future;
//   }
// }

// final dashboardControllerProvider =
//     AsyncNotifierProvider<DashboardController, DashboardState>(DashboardController.new);
