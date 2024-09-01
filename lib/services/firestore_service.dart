import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:seeds_ai_callmate_web_app/models/allocation_model.dart';
import 'package:seeds_ai_callmate_web_app/models/call_data.dart';
import 'package:seeds_ai_callmate_web_app/models/custom_field_model.dart';
import 'package:seeds_ai_callmate_web_app/models/customer_history_model.dart';
import 'package:seeds_ai_callmate_web_app/models/customers_model.dart';
import 'package:seeds_ai_callmate_web_app/models/employee_details_model.dart';
import 'package:seeds_ai_callmate_web_app/models/followups_model.dart';
import 'package:seeds_ai_callmate_web_app/models/import_file_model.dart';
import 'package:seeds_ai_callmate_web_app/models/organization_model.dart';
import 'package:seeds_ai_callmate_web_app/providers/customers_provider.dart';
import '../models/employee_calllogs_model.dart';

class FirestoreService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  // final String organizationId = 'ABC-1234-999';
  Map<String, dynamic> _lastKnownData = {};

  FirestoreService() {
    _firestore.settings = const Settings(persistenceEnabled: true);
    print('CustomerHistoryService initialized');
  }

  final CollectionReference _customersCollection = FirebaseFirestore.instance
      .collection('/organizations/ABC-1234-999/customers');

  Future<void> addCustomer(Map<String, dynamic> customerData) async {
    await _customersCollection.add(customerData);
  }

  // Future<Organization?> getOrganization(String organizationID) async {
  //   try {
  //     DocumentSnapshot doc = await _firestore
  //         .collection('organizations')
  //         .doc(organizationID)
  //         .get();
  //     if (doc.exists) {
  //       return Organization.fromFirestore(doc.data() as Map<String, dynamic>);
  //     }
  //     return null;
  //   } catch (e) {
  //     print("Error fetching organization: $e");
  //     return null;
  //   }
  // }

  Future<List<String>> fetchOrganizationIds() async {
    try {
      final firestore = FirebaseFirestore.instance;
      final querySnapshot = await firestore.collection('organizations').get();

      if (querySnapshot.docs.isNotEmpty) {
        return querySnapshot.docs.map((doc) => doc.id).toList();
      } else {
        throw Exception('No organizations found.');
      }
    } catch (e) {
      print('Error fetching organization IDs: $e');
      throw Exception('Failed to fetch organization IDs: $e');
    }
  }

  // Fetch all organization IDs
  Future<List<String>> getAllOrganizationIDs() async {
    try {
      QuerySnapshot querySnapshot =
          await _firestore.collection('organizations').get();
      List<String> organizationIDs =
          querySnapshot.docs.map((doc) => doc.id).toList();
      return organizationIDs;
    } catch (e) {
      print("Error fetching organization IDs: $e");
      return [];
    }
  }

  Future<Organization?> getOrganization(String organizationID) async {
    try {
      DocumentSnapshot doc = await _firestore
          .collection('organizations')
          .doc(organizationID)
          .get();
      if (doc.exists) {
        return Organization.fromFirestore(doc.data() as Map<String, dynamic>);
      }
      return null;
    } catch (e) {
      print("Error fetching organization: $e");
      return null;
    }
  }

//   Future<void> handleCustomerDataChange(
//       String phoneNumber, Map<dynamic, dynamic> newData) async {
//     print('Handling data change for customer: $phoneNumber');

//     // Get the last known data for this customer
//     final lastKnownData = _lastKnownData[phoneNumber] ?? {};

//     // Convert newData to Map<String, dynamic>
//     final convertedNewData = _convertToStringDynamicMap(newData);

//     // Compare new data with last known data
//     final changedFields = _getChangedFields(lastKnownData, convertedNewData);

//     if (changedFields.isEmpty) {
//       print('No changes detected for customer: $phoneNumber');
//       return;
//     }

//     final historyCollectionRef = _firestore
//         .collection('/organizations/$organizationId/customers')
//         .doc(phoneNumber)
//         .collection('history');

//     // Create separate history entries for each changed field
//     for (var entry in changedFields.entries) {
//       if (entry.key == 'createdOn' || entry.value == null) {
//         // Skip the "createdOn" field and any null values
//         continue;
//       }

//       // Combine entry key and value into a single string
//       // final notes = '${entry.key}: ${entry.value}';

//       String notes;

//       if (entry.value is Map<String, dynamic>) {
//         // Handle special cases for status and extraInfo
//         if (entry.key == 'status') {
//           notes = 'Assigned to: ${entry.value['agent']}';
//         } else if (entry.key == 'extraInfo') {
//           notes =
//               entry.value.entries.map((e) => '${e.key}: ${e.value}').join(', ');
//         } else {
//           notes =
//               entry.value.entries.map((e) => '${e.key}: ${e.value}').join(', ');
//         }
//       } else if (entry.value is List) {
//         // Handle special case for tags
//         notes = 'Updated tags: ${entry.value.join(', ')}';
//       } else {
//         // Handle regular fields
//         notes = '${entry.value}';
//       }
// ////////////////////
//       // Format the current date and time
//       final DateTime now = DateTime.now();
//       final String formattedDate =
//           DateFormat('yyyy-MM-dd HH:mm:ss.SSSSSS').format(now);

//       final historyEntry = {
//         'date': formattedDate,
//         'action': 'New',
//         'notes': notes,
//         'extraFields': {},
//       };

//       print('Attempting to create history entry: $historyEntry');

//       try {
//         await historyCollectionRef.add(historyEntry);
//         print(
//             'Successfully added history entry for customer: $phoneNumber, field: ${entry.key}');
//       } catch (e) {
//         print('Error adding history entry: $e');
//       }
//     }

