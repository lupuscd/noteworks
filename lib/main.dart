import 'package:flutter/material.dart';
import 'package:noteworks/constants/routes.dart';
import 'package:noteworks/pages/login_view.dart';
import 'package:noteworks/pages/main_ui.dart';
import 'package:noteworks/pages/register_view.dart';
import 'package:noteworks/pages/mail_verification_view.dart';
import 'package:noteworks/services/auth/auth_service.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(
    MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const HomePage(),
      routes: {
        loginRoute: (context) => const LoginPage(),
        registerRoute: (context) => const RegisterPage(),
        notesRoute: (context) => const NoteWorks(),
        verifyMailRoute: (context) => const VerifyEmailPage(),
      },
    ),
  );
}

class HomePage extends StatelessWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
        future: AuthService.firebase().initialize(),
        builder: (context, snapshot) {
          switch (snapshot.connectionState) {
            case ConnectionState.done:
              final user = AuthService.firebase().currentUser;
              if (user != null) {
                if (user.isEmailVerified) {
                  return const NoteWorks();
                } else {
                  return const VerifyEmailPage();
                }
              } else {
                return const LoginPage();
              }
            default:
              return const CircularProgressIndicator();
          }
        });
  }
}
