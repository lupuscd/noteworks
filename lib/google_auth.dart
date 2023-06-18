import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';

class Gauth {
  // Google sign in
  signInWithGoogle() async {
    //Begin signing
    final GoogleSignInAccount? gUser = await GoogleSignIn().signIn();

    //Get details
    final GoogleSignInAuthentication gAuth = await gUser!.authentication;

    //Create new credential
    final credential = GoogleAuthProvider.credential(
      accessToken: gAuth.accessToken,
      idToken: gAuth.idToken,
    );

    //Sign In
    return await FirebaseAuth.instance.signInWithCredential(credential);
  }
}
