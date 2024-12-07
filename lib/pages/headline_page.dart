// lib/home_page.dart
// ignore_for_file: library_private_types_in_public_api

import 'package:flutter/material.dart';
import 'package:news_app/pages/single_headline_page.dart';
import '../services/api_client.dart';

class HeadlinePage extends StatefulWidget {
  const HeadlinePage({super.key});

  @override
  _HeadlinePageState createState() => _HeadlinePageState();
}

class _HeadlinePageState extends State<HeadlinePage> {
  final ApiClient _apiClient = ApiClient();
  List<dynamic> _articles = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _fetchTopHeadlines();
  }

  void _fetchTopHeadlines() async {
    final response = await _apiClient.getTopHeadlines();
    setState(() {
      _articles = response.data['articles'];
      _isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Top Headlines'),
        backgroundColor: Colors.blue,
        foregroundColor: Colors.white,
      ),
      body: _isLoading
          ? const Center(
              child: CircularProgressIndicator(),
            )
          : ListView.builder(
              itemCount: _articles.length,
              itemBuilder: (context, index) {
                final article = _articles[index];
                return ListTile(
                  title: Text(article['title']),
                  subtitle: Text(article['source']['name']),
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) =>
                            SingleHeadlinePage(article: article),
                      ),
                    );
                  },
                );
              },
            ),
    );
  }
}
