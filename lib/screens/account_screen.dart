import 'package:flutter/material.dart';
import 'package:weather_app/services/auth_service.dart';
// import 'package:weather_app/screens/auth_screen.dart';

class AccountScreen extends StatelessWidget {
  final AuthService _authService = AuthService();
  AccountScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final user = _authService.currentUser;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Account'),
        actions: [
          if (user != null)
            IconButton(
              icon: const Icon(Icons.logout),
              onPressed: () async {
                await _authService.signOut();
                Navigator.pushReplacementNamed(context, '/auth');
              },
            ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (user != null) ...[
              ListTile(
                leading: CircleAvatar(
                  backgroundImage: user.photoURL != null
                      ? NetworkImage(user.photoURL!)
                      : null,
                  child: user.photoURL == null
                      ? const Icon(Icons.person)
                      : null,
                ),
                title: Text(user.displayName ?? 'No name'),
                subtitle: Text(user.email ?? 'No email'),
              ),
              const Divider(),
              ListTile(
                leading: const Icon(Icons.settings),
                title: const Text('Settings'),
                onTap: () {
                  // Add settings navigation if needed
                },
              ),
            ] else ...[
              Center(
                child: Column(
                  children: [
                    const Text('You are not signed in'),
                    const SizedBox(height: 20),
                    ElevatedButton(
                      onPressed: () {
                        Navigator.pushReplacementNamed(context, '/auth');
                      },
                      child: const Text('Sign In'),
                    ),
                  ],
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}
