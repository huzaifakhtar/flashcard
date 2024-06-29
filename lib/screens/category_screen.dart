// File: /lib/screens/category_screen.dart

import 'package:flutter/material.dart';
import 'class_screen.dart';

class CategoryScreen extends StatelessWidget {
  final String categoryName;

  const CategoryScreen({super.key, required this.categoryName});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(categoryName),
      ),
      body: ListView.builder(
        itemCount: 2,
        itemBuilder: (context, index) {
          return ListTile(
            title: Text('Class ${index + 11}'),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => ClassScreen(
                    className: 'Class ${index + 11}',
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
