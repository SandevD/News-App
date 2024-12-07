// ignore_for_file: library_private_types_in_public_api

import 'package:flutter/material.dart';
import 'package:news_app/pages/single_news_page.dart';
import 'package:provider/provider.dart';
import '../services/api_client.dart';
import 'package:news_app/providers/search_history_provider.dart';

// Extension to capitalize the first letter of a string
extension CapitalizeExtension on String {
  String capitalize() {
    if (isEmpty) return this;
    return this[0].toUpperCase() + substring(1);
  }
}

class SearchNewsPage extends StatefulWidget {
  const SearchNewsPage({super.key});

  @override
  _SearchNewsPageState createState() => _SearchNewsPageState();
}

class _SearchNewsPageState extends State<SearchNewsPage> {
  final ApiClient _apiClient = ApiClient();
  List<dynamic> _articles = [];
  final String _defaultSelection = 'technology';
  final TextEditingController _searchController = TextEditingController();
  bool _isLoading = false; // Flag for loading state

  @override
  void initState() {
    super.initState();
    _fetchSearchNews();
  }

  void _fetchSearchNews({String? searchQuery}) async {
    setState(() {
      _isLoading = true; // Show loading indicator
    });

    final response = await _apiClient.getSearchNews(
      searchQuery: searchQuery ?? _defaultSelection,
    );

    setState(() {
      _articles = response.data['articles'];
      _isLoading = false; // Hide loading indicator
    });
  }

  @override
  Widget build(BuildContext context) {
    // Get search history from the provider
    final searchHistory =
        Provider.of<SearchHistoryProvider>(context).searchHistory;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Search News'),
        backgroundColor: Colors.blue,
        foregroundColor: Colors.white,
      ),
      body: _isLoading
          ? const Center(
              child: CircularProgressIndicator()) // Centered loading indicator
          : Column(
              children: [
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: TextField(
                    controller: _searchController,
                    decoration: InputDecoration(
                      hintText: 'Search...',
                      suffixIcon: IconButton(
                        icon: const Icon(Icons.search),
                        onPressed: () {
                          final query = _searchController.text.trim();
                          if (query.isNotEmpty) {
                            // Add the search term to history and fetch the news
                            Provider.of<SearchHistoryProvider>(context,
                                    listen: false)
                                .addSearchQuery(query);
                            _fetchSearchNews(searchQuery: query);
                          }
                        },
                      ),
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: searchHistory.isEmpty
                      ? const Text(
                          'No history, get started by searching something.')
                      : SizedBox(
                          height: 40,
                          child: ListView.builder(
                            scrollDirection: Axis.horizontal,
                            itemCount: searchHistory.length,
                            itemBuilder: (context, index) {
                              final query = searchHistory[index];
                              return Padding(
                                padding:
                                    const EdgeInsets.symmetric(horizontal: 4.0, vertical: 1.0),
                                child: ElevatedButton(
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor:
                                        Colors.grey[300],
                                      foregroundColor: Colors.grey[700],
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(5),
                                    ),
                                  ),
                                  onPressed: () {
                                    // Fetch news based on the history item
                                    _fetchSearchNews(searchQuery: query);
                                  },
                                  child: Text(query.capitalize()),
                                ),
                              );
                            },
                          ),
                        ),
                ),
                // Display articles after fetching
                Expanded(
                  child: ListView.builder(
                    itemCount: _articles.length,
                    itemBuilder: (context, index) {
                      final article = _articles[index];
                      return ListTile(
                        title: Text(article['title']),
                        subtitle: Text(article['description'] ?? ''),
                        onTap: () {
                          // Navigate to the article page (if needed)
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) =>
                                  SingleNewsPage(article: article),
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