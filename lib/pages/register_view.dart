import 'package:flutter/material.dart';
import 'package:noteworks/constants/routes.dart';
import 'package:noteworks/services/auth/auth_exceptions.dart';
import 'package:noteworks/services/auth/auth_service.dart';
import 'package:noteworks/utilities/error_dialog.dart';

class RegisterPage extends StatefulWidget {
  const RegisterPage({super.key});

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  late final TextEditingController _email;
  late final TextEditingController _pass;

  @override
  void initState() {
    _email = TextEditingController();
    _pass = TextEditingController();
    super.initState();
  }

  @override
  void dispose() {
    _email.dispose();
    _pass.dispose();
    super.dispose();
  }

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
                await AuthService.firebase().createUser(
                  email: email,
                  password: pass,
                );
                AuthService.firebase().sendEmailVerification();
                Navigator.of(context).pushNamed(verifyMailRoute);
              } on WeakPassAuthExc {
                await showErrorDialog(
                  context,
                  'Weak password!',
                );
              } on EmailUsedAuthExc {
                await showErrorDialog(
                  context,
                  'Account with this email already exists!',
                );
              } on InvalidEmailAuthExc {
                await showErrorDialog(
                  context,
                  'Invalid email entered!',
                );
              } on GenericAuthExc {
                await showErrorDialog(
                  context,
                  'Failed to register!',
                );
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
              await AuthService.google().logIn();
            },
            icon: Image.asset('assets/images/google.png'),
          )
        ],
      ),
    );
  }
}