//     // Update the last known data for this customer
//     _lastKnownData[phoneNumber] = convertedNewData;
//   }

  // Future<void> handleCustomerDataChange(
  //     String phoneNumber, Map<dynamic, dynamic> newData) async {
  //   print('Handling data change for customer: $phoneNumber');

  //   // Fetch all organization IDs
  //   List<String> organizationIDs = await getAllOrganizationIDs();

  //   if (organizationIDs.isEmpty) {
  //     print('No organization IDs found');
  //     return;
  //   }

  //   // Loop through each organization ID
  //   for (String orgID in organizationIDs) {
  //     // Get the last known data for this customer
  //     final lastKnownData = _lastKnownData[phoneNumber] ?? {};

  //     // Convert newData to Map<String, dynamic>
  //     final convertedNewData = _convertToStringDynamicMap(newData);

  //     // Compare new data with last known data
  //     final changedFields = _getChangedFields(lastKnownData, convertedNewData);

  //     // Check if customer is new or existing
  //     final isNewCustomer = lastKnownData.isEmpty;

  //     if (isNewCustomer) {
  //       // Handle new customer creation
  //       final historyCollectionRef = _firestore
  //           .collection('/organizations/$orgID/customers')
  //           .doc(phoneNumber)
  //           .collection('history');

  //       String notes =
  //           'New customer created with details: ${convertedNewData.entries.map((e) => '${e.key}: ${e.value}').join(', ')}';

  //       if (convertedNewData['status'] != null) {
  //         final newStatus = convertedNewData['status'] ?? {};
  //         final newAgent = newStatus['agent'];

  //         if (newAgent != null && newAgent.isNotEmpty) {
  //           notes += ', New agent assigned: $newAgent';
  //         }
  //       }

  //       // Format the current date and time
  //       final DateTime now = DateTime.now();
  //       final String formattedDate =
  //           DateFormat('yyyy-MM-dd HH:mm:ss.SSSSSS').format(now);

  //       final historyEntry = {
  //         'date': formattedDate,
  //         'action': 'Create',
  //         'notes': notes,
  //         'extraFields': {},
  //       };

  //       print(
  //           'Attempting to create history entry for new customer: $historyEntry');

  //       try {
  //         await historyCollectionRef.add(historyEntry);
  //         print(
  //             'Successfully added history entry for new customer: $phoneNumber');
  //       } catch (e) {
  //         print('Error adding history entry for new customer: $e');
  //       }

  //       // Update the last known data for this customer
  //       _lastKnownData[phoneNumber] = convertedNewData;
  //       continue; // Skip the rest of the logic for new customers
  //     }

  //     if (changedFields.isEmpty) {
  //       print('No changes detected for customer: $phoneNumber');
  //       continue;
  //     }

  //     final historyCollectionRef = _firestore
  //         .collection('/organizations/$orgID/customers')
  //         .doc(phoneNumber)
  //         .collection('history');

  //     // Create separate history entries for each changed field
  //     for (var entry in changedFields.entries) {
  //       if (entry.key == 'createdOn' || entry.value == null) {
  //         // Skip the "createdOn" field and any null values
  //         continue;
  //       }

  //       // Determine if the change involves a new agent
  //       String notes;
  //       if (entry.key == 'status') {
  //         final oldStatus = lastKnownData['status'] ?? {};
  //         final newStatus = convertedNewData['status'] ?? {};

  //         if (oldStatus['agent'] != newStatus['agent']) {
  //           // Handle new or changed agent
  //           if (oldStatus['agent'] == null && newStatus['agent'] != null) {
  //             // New agent assigned
  //             notes = 'New agent assigned: ${newStatus['agent']}';
  //           } else if (oldStatus['agent'] != null &&
  //               newStatus['agent'] == null) {
  //             // Agent removed
  //             notes = 'Agent removed: ${oldStatus['agent']}';
  //           } else if (oldStatus['agent'] != newStatus['agent']) {
  //             // Agent changed
  //             notes =
  //                 'Agent changed from ${oldStatus['agent']} to ${newStatus['agent']}';
  //           } else {
  //             // No change in agent
  //             notes = 'Agent remains the same: ${newStatus['agent']}';
  //           }
  //         } else {
  //           notes =
  //               'Status updated: ${newStatus.entries.map((e) => '${e.key}: ${e.value}').join(', ')}';
  //         }
  //       } else if (entry.key == 'extraInfo') {
  //         notes =
  //             'Extra info updated: ${entry.value.entries.map((e) => '${e.key}: ${e.value}').join(', ')}';
  //       } else if (entry.value is List) {
  //         // Handle special case for tags
  //         notes = 'Updated tags: ${entry.value.join(', ')}';
  //       } else {
  //         // Handle regular fields
  //         notes = '${entry.key}: ${entry.value}';
  //       }

  //       // Format the current date and time
  //       final DateTime now = DateTime.now();
  //       final String formattedDate =
  //           DateFormat('yyyy-MM-dd HH:mm:ss.SSSSSS').format(now);

  //       final historyEntry = {
  //         'date': formattedDate,
  //         'action': 'Update',
  //         'notes': notes,
  //         'extraFields': {},
  //       };

  //       print('Attempting to create history entry: $historyEntry');

  //       try {
  //         await historyCollectionRef.add(historyEntry);
  //         print(
  //             'Successfully added history entry for customer: $phoneNumber, field: ${entry.key}');
  //       } catch (e) {
  //         print('Error adding history entry: $e');
  //       }
  //     }

  //     // Update the last known data for this customer
  //     _lastKnownData[phoneNumber] = convertedNewData;
  //   }
  // }

  //
  Future<void> handleCustomerDataChange(
      String phoneNumber, Map<dynamic, dynamic> newData) async {
    print('Handling data change for customer: $phoneNumber');

    // Fetch all organization IDs
    List<String> organizationIDs = await getAllOrganizationIDs();

    if (organizationIDs.isEmpty) {
      print('No organization IDs found');
      return;
    }

    // Loop through each organization ID
    for (String orgID in organizationIDs) {
      // Get the last known data for this customer
      final lastKnownData = _lastKnownData[phoneNumber] ?? {};

      // Convert newData to Map<String, dynamic>
      final convertedNewData = _convertToStringDynamicMap(newData);

      // Compare new data with last known data
      final changedFields = _getChangedFields(lastKnownData, convertedNewData);

      if (changedFields.isEmpty) {
        print('No changes detected for customer: $phoneNumber');
        continue;
      }

      final historyCollectionRef = _firestore
          .collection('/organizations/$orgID/customers')
          .doc(phoneNumber)
          .collection('history');

      // Create separate history entries for each changed field
      for (var entry in changedFields.entries) {
        if (entry.key == 'createdOn' || entry.value == null) {
          // Skip the "createdOn" field and any null values
          continue;
        }

        // Determine if the change involves a new agent
        String notes;
        if (entry.key == 'status') {
          final oldStatus = lastKnownData['status'] ?? {};
          final newStatus = convertedNewData['status'] ?? {};

          if (oldStatus['agent'] != newStatus['agent']) {
            // Handle new or changed agent
            if (oldStatus['agent'] == null && newStatus['agent'] != null) {
              // New agent assigned
              notes = 'New agent assigned: ${newStatus['agent']}';
            } else if (oldStatus['agent'] != null &&
                newStatus['agent'] == null) {
              // Agent removed
              notes = 'Agent removed: ${oldStatus['agent']}';
            } else if (oldStatus['agent'] != newStatus['agent']) {
              // Agent changed
              notes = 'Assigned to:${newStatus['agent']}';
            } else {
              // No change in agent
              notes = 'Agent remains the same: ${newStatus['agent']}';
            }
          } else {
            notes =
                'Status updated: ${newStatus.map((e) => '${e.key}: ${e.value}')}';
            // 'Status updated: ${newStatus.entries.map((e) => '${e.key}: ${e.value}').join(', ')}';
          }
        } else if (entry.key == 'extraInfo') {
          notes =
              'Extra info updated: ${entry.value.entries.map((e) => '${e.key}: ${e.value}').join(', ')}';
        } else if (entry.value is List) {
          // Handle special case for tags
          notes = '${entry.value.join(', ')}';
          // notes = 'Updated tags: ${entry.value.join(', ')}';
        } else {
          // Handle regular fields
          notes = '${entry.value}';
          // notes = '${entry.key}: ${entry.value}';
        }

        // Format the current date and time
        final DateTime now = DateTime.now();
        final String formattedDate =
            DateFormat('yyyy-MM-dd HH:mm:ss.SSSSSS').format(now);

        final historyEntry = {
          'date': formattedDate,
          'action': 'New',
          'notes': notes,
          'extraFields': {},
        };

        print('Attempting to create history entry: $historyEntry');

        try {
          await historyCollectionRef.add(historyEntry);
          print(
              'Successfully added history entry for customer: $phoneNumber, field: ${entry.key}');
        } catch (e) {
          print('Error adding history entry: $e');
        }
      }

      // Update the last known data for this customer
      _lastKnownData[phoneNumber] = convertedNewData;
    }
  }

// Helper method to convert Map<dynamic, dynamic> to Map<String, dynamic>
  Map<String, dynamic> _convertToStringDynamicMap(Map<dynamic, dynamic> input) {
    return input.map((key, value) {
      if (value is Map) {
        return MapEntry(key.toString(), _convertToStringDynamicMap(value));
      } else if (value is List) {
        return MapEntry(key.toString(), _convertList(value));
      } else {
        return MapEntry(key.toString(), value);
      }
    });
  }

