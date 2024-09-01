// import 'package:flutter/material.dart';
// import 'package:seeds_ai_callmate_web_app/models/customer_history_model.dart';
// import 'package:seeds_ai_callmate_web_app/services/firestore_service.dart';

// // class HistoryProvider with ChangeNotifier {
// //   final FirestoreService _firestoreService = FirestoreService();
// //   List<CustomerHistory> _timelines = [];

// //   List<CustomerHistory> get timelines => _timelines;

// //   Future<void> fetchCustomerTimelines(String customerId) async {
// //     if (customerId.isNotEmpty) {
// //       try {
// //         _timelines = await _firestoreService.getCustomerHistory(customerId);
// //         notifyListeners();
// //       } catch (e) {
// //         print("Error fetching customer timelines: $e");
// //       }
// //     } else {
// //       print("Error: customerId is null or empty");
// //     }
// //   }
// // }

// class HistoryProvider with ChangeNotifier {
//   final FirestoreService _firestoreService = FirestoreService();
//   List<CustomerHistory> _histories = [];

//   List<CustomerHistory> get histories => _histories;

//   Future<void> fetchCustomerHistories(String organizationId, String customerId) async {
//     if (customerId.isNotEmpty && organizationId.isNotEmpty) {
//       try {
//         _histories = await _firestoreService.getCustomerHistory(organizationId, customerId);
//         notifyListeners();
//       } catch (e) {
//         print("Error fetching customer histories: $e");
//       }
//     } else {
//       print("Error: organizationId or customerId is null or empty");
//     }
//   }
// }

import 'package:flutter/material.dart';
import 'package:seeds_ai_callmate_web_app/models/customer_history_model.dart';
import 'package:seeds_ai_callmate_web_app/services/firestore_service.dart';

class HistoryProvider with ChangeNotifier {
  final FirestoreService _firestoreService = FirestoreService();

  List<CustomerHistories> _histories = [];
  bool _isLoading = false;
  String? _errorMessage;

  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;
  List<CustomerHistories> get histories => _histories;

  Future<void> fetchCustomerHistories(
      String organizationId, String customerId) async {
    // Print starting fetch attempt with provided IDs
    print(
        "Starting fetchCustomerHistories with organizationId: $organizationId, customerId: $customerId");

    if (organizationId.isNotEmpty && customerId.isNotEmpty) {
      _isLoading = true;
      _errorMessage = null;
      notifyListeners();

      print("Loading state set to true. Fetching data...");

      try {
        // Attempt to fetch customer histories
        print("Attempting to get customer histories from Firestore...");
        _histories = await _firestoreService.getCustomerHistories(
            organizationId, customerId);

        print("Successfully fetched ${_histories.length} customer histories.");
      } catch (e) {
        _errorMessage = "Error fetching customer histories: $e";
        print(_errorMessage);
      } finally {
        _isLoading = false;
        notifyListeners();
        print("Loading state set to false.");
      }
    } else {
      _errorMessage = "Error: organizationId or customerId is null or empty";
      print(_errorMessage);
      // Optionally notify listeners even if there's an error
      notifyListeners();
    }
  }
}
