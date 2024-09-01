import 'package:flutter/material.dart';

class SearchProvider with ChangeNotifier {
  List<String> _data = [];
  List<String> _searchResults = [];
  String _query = '';

  List<String> get searchResults => _searchResults;

  void updateData(List<String> data) {
    _data = data;
    _filterResults();
  }

  void updateQuery(String query) {
    _query = query;
    _filterResults();
  }

  void _filterResults() {
    if (_query.isEmpty) {
      _searchResults = _data;
    } else {
      _searchResults = _data
          .where(
              (element) => element.toLowerCase().contains(_query.toLowerCase()))
          .toList();
    }
    notifyListeners();
  }
}
