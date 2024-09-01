import 'dart:convert';
import 'dart:io';

import 'package:csv/csv.dart';
import 'package:flutter/material.dart';

import 'package:seeds_ai_callmate_web_app/models/import_file_model.dart';
import 'package:seeds_ai_callmate_web_app/services/firestore_service.dart';

class ImportDataProvider with ChangeNotifier {
  final FirestoreService _firestoreService = FirestoreService();
  List<ImportData> _importDataList = [];
  List<String> _headers = [];
  List<List<dynamic>> _rows = [];
  bool _isLoading = false;

  List<ImportData> get importDataList => _importDataList;
  List<String> get headers => _headers;
  List<List<dynamic>> get rows => _rows;
  bool get isLoading => _isLoading;

  // Fetch all ImportData
  Future<void> fetchImportData() async {
    _isLoading = true;
    notifyListeners();

    _importDataList = await _firestoreService.fetchImportData();

    _isLoading = false;
    notifyListeners();
  }

  // Save ImportData
  Future<void> saveImportData(ImportData importData) async {
    await _firestoreService.saveImportData(importData);
    await fetchImportData();
  }

  // Import multiple ImportData
  Future<void> importData(List<ImportData> importDataList) async {
    try {
      for (ImportData importData in importDataList) {
        await _firestoreService.saveImportData(importData);
      }
      notifyListeners();
    } catch (e) {
      print('Error importing data: $e');
    }
  }

  // Parse CSV file
  Future<void> parseCsv(File csvFile) async {
    final input = csvFile.openRead();
    final fields = await input
        .transform(utf8.decoder)
        .transform(const CsvToListConverter())
        .toList();

    _headers = List<String>.from(fields.first);
    _rows = fields.skip(1).toList();

    // Convert CSV rows to ImportData objects
    List<ImportData> importDataList = [];
    for (var row in _rows) {
      ImportData importData = ImportData.fromCsvRow(row, _headers);
      importDataList.add(importData);
    }

    // Import data to Firestore
    await importData(importDataList);
    notifyListeners();
  }
}
