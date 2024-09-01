import 'package:intl/intl.dart';

// class Customer {
//   final String id;
//   final String address;
//   final String category;
//   final String company;
//   final String createdOn;
//   final String email;
//   final String name;
//   final String phone;
//   final dynamic
//       status; // Ensure this is handled correctly based on its expected type
//   final String assignTo;
//   final String agent;
//   final DateTime? nextFollowUp;
//   final List<String> tags;
//   final String option;
//   final String date;
//   final String text;

//   Customer({
//     required this.id,
//     required this.address,
//     required this.category,
//     required this.company,
//     required this.createdOn,
//     required this.email,
//     required this.name,
//     required this.phone,
//     required this.status,
//     required this.assignTo,
//     required this.agent,
//     required this.nextFollowUp,
//     required this.tags,
//     required this.option,
//     required this.date,
//     required this.text,
//   });

//   factory Customer.fromFirestore(Map<String, dynamic> data, String id) {
//     return Customer(
//       id: id,
//       address: _getStringFromMap(data, 'address'),
//       category: _getStringFromMap(data, 'category'),
//       company: _getStringFromMap(data, 'company'),
//       createdOn: _getStringFromMap(data, 'createdOn'),
//       email: _getStringFromMap(data, 'email'),
//       name: _getStringFromMap(data, 'name'),
//       phone: _getStringFromMap(data, 'phone'),
//       status: data['status'] ??
//           '', // Ensure this is handled correctly based on its type
//       agent: _getStringFromMap(data, 'agent'),
//       nextFollowUp: data['nextFollowUp'] != null
//           ? DateTime.tryParse(
//               data['nextFollowUp']) // Use tryParse for safe parsing
//           : null,
//       tags: data['tags'] is Iterable ? List<String>.from(data['tags']) : [],
//       assignTo: _getStringFromMap(data, 'assignTo'),
//       option: _getStringFromMap(data, 'option'),
//       date: _getStringFromMap(data, 'date'),
//       text: _getStringFromMap(data, 'text'),
//     );
//   }

//   Map<String, dynamic> toFirestore() {
//     return {
//       'address': address,
//       'category': category,
//       'company': company,
//       'createdOn': createdOn,
//       'email': email,
//       'name': name,
//       'phone': phone,
//       'status': status,
//       'assignTo': assignTo,
//       'agent': agent,
//       'nextFollowUp': nextFollowUp?.toIso8601String(),
//       'tags': tags,
//       'option': option,
//       'date': date,
//       'text': text,
//     };
//   }

//   String _getFormattedDateTime() {
//     final now = DateTime.now();
//     final timeFormatter = DateFormat('hh:mm a');
//     final dateFormatter = DateFormat('d MMM yyyy, EEEE');

//     final time = timeFormatter.format(now);
//     final date = dateFormatter.format(now);

//     return '$time, $date';
//   }

//   static String _capitalizeFirstLetter(String text) {
//     if (text.isEmpty) return text;
//     return text[0].toUpperCase() + text.substring(1).toLowerCase();
//   }

//   static String _getStringFromMap(Map<String, dynamic> map, String key) {
//     final value = map[key];
//     if (value is String) {
//       return _capitalizeFirstLetter(value);
//     } else if (value is Map) {
//       return ''; // Handle Map type according to your needs
//     }
//     return '';
//   }
// }

class Customer {
  final String id;
  final String address;
  final String category;
  final String company;
  final String createdOn; // Changed to DateTime for consistency
  final String email;
  final String name;
  final String phone;
  final dynamic status; // Keep as dynamic but handle its type carefully
  final String assignTo;
  final String agent;
  final DateTime? nextFollowUp;
  final List<String> tags;
  final Map<String, dynamic>
      extraFields; // Changed to Map to handle dynamic fields
  final DateTime? date; // Changed to DateTime for consistency
  final String text;

  Customer({
    required this.id,
    required this.address,
    required this.category,
    required this.company,
    required this.createdOn,
    required this.email,
    required this.name,
    required this.phone,
    required this.status,
    required this.assignTo,
    required this.agent,
    required this.nextFollowUp,
    required this.tags,
    required this.extraFields,
    required this.date,
    required this.text,
  });