// Helper method to convert List elements
  List _convertList(List input) {
    return input.map((element) {
      if (element is Map) {
        return _convertToStringDynamicMap(element);
      } else if (element is List) {
        return _convertList(element);
      } else {
        return element;
      }
    }).toList();
  }

  Map<String, dynamic> _getChangedFields(
      Map<String, dynamic> oldData, Map<String, dynamic> newData) {
    final changedFields = <String, dynamic>{};

    // Loop through newData and detect changes at different levels
    newData.forEach((key, value) {
      if (key == 'createdOn') {
        // Skip the "createdOn" field
        return;
      }

      if (value is Map<String, dynamic>) {
        // Recursively detect changes in nested maps
        final subChangedFields = _getChangedFields(
            oldData[key] as Map<String, dynamic>? ?? {}, value);
        if (subChangedFields.isNotEmpty) {
          changedFields[key] = subChangedFields;
        }
      } else if (value is List) {
        final oldList = oldData[key] as List? ?? [];
        final newList = value;

        // Detect changes in lists
        if (oldList.length != newList.length) {
          changedFields[key] = newList;
        } else {
          final changedListElements = <dynamic>[];
          for (int i = 0; i < newList.length; i++) {
            if (oldList[i] != newList[i]) {
              changedListElements.add(newList[i]);
            }
          }
          if (changedListElements.isNotEmpty) {
            changedFields[key] = changedListElements;
          }
        }
      } else if (oldData[key] != value) {
        // Detect changes in primitive data types
        changedFields[key] = value;
      }
    });

    return changedFields;
  }

  void listenToCustomerChanges() {
    print('Starting to listen for customer changes...');

    _firestore
        .collection('/organizations/ABC-1234-999/customers')
        .snapshots()
        .listen((snapshot) {
      print('Received snapshot. Document count: ${snapshot.docs.length}');
      print('Change count: ${snapshot.docChanges.length}');

      for (var change in snapshot.docChanges) {
        print('Change type: ${change.type}');
        final phoneNumber = change.doc.id;
        final newData = change.doc.data() as Map<dynamic, dynamic>;

        if (change.type == DocumentChangeType.added) {
          print('New customer added: $phoneNumber');
          _lastKnownData[phoneNumber] = _convertToStringDynamicMap(newData);
        } else if (change.type == DocumentChangeType.modified) {
          print('Detected change for customer: $phoneNumber');
          handleCustomerDataChange(
            phoneNumber,
            newData,
          );
        }
      }
    }, onError: (error) {
      print('Error listening to customer changes: $error');
    });
  }

  // void listenToCustomerChanges() async {
  //   print('Starting to listen for customer changes...');

  //   // Fetch all organization IDs
  //   List<String> organizationIDs = await getAllOrganizationIDs();

  //   if (organizationIDs.isEmpty) {
  //     print('No organization IDs found');
  //     return;
  //   }

  //   // Loop through each organization ID
  //   for (String orgID in organizationIDs) {
  //     _firestore
  //         .collection('/organizations/$orgID/customers')
  //         .snapshots()
  //         .listen((snapshot) {
  //       print(
  //           'Received snapshot for organization $orgID. Document count: ${snapshot.docs.length}');
  //       print('Change count: ${snapshot.docChanges.length}');

  //       for (var change in snapshot.docChanges) {
  //         print('Change type: ${change.type}');
  //         final phoneNumber = change.doc.id;
  //         final newData = change.doc.data() as Map<dynamic, dynamic>;

  //         if (change.type == DocumentChangeType.added) {
  //           print('New customer added: $phoneNumber in organization $orgID');
  //           _lastKnownData[phoneNumber] = _convertToStringDynamicMap(newData);
  //         } else if (change.type == DocumentChangeType.modified) {
  //           print(
  //               'Detected change for customer: $phoneNumber in organization $orgID');
  //           handleCustomerDataChange(phoneNumber, newData);
  //         }
  //       }
  //     }, onError: (error) {
  //       print(
  //           'Error listening to customer changes for organization $orgID: $error');
  //     });
  //   }
  // }

//////////////////////////////
  Future<void> updateCustomerData({
    required String organizationId,
    required String customerId,
    required Map<String, dynamic> newData,
  }) async {
    // Reference to the customer document
    DocumentReference customerRef = FirebaseFirestore.instance
        .collection('organizations')
        .doc(organizationId)
        .collection('customers')
        .doc(customerId);

    // Get the current data
    DocumentSnapshot customerSnapshot = await customerRef.get();
    Map<String, dynamic>? currentData =
        customerSnapshot.data() as Map<String, dynamic>?;

    if (currentData == null) return;

    // Iterate over the fields in newData
    for (String key in newData.keys) {
      if (newData[key] != currentData[key]) {
        // Create a note for the updated field
        String notes = "$key: ${newData[key]}";

        // Reference to the history collection
        CollectionReference historyRef = customerRef.collection('history');

        // Add a new document to the history collection
        await historyRef.add({
          'date': DateTime.now(),
          'action': 'new',
          'extraFields': {
            'notes': notes,
          },
        });
      }
    }

    // Update the customer document with new data
    await customerRef.update(newData);
  }

  Future<void> fetchAndUpdateData() async {
    // Fetch organization IDs
    QuerySnapshot organizationsSnapshot =
        await FirebaseFirestore.instance.collection('organizations').get();

    if (organizationsSnapshot.docs.isEmpty) {
      print('No organizations found.');
      return;
    }

    // Assuming you want to work with the first organization
    DocumentSnapshot organizationDoc = organizationsSnapshot.docs.first;
    String organizationId = organizationDoc.id;

    // Fetch customer IDs for the selected organization
    QuerySnapshot customersSnapshot = await FirebaseFirestore.instance
        .collection('organizations')
        .doc(organizationId)
        .collection('customers')
        .get();

    if (customersSnapshot.docs.isEmpty) {
      print('No customers found.');
      return;
    }

    // Assuming you want to work with the first customer
    DocumentSnapshot customerDoc = customersSnapshot.docs.first;
    String customerId = customerDoc.id;

    // Define new data to update
    Map<String, dynamic> newData = {
      'notes': 'Updated note',
      'category': 'New Category',
    };

    // Update the customer data and create history entries
    await updateCustomerData(
      organizationId: organizationId,
      customerId: customerId,
      newData: newData,
    );
  }
//use to create CRMFields

  Future<List<Map<String, dynamic>>> fetchCustomFields(
      String organizationId) async {
    final firestore = FirebaseFirestore.instance;
    final docSnapshot =
        await firestore.collection('organizations').doc(organizationId).get();

    if (docSnapshot.exists) {
      final data = docSnapshot.data();
      final customFields = data?['Custom Fields'] as List<dynamic>?;

      return customFields?.map((field) {
            return {
              'name': field['name'] ?? '',
              'type': field['type'] ?? '',
              'field': field['field'] ?? '',
            };
          }).toList() ??
          [];
    } else {
      throw Exception('No data found for the given organization ID.');
    }
  }

  Future<List<Map<String, dynamic>>> fetchCRMFields(
      String organizationId) async {
    try {
      DocumentSnapshot doc = await _firestore
          .collection('organizations')
          .doc(organizationId)
          .get();

      if (doc.exists) {
        List<dynamic> fields = doc['Custom Fields'] ?? [];
        return fields.map((field) {
          Map<String, dynamic> normalizedField =
              Map<String, dynamic>.from(field);

          // Handle 'options' field
          if (normalizedField['options'] != null) {
            if (normalizedField['options'] is List) {
              normalizedField['options'] =
                  (normalizedField['options'] as List<dynamic>)
                      .map((option) => option.toString())
                      .toList();
            } else if (normalizedField['options'] is String) {
              // If it's a String, we'll keep it as is
            } else {
              // If it's neither List nor String, we'll set it to an empty list
              normalizedField['options'] = [];
            }
          } else {
            normalizedField['options'] = [];
          }

          return normalizedField;
        }).toList();
      } else {
        return [];
      }
    } catch (e) {
      print('Error fetching CRM fields: $e');
      return [];
    }
  }

///////////////

  Future<void> addCustomField(String orgId, CRMField field) async {
    DocumentReference docRef =
        _firestore.collection('organizations').doc(orgId);
    await docRef.update({
      'Custom Fields': FieldValue.arrayUnion([field.toMap()]),
    });
  }

  Future<List<CRMField>> getCustomFields(String orgId) async {
    DocumentSnapshot docSnapshot =
        await _firestore.collection('organizations').doc(orgId).get();
    List<dynamic> fields = docSnapshot['Custom Fields'];
    return fields.map((field) => CRMField.fromMap(field)).toList();
  }

  Future<bool> _isFieldNameUniqueInDB(String orgId, String fieldName) async {
    DocumentSnapshot docSnapshot =
        await _firestore.collection('organizations').doc(orgId).get();
    List<dynamic> fields = docSnapshot['Custom Fields'];
    return !fields.any((field) => CRMField.fromMap(field).name == fieldName);
  }

  Future<bool> _isOptionUniqueInDB(
      String orgId, String fieldName, String optionName) async {
    DocumentSnapshot docSnapshot =
        await _firestore.collection('organizations').doc(orgId).get();
    List<dynamic> fields = docSnapshot['Custom Fields'];

    // Find the field with the specified name
    CRMField? field = fields
        .map((f) => CRMField.fromMap(f))
        .firstWhere((field) => field.name == fieldName);

    // Check if the field exists and the option is unique
    return !(field.options ?? []).contains(optionName);
  }

  Future<void> addOptionToField(
      String orgId, String fieldName, Map<String, dynamic> newOption) async {
    try {
      DocumentReference docRef =
          _firestore.collection('organizations').doc(orgId);
      DocumentSnapshot docSnapshot = await docRef.get();
      List<dynamic> fields = docSnapshot['Custom Fields'] ?? [];

      // Update the field with new option
      List<Map<String, dynamic>> updatedFields = fields.map((field) {
        Map<String, dynamic> fieldData = field as Map<String, dynamic>;
        if (fieldData['name'] == fieldName && fieldData['type'] == 'options') {
          List<dynamic> options = fieldData['options'] ?? [];
          options.add(newOption);
          fieldData['options'] = options;
        }
        return fieldData;
      }).toList();

      // Update the Firestore document with the new options
      await docRef.update({
        'Custom Fields': updatedFields,
      });

      print('Option added and Firestore updated successfully.');
    } catch (e) {
      print('Error adding option to field: $e');
    }
  }

  // bool _isOptionUniqueInField(
  //     String optionName, List<Map<String, String>> options) {
  //   return !options.any((option) => option['name'] == optionName);
  // }

  Future<void> updateCRMFields(
      String organizationId, List<Map<String, dynamic>> fields) {
    return _firestore.collection('organizations').doc(organizationId).update({
      'Custom Fields': fields, // Directly use the fields list
    });
  }

