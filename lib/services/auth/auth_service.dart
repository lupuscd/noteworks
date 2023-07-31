import 'package:noteworks/services/auth/auth_provider.dart';
import 'package:noteworks/services/auth/auth_user.dart';
import 'package:noteworks/services/auth/firebase_provider.dart';
import 'package:noteworks/services/auth/google_provider.dart';

class AuthService implements AuthProvider {
  final AuthProvider provider;

  const AuthService(this.provider);

  factory AuthService.firebase() => AuthService(FirebaseAuthProvider());
  factory AuthService.google() => AuthService(GoogleAuthProvider());

  @override
  Future<AuthUser> createUser({
    required String email,
    required String password,
  }) =>
      provider.createUser(
        email: email,
        password: password,
      );

  @override
  AuthUser? get currentUser => provider.currentUser;

  @override
  Future<AuthUser> logIn({
    String? email,
    String? password,
  }) =>
      provider.logIn(
        email: email,
        password: password,
      );

  @override
  Future<void> logOut() => provider.logOut();

  @override
  Future<void> sendEmailVerification() => provider.sendEmailVerification();

  @override
  Future<void> initialize() => provider.initialize();

  @override
  Future<void> sendPasswordResetEmail({required String email}) =>
      provider.sendPasswordResetEmail(email: email);
}
