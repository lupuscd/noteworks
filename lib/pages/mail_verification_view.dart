import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:noteworks/constants/routes.dart';

// VerifyEmailPage is a StatefulWidget to manage email verification functionality
class VerifyEmailPage extends StatefulWidget {
  const VerifyEmailPage({super.key});

  @override
  State<VerifyEmailPage> createState() => _VerifyEmailPageState();
}

// _VerifyEmailPageState manages the state of the VerifyEmailPage widget
class _VerifyEmailPageState extends State<VerifyEmailPage> {
  // Build the VerifyEmailPage widget
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Email Verification'),
      ),
      body: Column(children: [
        const Text('Email verification sent'),
        const Text('Email not received? Press the button below:'),
        TextButton(
          onPressed: () async {
            // Get the current user
            final user = FirebaseAuth.instance.currentUser;

            // Send an email verification
            await user?.sendEmailVerification();
          },
          child: const Text('Send mail verification'),
        ),
        TextButton(
          onPressed: () async {
            await FirebaseAuth.instance.signOut();
            Navigator.of(context).pushNamedAndRemoveUntil(
              registerRoute,
              (route) => false,
            );
          },
          child: const Icon(Icons.autorenew_rounded),
        )
      ]),
    );
  }
}
