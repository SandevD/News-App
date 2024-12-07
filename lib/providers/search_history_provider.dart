import 'package:flutter/material.dart';

class SearchHistoryProvider extends ChangeNotifier {
  final List<String> _searchHistory = [];

  List<String> get searchHistory => _searchHistory;

  void addSearchQuery(String query) {
    if (!_searchHistory.contains(query)) {
      _searchHistory.insert(0, query); // Add new search at the top
      if (_searchHistory.length > 5) {
        _searchHistory.removeLast(); // Keep history size to 5
      }
      notifyListeners();
    }
  }
}
