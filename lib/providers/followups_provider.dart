import 'package:flutter/material.dart';

import 'package:seeds_ai_callmate_web_app/models/followups_model.dart';
import 'package:seeds_ai_callmate_web_app/services/firestore_service.dart';

class FollowupsProvider with ChangeNotifier {
  final FirestoreService _firestoreService = FirestoreService();
  List<Followup> _followups = [];
  List<Followup> _filteredFollowups = [];
  bool _isLoading = true;
  Followup? _selectedFollowup;

  List<Followup> get followups => _followups;
  List<Followup> get filteredfollowups => _filteredFollowups;
  Followup? get selectedFollowup => _selectedFollowup;
  bool get isLoading => _isLoading;

  Future<void> fetchFollowups() async {
    _isLoading = true;
    notifyListeners();

    _followups = await _firestoreService.fetchNewFollowups();

    _isLoading = false;
    notifyListeners();
  }

  void selectFollowup(Followup followup) {
    _selectedFollowup = followup;
    notifyListeners();
  }
  // }

  void clearFollowup() {
    _selectedFollowup = null;
    notifyListeners();
  }

  void _setLoading(bool value) {
    _isLoading = value;
    notifyListeners();
  }

  void _handleError(dynamic error) {
    print("Error fetching followups: $error");
    // Optionally, handle the error (e.g., show a snackbar or dialog)
  }

  void sortFollowups(String sortOption) {
    switch (sortOption) {
      case 'Name: A-Z':
        _followups.sort((a, b) => a.name.compareTo(b.name));
        break;
      case 'Date: New to Old':
        _followups.sort((a, b) => b.createdOn.compareTo(a.createdOn));
        break;
      case 'Date: Old to New':
        _followups.sort((a, b) => a.createdOn.compareTo(b.createdOn));
        break;
    }
    notifyListeners();
  }

  void searchFollowups(String query) {
    if (query.isEmpty) {
      _filteredFollowups = List.from(_followups);
    } else {
      _filteredFollowups = _followups.where((followup) {
        return followup.name.toLowerCase().contains(query.toLowerCase()) ||
            followup.phone.contains(query) ||
            followup.company.toLowerCase().contains(query.toLowerCase());
      }).toList();
    }
    notifyListeners();
  }
}
