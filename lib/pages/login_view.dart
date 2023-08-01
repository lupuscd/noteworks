import 'package:flutter/material.dart';
import 'package:noteworks/constants/routes.dart';
import 'package:noteworks/services/auth/auth_exceptions.dart';
import 'package:noteworks/services/auth/auth_service.dart';
import 'package:noteworks/utilities/error_dialog.dart';
import 'package:noteworks/utilities/forgot_pass_button.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  late final TextEditingController _email;
  late final TextEditingController _pass;
  late final PasswordResetDialog _passwordResetDialog;

  @override
  void initState() {
    _email = TextEditingController();
    _pass = TextEditingController();
    _passwordResetDialog = PasswordResetDialog(_email);
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
                await AuthService.firebase().logIn(
                  email: email,
                  password: pass,
                );
                final user = AuthService.firebase().currentUser;
                if (user?.isEmailVerified ?? false) {
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
              } on UserNotFoundAuthExc {
                await showErrorDialog(
                  context,
                  'User not found!',
                );
              } on WrongPassAuthExc {
                await showErrorDialog(
                  context,
                  'Wrong password!',
                );
              } on GenericAuthExc {
                await showErrorDialog(
                  context,
                  'Authentication error!',
                );
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
              await AuthService.google().logIn();
              Navigator.of(context).pushNamedAndRemoveUntil(
                notesRoute,
                (route) => false,
              );
            },
            icon: Image.asset('assets/images/google.png'),
          )
        ],
      ),
    );
  }
}
