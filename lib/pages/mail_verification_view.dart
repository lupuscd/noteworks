import 'package:flutter/material.dart';
import 'package:noteworks/constants/routes.dart';
import 'package:noteworks/services/auth/auth_service.dart';

class VerifyEmailPage extends StatefulWidget {
  const VerifyEmailPage({super.key});

  @override
  State<VerifyEmailPage> createState() => _VerifyEmailPageState();
}

class _VerifyEmailPageState extends State<VerifyEmailPage> {
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
            await AuthService.firebase().sendEmailVerification();
          },
          child: const Text('Send mail verification'),
        ),
        TextButton(
          onPressed: () async {
            if (AuthService.google().currentUser != null) {
              await AuthService.google().logOut();
            } else if (AuthService.firebase().currentUser != null) {
              await AuthService.firebase().logOut();
            }
            Navigator.of(context).pushNamedAndRemoveUntil(
              loginRoute,
              (_) => false,
            );
          },
          child: const Icon(Icons.autorenew_rounded),
        )
      ]),
    );
  }
}