  factory Customer.fromFirestore(Map<String, dynamic> data, String id) {
    return Customer(
      id: id,
      address: _getStringFromMap(data, 'address'),
      category: _getStringFromMap(data, 'category'),
      company: _getStringFromMap(data, 'company'),
      createdOn: _getStringFromMap(data, 'createdOn'),
      email: _getStringFromMap(data, 'email'),
      name: _getStringFromMap(data, 'name'),
      phone: _getStringFromMap(data, 'phone'),
      status: _getStatusFromMap(data, 'status'),
      agent: _getStringFromMap(data, 'agent'),
      nextFollowUp: data['nextFollowUp'] != null
          ? DateTime.tryParse(data['nextFollowUp'])
          : null,
      tags: data['tags'] is Iterable ? List<String>.from(data['tags']) : [],
      assignTo: _getStringFromMap(data, 'assignTo'),
      extraFields: _getExtraFieldsFromMap(data, 'extraFields'),
      date: data['date'] != null ? DateTime.tryParse(data['date']) : null,
      text: _getStringFromMap(data, 'text'),
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
      'extraFields': extraFields,
      'date': date?.toIso8601String(),
      'text': text,
    };
  }

  static String _capitalizeFirstLetter(String text) {
    if (text.isEmpty) return text;
    return text[0].toUpperCase() + text.substring(1).toLowerCase();
  }

  static String _getStringFromMap(Map<String, dynamic> map, String key) {
    final value = map[key];
    if (value is String) {
      return _capitalizeFirstLetter(value);
    }
    return ''; // Return empty string if the value is not a string
  }

  static DateTime _getDateTimeFromMap(Map<String, dynamic> map, String key) {
    final value = map[key];
    if (value is String) {
      return DateTime.tryParse(value) ??
          DateTime.now(); // Provide a default value if parsing fails
    }
    return DateTime
        .now(); // Provide a default value if the value is not a string
  }

  static Map<String, dynamic> _getExtraFieldsFromMap(
      Map<String, dynamic> map, String key) {
    final value = map[key];
    if (value is Map) {
      return Map<String, dynamic>.from(value); // Ensure it's a Map
    }
    return {}; // Return an empty map if the value is not a map
  }

  static dynamic _getStatusFromMap(Map<String, dynamic> map, String key) {
    final value = map[key];
    if (value is Map) {
      return Map<String, dynamic>.from(value); // Ensure it's a Map
    }
    return {}; // Return an empty map if the value is not a map
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

///////////////////////////////////////////////////////////

class Customeradd {
  final String phone;
  // final String assignedto;
  final String category;
  final String notes;
  final String name;
  final String email;
  final String company;
  final String address;
  final Map<String, dynamic> status;
  final Map<String, dynamic> extraInfo;
  final List<String> tags;
  final DateTime createdOn;

  Customeradd({
    required this.phone,
    // required this.assignedto,
    required this.category,
    required this.notes,
    required this.name,
    required this.email,
    required this.company,
    required this.address,
    required this.status,
    required this.extraInfo,
    required this.tags,
    required this.createdOn,
  });

  Map<String, dynamic> toMap() {
    return {
      'phone': phone,
      // 'assignedto': assignedto,
      'category': category,
      'notes': notes,
      'name': name,
      'email': email,
      'company': company,
      'address': address,
      'status': Map<String, dynamic>.from(status),
      // 'status': status,
      'extraInfo': Map<String, dynamic>.from(extraInfo),

      'tags': tags,
      'createdOn': DateTime.now().toString(),
    };
  }

  // Function to get a formatted date-time string (if needed for display)
  String getFormattedCreatedOn() {
    final timeFormatter = DateFormat('hh:mm a');
    final dateFormatter = DateFormat('d MMM yyyy, EEEE');

    final time = timeFormatter.format(createdOn);
    final date = dateFormatter.format(createdOn);

    return '$time, $date';
  }
}
