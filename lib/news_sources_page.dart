// lib/news_sources_page.dart
// ignore_for_file: library_private_types_in_public_api

import 'package:flutter/material.dart';
import 'api_client.dart';

class NewsSourcesPage extends StatefulWidget {
  const NewsSourcesPage({super.key});

  @override
  _NewsSourcesPageState createState() => _NewsSourcesPageState();
}

class _NewsSourcesPageState extends State<NewsSourcesPage> {
  final ApiClient _apiClient = ApiClient();
  List<dynamic> _sources = [];

  @override
  void initState() {
    super.initState();
    _fetchNewsSources();
  }

  void _fetchNewsSources() async {
    final response = await _apiClient.getNewsSources();
    setState(() {
      _sources = response.data['sources'];
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('News Sources'),
        backgroundColor: Colors.blue,
        foregroundColor: Colors.white,
      ),
      body: ListView.builder(
        itemCount: _sources.length,
        itemBuilder: (context, index) {
          final source = _sources[index];
          return ListTile(
            title: Text(source['name']),
            subtitle: Text(source['description'] ?? 'No description available'),
          );
        },
      ),
    );
  }
}
