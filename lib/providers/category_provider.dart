import 'package:flutter/material.dart';
import 'package:seeds_ai_callmate_web_app/models/customers_model.dart';

import 'package:seeds_ai_callmate_web_app/services/firestore_service.dart';

class CategoryProvider with ChangeNotifier {
  FirestoreService firestoreService;
  List<Map<String, dynamic>> _categories = [];
  Map<String, int> _statusData = {};
  bool _isDuplicate = false;
  List<Customer> _customers = [];
  bool _isLoading = false;
  Customer? _selectedCustomer;

  String? _organizationId;
  String? get organizationId => _organizationId;

  List<Map<String, dynamic>> get categories => _categories;
  Map<String, int> get statusData => _statusData;
  bool get isDuplicate => _isDuplicate;
  List<Customer> get customers => _customers;
  bool get isLoading => _isLoading;
  Customer? get selectedCustomer => _selectedCustomer;

  // Store the selected color as a hex string
  String? _selectedColorHex;
  String? get selectedColorHex => _selectedColorHex;

  CategoryProvider(this.firestoreService) {
    _initializeStatusData();
  }

  int getTotalStatusCount() {
    return _statusData.values.fold(0, (sum, count) => sum + count);
  }

  Future<void> _initializeStatusData() async {
    try {
      // Fetch categories
      List<Map<String, dynamic>> categories =
          await firestoreService.fetchCategories();
      print('Fetched categories: $categories');

      _statusData = {for (var category in categories) category['value']: 0};
      print('Initialized status data: $_statusData');

      // Fetch customers and count categories
      String collectionPath = 'customers';
      _customers = await firestoreService.fetchCustomers(_organizationId!);
      print('Fetched customers: $_customers');

      for (var customer in _customers) {
        String category = customer.category;
        if (_statusData.containsKey(category)) {
          _statusData[category] = (_statusData[category] ?? 0) + 1;
          print('Updated status data: $_statusData');
        }
      }

      _categories = categories;
      notifyListeners();
    } catch (e) {
      // Handle error if needed
      print('Error initializing status data: $e');
    }
  }

  Future<void> fetchCategories() async {
    try {
      _categories = await firestoreService.fetchCategories();
      print('Fetched categories: $_categories');
      notifyListeners();
    } catch (e) {
      print('Error fetching categories: $e');
      // Handle or report the error appropriately
    }
  }

  Future<bool> checkCategoryDuplicate(String name) async {
    // Retrieve categories from Firestore and check for duplicates
    try {
      final categories = await firestoreService.fetchCategories();
      print('Fetched categories for duplication check: $categories');
      return categories.any((category) => category['name'] == name);
    } catch (e) {
      print('Error checking category duplicate: $e');
      return false; // Default to false in case of error
    }
  }

  Future<void> addCategory(String name, String type, [String? colorHex]) async {
    try {
      if (_isDuplicate) {
        print('Category with this name already exists.');
        return;
      }

      await firestoreService.addCategory(name, type, colorHex);
      await fetchCategories();
    } catch (e) {
      print('Error adding category: $e');
    }
  }

  Future<void> updateCategory(String oldName, String newName,
      [String? colorHex]) async {
    try {
      await firestoreService.updateCategory(oldName, newName, colorHex);
      await fetchCategories();
    } catch (e) {
      print('Error updating category: $e');
    }
  }

  Future<void> deleteCategory(String name) async {
    try {
      await firestoreService.deleteCategory(name);
      await fetchCategories();
    } catch (e) {
      print('Error deleting category: $e');
    }
  }

  void setSelectedColor(String colorHex) {
    _selectedColorHex = colorHex;
    notifyListeners();
  }
  // Future<void> updateCategory(String oldName, String newName) async {
  //   try {
  //     await firestoreService.updateCategory(oldName, newName);
  //     await fetchCategories();
  //   } catch (e) {
  //     print('Error updating category: $e');
  //     // Handle or report the error appropriately
  //   }
  // }

  // Future<void> deleteCategory(String name) async {
  //   try {
  //     await firestoreService.deleteCategory(name);
  //     await fetchCategories();
  //   } catch (e) {
  //     print('Error deleting category: $e');
  //     // Handle or report the error appropriately
  //   }
  // }
}
