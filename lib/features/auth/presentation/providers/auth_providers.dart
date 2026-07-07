import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/di/injection.dart';
import '../../../../core/session/current_user_provider.dart';
import '../../domain/entities/auth_user.dart';
import '../../domain/repositories/auth_repository.dart';

final authRepositoryProvider = Provider<AuthRepository>((ref) => getIt<AuthRepository>());

/// One controller shared by Sign Up, Sign In, and OTP screens -- they
/// all call a method here and watch the same AsyncValue for loading/
/// error state, instead of three screens each re-implementing button-
/// loading and error-mapping logic slightly differently.
class AuthController extends AsyncNotifier<void> {
  @override
  Future<void> build() async {}

  Future<bool> signUp({required String name, required String email, required String password}) async {
    state = const AsyncLoading();
    final result = await AsyncValue.guard(
      () => ref.read(authRepositoryProvider).signUp(name: name, email: email, password: password),
    );
    _applyResult(result);
    return !result.hasError;
  }

  Future<bool> signIn({required String email, required String password}) async {
    state = const AsyncLoading();
    final result = await AsyncValue.guard(
      () => ref.read(authRepositoryProvider).signIn(email: email, password: password),
    );
    _applyResult(result);
    return !result.hasError;
  }

  Future<bool> verifyOtp({required String email, required String code}) async {
    state = const AsyncLoading();
    final result = await AsyncValue.guard(
      () => ref.read(authRepositoryProvider).verifyOtp(email: email, code: code),
    );
    _applyResult(result);
    return !result.hasError;
  }

  Future<bool> sendPasswordResetCode({required String email}) async {
    state = const AsyncLoading();
    final result = await AsyncValue.guard(
      () => ref.read(authRepositoryProvider).sendPasswordResetCode(email: email),
    );
    state = result.hasError ? AsyncError(result.error!, result.stackTrace!) : const AsyncData(null);
    return !result.hasError;
  }

  void _applyResult<T>(AsyncValue<T> result) {
    if (result.hasError) {
      state = AsyncError(result.error!, result.stackTrace!);
    } else {
      state = const AsyncData(null);
      final value = result.value;
      if (value is AuthUser) {
        ref.read(currentUserProvider.notifier).state = value;
      }
    }
  }

  /// Reads a human-readable message off whatever AppException is
  /// currently in state -- every screen calls this instead of doing
  /// its own error-to-string mapping.
  String? get errorMessage {
    final error = state.error;
    if (error == null) return null;
    return error.toString().replaceFirst('Exception: ', '');
  }
}

final authControllerProvider = AsyncNotifierProvider<AuthController, void>(AuthController.new);
