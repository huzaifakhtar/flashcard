// File: /lib/screens/notification_settings_screen.dart

import 'package:flutter/material.dart';

class NotificationSettingsScreen extends StatefulWidget {
  const NotificationSettingsScreen({super.key});

  @override
  _NotificationSettingsScreenState createState() => _NotificationSettingsScreenState();
}

class _NotificationSettingsScreenState extends State<NotificationSettingsScreen> {
  bool _newFlashcards = true;
  bool _reminders = true;
  bool _promotions = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Notification Settings'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            SwitchListTile(
              title: const Text('New Flashcards'),
              value: _newFlashcards,
              onChanged: (bool value) {
                setState(() {
                  _newFlashcards = value;
                });
              },
            ),
            SwitchListTile(
              title: const Text('Reminders'),
              value: _reminders,
              onChanged: (bool value) {
                setState(() {
                  _reminders = value;
                });
              },
            ),
            SwitchListTile(
              title: const Text('Promotions'),
              value: _promotions,
              onChanged: (bool value) {
                setState(() {
                  _promotions = value;
                });
              },
            ),
          ],
        ),
      ),
    );
  }
}
