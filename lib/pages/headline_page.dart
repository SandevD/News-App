// ignore_for_file: library_private_types_in_public_api

import 'package:flutter/material.dart';
import 'package:news_app/pages/single_headline_page.dart';
import 'package:news_app/pages/single_news_page.dart';
import '../services/api_client.dart';

extension CapitalizeExtension on String {
  String capitalize() {
    if (isEmpty) return this;
    return this[0].toUpperCase() + substring(1);
  }
}

class HeadlinePage extends StatefulWidget {
  const HeadlinePage({super.key});

  @override
  _HeadlinePageState createState() => _HeadlinePageState();
}

class _HeadlinePageState extends State<HeadlinePage> {
  final ApiClient _apiClient = ApiClient();
  List<dynamic> _articles = [];
  bool _isLoading = true;
  String _selectedCategory = 'business';

  final List<String> _categories = [
    'business',
    'entertainment',
    'general',
    'health',
    'science',
    'sports', 
    'technology',
  ];

  @override
  void initState() {
    super.initState();
    _fetchTopHeadlines();
  }

  void _fetchTopHeadlines() async {
    _isLoading = true;
    final response =
        await _apiClient.getTopHeadlines(category: _selectedCategory);
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
          : Column(
              children: [
                Container(
                  height: 50,
                  padding: const EdgeInsets.symmetric(vertical: 8.0),
                  child: ListView.builder(
                    scrollDirection: Axis.horizontal,
                    itemCount: _categories.length,
                    itemBuilder: (context, index) {
                      final category = _categories[index];
                      final isSelected = _selectedCategory == category;
                      return Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 8.0),
                        child: GestureDetector(
                          onTap: () {
                            setState(() {
                              _selectedCategory = category;
                            });
                            _fetchTopHeadlines();
                          },
                          child: Container(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 16.0, vertical: 4.0),
                            decoration: BoxDecoration(
                              color:
                                  isSelected ? Colors.blue : Colors.grey[300],
                              borderRadius: BorderRadius.circular(5),
                              border: Border.all(
                                color: isSelected
                                    ? Colors.blue
                                    : Colors.transparent,
                                width: 2,
                              ),
                            ),
                            child: Center(
                              child: Text(
                                category.capitalize(),
                                style: TextStyle(
                                  color:
                                      isSelected ? Colors.white : Colors.black,
                                  fontSize: 14,
                                ),
                              ),
                            ),
                          ),
                        ),
                      );
                    },
                  ),
                ),
                Expanded(
                  child: ListView.builder(
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
                ),
              ],
            ),
    );
  }
}
