import 'package:intl/intl.dart';

class Allocation {
  final String address;
  final String category;
  final String company;
  final String createdOn;
  final String email;
  final String name;
  final String phone;
  final Map<String, dynamic> status;
  final String agent;
  final String assignTo;
  final DateTime? nextFollowUp;
  final List<String> tags;

  Allocation({
    required this.address,
    required this.category,
    required this.company,
    required this.createdOn,
    required this.email,
    required this.name,
    required this.phone,
    required this.status,
    required this.agent,
    required this.assignTo,
    required this.nextFollowUp,
    required this.tags,
  });

  factory Allocation.fromFirestore(Map<String, dynamic> data) {
    return Allocation(
      address: _capitalizeFirstLetter(data['address'] ?? ''),
      category: _capitalizeFirstLetter(data['category'] ?? ''),
      company: _capitalizeFirstLetter(data['company'] ?? ''),
      createdOn: _capitalizeFirstLetter(data['createdOn'] ?? ''),
      email: _capitalizeFirstLetter(data['email'] ?? ''),
      name: _capitalizeFirstLetter(data['name'] ?? ''),
      phone: _capitalizeFirstLetter(data['phone'] ?? ''),
      status: data['status'] ?? {},
      agent: _capitalizeFirstLetter(data['agent'] ?? ''),
      nextFollowUp: data['nextFollowUp'] != null
          ? DateTime.parse(data['nextFollowUp'])
          : null,
      tags: data['tags'] is Iterable ? List<String>.from(data['tags']) : [],
      assignTo: _capitalizeFirstLetter(data['assignTo'] ?? ''),
    );
  }

  Map<String, dynamic> toFirestore() {
    return {
      'address': address,
      'category': category,
      'company': company,
      'createdOn': createdOn,
      'email': email,
      'name': name,
      'phone': phone,
      'status': status,
      'assignTo': assignTo,
      'agent': agent,
      'nextFollowUp': nextFollowUp?.toIso8601String(),
      'tags': tags,
    };
  }

  static String _capitalizeFirstLetter(String text) {
    if (text.isEmpty) return text;
    return text[0].toUpperCase() + text.substring(1).toLowerCase();
  }
}

String formatCreatedOn(String createdOn) {
  // Replace lowercase 't' with uppercase 'T'
  createdOn = createdOn.replaceFirst('t', 'T');
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
