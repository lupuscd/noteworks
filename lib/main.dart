import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:noteworks/firebase_options.dart';
import 'package:noteworks/pages/loginview.dart';
import 'package:noteworks/pages/registerview.dart';
import 'package:noteworks/pages/mailverificationview.dart';

void main() {
  WidgetsFlutterBinding
      .ensureInitialized(); // Ensure that Firebase is initialized before rendering the app
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
  const HomePage({Key? key}) : super(key: key);

  // Reloads the current user from Firebase to get the latest user data
  Future<User> _reloadUser(User user) async {
    await user.reload();
    return FirebaseAuth.instance.currentUser!;
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      // Initialize Firebase app with default options
      future: Firebase.initializeApp(
        options: DefaultFirebaseOptions.currentPlatform,
      ),
      builder: (context, snapshot) {
        // Once Firebase is initialized
        if (snapshot.connectionState == ConnectionState.done) {
          // Get the current user from FirebaseAuth
          final User? initialUser = FirebaseAuth.instance.currentUser;

          // If the user is logged in
          if (initialUser != null) {
            // Reload the user data
            return FutureBuilder(
              future: _reloadUser(initialUser),
              builder: (context, snapshot) {
                // Once the user data has been reloaded
                if (snapshot.connectionState == ConnectionState.done) {
                  // Get the reloaded user data
                  final User user = snapshot.data as User;
                  // If the user's email is verified
                  if (user.emailVerified) {
                    print('Mail is verified');
                    // Render the "Done" text
                    return const Text('Done');
                  } else {
                    // If the email is not verified, show the VerifyEmailPage
                    return const VerifyEmailPage();
                  }
                }
                // Show a CircularProgressIndicator while waiting for user data to reload
                return const CircularProgressIndicator();
              },
            );
          } else {
            // If the user is not logged in, show the LoginPage
            return const LoginPage();
          }
        }
        // Show a CircularProgressIndicator while waiting for Firebase to initialize
        return const CircularProgressIndicator();
      },
    );
  }
}
