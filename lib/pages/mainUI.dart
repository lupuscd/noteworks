import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:noteworks/constants/routes.dart';

// Define an enumeration for the menu actions
enum MenuAction { logout }

// Define a StatefulWidget for the main user interface
class NoteWorks extends StatefulWidget {
  const NoteWorks({super.key});

  // Create the State object for this StatefulWidget
  @override
  State<NoteWorks> createState() => _NoteWorksState();
}

// Define the State class for the NoteWorks StatefulWidget
class _NoteWorksState extends State<NoteWorks> {
  @override
  Widget build(BuildContext context) {
    // Build and return the widget tree for this screen
    return Scaffold(
      appBar: AppBar(
        // Set the title of the App Bar
        title: const Text('Main UI'),
        // Define the actions for the App Bar
        actions: [
          // Add a PopupMenuButton to the App Bar
          PopupMenuButton<MenuAction>(
            // Handle the selected menu option
            onSelected: (value) async {
              switch (value) {
                case MenuAction.logout:
                  // Show a dialog to confirm logout
                  final shouldLogout = await showLogoutDialog(context);
                  // If the user confirms, then logout
                  if (shouldLogout) {
                    await FirebaseAuth.instance.signOut();
                    // Navigate to the login screen, removing all other screens from the stack
                    Navigator.of(context).pushNamedAndRemoveUntil(
                      loginRoute,
                      (_) => false,
                    );
                  }
              }
            },
            // Build the menu items for the PopupMenuButton
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
      // Set the body of the Scaffold
      body: const Text('Hello!'),
    );
  }
}

// Define a function to show a dialog and return a Future<bool> indicating whether the user
// confirmed the action or not
Future<bool> showLogoutDialog(BuildContext context) {
  return showDialog<bool>(
      context: context,
      barrierDismissible: true,
      builder: (BuildContext context) {
        return AlertDialog(
          // Set the title of the AlertDialog
          title: const Text('Log Out'),
          // Set the content of the AlertDialog
          content: const Text('Are you sure?'),
          // Define the actions of the AlertDialog
          actions: [
            TextButton(
              onPressed: () {
                // Dismiss the dialog and return false
                Navigator.of(context).pop(false);
              },
              child: const Text('Cancel'),
            ),
            TextButton(
              onPressed: () {
                // Dismiss the dialog and return true
                Navigator.of(context).pop(true);
              },
              child: const Text('Log Out'),
            ),
          ],
        );
      }).then((value) => value ?? false);
}
