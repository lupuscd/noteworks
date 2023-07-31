import 'package:flutter/material.dart';
import 'package:noteworks/services/auth/auth_exceptions.dart';
import 'package:noteworks/services/auth/auth_service.dart';
import 'package:noteworks/utilities/error_dialog.dart';

class PasswordResetDialog {
  final TextEditingController _email;

  PasswordResetDialog(this._email);

  void _forgotPassword(BuildContext context) async {
    final email = _email.text.trim();

    try {
      await AuthService.firebase().sendPasswordResetEmail(email: email);

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Password reset email sent')),
      );
    } on ErrorSendingResetEmail {
      await showErrorDialog(context, 'Error sending password reset mail.');
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
