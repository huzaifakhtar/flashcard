// File: /lib/screens/topic_screen.dart

import 'package:flutter/material.dart';
import 'flashcard_screen.dart';

class TopicScreen extends StatelessWidget {
  final String topicName;

  const TopicScreen({super.key, required this.topicName});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(topicName),
      ),
      body: ListView.builder(
        itemCount: 1,
        itemBuilder: (context, index) {
          return ListTile(
            title: Text('Flashcard Set ${index + 1}'),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const FlashcardScreen(),
                ),
              );
            },
          );
        },
      ),
    );
  }
}
