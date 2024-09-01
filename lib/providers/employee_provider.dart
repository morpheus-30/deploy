import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:seeds_ai_callmate_web_app/models/employee_details_model.dart';
import 'package:seeds_ai_callmate_web_app/services/firestore_service.dart';

class EmployeeDetailsProvider with ChangeNotifier {
  final FirestoreService _firestoreService = FirestoreService();

  List<EmployeeDetails> _employeeDetails = [];
  bool _isLoading = false;

  List<EmployeeDetails> get employeeDetails => _employeeDetails;
  bool get isLoading => _isLoading;

  // EmployeeDetailsProvider() {

  // }

  Future<void> fetchEmployees(String docPath) async {
    _isLoading = true;
    notifyListeners();

    try {
      _employeeDetails = await _firestoreService.getEmployees(docPath);
    } catch (error) {
      print('Error fetching employee details: $error');
    }

    _isLoading = false;
    notifyListeners();
  }

  @override
  void dispose() {
    // No subscription to cancel
    super.dispose();
  }
}
