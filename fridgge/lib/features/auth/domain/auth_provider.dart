// ──────────────────────────────────────────────────────────────────────────────
// Fridgge — auth_provider.dart
// Module 1 stub — returns unauthenticated state.
// Full Firebase implementation in Module 2.
// ──────────────────────────────────────────────────────────────────────────────

import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'auth_provider.g.dart';

/// Watches the Firebase auth state.
/// Returns [true] when a user is signed in, [false] otherwise.
///
/// TODO (Module 2): Replace stub with FirebaseAuth.instance.authStateChanges().
@riverpod
Stream<bool> authState(AuthStateRef ref) async* {
  // Stub: always "not authenticated" until Module 2 wires Firebase Auth
  yield false;
}
