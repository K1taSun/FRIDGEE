// Providery Riverpod dla Autoryzacji.

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../data/auth_repository.dart';

part 'auth_provider.g.dart';

@riverpod
AuthRepository authRepository(AuthRepositoryRef ref) {
  return AuthRepository();
}

// Strumień stanu autoryzacji Firebase.
@riverpod
Stream<User?> authState(AuthStateRef ref) {
  try {
    return FirebaseAuth.instance.authStateChanges();
  } catch (_) {
    return Stream.value(null);
  }
}

// Switch dla trybu gościa (pod Moduł 2).
final isGuestProvider = StateProvider<bool>((ref) => false);

// Kontroler logiki auth.
@riverpod
class AuthController extends _$AuthController {
  @override
  FutureOr<void> build() {}

  Future<void> login(String email, String password) async {
    state = const AsyncLoading();
    state = await AsyncValue.guard(() =>
        ref.read(authRepositoryProvider).signInWithEmail(email, password));
  }

  Future<void> register(String email, String password) async {
    state = const AsyncLoading();
    state = await AsyncValue.guard(() =>
        ref.read(authRepositoryProvider).registerWithEmail(email, password));
  }

  Future<void> signInWithGoogle() async {
    state = const AsyncLoading();
    state = await AsyncValue.guard(
        () => ref.read(authRepositoryProvider).signInWithGoogle());
  }

  Future<void> signInWithApple() async {
    state = const AsyncLoading();
    state = await AsyncValue.guard(
        () => ref.read(authRepositoryProvider).signInWithApple());
  }

  Future<void> signOut() async {
    state = const AsyncLoading();
    state = await AsyncValue.guard(
        () => ref.read(authRepositoryProvider).signOut());
  }
}
