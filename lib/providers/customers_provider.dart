import 'package:flutter/material.dart';
import 'package:seeds_ai_callmate_web_app/models/customers_model.dart';
import 'package:seeds_ai_callmate_web_app/services/firestore_service.dart';

class CustomerProvider with ChangeNotifier {
  final FirestoreService _firestoreService = FirestoreService();
  List<Customer> _customers = [];
  bool _isLoading = false;
  Customer? _selectedCustomer;
  String? _organizationId = '';

  List<Customer> get customers => _customers;
  bool get isLoading => _isLoading;
  Customer? get selectedCustomer => _selectedCustomer;
  String? get organizationId => _organizationId;
  String? get selectedCustomerId => _selectedCustomer?.id;

//////////////////////////////////
//  String _organizationId = '';
  String _selectedAgentID = '';

  // String get organizationId => _organizationId;
  String get selectedAgentID => _selectedAgentID;

  void setSelectedAgentID(String id) {
    _selectedAgentID = id;
    notifyListeners();
    print('Agent ID set to: $_selectedAgentID');
  }

  // Set the organization ID
  void setOrganizationId(String id) {
    print('Setting organization ID: $id');
    _organizationId = id;
    notifyListeners();
    print('Organization ID set to: $_organizationId');
  }

  // Fetch customers from Firestore
  Future<void> loadCustomers() async {
    if (_organizationId == null) {
      print('Error: Organization ID is not set');
      throw Exception('Organization ID is not set');
    }

    print('Loading customers for organization ID: $_organizationId');
    _isLoading = true;
    notifyListeners();

    try {
      _customers = await _firestoreService.fetchCustomers(_organizationId!);
      print('Successfully loaded ${_customers.length} customers');
    } catch (e) {
      print('Error loading customers: $e');
      // You might want to set an error state here
    } finally {
      _isLoading = false;
      notifyListeners();
      print('Finished loading customers');
    }
  }

  // Select a customer
  void selectCustomer(Customer customer) {
    print('Selecting customer: ${customer.name}');
    _selectedCustomer = customer;
    notifyListeners();
  }

  // Deselect the selected customer
  void deselectCustomer() {
    print('Deselecting customer');
    _selectedCustomer = null;
    notifyListeners();
  }
}
