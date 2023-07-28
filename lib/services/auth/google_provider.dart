import 'package:noteworks/services/auth/auth_user.dart';
import 'package:noteworks/services/auth/auth_provider.dart';
import 'package:noteworks/services/auth/auth_exceptions.dart';
import 'package:google_sign_in/google_sign_in.dart';

class GoogleAuthProvider implements AuthProvider {
  final GoogleSignIn _googleSignIn = GoogleSignIn();

  @override
  Future<AuthUser> createUser({
    required String email,
    required String password,
  }) {
    throw GenericAuthExc();
  }

  @override
  AuthUser? get currentUser {
    final user = _googleSignIn.currentUser;
    if (user != null) {
      return AuthUser.fromGoogle(user);
    } else {
      return null;
    }
  }

  @override
  Future<AuthUser> logIn({
    required String email,
    required String password,
  }) async {
    try {
      await _googleSignIn.signIn();
      final user = currentUser;
      if (user != null) {
        return user;
      } else {
        throw UserNotLoggedExc();
      }
    } catch (_) {
      throw GenericAuthExc();
    }
  }

  @override
  Future<void> logOut() async {
    final user = _googleSignIn.currentUser;
    if (user != null) {
      await _googleSignIn.signOut();
    } else {
      throw UserNotLoggedExc();
    }
  }

  @override
  Future<void> sendEmailVerification() async {
    throw GenericAuthExc();
  }
}