// use to store bulk import file data
  Future<void> addCustomerData(
      Map<String, dynamic> data, String organizationId) async {
    await _firestore
        .collection("organizations")
        // .collection('/organizations/ABC-1234-999/customers')
        .doc(organizationId)
        .collection("customers")
        .add(data);
  }

  // Future<void> createOrUpdateCustomer(
  //   Map<String, dynamic> customerData,
  // ) async {
  //   try {
  //     String name = customerData['name'];
  //     if (name.isEmpty) {
  //       throw Exception('Name cannot be empty.');
  //     }

  //     print('Querying Firestore for customer with name: $name');

  //     // Fetch all customers; you may need to optimize this depending on the data size
  //     QuerySnapshot customersSnapshot = await _firestore
  //         .collection('organizations')
  //         .doc('ABC-1234-999')
  //         .collection('customers')
  //         .orderBy('name')
  //         .get();

  //     QueryDocumentSnapshot? matchingCustomer;

  //     // Find the exact match ignoring case
  //     for (var doc in customersSnapshot.docs) {
  //       if (doc['name'].toString().toLowerCase() == name.toLowerCase()) {
  //         matchingCustomer = doc;
  //         break;
  //       }
  //     }

  //     if (matchingCustomer != null) {
  //       DocumentReference customerRef = matchingCustomer.reference;
  //       Map<String, dynamic> updateData = {};

  //       // Update fields if they exist in customerData
  //       final fieldsToUpdate = [
  //         'address',
  //         'assignedto',
  //         'category',
  //         'company',
  //         'email',
  //         'name',
  //         'phone',
  //         'tags',
  //         'notes'
  //       ];

  //       for (var field in fieldsToUpdate) {
  //         if (customerData[field] != null && customerData[field].isNotEmpty) {
  //           updateData[field] = customerData[field];
  //         }
  //       }

  //       // Handle tags separately
  //       if (customerData['tags'] != null &&
  //           customerData['tags'] is List &&
  //           (customerData['tags'] as List).isNotEmpty) {
  //         updateData['tags'] = FieldValue.arrayUnion(customerData['tags']);
  //       }

  //       // Update status with correct phone number and type
  //       if (customerData['status'] != null && customerData['status'] is Map) {
  //         updateData['status'] = {
  //           'agent': customerData['status']['agent'] ?? '',
  //           'type': customerData['status']['type'] ?? 'new',
  //         };
  //       }

  //       // // Update status
  //       // updateData['status'] = {
  //       //   'agent': customerData['agent'] ?? '',
  //       //   'type': customerData[''] ?? 'new',
  //       // };

  //       // Don't update createdOn field as it should remain the original creation date

  //       await customerRef.update(updateData);
  //       print('Customer "${matchingCustomer['name']}" updated successfully');
  //     } else {
  //       print('No customers found matching: $name');
  //     }
  //   } catch (e) {
  //     print('Error updating customer: $e');
  //     throw e;
  //   }
  // }

  Future<void> createOrUpdateCustomer(
    Map<String, dynamic> customerData,
  ) async {
    try {
      String name = customerData['name'];
      if (name.isEmpty) {
        throw Exception('Name cannot be empty.');
      }

      print('Querying Firestore for customer with name: $name');

      // Fetch all organization IDs dynamically
      List<String> organizationIDs = await getAllOrganizationIDs();

      QueryDocumentSnapshot? matchingCustomer;

      // Iterate over each organization ID
      for (String organizationID in organizationIDs) {
        // Fetch all customers for the organization
        QuerySnapshot customersSnapshot = await _firestore
            .collection('organizations')
            .doc(organizationID)
            .collection('customers')
            .orderBy('name')
            .get();

        // Find the exact match ignoring case
        for (var doc in customersSnapshot.docs) {
          if (doc['name'].toString().toLowerCase() == name.toLowerCase()) {
            matchingCustomer = doc;
            break;
          }
        }

        if (matchingCustomer != null) {
          DocumentReference customerRef = matchingCustomer.reference;
          Map<String, dynamic> updateData = {};

          // Update fields if they exist in customerData
          final fieldsToUpdate = [
            'address',
            'assignedto',
            'category',
            'company',
            'email',
            'name',
            'phone',
            'tags',
            'notes'
          ];

          for (var field in fieldsToUpdate) {
            if (customerData[field] != null && customerData[field].isNotEmpty) {
              updateData[field] = customerData[field];
            }
          }

          // Handle tags separately
          if (customerData['tags'] != null &&
              customerData['tags'] is List &&
              (customerData['tags'] as List).isNotEmpty) {
            updateData['tags'] = FieldValue.arrayUnion(customerData['tags']);
          }

          // Update status with correct phone number and type
          if (customerData['status'] != null && customerData['status'] is Map) {
            updateData['status'] = {
              'agent': customerData['status']['agent'] ?? '',
              'type': customerData['status']['type'] ?? 'new',
            };
          }

          // Don't update createdOn field as it should remain the original creation date
          await customerRef.update(updateData);
          print('Customer "${matchingCustomer['name']}" updated successfully');
          break;
        }
      }

      if (matchingCustomer == null) {
        print('No customers found matching: $name');
      }
    } catch (e) {
      print('Error updating customer: $e');
      throw e;
    }
  }

  //   }
  // }

  // Future<void> updateCategory(String oldName, String newName,
  //     [String? colorHex]) async {
  //   try {
  //     final doc = await _firestore
  //         .collection('organizations')
  //         .doc('ABC-1234-999')
  //         .get();
  //     final data = doc.data() as Map<String, dynamic>;
  //     final categories =
  //         List<Map<String, dynamic>>.from(data['categories'] ?? []);
  //     final updatedCategories = categories.map((category) {
  //       if (category['name'] == oldName) {
  //         return {
  //           ...category,
  //           'name': newName,
  //           if (colorHex != null && colorHex.isNotEmpty) 'color': colorHex,
  //         };
  //       }
  //       return category;
  //     }).toList();

  //     await _firestore.collection('organizations').doc('ABC-1234-999').update({
  //       'categories': updatedCategories,
  //     });
  //   } catch (e) {
  //     print('Error updating category: $e');
  //   }
  // }

  Future<void> updateCategory(String oldName, String newName,
      [String? colorHex]) async {
    try {
      // Fetch all organization IDs dynamically
      List<String> organizationIDs = await getAllOrganizationIDs();

      for (String organizationID in organizationIDs) {
        // Get the document reference for the organization
        DocumentReference docRef =
            _firestore.collection('organizations').doc(organizationID);

        // Fetch the document
        DocumentSnapshot doc = await docRef.get();
        final data = doc.data() as Map<String, dynamic>?;
        if (data == null || !data.containsKey('categories')) {
          print(
              'Categories field is missing or document data is null for organization ID: $organizationID');
          continue;
        }

        final categories =
            List<Map<String, dynamic>>.from(data['categories'] ?? []);
        final updatedCategories = categories.map((category) {
          if (category['name'] == oldName) {
            return {
              ...category,
              'name': newName,
              if (colorHex != null && colorHex.isNotEmpty) 'color': colorHex,
            };
          }
          return category;
        }).toList();

        // Update the document
        await docRef.update({
          'categories': updatedCategories,
        });
      }
    } catch (e) {
      print('Error updating category: $e');
    }
  }

  // Future<void> deleteCategory(String name) async {
  //   try {
  //     final doc = await _firestore
  //         .collection('organizations')
  //         .doc('ABC-1234-999')
  //         .get();
  //     final data = doc.data() as Map<String, dynamic>;
  //     final categories =
  //         List<Map<String, dynamic>>.from(data['categories'] ?? []);
  //     final updatedCategories =
  //         categories.where((category) => category['name'] != name).toList();

  //     await _firestore.collection('organizations').doc('ABC-1234-999').update({
  //       'categories': updatedCategories,
  //     });
  //   } catch (e) {
  //     print('Error deleting category: $e');
  //   }
  // }

  Future<void> deleteCategory(String name) async {
    try {
      // Fetch all organization IDs dynamically
      List<String> organizationIDs = await getAllOrganizationIDs();

      for (String organizationID in organizationIDs) {
        // Get the document reference for the organization
        DocumentReference docRef =
            _firestore.collection('organizations').doc(organizationID);

        // Fetch the document
        DocumentSnapshot doc = await docRef.get();
        final data = doc.data() as Map<String, dynamic>?;
        if (data == null || !data.containsKey('categories')) {
          print(
              'Categories field is missing or document data is null for organization ID: $organizationID');
          continue;
        }

        final categories =
            List<Map<String, dynamic>>.from(data['categories'] ?? []);
        final updatedCategories =
            categories.where((category) => category['name'] != name).toList();

        // Update the document
        await docRef.update({
          'categories': updatedCategories,
        });
      }
    } catch (e) {
      print('Error deleting category: $e');
    }
  }

  // Future<void> addCategory(String name, String type, [String? colorHex]) async {
  //   final category = {
  //     'name': name,
  //     'type': type,
  //     'color': colorHex, // Example color value
  //   };
  //   try {
  //     await _firestore.collection('organizations').doc('ABC-1234-999').update({
  //       'categories': FieldValue.arrayUnion([category])
  //     });
  //   } catch (e) {
  //     throw Exception('Error adding category: $e');
  //   }
  // }

  Future<void> addCategory(String name, String type, [String? colorHex]) async {
    final category = {
      'name': name,
      'type': type,
      'color': colorHex ?? '#000000', // Default color if none provided
    };

    try {
      // Fetch all organization IDs dynamically
      List<String> organizationIDs = await getAllOrganizationIDs();

      for (String organizationID in organizationIDs) {
        // Get the document reference for the organization
        DocumentReference docRef =
            _firestore.collection('organizations').doc(organizationID);

        // Update the document
        await docRef.update({
          'categories': FieldValue.arrayUnion([category]),
        });
      }
    } catch (e) {
      print('Error adding category: $e');
      throw Exception('Error adding category: $e');
    }
  }

  // Future<bool> categoryExists(String name) async {
  //   try {
  //     DocumentSnapshot doc = await _firestore
  //         .collection('organizations')
  //         .doc('ABC-1234-999')
  //         .get();
  //     if (!doc.exists) {
  //       print('Document does not exist at the path.');
  //       return false;
  //     }

  //     final data = doc.data() as Map<String, dynamic>?;
  //     if (data == null || !data.containsKey('categories')) {
  //       return false;
  //     }

  //     final categories =
  //         List<Map<String, dynamic>>.from(data['categories'] ?? []);
  //     return categories.any((category) => category['name'] == name);
  //   } catch (e) {
  //     print('Error checking category existence: $e');
  //     throw Exception('Error checking category existence: $e');
  //   }
  // }

  Future<bool> categoryExists(String name) async {
    try {
      // Fetch all organization IDs dynamically
      List<String> organizationIDs = await getAllOrganizationIDs();

      for (String organizationID in organizationIDs) {
        // Get the document reference for the organization
        DocumentSnapshot doc = await _firestore
            .collection('organizations')
            .doc(organizationID)
            .get();

        if (!doc.exists) {
          print(
              'Document does not exist at the path for organization ID: $organizationID');
          continue;
        }

        final data = doc.data() as Map<String, dynamic>?;
        if (data == null || !data.containsKey('categories')) {
          continue;
        }

        final categories =
            List<Map<String, dynamic>>.from(data['categories'] ?? []);
        if (categories.any((category) => category['name'] == name)) {
          return true; // Return true if category is found
        }
      }

      return false; // Return false if category is not found in any organization
    } catch (e) {
      print('Error checking category existence: $e');
      throw Exception('Error checking category existence: $e');
    }
  }

  // Future<List<Map<String, dynamic>>> fetchCategories() async {
  //   try {
  //     DocumentSnapshot doc = await _firestore
  //         .collection('organizations')
  //         .doc('ABC-1234-999')
  //         .get();
  //     if (!doc.exists) {
  //       print('Document does not exist at the path.');
  //       throw Exception('Document does not exist');
  //     }

  //     final data = doc.data() as Map<String, dynamic>?;
  //     if (data == null || !data.containsKey('categories')) {
  //       print('Categories field is missing or document data is null.');
  //       return [];
  //     }
  //     final categories =
  //         List<Map<String, dynamic>>.from(data['categories'] ?? []);
  //     print('Fetched categories: $categories');

  //     return categories.map((category) {
  //       return {
  //         // 'value': category['name'] ?? 'Unnamed',
  //         'name': category['name'] ?? 'Unnamed',
  //         'color': category['color'] ?? '#000000',

  //         // 'icon': Icons.category, // You can choose the icon based on the type if needed
  //       };
  //     }).toList();
  //     // return categories;
  //   } catch (e) {
  //     print('Error fetching categories: $e');
  //     throw Exception('Error fetching categories: $e');
  //   }
  // }

  Future<List<Map<String, dynamic>>> fetchCategories() async {
    try {
      List<String> organizationIDs = await getAllOrganizationIDs();
      List<Map<String, dynamic>> allCategories = [];

      for (String organizationID in organizationIDs) {
        DocumentSnapshot doc = await _firestore
            .collection('organizations')
            .doc(organizationID)
            .get();

        if (!doc.exists) {
          print(
              'Document does not exist at the path for organization ID: $organizationID');
          continue; // Skip to the next organization if the document does not exist
        }

        final data = doc.data() as Map<String, dynamic>?;
        if (data == null || !data.containsKey('categories')) {
          print(
              'Categories field is missing or document data is null for organization ID: $organizationID');
          continue; // Skip to the next organization if the categories field is missing
        }

        final categories =
            List<Map<String, dynamic>>.from(data['categories'] ?? []);
        print(
            'Fetched categories for organization ID $organizationID: $categories');

        allCategories.addAll(categories.map((category) {
          return {
            'name': category['name'] ?? 'Unnamed',
            'color': category['color'] ?? '#000000',
          };
        }).toList());
      }

      return allCategories;
    } catch (e) {
      print('Error fetching categories: $e');
      throw Exception('Error fetching categories: $e');
    }
  }

  // Future<void> addCustomerDataIfNotExists(Map<String, dynamic> data) async {
  //   // Check if the document already exists using a unique identifier (e.g., phone number)
  //   String phoneNumber = data['phoneNumber'];
  //   QuerySnapshot querySnapshot = await _firestore
  //       .collection('organizations/ABC-1234-999/customers')
  //       .where('phoneNumber', isEqualTo: phoneNumber)
  //       .limit(1)
  //       .get();

  //   if (querySnapshot.docs.isEmpty) {
  //     // If no existing document is found, add the new data
  //     await _firestore
  //         .collection('organizations/ABC-1234-999/customers')
  //         .add(data);
  //   }
  // }

  Future<void> addCustomerDataIfNotExists(Map<String, dynamic> data) async {
    String phoneNumber = data['phoneNumber'];
    List<String> organizationIDs = await getAllOrganizationIDs();

    for (String organizationID in organizationIDs) {
      QuerySnapshot querySnapshot = await _firestore
          .collection('organizations/$organizationID/customers')
          .where('phoneNumber', isEqualTo: phoneNumber)
          .limit(1)
          .get();

      if (querySnapshot.docs.isEmpty) {
        // If no existing document is found in the current organization, add the new data
        await _firestore
            .collection('organizations/$organizationID/customers')
            .add(data);
        print('Customer data added to organization ID: $organizationID');
      } else {
        print(
            'Customer data already exists in organization ID: $organizationID');
      }
    }
  }

  // Future<void> uploadData(List<Map<String, dynamic>> data) async {
  //   // Logic to upload data to Firestore
  //   // Example:
  //   for (var item in data) {
  //     await FirebaseFirestore.instance
  //         .collection('/organizations/ABC-1234-999/customers')
  //         .add(item);
  //   }
  // }

  Future<void> uploadData(List<Map<String, dynamic>> data) async {
    try {
      // Fetch all organization IDs dynamically
      List<String> organizationIDs = await getAllOrganizationIDs();

      for (String organizationID in organizationIDs) {
        // Get the collection reference for the organization
        CollectionReference customersCollection = FirebaseFirestore.instance
            .collection('organizations/$organizationID/customers');

        // Upload each item to the Firestore collection
        for (var item in data) {
          await customersCollection.add(item);
        }

        print('Data uploaded to organization: $organizationID');
      }
    } catch (e) {
      print('Error uploading data: $e');
      throw Exception('Error uploading data: $e');
    }
  }

