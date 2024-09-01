import 'package:flutter/material.dart';
import 'package:seeds_ai_callmate_web_app/models/custom_field_model.dart';
import 'package:seeds_ai_callmate_web_app/services/firestore_service.dart';

class CRMFieldsProvider with ChangeNotifier {
  final FirestoreService _firestoreService =
      FirestoreService(); // Update with your actual service

  List<CRMField> _customFields = [];

  List<CRMField> get customFields => _customFields;

  List<CRMField> _fields = [];

  List<CRMField> get fields => _fields;

  final Map<String, dynamic> _fieldValues = {};

  Map<String, dynamic> get fieldValues => _fieldValues;

  // void updateFieldValue(String fieldName, dynamic value) {
  //   _fieldValues[fieldName] = value;
  //   notifyListeners();
  // }

  void clearFieldValues() {
    fieldValues.clear();
    notifyListeners();
  }

  Future<void> addCRMField(String orgId, CRMField field) async {
    try {
      await _firestoreService.addCustomField(orgId, field);
      _customFields.add(field);
      notifyListeners();
    } catch (e) {
      print('Error adding CRM field: $e');
    }
  }

  Future<void> loadFields(String orgId) async {
    _fields = await _firestoreService.getCustomFields(orgId);
    notifyListeners();
  }

// Example for parsing CRMFields from Firestore

  Future<void> fetchCRMFields(String organizationId) async {
    try {
      final List<Map<String, dynamic>> fieldsData =
          await _firestoreService.fetchCRMFields(organizationId);

      _customFields = fieldsData.map((data) {
        return CRMField(
          name: data['name'] as String? ?? '',
          type: data['type'] as String? ?? '',
          field: data['field'] as String? ?? '',
          options: (data['options'] as List<dynamic>?)?.cast<String>(),
        );
      }).toList();

      notifyListeners();
    } catch (e) {
      print('Error processing CRM fields: $e');
      // Optionally, you can rethrow the error or handle it in a way that's appropriate for your app
      // throw Exception('Failed to process CRM fields: $e');
    }
  }

  Future<void> updateCRMFieldName(
      int index, String newName, String organizationId) async {
    try {
      CRMField field = _customFields[index];
      CRMField updatedField = CRMField(
        name: newName,
        type: field.type,
        field: field.field,
        options: field.options,
      );

      _customFields[index] = updatedField;
      await _firestoreService.updateCRMFields(
          organizationId, _customFields.map((f) => f.toMap()).toList());
      notifyListeners();
    } catch (e) {
      print('Error updating CRM field name: $e');
    }
  }

  Future<void> deleteCRMField(int index, String organizationId) async {
    try {
      _customFields.removeAt(index);
      await _firestoreService.updateCRMFields(
          organizationId, _customFields.map((f) => f.toMap()).toList());
      notifyListeners();
    } catch (e) {
      print('Error deleting CRM field: $e');
    }
  }

  // Updated method with print statements
  void updateFieldValue(String fieldName, String newValue) {
    print('Attempting to update field: $fieldName with value: $newValue');
    bool fieldFound = false;

    for (var field in _customFields) {
      if (field.name == fieldName) {
        print('Field found: ${field.name}');
        // Update the field as needed (assuming text/number fields)
        field = CRMField(
          name: field.name,
          type: field.type,
          field: field.field,
          options: field.options, // Keep existing options if they exist
        );
        print('Field updated: ${field.name}');
        fieldFound = true;
        notifyListeners();
        break;
      }
    }

    if (!fieldFound) {
      print('Field not found: $fieldName');
    }
  }

  Future<void> updateCRMField(
      int index, CRMField updatedField, String organizationId) async {
    try {
      _customFields[index] = updatedField;
      await _firestoreService.updateCRMFields(
          organizationId, _customFields.map((f) => f.toMap()).toList());
      notifyListeners();
    } catch (e) {
      print('Error updating CRM field: $e');
    }
  }
}
