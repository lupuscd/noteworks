import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';

class Gauth {
  // Method to sign in with Google
  signInWithGoogle() async {
    // Begin the Google sign in process
    final GoogleSignInAccount? gUser = await GoogleSignIn().signIn();

    // Obtain authentication details from the GoogleSignInAccount
    final GoogleSignInAuthentication gAuth = await gUser!.authentication;

    // Create a new credential using the authentication details
    final credential = GoogleAuthProvider.credential(
      accessToken: gAuth.accessToken,
      idToken: gAuth.idToken,
    );

    // Sign in to FirebaseAuth using the Google credential
    return await FirebaseAuth.instance.signInWithCredential(credential);
  }
}