//This Line Used for employees.dart screen to fetch data from the firestore databse
  Future<List<EmployeeDetails>> getEmployees(String docPath) async {
    final snapshot = await _firestore.collection(docPath).get();
    return snapshot.docs
        .map((doc) => EmployeeDetails.fromFirestore(doc.data()))
        .toList();
  }

//This Line Used for customers.dart screen to fetch data from the firestore databse
  Future<List<Customer>> getCustomers(String collectionPath) async {
    final snapshot = await _firestore.collection(collectionPath).get();
    return snapshot.docs
        .map((doc) => Customer.fromFirestore(doc.data(), doc.id))
        .toList();
  }

// use to create customer leads in the firestore database from the customers screen
  // Future<void> createCustomer(Map<String, dynamic> customerData) async {
  //   try {
  //     // Replace '/organizations/ABC-1234-999/customers' with your Firestore path
  //     await _firestore
  //         .collection('/organizations/ABC-1234-999/customers')
  //         .add(customerData);
  //   } catch (e) {
  //     print('Error creating customer in Firestore: $e');
  //     // Optionally, throw the error further if needed
  //     throw e;
  //   }
  // }

  Future<void> createCustomer(Map<String, dynamic> customerData) async {
    try {
      // Fetch all organization IDs dynamically
      List<String> organizationIDs = await getAllOrganizationIDs();

      for (String organizationID in organizationIDs) {
        // Get the collection reference for the organization
        CollectionReference customersCollection =
            _firestore.collection('organizations/$organizationID/customers');

        // Add the customer data to the Firestore collection
        await customersCollection.add(customerData);

        print('Customer created in organization: $organizationID');
      }
    } catch (e) {
      print('Error creating customer in Firestore: $e');
      // Optionally, throw the error further if needed
      throw e;
    }
  }

