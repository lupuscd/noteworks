import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:noteworks/constants/routes.dart';
import 'package:noteworks/utilities/error_dialog.dart';
import 'package:noteworks/services/auth/google_auth.dart';

// RegisterPage is a StatefulWidget to manage user registration functionality
class RegisterPage extends StatefulWidget {
  const RegisterPage({super.key});

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

// _RegisterPageState manages the state of the RegisterPage widget
class _RegisterPageState extends State<RegisterPage> {
  // Declare TextEditingController instances for email and password fields
  late final TextEditingController _email;
  late final TextEditingController _pass;

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

  // Build the RegisterPage widget
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Register'),
      ),
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
                await FirebaseAuth.instance.createUserWithEmailAndPassword(
                  email: email,
                  password: pass,
                );
                final user = FirebaseAuth.instance.currentUser;
                await user?.sendEmailVerification();
                Navigator.of(context).pushNamed(verifyMailRoute);
              } on FirebaseAuthException catch (e) {
                if (e.code == 'weak-password') {
                  await showErrorDialog(context, 'Weak password');
                } else if (e.code == 'email-already-in-use') {
                  await showErrorDialog(
                      context, 'Account with this email already exists');
                } else if (e.code == 'invalid-email') {
                  await showErrorDialog(context, 'Invalid email entered');
                } else {
                  await showErrorDialog(context, 'Error: ${e.code}!');
                }
              } catch (e) {
                await showErrorDialog(
                    context, 'An unexpected error occurred: $e');
              }
            },
            child: const Text('Register'),
          ),
          TextButton(
            onPressed: () {
              Navigator.of(context).pushNamedAndRemoveUntil(
                loginRoute,
                (route) => false,
              );
            },
            child: const Text('Already registered? Log In!'),
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