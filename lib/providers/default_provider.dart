import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:seeds_ai_callmate_web_app/models/customers_model.dart';
import 'package:seeds_ai_callmate_web_app/models/employee_details_model.dart';
import 'package:seeds_ai_callmate_web_app/models/followups_model.dart';
// import '../models/employee_call_logs.dart';
import '../services/firestore_service.dart';

class DefaultProvider with ChangeNotifier {
  final FirestoreService _firestoreService = FirestoreService();
  String _phoneNumber = '';
  String _assignedagent = '';
  String _category = '';
  String _notes = '';
  String _name = '';
  String _email = '';
  String _company = '';
  String _address = '';
  String _city = '';
  String _state = '';
  String _pincode = '';
  String _option = '';
  DateTime _date = DateTime.now();
  String _text = '';
  String _source = '';
  String _status = '';
  // Update phone number
  // Update methods

  // Public getters for private fields
  String get phoneNumber => _phoneNumber;
  String get agent => _assignedagent;
  String get category => _category;
  String get notes => _notes;
  String get name => _name;
  String get email => _email;
  String get company => _company;
  String get address => _address;
  String get city => _city;
  String get state => _state;
  String get pincode => _pincode;
  String get option => _option;
  DateTime get date => _date;
  String get text => _text;
  String get source => _source;
  String get status => _status;

  void updatePhoneNumber(String phoneNumber) {
    _phoneNumber = phoneNumber;
    notifyListeners();
  }

  void updateCategory(String assignTo) {
    _category = assignTo;
    notifyListeners();
  }

  void updateNotes(String notes) {
    _notes = notes;
    notifyListeners();
  }

  void updateName(String name) {
    _name = name;
    notifyListeners();
  }

  void updateEmail(String email) {
    _email = email;
    notifyListeners();
  }

  void updateCompany(String company) {
    _company = company;
    notifyListeners();
  }

  void updateAddress(String address) {
    _address = address;
    notifyListeners();
  }

  void updateCity(String city) {
    _city = city;
    notifyListeners();
  }

  void updateState(String state) {
    _state = state;
    notifyListeners();
  }

  void updatePincode(String pincode) {
    _pincode = pincode;
    notifyListeners();
  }

  void updateOption(String option) {
    _option = option;
    notifyListeners();
  }

  void updateDate(DateTime date) {
    _date = date;
    notifyListeners();
  }

  void updateText(String text) {
    _text = text;
    notifyListeners();
  }

  void updateSource(String source) {
    _source = source;
    notifyListeners();
  }

  void updateStatus(String status) {
    _status = status;
    notifyListeners();
  }

  void updatePriority(String assignedto) {
    _assignedagent = assignedto;
    notifyListeners();
  }

  Map<String, dynamic> formData = {};
  void updateFormData(String key, dynamic value) {
    formData[key] = value;
    notifyListeners();
  }

  Map<String, String> extraFields = {};

  void updateFieldValue(String fieldName, String value) {
    extraFields[fieldName] = value;
    notifyListeners();
  }

  // Save data to Firestore

// way to fecth dynamic organizationID
  // Future<void> saveToFirestore() async {
  //   try {
  //     final organizationIds = await _firestoreService.fetchOrganizationIds();

  //     for (String organizationId in organizationIds) {
  //       final customFields =
  //           await _firestoreService.fetchCustomFields(organizationId);

  //       final extraFields = <String, dynamic>{};

  //       for (var field in customFields) {
  //         final name = field['name'] ?? '';
  //         final type = field['type'] ?? '';

  //         if (type == 'textfield') {
  //           extraFields[name] = _text;
  //         } else if (type == 'options') {
  //           extraFields[name] = _option;
  //         } else if (type == 'date') {
  //           extraFields[name] = _date;
  //         }
  //       }

  //       final customer = Customeradd(
  //         phone: _phoneNumber,
  //         agent: _agent,
  //         category: _category,
  //         notes: _notes,
  //         name: _name,
  //         email: _email,
  //         company: _company,
  //         address: _address,
  //         status: {
  //           'type': 'new',
  //           'agentPhone': _phoneNumber,
  //         },
  //         tags: [], // Initialize with an empty list if not used
  //         createdOn: DateTime.now(), // Set to current date and time
  //         extraFields: extraFields,
  //       );

  //       await _firestoreService.addIndividualCustomer(customer);

  //       print(
  //           'Data successfully saved to Firestore for organization: $organizationId.');
  //     }
  //   } catch (e) {
  //     print('Error saving data to Firestore: $e');
  //     throw Exception('Failed to save data: $e');
  //   }
  // }

