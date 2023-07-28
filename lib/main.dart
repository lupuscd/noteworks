import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:noteworks/constants/routes.dart';
import 'package:noteworks/firebase_options.dart';
import 'package:noteworks/pages/login_view.dart';
import 'package:noteworks/pages/main_ui.dart';
import 'package:noteworks/pages/register_view.dart';
import 'package:noteworks/pages/mail_verification_view.dart';

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

  Future<User> _reloadUser(User user) async {
    await user.reload();
    return FirebaseAuth.instance.currentUser!;
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: Firebase.initializeApp(
        options: DefaultFirebaseOptions.currentPlatform,
      ),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.done) {
          final User? initialUser = FirebaseAuth.instance.currentUser;

          if (initialUser != null) {
            return FutureBuilder(
              future: _reloadUser(initialUser),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.done) {
                  if (snapshot.data != null) {
                    final User user = snapshot.data as User;
                    if (user.emailVerified) {
                      return const NoteWorks();
                    } else {
                      return const VerifyEmailPage();
                    }
                  }
                }
                return const CircularProgressIndicator();
              },
            );
          } else {
            return const LoginPage();
          }
        }
        return const CircularProgressIndicator();
      },
    );
  }
}
