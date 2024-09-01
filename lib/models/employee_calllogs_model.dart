// import 'package:intl/intl.dart';

// class EmployeeCallLogs {
//   final String name;
//   final String phoneNumber;
//   final DateTime callDate;
//   final int callDuration; // Duration in seconds
//   final int breakDuration; // Break time in seconds
//   final int idleDuration; // Idle time in seconds
//   final int loginDuration; // Login time in seconds
//   final int wrapUpDuration; // Wrap-up time in seconds
//   final String callType;
//   final String recordingURL;

//   EmployeeCallLogs({
//     required this.name,
//     required this.phoneNumber,
//     required this.callDate,
//     required this.callDuration,
//     required this.breakDuration,
//     required this.idleDuration,
//     required this.loginDuration,
//     required this.wrapUpDuration,
//     required this.callType,
//     required this.recordingURL,
//   });

//   factory EmployeeCallLogs.fromFirestore(Map<String, dynamic> data) {
//     DateTime parsedDate;
//     try {
//       parsedDate =
//           DateFormat('yyyy-MM-dd HH:mm:ss').parse(data['callDate'] ?? '');
//     } catch (e) {
//       parsedDate = DateTime.now(); // Default to current date if parsing fails
//       print(
//           'Error parsing date: $e - Original date string: ${data['callDate']}');
//     }

//     return EmployeeCallLogs(
//       name: data['name'] ?? 'Unknown',
//       phoneNumber: data['phoneNumber']?.toString() ?? '',
//       callDate: parsedDate,
//       callDuration: data['callDuration'] ?? 0,
//       breakDuration: data['breakDuration'] ?? 0,
//       idleDuration: data['idleDuration'] ?? 0,
//       loginDuration: data['loginDuration'] ?? 0,
//       wrapUpDuration: data['wrapUpDuration'] ?? 0,
//       callType: _processCallType(data['callType']?.toString() ?? ''),
//       recordingURL: data['recordingURL']?.toString() ?? '',
//     );
//   }

//   Map<String, dynamic> toFirestore() {
//     return {
//       'name': name,
//       'phoneNumber': phoneNumber,
//       'callDate': DateFormat('yyyy-MM-dd HH:mm:ss').format(callDate),
//       'callDuration': callDuration,
//       'breakDuration': breakDuration,
//       'idleDuration': idleDuration,
//       'loginDuration': loginDuration,
//       'wrapUpDuration': wrapUpDuration,
//       'callType': callType,
//       'recordingURL': recordingURL,
//     };
//   }

//   static String _getStringFromMap(Map<String, dynamic> map, String key) {
//     final value = map[key];
//     if (value is String) {
//       return _capitalizeFirstLetter(value);
//     }
//     return ''; // Return empty string if the value is not a string
//   }

//   static String _capitalizeFirstLetter(String text) {
//     if (text.isEmpty) return text;
//     return text[0].toUpperCase() + text.substring(1).toLowerCase();
//   }

//   static String _processCallType(String rawCallType) {
//     if (rawCallType.startsWith('CallType.')) {
//       return rawCallType.substring('CallType.'.length);
//     }
//     return rawCallType;
//   }

//   String getFormattedDuration() {
//     if (callDuration <= 0) {
//       return '0';
//     }

//     Duration duration = Duration(seconds: callDuration);

//     String formattedDuration = '';

//     if (duration.inHours > 0) {
//       formattedDuration += '${duration.inHours}H ';
//     }

//     if (duration.inMinutes.remainder(60) > 0) {
//       formattedDuration += '${duration.inMinutes.remainder(60)}m ';
//     }

//     if (duration.inSeconds.remainder(60) > 0) {
//       formattedDuration += '${duration.inSeconds.remainder(60)}s';
//     }

//     return formattedDuration.trim();
//   }

//   Duration get callDurationAsDuration => Duration(seconds: callDuration);
//   Duration get breakDurationAsDuration => Duration(seconds: breakDuration);
//   Duration get idleDurationAsDuration => Duration(seconds: idleDuration);
//   Duration get loginDurationAsDuration => Duration(seconds: loginDuration);
//   Duration get wrapUpDurationAsDuration => Duration(seconds: wrapUpDuration);

//   DateTime get callDateTime => callDate;
// }

import 'package:intl/intl.dart';

