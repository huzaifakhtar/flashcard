// File: /lib/screens/progress_dashboard.dart

import 'package:flutter/material.dart';

class ProgressDashboard extends StatelessWidget {
  const ProgressDashboard({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Progress Dashboard'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            const Text(
              'Performance Over Time',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(
              height: 200,
              child: Center(child: Text('Line Graph Placeholder')), // Add line graph here
            ),
            const SizedBox(height: 20),
            const Text(
              'Proficiency by Topics',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(
              height: 200,
              child: Center(child: Text('Pie Chart Placeholder')), // Add pie chart here
            ),
            const SizedBox(height: 20),
            const Text(
              'Recent Activity',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            Expanded(
              child: ListView(
                children: const [
                  ListTile(
                    title: Text('Deck 1'),
                    subtitle: Text('Practiced 3 times'),
                  ),
                  ListTile(
                    title: Text('Deck 2'),
                    subtitle: Text('Practiced 5 times'),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
