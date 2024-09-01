import 'package:intl/intl.dart';

class ImportData {
  final String name;
  final String phone;
  final String email;
  final String address;
  final String category;
  final String company;

  // final Map<String, String> status;
  final String notes;
  final List<String> tags;
  final String createdOn;

  ImportData({
    required this.name,
    required this.phone,
    required this.email,
    required this.address,
    required this.category,
    required this.company,
    // required this.status,
    required this.notes,
    required this.tags,
    required this.createdOn,
  });

  // Convert ImportData to a Map for Firestore
  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'phone': phone,
      'email': email,
      'address': address,
      'category': category,
      'company': company,
      // 'status': Map<String, dynamic>.from(status),
      'notes': notes,
      'tags': tags,
      'createdOn': DateTime.now().toIso8601String(),
    };
  }

  // Create ImportData from a map
  factory ImportData.fromMap(Map<String, dynamic> map) {
    return ImportData(
      name: map['name'] ?? '',
      phone: map['phone'] ?? '',
      email: map['email'] ?? '',
      address: map['address'] ?? '',
      category: map['category'] ?? '',
      company: map['company'] ?? '',
      // status: Map<String, String>.from(map['status'] ?? {}),
      notes: map['notes'] ?? '',
      tags: List<String>.from(map['tags'] ?? []),
      createdOn: map['createdOn'] ?? '',
    );
  }

  // Create ImportData from a CSV row
  factory ImportData.fromCsvRow(List<dynamic> row, List<String> headers) {
    Map<String, int> headerIndex = {
      for (int i = 0; i < headers.length; i++) headers[i]: i,
    };

    return ImportData(
      name: row[headerIndex['Name'] ?? -1]?.toString() ?? '',
      phone: row[headerIndex['Phone'] ?? -1]?.toString() ?? '',
      email: row[headerIndex['Email'] ?? -1]?.toString() ?? '',
      address: row[headerIndex['Address'] ?? -1]?.toString() ?? '',
      category: row[headerIndex['Category'] ?? -1]?.toString() ?? '',
      company: row[headerIndex['Company'] ?? -1]?.toString() ?? '',
      // status: _parseStatus(row[headerIndex['Status'] ?? -1]?.toString() ?? ''),
      notes: row[headerIndex['Notes'] ?? -1]?.toString() ?? '',
      tags: _parseTags(row[headerIndex['Tags'] ?? -1]?.toString() ?? ''),
      createdOn: row[headerIndex['CreatedOn'] ?? -1]?.toString() ?? '',
    );
  }

  // Helper method to parse status from a string
  static Map<String, String> _parseStatus(String statusString) {
    Map<String, String> statusMap = {};
    if (statusString.isNotEmpty) {
      statusString.split(';').forEach((pair) {
        List<String> keyValue = pair.split(':');
        if (keyValue.length == 2) {
          statusMap[keyValue[0].trim()] = keyValue[1].trim();
        }
      });
    }
    return statusMap;
  }

  // Helper method to parse tags from a string
  static List<String> _parseTags(String tagsString) {
    return tagsString.isNotEmpty
        ? tagsString.split(',').map((tag) => tag.trim()).toList()
        : [];
  }

  // Get formatted current date and time
  // static String getFormattedDateTime() {
  //   final now = DateTime.now();
  //   final timeFormatter = DateFormat('hh:mm a');
  //   final dateFormatter = DateFormat('d MMM yyyy, EEEE');

  //   final time = timeFormatter.format(now);
  //   final date = dateFormatter.format(now);

  //   return '$time, $date';
  // }
}