  Future<void> saveToFirestore() async {
    if (_phoneNumber.isEmpty) {
      throw Exception('Phone number is required');
    }
    if (_name.isEmpty) {
      throw Exception('Name is required');
    }
    // Add any additional validation as needed

    // Fetch dynamic fields from Firestore
    final customFields = await _firestoreService.fetchCustomFields(
        'ABC-1234-999'); // Replace with dynamic organization ID

    final extraInfo = <String, dynamic>{};

    for (var field in customFields) {
      final name = field['name'] ?? '';
      final type = field['type'] ?? '';

      if (type == 'textfield') {
        extraInfo[name] = _text;
      } else if (type == 'options') {
        extraInfo[name] = _option;
      } else if (type == 'date') {
        extraInfo[name] = DateTime.now().toString();
      }
    }

    // Fetch all agents and find the selected agent's phone number
    String agentPhoneNumber = '';
    try {
      final agentDocs = await _firestoreService.fetchAllAgentIds();
      for (var agentId in agentDocs) {
        final agentDoc =
            await _firestoreService.fetchAgentDetails('ABC-1234-999', agentId);
        final agentDetails = EmployeeDetails.fromFirestore(agentDoc.data()!);

        if (agentDetails.name == _assignedagent) {
          agentPhoneNumber = agentDetails.phone;
          break;
        }
      }
    } catch (e) {
      print('Error fetching agent details: $e');
      throw Exception('Failed to fetch agent details');
    }

    if (agentPhoneNumber.isEmpty) {
      throw Exception('Failed to fetch the agent\'s phone number');
    }

    Customeradd customer = Customeradd(
      phone: _phoneNumber,
      // assignedto: _assignedagent,
      category: _category,
      notes: _notes,
      name: _name,
      email: _email,
      company: _company,
      address: _address,
      status: {
        'type': 'new',
        'agent': agentPhoneNumber,
      },
      tags: [], // Initialize with an empty list if not used
      createdOn: DateTime.now(), // Set to current date and time
      extraInfo: extraInfo,
      // extraFields: extraFields,
    );

    try {
      await _firestoreService.addIndividualCustomer(customer);
      print('Data successfully saved to Firestore.');

      // Create a history entry for the new customer
      await _firestoreService.handleCustomerDataChange(
          _phoneNumber, customer.toMap());
      print('History entry created for new customer.');

      // Ensure the listener is active
      _firestoreService.listenToCustomerChanges();
    } catch (e) {
      print('Error saving data to Firestore: $e');
      throw Exception('Failed to save data: $e');
    }
  }

// OPEN FOLLOWUP / OPEN MISSEDCALL Container from DASHBOARD

  int _selectedPageIndex = 0;

  int get selectedPageIndex => _selectedPageIndex;

  final PageController _pageController = PageController();

  PageController get pageController => _pageController;

  void setSelectedPageIndex(int index) {
    if (index >= 0) {
      _selectedPageIndex = index;
      _pageController.jumpToPage(index);
      notifyListeners();
    }
  }

  @override
  void dispose() {
    _pageController.dispose();
    // stopListeningForItems();
    super.dispose();
  }

  void setLoading(bool loading) {
    _isLoading = loading;
    notifyListeners();
  }

//Import csv Data Screen
  Future<bool> checkPhoneNumberExists(String phoneNumber) async {
    return false; // Replace with actual implementation
  }

  Future<void> addCustomer(Map<String, dynamic> customerData) async {
    await _firestoreService.addCustomer(customerData);
    notifyListeners();
  }

  List<String> _headers = [];
  List<List<dynamic>> _rows = [];

  List<String> get headers => _headers;
  List<List<dynamic>> get rows => _rows;

  //Customer Data SCreen
  bool _isLoading = false;
  bool get isLoading => _isLoading;

  String _selectedEmployee = 'All';
  String get selectedEmployee => _selectedEmployee;

  // final FirestoreService _firestoreService = FirestoreService();

  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  List<Customer> _customers = [];
  Customer? selectedCustomer;
  Customer? selectedStatus;

  List<Customer> get customers => _customers;

  List<EmployeeDetails> _employees = [];

  List<EmployeeDetails> get employees => _employees;

// Method to create a new customer in Firestore
  Future<void> createCustomer(Map<String, dynamic> customerData) async {
    try {
      // Implement your Firestore service to save customerData
      await FirestoreService().createCustomer(customerData);

      // Notify listeners if necessary
      notifyListeners();
    } catch (e) {
      // Handle errors as needed
      print('Error creating customer: $e');
      // Optionally, throw the error further if needed
      throw e;
    }
  }

  void deselectCustomer() {
    selectedCustomer = null;
    notifyListeners();
  }

  List<Followup> _followups = [];
  // bool _isLoading = true;
  Followup? _selectedfollowups;

  List<Followup> get followups => _followups;
  // bool get isLoading => _isLoading;
  Followup? get selectedfollowups => _selectedfollowups;

  Future<void> fetchFollowups(String collectionPath) async {
    setLoading(true);

    try {
      QuerySnapshot querySnapshot = await FirebaseFirestore.instance
          .collection(collectionPath)
          .where('status.type', isEqualTo: 'Follow-Up')
          .get();

      _followups = querySnapshot.docs
          .map((doc) =>
              Followup.fromFirestore(doc.data() as Map<String, dynamic>))
          .toList();
    } catch (error) {
      print("Error fetching followups: $error");
    }

    setLoading(false);
  }

  void selectFollowup(Followup followup) {
    _selectedfollowups = followup;
    notifyListeners();
  }

  void clearFollowup() {
    _selectedfollowups = null;
    // _selectedAllocation = null;
    notifyListeners();
  }

  ////////////////////////

  void selectCustomer(Customer customer) {
    selectedCustomer = customer;
    notifyListeners();
  }

  void clearSelectedCustomer() {
    selectedCustomer = null;
    notifyListeners();
  }

  //This Line Used for employees.dart screen to fetch data from the firestore databse
  Future<void> fetchEmployees(String docPath) async {
    _employees = await _firestoreService.getEmployees(docPath);
    notifyListeners();
  }

  Future<List<Map<String, dynamic>>> fetchItems(String collectionPath) async {
    try {
      QuerySnapshot querySnapshot =
          await _firestore.collection(collectionPath).get();
      List<Map<String, dynamic>> items = querySnapshot.docs
          .map((doc) => doc.data() as Map<String, dynamic>)
          .toList();
      return items;
    } catch (e) {
      print('Error fetching items: $e');
      return [];
    }
  }
}
