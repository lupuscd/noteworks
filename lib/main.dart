import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:noteworks/firebase_options.dart';
import 'package:noteworks/pages/loginview.dart';
import 'package:noteworks/pages/registerview.dart';
import 'package:noteworks/pages/mailverificationview.dart';

void main() {
  WidgetsFlutterBinding
      .ensureInitialized(); // this helps firebase run before rendering app
  runApp(
    MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const HomePage(),
      routes: {
        '/login/': (context) => const LoginPage(),
        '/register/': (context) => const RegisterPage(),
      },
    ),
  );
}

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: Firebase.initializeApp(
        options: DefaultFirebaseOptions.currentPlatform,
      ),
      builder: (context, snapshot) {
        switch (snapshot.connectionState) {
          case ConnectionState.done:
            final user = FirebaseAuth.instance.currentUser;
            if (user != null) {
              if (user.emailVerified) {
                print('Mail is verified');
              } else {
                return const VerifyEmailPage();
              }
            } else {
              return const LoginPage();
            }
            return const Text('Done');
          default:
            return const CircularProgressIndicator();
        }
      },
    );
  }
}
