import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class SingleNewsPage extends StatelessWidget {
  final Map<String, dynamic> article;

  const SingleNewsPage({super.key, required this.article});

  Future<void> _launchURL() async {
    final Uri url = Uri.parse(article['url']);
    if (!await launchUrl(url)) {
      throw Exception('Could not launch $url');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              article['title'],
              style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            if (article['urlToImage'] != null)
              Image.network(article['urlToImage']),
            const SizedBox(height: 8),
            Text('By ${article['author'] ?? 'Unknown'}',
                style: const TextStyle(fontSize: 16)),
            const SizedBox(height: 8),
            Text(article['description'] ?? 'No description available'),
            const SizedBox(height: 16),
            TextButton(
              onPressed: _launchURL,
              child: const Text(
                'Read the full article',
                style: TextStyle(
                  color: Colors.blue,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
