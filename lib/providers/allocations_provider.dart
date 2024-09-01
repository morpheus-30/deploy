import 'package:flutter/material.dart';
import 'package:seeds_ai_callmate_web_app/models/allocation_model.dart';
import 'package:seeds_ai_callmate_web_app/services/firestore_service.dart';

class AllocationProvider with ChangeNotifier {
  final FirestoreService _firestoreService = FirestoreService();
  List<Allocation> _allocations = [];
  bool _isLoading = true;
  Allocation? _selectedAllocation;

  List<Allocation> get allocations => _allocations;
  bool get isLoading => _isLoading;
  Allocation? get selectedAllocation => _selectedAllocation;

  // Fetch allocations from Firestore
  Future<void> fetchAllocations() async {
    _isLoading = true;
    notifyListeners();

    _allocations = await _firestoreService.fetchNewAllocations();

    _isLoading = false;
    notifyListeners();
  }

  // Handle selection of an allocation
  void selectAllocation(Allocation allocation) {
    _selectedAllocation = allocation;
    notifyListeners();
  }

  void deselectAllocation() {
    _selectedAllocation = null;
    notifyListeners();
  }

  Future<void> createOrUpdateCustomer(Map<String, dynamic> customerData) async {
    try {
      print(
          'Starting createOrUpdateCustomer in provider with data: $customerData');
      await _firestoreService.createOrUpdateCustomer(customerData);
      print('Customer data processed successfully');
      notifyListeners();
    } catch (e) {
      print('Error creating/updating customer in provider: $e');
    }
  }
}
