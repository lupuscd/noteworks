import 'package:flutter/material.dart';
import 'package:noteworks/constants/routes.dart';
import 'package:noteworks/enums/menu_action.dart';
import 'package:noteworks/services/auth/auth_service.dart';

class NoteWorks extends StatefulWidget {
  const NoteWorks({super.key});

  @override
  State<NoteWorks> createState() => _NoteWorksState();
}

class _NoteWorksState extends State<NoteWorks> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Main UI'),
        actions: [
          PopupMenuButton<MenuAction>(
            onSelected: (value) async {
              switch (value) {
                case MenuAction.logout:
                  final shouldLogout = await showLogoutDialog(context);
                  if (shouldLogout) {
                    if (AuthService.google().currentUser != null) {
                      await AuthService.google().logOut();
                    } else if (AuthService.firebase().currentUser != null) {
                      await AuthService.firebase().logOut();
                    }
                    Navigator.of(context).pushNamedAndRemoveUntil(
                      loginRoute,
                      (_) => false,
                    );
                  }
              }
            },
            itemBuilder: (context) {
              return const [
                PopupMenuItem<MenuAction>(
                  value: MenuAction.logout,
                  child: Text('Log Out'),
                ),
              ]; // return
            },
          )
        ], // actions
      ),
      body: const Text('Hello!'),
    );
  }
}

Future<bool> showLogoutDialog(BuildContext context) {
  return showDialog<bool>(
      context: context,
      barrierDismissible: true,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Log Out'),
          content: const Text('Are you sure?'),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(false);
              },
              child: const Text('Cancel'),
            ),
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(true);
              },
              child: const Text('Log Out'),
            ),
          ],
        );
      }).then((value) => value ?? false);
}
