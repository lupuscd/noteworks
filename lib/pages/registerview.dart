import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:noteworks/constants/routes.dart';
import 'package:noteworks/google_auth.dart';

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
        title: Text('Register'),
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
                final userCredential =
                    await FirebaseAuth.instance.createUserWithEmailAndPassword(
                  email: email,
                  password: pass,
                );
              } on FirebaseAuthException catch (e) {
                if (e.code == 'weak-password') {
                  print(
                      'The password provided is too weak! Use 6 characters or more.');
                } else if (e.code == 'email-already-in-use') {
                  print('An account already exists for that email!');
                } else if (e.code == 'invalid-email') {
                  print('Use a valid email!');
                }
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
              await Gauth().signInWithGoogle();
            },
            icon: Image.asset('assets/images/google.png'),
          )
        ],
      ),
    );
  }
}
