// File: /lib/screens/class_screen.dart

import 'package:flutter/material.dart';
import 'chapter_screen.dart';

class ClassScreen extends StatelessWidget {
  final String className;

  const ClassScreen({super.key, required this.className});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(className),
      ),
      body: ListView.builder(
        itemCount: 5,
        itemBuilder: (context, index) {
          return ListTile(
            title: Text('Chapter ${index + 1}'),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => ChapterScreen(
                    chapterName: 'Chapter ${index + 1}',
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