class EmployeeCallLogs {
  final String name;
  final String phoneNumber;
  final DateTime callDate;
  final int callDuration; // Duration in seconds
  final int breakDuration; // Break time in seconds
  final int idleDuration; // Idle time in seconds
  final int loginDuration; // Login time in seconds
  final int wrapUpDuration; // Wrap-up time in seconds
  final String callType;
  final String recordingURL;

  EmployeeCallLogs({
    required this.name,
    required this.phoneNumber,
    required this.callDate,
    required this.callDuration,
    required this.breakDuration,
    required this.idleDuration,
    required this.loginDuration,
    required this.wrapUpDuration,
    required this.callType,
    required this.recordingURL,
  });

  factory EmployeeCallLogs.fromFirestore(Map<String, dynamic> data) {
    DateTime parsedDate;
    try {
      parsedDate =
          DateFormat('yyyy-MM-dd HH:mm:ss').parse(data['callDate'] ?? '');
    } catch (e) {
      parsedDate = DateTime.now(); // Default to current date if parsing fails
      print(
          'Error parsing date: $e - Original date string: ${data['callDate']}');
    }

    return EmployeeCallLogs(
      name: data['name'] ?? 'Unknown',
      phoneNumber: data['phoneNumber']?.toString() ?? '',
      callDate: parsedDate,
      callDuration: data['callDuration'] ?? 0,
      breakDuration: data['breakDuration'] ?? 0,
      idleDuration: data['idleDuration'] ?? 0,
      loginDuration: data['loginDuration'] ?? 0,
      wrapUpDuration: data['wrapUpDuration'] ?? 0,
      callType: _processCallType(data['callType']?.toString() ?? ''),
      recordingURL: data['recordingURL']?.toString() ?? '',
    );
  }

  Map<String, dynamic> toFirestore() {
    return {
      'name': name,
      'phoneNumber': phoneNumber,
      'callDate': DateFormat('yyyy-MM-dd HH:mm:ss').format(callDate),
      'callDuration': callDuration,
      'breakDuration': breakDuration,
      'idleDuration': idleDuration,
      'loginDuration': loginDuration,
      'wrapUpDuration': wrapUpDuration,
      'callType': callType,
      'recordingURL': recordingURL,
    };
  }

  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'phoneNumber': phoneNumber,
      'callDate': callDate.toString(),
      'callDuration': callDuration,
      'breakDuration': breakDuration,
      'idleDuration': idleDuration,
      'loginDuration': loginDuration,
      'wrapUpDuration': wrapUpDuration,
      'callType': callType,
      'recordingURL': recordingURL,
    };
  }

  static EmployeeCallLogs fromJson(Map<String, dynamic> json) {
    return EmployeeCallLogs(
      name: json['name'],
      phoneNumber: json['phoneNumber'],
      callDate: DateTime.parse(json['callDate']),
      callDuration: json['callDuration'],
      breakDuration: json['breakDuration'],
      idleDuration: json['idleDuration'],
      loginDuration: json['loginDuration'],
      wrapUpDuration: json['wrapUpDuration'],
      callType: json['callType'],
      recordingURL: json['recordingURL'],
    );
  }

  static String _processCallType(String rawCallType) {
    if (rawCallType.startsWith('CallType.')) {
      return rawCallType.substring('CallType.'.length);
    }
    return rawCallType;
  }

  String getFormattedDuration() {
    if (callDuration <= 0) {
      return '0';
    }

    Duration duration = Duration(seconds: callDuration);

    String formattedDuration = '';

    if (duration.inHours > 0) {
      formattedDuration += '${duration.inHours}H ';
    }

    if (duration.inMinutes.remainder(60) > 0) {
      formattedDuration += '${duration.inMinutes.remainder(60)}m ';
    }

    if (duration.inSeconds.remainder(60) > 0) {
      formattedDuration += '${duration.inSeconds.remainder(60)}s';
    }

    return formattedDuration.trim();
  }

  Duration get callDurationAsDuration => Duration(seconds: callDuration);
  Duration get breakDurationAsDuration => Duration(seconds: breakDuration);
  Duration get idleDurationAsDuration => Duration(seconds: idleDuration);
  Duration get loginDurationAsDuration => Duration(seconds: loginDuration);
  Duration get wrapUpDurationAsDuration => Duration(seconds: wrapUpDuration);

  DateTime get callDateTime => callDate;
}
