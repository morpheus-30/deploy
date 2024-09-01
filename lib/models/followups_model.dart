import 'package:intl/intl.dart';

class Followup {
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

  Followup({
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

  factory Followup.fromFirestore(Map<String, dynamic> data) {
    return Followup(
      address: data['address'] ?? '',
      category: data['category'] ?? '',
      company: data['company'] ?? '',
      createdOn: data['createdOn'] ?? '',
      email: data['email'] ?? '',
      name: data['name'] ?? '',
      phone: data['phone'] ?? '',
      status: data['status'] ?? {},
      agent: data['agent'] ?? '',
      nextFollowUp: data['nextFollowUp'] != null
          ? DateTime.parse(data['nextFollowUp'])
          : null,
      tags: data['tags'] is Iterable ? List<String>.from(data['tags']) : [],
      assignTo: data['assignTo'] ?? '',
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
