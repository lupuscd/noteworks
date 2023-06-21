import 'package:firebase_auth/firebase_auth.dart';

class PasswordReset {
  // Create an instance of FirebaseAuth
  final FirebaseAuth _reset = FirebaseAuth.instance;

  // Function to send a password reset email
  Future<void> sendPasswordResetEmail(String email) async {
    try {
      // Use FirebaseAuth to send a password reset email to the given email address
      await _reset.sendPasswordResetEmail(email: email);
    } catch (e) {
      // If there is an error sending the email, print the error message
      print('Error sending password reset email: $e');
      // Uncomment the following line if you want to rethrow the error
      // throw e;
    }
  }
}
