import 'package:connectivity_plus/connectivity_plus.dart';

/// Wraps connectivity_plus so nothing else in the app imports that
/// package directly. AuthRepositoryImpl uses this to decide online vs.
/// offline signup; VerificationReminderListener uses it to notice when
/// connectivity returns so it can nudge an unverified user.
class ConnectivityService {
  final _connectivity = Connectivity();

  Future<bool> isOnline() async {
    final result = await _connectivity.checkConnectivity();
    return !result.contains(ConnectivityResult.none);
  }

  Stream<bool> get onOnlineStatusChanged {
    return _connectivity.onConnectivityChanged.map(
      (results) => !results.contains(ConnectivityResult.none),
    );
  }
}
