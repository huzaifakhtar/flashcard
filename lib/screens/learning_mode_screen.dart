// File: /lib/screens/learning_mode_screen.dart

import 'package:flutter/material.dart';

class LearningModeScreen extends StatelessWidget {
  const LearningModeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Select Learning Mode'),
      ),
      body: ListView(
        children: [
          ListTile(
            leading: const Icon(Icons.quiz),
            title: const Text('Quiz'),
            onTap: () {
              // Navigate to Quiz Mode
            },
          ),
          ListTile(
            leading: const Icon(Icons.edit),
            title: const Text('Write-in'),
            onTap: () {
              // Navigate to Write-in Mode
            },
          ),
          ListTile(
            leading: const Icon(Icons.link),
            title: const Text('Matching'),
            onTap: () {
              // Navigate to Matching Mode
            },
          ),
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: ElevatedButton(
              onPressed: () {
                // Start selected learning mode
              },
              child: const Text('Start'),
            ),
          ),
        ],
      ),
    );
  }
}
