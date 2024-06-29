// File: /lib/screens/chapter_screen.dart

import 'package:flutter/material.dart';
import 'topic_screen.dart';

class ChapterScreen extends StatelessWidget {
  final String chapterName;

  const ChapterScreen({super.key, required this.chapterName});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(chapterName),
      ),
      body: ListView.builder(
        itemCount: 10,
        itemBuilder: (context, index) {
          return ListTile(
            title: Text('Topic ${index + 1}'),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => TopicScreen(
                    topicName: 'Topic ${index + 1}',
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }
}