// able to add individual customers with detail notes
  // Future<void> addIndividualCustomer(Customeradd customeradd) async {
  //   try {
  //     // Remove "+91" prefix from phone number if present
  //     String phoneNumber = customeradd.phone.startsWith('+91')
  //         ? customeradd.phone.substring(3) // Remove "+91"
  //         : customeradd.phone;

  //     await FirebaseFirestore.instance
  //         .collection('/organizations/ABC-1234-999/customers')
  //         .doc(phoneNumber) // Use phone number as document ID
  //         .set(customeradd.toMap());
  //   } catch (e) {
  //     print('Error adding customer to Firestore: $e');
  //     throw Exception('Failed to add customer: $e');
  //   }
  // }

  // Future<void> addIndividualCustomer(Customeradd customeradd) async {
  //   try {
  //     // Remove "+91" prefix from phone number if present
  //     String phoneNumber = customeradd.phone.startsWith('+91')
  //         ? customeradd.phone.substring(3) // Remove "+91"
  //         : customeradd.phone;

  //     // Fetch all organization IDs dynamically
  //     List<String> organizationIDs = await getAllOrganizationIDs();

  //     for (String organizationID in organizationIDs) {
  //       // Get the collection reference for the organization
  //       DocumentReference customerDoc = FirebaseFirestore.instance
  //           .collection('organizations/$organizationID/customers')
  //           .doc(phoneNumber); // Use phone number as document ID

  //       // Set the customer data in Firestore
  //       await customerDoc.set(customeradd.toMap());

  //       print('Customer added/updated in organization: $organizationID');
  //     }
  //   } catch (e) {
  //     print('Error adding customer to Firestore: $e');
  //     throw Exception('Failed to add customer: $e');
  //   }
  // }

  Future<void> addIndividualCustomer(Customeradd customeradd) async {
    try {
      // Remove "+91" prefix from phone number if present
      String phoneNumber = customeradd.phone.startsWith('+91')
          ? customeradd.phone.substring(3) // Remove "+91"
          : customeradd.phone;

      // Fetch all organization IDs dynamically
      List<String> organizationIDs = await getAllOrganizationIDs();

      for (String organizationID in organizationIDs) {
        // Get the collection reference for the organization
        DocumentReference customerDoc = FirebaseFirestore.instance
            .collection('organizations/$organizationID/customers')
            .doc(phoneNumber); // Use phone number as document ID

        // Set the customer data in Firestore
        await customerDoc.set(customeradd.toMap());

        print('Customer added/updated in organization: $organizationID');

        // Check if status contains an agent and the agent is not null
        if (customeradd.status['agent'] != null) {
          String agent = customeradd.status['agent'];

          // Create a history entry
          final DateTime now = DateTime.now();
          final String formattedDate =
              DateFormat('yyyy-MM-dd HH:mm:ss.SSSSSS').format(now);

          final historyEntry = {
            'date': formattedDate,
            'action': 'New',
            'notes': 'Assigned to: $agent',
            'extraFields': {},
          };

          // Add the history entry to the customer's history collection
          await customerDoc.collection('history').add(historyEntry);

          print(
              'History entry added for agent assignment in organization: $organizationID');
        }
      }
    } catch (e) {
      print('Error adding customer to Firestore: $e');
      throw Exception('Failed to add customer: $e');
    }
  }

// Method to fetch allocations from Firestore
  // Fetch allocations with status.type 'new'
  // Future<List<Allocation>> fetchNewAllocations() async {
  //   try {
  //     QuerySnapshot snapshot = await _firestore
  //         .collection('organizations')
  //         .doc('ABC-1234-999')
  //         // .collection('')
  //         .collection('customers')
  //         .where('status.type', isEqualTo: 'new')
  //         .get();

  //     return snapshot.docs
  //         .map((doc) =>
  //             Allocation.fromFirestore(doc.data() as Map<String, dynamic>))
  //         .toList();
  //   } catch (e) {
  //     print('Error fetching new allocations: $e');
  //     return [];
  //   }
  // }

  Future<List<Allocation>> fetchNewAllocations() async {
    try {
      List<String> organizationIDs = await getAllOrganizationIDs();
      List<Allocation> allAllocations = [];

      for (String organizationID in organizationIDs) {
        QuerySnapshot snapshot = await _firestore
            .collection('organizations')
            .doc(organizationID)
            .collection('customers')
            .where('status.type', isEqualTo: 'new')
            .get();

        List<Allocation> allocations = snapshot.docs
            .map((doc) =>
                Allocation.fromFirestore(doc.data() as Map<String, dynamic>))
            .toList();

        allAllocations.addAll(allocations);
      }

      return allAllocations;
    } catch (e) {
      print('Error fetching new allocations: $e');
      return [];
    }
  }

