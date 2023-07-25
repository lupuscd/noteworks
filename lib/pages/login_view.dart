import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:noteworks/constants/routes.dart';
import 'package:noteworks/utilities/error_dialog.dart';
import 'package:noteworks/utilities/forgot_pass_button.dart';
import 'package:noteworks/services/auth/google_auth.dart';

// LoginPage is a StatefulWidget to manage user login functionality
class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

// _LoginPageState manages the state of the LoginPage widget
class _LoginPageState extends State<LoginPage> {
  // Declare TextEditingController instances for email and password fields
  late final TextEditingController _email;
  late final TextEditingController _pass;
  late final PasswordResetDialog _passwordResetDialog;

  //Instantiate a PasswordReset object to reset the user's password
  final PasswordReset _passwordReset = PasswordReset();

  // Initialize the TextEditingController instances
  @override
  void initState() {
    _email = TextEditingController();
    _pass = TextEditingController();
    _passwordResetDialog = PasswordResetDialog(_email, _passwordReset);
    super.initState();
  }

  // Dispose of the TextEditingController instances to free resources
  @override
  void dispose() {
    _email.dispose();
    _pass.dispose();
    super.dispose();
  }

  // Build the LoginPage widget
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Log In')),
      body: Column(
        children: [
          TextField(
            controller: _email,
            enableSuggestions: false,
            autocorrect: false,
            keyboardType: TextInputType.emailAddress,
            decoration: const InputDecoration(
              hintText: 'Enter your email',
            ),
          ),
          TextField(
            controller: _pass,
            obscureText: true,
            enableSuggestions: false,
            autocorrect: false,
            decoration: const InputDecoration(
              hintText: 'Enter your password',
            ),
          ),
          TextButton(
            onPressed: () async {
              final email = _email.text.trim();
              final pass = _pass.text;
              try {
                await FirebaseAuth.instance
                    .signInWithEmailAndPassword(email: email, password: pass);
                final user = FirebaseAuth.instance.currentUser;
                if (user?.emailVerified ?? false) {
                  Navigator.of(context).pushNamedAndRemoveUntil(
                    notesRoute,
                    (route) => false,
                  );
                } else {
                  Navigator.of(context).pushNamedAndRemoveUntil(
                    verifyMailRoute,
                    (route) => false,
                  );
                }
              } on FirebaseAuthException catch (e) {
                if (e.code == 'user-not-found') {
                  await showErrorDialog(context, 'User not found!');
                } else if (e.code == 'wrong-password') {
                  await showErrorDialog(context, 'Wrong password!');
                } else {
                  await showErrorDialog(context, 'Error: ${e.code}!');
                }
              } catch (e) {
                await showErrorDialog(
                    context, 'An unexpected error occurred: $e');
              }
            },
            child: const Text('Log In'),
          ),
          TextButton(
            onPressed: () {
              Navigator.of(context).pushNamedAndRemoveUntil(
                registerRoute,
                (route) => false,
              );
            },
            child: const Text('Register Here!'),
          ),
          TextButton(
            onPressed: () =>
                _passwordResetDialog.showRecoverPasswordDialog(context),
            child: const Text('Forgot Password?'),
          ),
          const Text('Or continue with Google:'),
          IconButton(
            onPressed: () async {
              await Gauth().signInWithGoogle(context);
            },
            icon: Image.asset('assets/images/google.png'),
          )
        ],
      ),
    );
  }
}
