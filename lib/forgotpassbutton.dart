import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

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

// This class is responsible for showing a recovery password dialog and handling the password reset process.
class PasswordResetDialog {
  // These are references to the controller for the email field and the PasswordReset object.
  final TextEditingController _email;
  final PasswordReset _passwordReset;

  // This constructor initializes the _email and _passwordReset fields with the provided arguments.
  PasswordResetDialog(this._email, this._passwordReset);

  // This method is responsible for sending the password reset email.
  // It gets the email address from the _email controller, trims it, and sends the reset email.
  // If the process is successful, it shows a snack bar with a success message.
  // If there's an error, it shows a snack bar with an error message.
  void _forgotPassword(BuildContext context) async {
    // Get the email address from the controller and trim any whitespace.
    final email = _email.text.trim();

    try {
      // Attempt to send the password reset email.
      await _passwordReset.sendPasswordResetEmail(email);

      // Show a snack bar with a success message.
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Password reset email sent')),
      );
    } catch (e) {
      // If there's an error, show a snack bar with an error message.
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Error sending password reset email')),
      );
    }
  }

  // This method shows a dialog where the user can enter their email to recover their password.
  // It contains a TextField for input and two buttons: one to cancel and close the dialog, and one to submit the form.
  Future<void> showRecoverPasswordDialog(BuildContext context) async {
    // showDialog is a Flutter method that shows a material design modal dialog.
    return showDialog<void>(
      context: context,
      barrierDismissible: true,
      builder: (BuildContext context) {
        // The dialog contains an AlertDialog widget.
        return AlertDialog(
          // The title of the AlertDialog.
          title: const Text('Recover Password'),
          content: SingleChildScrollView(
            child: ListBody(
              children: <Widget>[
                // This TextField is where the user enters their email.
                // It uses _email as its controller.
                TextField(
                  controller: _email,
                  decoration:
                      const InputDecoration(labelText: 'Enter your used email'),
                ),
              ],
            ),
          ),
          actions: [
            // This is the 'Cancel' button. It closes the dialog when pressed.
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text('Cancel'),
            ),
            // This is the 'Recover' button. It calls _forgotPassword and then closes the dialog when pressed.
            TextButton(
              onPressed: () {
                _forgotPassword(context);
                Navigator.of(context).pop();
              },
              child: const Text('Recover'),
            ),
          ],
        );
      },
    );
  }
}
