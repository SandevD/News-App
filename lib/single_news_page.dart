// lib/single_news_page.dart
import 'package:flutter/material.dart';

class SingleNewsPage extends StatelessWidget {
  final Map<String, dynamic> article;

  const SingleNewsPage({super.key, required this.article});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(article['title'], style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
            const SizedBox(height: 8),
            Text('By ${article['author'] ?? 'Unknown'}', style: const TextStyle(fontSize: 16)),
            const SizedBox(height: 8),
            Text(article['description'] ?? 'No description available'),
          ],
        ),
      ),
    );
  }
}