// Method to fetch followups from Firestore  status.type 'Follow-up'
  // Future<List<Followup>> fetchNewFollowups() async {
  //   try {
  //     QuerySnapshot snapshot = await _firestore
  //         .collection('organizations')
  //         .doc('ABC-1234-999')
  //         .collection('customers')
  //         .where('status.type', isEqualTo: 'Follow-Up')
  //         .get();

  //     return snapshot.docs
  //         .map((doc) =>
  //             Followup.fromFirestore(doc.data() as Map<String, dynamic>))
  //         .toList();
  //   } catch (e) {
  //     print('Error fetching new followups: $e');
  //     return [];
  //   }
  // }

  Future<List<Followup>> fetchNewFollowups() async {
    try {
      // Fetch all organization IDs dynamically
      List<String> organizationIDs = await getAllOrganizationIDs();
      List<Followup> allFollowups = [];

      for (String organizationID in organizationIDs) {
        // Query the 'customers' collection for follow-ups in each organization
        QuerySnapshot snapshot = await _firestore
            .collection('organizations/$organizationID/customers')
            .where('status.type', isEqualTo: 'Follow-Up')
            .get();

        // Map the documents to Followup instances and add to the list
        List<Followup> followups = snapshot.docs
            .map((doc) =>
                Followup.fromFirestore(doc.data() as Map<String, dynamic>))
            .toList();

        allFollowups.addAll(followups);
      }

      return allFollowups;
    } catch (e) {
      print('Error fetching new followups: $e');
      return [];
    }
  }

  // Future<List<String>> fetchAllAgentIds() async {
  //   final agentCollection =
  //       _firestore.collection('/organizations/ABC-1234-999/agents');
  //   final snapshot = await agentCollection.get();
  //   return snapshot.docs.map((doc) => doc.id).toList();
  // }

  Future<List<String>> fetchAllAgentIds() async {
    try {
      List<String> organizationIDs = await getAllOrganizationIDs();
      List<String> allAgentIds = [];

      for (String organizationID in organizationIDs) {
        final agentCollection =
            _firestore.collection('organizations/$organizationID/agents');
        final snapshot = await agentCollection.get();
        List<String> agentIds = snapshot.docs.map((doc) => doc.id).toList();
        allAgentIds.addAll(agentIds);
      }

      return allAgentIds;
    } catch (e) {
      print('Error fetching agent IDs: $e');
      return [];
    }
  }

// Fetch specific agent details based on organization ID and agent ID
  Future<DocumentSnapshot<Map<String, dynamic>>> fetchAgentDetails(
      String organizationId, String agentId) async {
    try {
      final agentDoc = await _firestore
          .doc('/organizations/$organizationId/agents/$agentId')
          .get();

      if (!agentDoc.exists) {
        throw Exception('Agent not found');
      }

      return agentDoc;
    } catch (e) {
      print('Error fetching agent details: $e');
      throw Exception('Failed to fetch agent details');
    }
  }

  // Future<List<EmployeeCallLogs>> fetchCallLogs(String agentId) async {
  //   try {
  //     QuerySnapshot snapshot = await _firestore
  //         .collection('/organizations/ABC-1234-999/agents/$agentId/callLogs')
  //         .get();

  //     return snapshot.docs
  //         .map((doc) => EmployeeCallLogs.fromFirestore(
  //             doc.data() as Map<String, dynamic>))
  //         .toList();
  //   } catch (e) {
  //     print('Error fetching call logs: $e');
  //     return [];
  //   }
  // }

  Future<List<EmployeeCallLogs>> fetchCallLogs(String agentId) async {
    try {
      List<String> organizationIDs = await getAllOrganizationIDs();
      List<EmployeeCallLogs> allCallLogs = [];

      for (String organizationID in organizationIDs) {
        QuerySnapshot snapshot = await _firestore
            .collection(
                'organizations/$organizationID/agents/$agentId/callLogs')
            .get();

        List<EmployeeCallLogs> callLogs = snapshot.docs
            .map((doc) => EmployeeCallLogs.fromFirestore(
                doc.data() as Map<String, dynamic>))
            .toList();

        allCallLogs.addAll(callLogs);
      }

      return allCallLogs;
    } catch (e) {
      print('Error fetching call logs: $e');
      return [];
    }
  }

  // Future<List<String>> fetchAgentIds() async {
  //   try {
  //     QuerySnapshot querySnapshot = await _firestore
  //         .collection('/organizations/ABC-1234-999/agents')
  //         .get();
  //     return querySnapshot.docs.map((doc) => doc.id).toList();
  //   } catch (e) {
  //     print("Error fetching agent IDs: $e");
  //     rethrow;
  //   }
  // }

  Future<List<String>> fetchAgentIds() async {
    try {
      List<String> organizationIDs = await getAllOrganizationIDs();
      List<String> allAgentIds = [];

      for (String organizationID in organizationIDs) {
        QuerySnapshot querySnapshot = await _firestore
            .collection('organizations/$organizationID/agents')
            .get();
        List<String> agentIds =
            querySnapshot.docs.map((doc) => doc.id).toList();
        allAgentIds.addAll(agentIds);
      }

      return allAgentIds;
    } catch (e) {
      print("Error fetching agent IDs: $e");
      rethrow;
    }
  }

  // Future<Map<String, String>> fetchAgents() async {
  //   try {
  //     QuerySnapshot querySnapshot = await _firestore
  //         .collection('/organizations/ABC-1234-999/agents')
  //         .get();

  //     return Map.fromEntries(querySnapshot.docs.map((doc) {
  //       String id = doc.id;
  //       Map<String, dynamic>? data = doc.data() as Map<String, dynamic>?;
  //       String name = data?['name'] ??
  //           ''; // Ensure the 'name' field is present in your Firestore documents
  //       return MapEntry(name, id);
  //     }).where((entry) => entry.key.isNotEmpty));
  //   } catch (e) {
  //     print("Error fetching agents: $e");
  //     return {};
  //   }
  // }

  Future<Map<String, String>> fetchAgents() async {
    try {
      List<String> organizationIDs = await getAllOrganizationIDs();
      Map<String, String> allAgents = {};

      for (String organizationID in organizationIDs) {
        QuerySnapshot querySnapshot = await _firestore
            .collection('organizations/$organizationID/agents')
            .get();

        Map<String, String> agents =
            Map.fromEntries(querySnapshot.docs.map((doc) {
          String id = doc.id;
          Map<String, dynamic>? data = doc.data() as Map<String, dynamic>?;
          String name =
              data?['name'] ?? ''; // Ensure the 'name' field is present
          return MapEntry(name, id);
        }).where((entry) => entry.key.isNotEmpty));

        allAgents.addAll(agents);
      }

      return allAgents;
    } catch (e) {
      print("Error fetching agents: $e");
      return {};
    }
  }

  // Future<Map<DateTime, Map<String, int>>> fetchCallLogsForMonth(
  //     String agentId, DateTime month) async {
  //   final startDate = DateTime(month.year, month.month, 1);
  //   final endDate = DateTime(month.year, month.month + 1, 0);

  //   final querySnapshot = await _firestore
  //       .collection('/organizations/ABC-1234-999/agents/$agentId/callLogs')
  //       .where('callDate', isGreaterThanOrEqualTo: startDate.toIso8601String())
  //       .where('callDate', isLessThanOrEqualTo: endDate.toIso8601String())
  //       .get();

  //   Map<DateTime, Map<String, int>> callLogs = {};

  //   for (var doc in querySnapshot.docs) {
  //     final data = doc.data();
  //     DateTime date = DateTime.parse(data['callDate']);
  //     String type =
  //         data['callType']; // "CallType.outgoing" or "CallType.incoming"
  //     int duration = data['callDuration'] ?? 0;

  //     final callType = type.contains('outgoing') ? 'outbound' : 'inbound';

  //     if (!callLogs.containsKey(date)) {
  //       callLogs[date] = {"inbound": 0, "outbound": 0};
  //     }

  //     callLogs[date]![callType] != 1; // Increment call count
  //   }

  //   return callLogs;
  // }

  Future<Map<DateTime, Map<String, int>>> fetchCallLogsForMonth(
      String agentId, DateTime month) async {
    final startDate = DateTime(month.year, month.month, 1);
    final endDate = DateTime(month.year, month.month + 1, 0);

    try {
      List<String> organizationIDs = await getAllOrganizationIDs();
      Map<DateTime, Map<String, int>> allCallLogs = {};

      for (String organizationID in organizationIDs) {
        final querySnapshot = await _firestore
            .collection(
                'organizations/$organizationID/agents/$agentId/callLogs')
            .where('callDate',
                isGreaterThanOrEqualTo: startDate.toIso8601String())
            .where('callDate', isLessThanOrEqualTo: endDate.toIso8601String())
            .get();

        for (var doc in querySnapshot.docs) {
          final data = doc.data() as Map<String, dynamic>;
          DateTime date = DateTime.parse(data['callDate']);
          String type =
              data['callType']; // "CallType.outgoing" or "CallType.incoming"
          int duration = data['callDuration'] ?? 0;

          final callType = type.contains('outgoing') ? 'outbound' : 'inbound';

          if (!allCallLogs.containsKey(date)) {
            allCallLogs[date] = {"inbound": 0, "outbound": 0};
          }

          allCallLogs[date]![callType] =
              (allCallLogs[date]![callType] ?? 0) + 1;
        }
      }

      return allCallLogs;
    } catch (e) {
      print('Error fetching call logs for the month: $e');
      return {};
    }
  }

  Future<List<CallLog>> fetchInOutCallLogs(
      String organizationId, String agentId) async {
    try {
      final snapshot = await _firestore
          .collection('organizations')
          .doc(organizationId)
          .collection('agents')
          .doc(agentId)
          .collection('callLogs')
          .get();

      return snapshot.docs
          .map((doc) => CallLog.fromFirestore(doc.data()))
          .toList();
    } catch (e) {
      print('Error fetching call logs: $e');
      return [];
    }
  }

  // Fetch all customer histories from a dynamic path
  Future<List<CustomerHistories>> getCustomerHistories(
      String organizationId, String customerId) async {
    print(
        "Fetching customer histories for organizationId: $organizationId, customerId: $customerId");

    try {
      final snapshot = await _firestore
          .collection('organizations')
          .doc(organizationId)
          .collection('customers')
          .doc(customerId)
          .collection('history')
          .get();

      print("Fetched ${snapshot.docs.length} documents");

      // Map documents to CustomerHistory objects
      final histories = snapshot.docs.map((doc) {
        print("Document ID: ${doc.id}");
        print("Document Data: ${doc.data()}");
        return CustomerHistories.fromMap(doc.data());
      }).toList();

      print("Mapped ${histories.length} CustomerHistory objects");
      return histories;
    } catch (e) {
      print("Error fetching customer histories: $e");
      throw e; // rethrow to handle in the calling function
    }
  }

  Future<CustomerHistories?> getCustomerHistory(
      String organizationId, String customerId, String historyId) async {
    try {
      print("Fetching customer history for ID: $customerId");
      final snapshot = await _firestore
          .collection('organizations')
          .doc(organizationId)
          .collection('customers')
          .doc(customerId)
          .collection('history')
          .doc(historyId)
          .get();

      if (snapshot.exists) {
        return CustomerHistories.fromMap(snapshot.data()!);
      } else {
        print("No history found for customer ID: $customerId");
        return null;
      }
    } catch (e) {
      print("Error fetching customer history for ID: $customerId. Error: $e");
      rethrow;
    }
  }

  Future<List<DocumentSnapshot>> fetchcustomerCallLogs(
      BuildContext context, String phoneNumber) async {
    final customerProvider =
        Provider.of<CustomerProvider>(context, listen: false);
    final organizationID = customerProvider.organizationId;
    final agentID = customerProvider.selectedAgentID;

    print('Fetching call logs for phone number: $phoneNumber');
    print('Organization ID: $organizationID');
    print('Agent ID: $agentID');

    if (organizationID == null || agentID.isEmpty) {
      print('Error: Organization ID or Agent ID is empty.');
      return [];
    }

    try {
      final querySnapshot = await FirebaseFirestore.instance
          .collection('organizations')
          .doc(organizationID)
          .collection('agents')
          .doc(agentID)
          .collection('callLogs')
          .where('phone', isEqualTo: phoneNumber)
          .get();

      print('Fetched ${querySnapshot.docs.length} call logs.');
      return querySnapshot.docs;
    } catch (e) {
      print('Error fetching call logs: $e');
      return [];
    }
  }

