import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:noteworks/constants/routes.dart';
import 'package:noteworks/google_auth.dart';
import 'package:noteworks/pages/registerview.dart';
import 'package:noteworks/passreset.dart';

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

  // Instantiate a PasswordReset object to reset the user's password
  final PasswordReset _passwordReset = PasswordReset();

  // Initialize the TextEditingController instances
  @override
  void initState() {
    _email = TextEditingController();
    _pass = TextEditingController();
    super.initState();
  }

  // Dispose of the TextEditingController instances to free resources
  @override
  void dispose() {
    _email.dispose();
    _pass.dispose();
    super.dispose();
  }

  // Function to handle the password reset process
  void _forgotPassword() async {
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

  // Function to show a dialog for recovering the password
  Future<void> _showRecoverPasswordDialog() async {
    return showDialog<void>(
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
                _forgotPassword();
                Navigator.of(context).pop();
              },
              child: const Text('Recover'),
            ),
          ],
        );
      },
    );
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
              final email = _email.text;
              final pass = _pass.text;
              try {
                final userCredential =
                    await FirebaseAuth.instance.signInWithEmailAndPassword(
                  email: email,
                  password: pass,
                );
                Navigator.of(context).pushNamedAndRemoveUntil(
                  notesRoute,
                  (route) => false,
                );
              } on FirebaseAuthException catch (e) {
                if (e.code == 'user-not-found') {
                  print('User not found!');
                } else if (e.code == 'wrong-password') {
                  print('Wrong password!');
                }
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
            onPressed: _showRecoverPasswordDialog,
            child: Text('Forgot Password?'),
          ),
          const Text('Or continue with Google:'),
          IconButton(
            onPressed: () async {
              await Gauth().signInWithGoogle();
            },
            icon: Image.asset('assets/images/google.png'),
          )
        ],
      ),
    );
  }
}
