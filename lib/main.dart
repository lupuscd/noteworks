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
  const HomePage({Key? key}) : super(key: key); // Update this line

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
                  final User user = snapshot.data as User;
                  if (user.emailVerified) {
                    print('Mail is verified');
                    return const Text('Done');
                  } else {
                    return const VerifyEmailPage();
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
