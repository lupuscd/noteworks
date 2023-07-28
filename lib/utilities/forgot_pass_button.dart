import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class PasswordReset {
  final FirebaseAuth _reset = FirebaseAuth.instance;

  Future<void> sendPasswordResetEmail(String email) async {
    try {
      await _reset.sendPasswordResetEmail(email: email);
    } catch (e) {
      print('Error sending password reset email: $e');
      // Uncomment the following line if you want to rethrow the error
      // throw e;
    }
  }
}

class PasswordResetDialog {
  final TextEditingController _email;
  final PasswordReset _passwordReset;

  PasswordResetDialog(this._email, this._passwordReset);

  void _forgotPassword(BuildContext context) async {
    final email = _email.text.trim();

    try {
      await _passwordReset.sendPasswordResetEmail(email);

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Password reset email sent')),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Error sending password reset email')),
      );
    }
  }

  Future<void> showRecoverPasswordDialog(BuildContext context) async {
    return showDialog(
      context: context,
      barrierDismissible: true,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Recover Password'),
          content: SingleChildScrollView(
            child: ListBody(
              children: <Widget>[
                TextField(
                  controller: _email,
                  decoration:
                      const InputDecoration(labelText: 'Enter your used email'),
                ),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text('Cancel'),
            ),
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
