import 'package:intl/intl.dart';

class EmployeeDetails {
  final String name;
  final String phone;
  final String lastSyncTime;
  final String organisation;

  EmployeeDetails({
    required this.name,
    required this.phone,
    required this.lastSyncTime,
    required this.organisation,
  });

  factory EmployeeDetails.fromFirestore(Map<String, dynamic> data) {
    return EmployeeDetails(
      name: data['name'] ?? '',
      phone: data['phone'] ?? 'Unknown',
      lastSyncTime: data['lastSyncTime'] ?? '',
      organisation: data['organisation'] ?? '',
    );
  }

  Map<String, dynamic> toFirestore() {
    return {
      'name': name,
      'phone': phone,
      'lastSyncTime': lastSyncTime,
      'organisation': organisation,
    };
  }
}

String formatCreatedOn(String createdOn) {
  DateTime createdOnDate = DateTime.parse(createdOn);
  DateTime now = DateTime.now();
  String formattedTime = DateFormat('hh:mma').format(createdOnDate);
  String formattedDate;

  if (createdOnDate.year == now.year &&
      createdOnDate.month == now.month &&
      createdOnDate.day == now.day) {
    formattedDate = 'Today';
  } else if (createdOnDate.year == now.year &&
      createdOnDate.month == now.month &&
      createdOnDate.day == now.subtract(Duration(days: 1)).day) {
    formattedDate = 'Yesterday';
  } else {
    formattedDate = DateFormat('MMM dd').format(createdOnDate);
  }

  return ' $formattedTime,$formattedDate';
}
