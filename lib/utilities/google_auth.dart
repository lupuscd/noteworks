import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:noteworks/utilities/errordialog.dart';

class Gauth {
  // Method to sign in with Google
  Future<UserCredential?> signInWithGoogle(BuildContext context) async {
    try {
      // Begin the Google sign in process
      final GoogleSignInAccount? gUser = await GoogleSignIn().signIn();

      if (gUser == null) {
        // User cancelled the Google SignIn process
        return null;
      }

      // Obtain authentication details from the GoogleSignInAccount
      final GoogleSignInAuthentication gAuth = await gUser.authentication;

      // Create a new credential using the authentication details
      final credential = GoogleAuthProvider.credential(
        accessToken: gAuth.accessToken,
        idToken: gAuth.idToken,
      );

      // Sign in to FirebaseAuth using the Google credential
      return await FirebaseAuth.instance.signInWithCredential(credential);
    } on FirebaseAuthException catch (e) {
      await showErrorDialog(context, 'FirebaseAuth error: ${e.code}');
      return null;
    } catch (e) {
      await showErrorDialog(context, 'An unexpected error occurred: $e');
      return null;
    }
  }
}