/////////////////////////////////////

  Future<List<Customer>> fetchCustomers(String organizationId) async {
    try {
      final snapshot = await _firestore
          .collection('organizations') // Permanent collection
          .doc(organizationId) // Dynamic document ID
          .collection('customers') // Subcollection
          .get();

      return snapshot.docs
          .map((doc) => Customer.fromFirestore(doc.data(), doc.id))
          .toList();
    } catch (e) {
      print('Error fetching customers: $e');
      return []; // Return an empty list or handle error as needed
    }
  }

  // Future<void> saveImportData(ImportData data) async {
  //   try {
  //     await _firestore
  //         .collection('/organizations/ABC-1234-999/customers')
  //         .doc(data.phone)
  //         .set(data.toMap());
  //   } catch (e) {
  //     print('Error saving data: $e');
  //     throw e;
  //   }
  // }

  Future<void> saveImportData(ImportData data) async {
    try {
      List<String> organizationIDs = await getAllOrganizationIDs();

      for (String organizationID in organizationIDs) {
        await _firestore
            .collection('organizations/$organizationID/customers')
            .doc(data.phone)
            .set(data.toMap());
      }
    } catch (e) {
      print('Error saving data: $e');
      throw e;
    }
  }

  // Fetch all ImportData from Firestore

  Future<List<ImportData>> fetchImportData() async {
    try {
      // Fetch all organization IDs dynamically
      List<String> organizationIDs = await getAllOrganizationIDs();
      List<ImportData> allImportData = [];

      for (String organizationID in organizationIDs) {
        final CollectionReference importDataCollection = FirebaseFirestore
            .instance
            .collection('organizations')
            .doc(organizationID)
            .collection('customers');

        QuerySnapshot querySnapshot = await importDataCollection.get();
        List<ImportData> importDataList = querySnapshot.docs
            .map(
                (doc) => ImportData.fromMap(doc.data() as Map<String, dynamic>))
            .toList();

        allImportData.addAll(importDataList);
      }

      return allImportData;
    } catch (e) {
      print('Error fetching import data: $e');
      throw Exception('Error fetching data from Firestore: $e');
    }
  }

  // Fetch a single ImportData by phone number
  Future<ImportData?> fetchImportDataByPhone(String phone) async {
    try {
      String documentId = phone.startsWith('+') ? phone.substring(1) : phone;
      // Fetch all organization IDs dynamically
      List<String> organizationIDs = await getAllOrganizationIDs();

      for (String organizationID in organizationIDs) {
        final DocumentSnapshot docSnapshot = await FirebaseFirestore.instance
            .collection('organizations')
            .doc(organizationID)
            .collection('customers')
            .doc(documentId)
            .get();

        if (docSnapshot.exists) {
          return ImportData.fromMap(docSnapshot.data() as Map<String, dynamic>);
        }
      }

      return null;
    } catch (e) {
      print('Error fetching import data by phone: $e');
      throw Exception('Error fetching data from Firestore: $e');
    }
  }

  // Future<List<ImportData>> fetchImportData() async {
  //   try {
  //     QuerySnapshot querySnapshot = await _importDataCollection.get();
  //     return querySnapshot.docs
  //         .map((doc) => ImportData.fromMap(doc.data() as Map<String, dynamic>))
  //         .toList();
  //   } catch (e) {
  //     print('Error fetching import data: $e');
  //     throw Exception('Error fetching data from Firestore: $e');
  //   }
  // }

  // // Fetch a single ImportData by phone number
  // Future<ImportData?> fetchImportDataByPhone(String phone) async {
  //   String documentId = phone.startsWith('+') ? phone.substring(1) : phone;
  //   DocumentSnapshot docSnapshot =
  //       await _importDataCollection.doc(documentId).get();
  //   if (docSnapshot.exists) {
  //     return ImportData.fromMap(docSnapshot.data() as Map<String, dynamic>);
  //   }
  //   return null;
  // }

  Future addOrgDetails(Map<String, dynamic> data, String organizationId) async {
    await _firestore
        .collection("organizations")
        .doc(organizationId)
        .update(data);
  }

  //to validate a org code
  Future<bool> checkIfOrgExists(String orgCode) async {
    bool isValid = await _firestore
        .collection("organizations")
        .doc(orgCode)
        .get()
        .then((value) => value.exists);
    return isValid;
  }

  Future<String> getOrgId(String email) {
    return _firestore
        .collection("managers")
        .doc(email)
        .get()
        .then((value) => value.data()!['organizationId']);
  }
}
