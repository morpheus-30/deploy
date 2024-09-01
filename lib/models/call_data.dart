// class CallLog {
//   final String date;
//   final int inboundCalls;
//   final int outboundCalls;

//   CallLog({
//     required this.date,
//     required this.inboundCalls,
//     required this.outboundCalls,
//   });

//   factory CallLog.fromFirestore(Map<String, dynamic> data) {
//     return CallLog(
//       date: data['date'] as String,
//       inboundCalls: data['inboundCalls'] as int,
//       outboundCalls: data['outboundCalls'] as int,
//     );
//   }
// }

import 'package:cloud_firestore/cloud_firestore.dart';

class CallLog {
  final DateTime callDate;
  final String callType;

  CallLog({required this.callDate, required this.callType});

  factory CallLog.fromFirestore(Map<String, dynamic> json) {
    return CallLog(
      callDate: (json['callDate'] as Timestamp).toDate(),
      callType: json['callType'],
    );
  }

  factory CallLog.fromJson(Map<String, dynamic> json) {
    return CallLog(
      callDate: DateTime.parse(json['callDate']),
      callType: json['callType'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'callDate': callDate.toIso8601String(),
      'callType': callType,
    };
  }
}

// class CallLog {
//   final DateTime callDate;
//   final String callType;

//   CallLog({required this.callDate, required this.callType});

// factory CallLog.fromJson(Map<String, dynamic> json) {
//   return CallLog(
//     callDate: DateTime.parse(json['callDate']),
//     callType: json['callType'],
//   );
// }

//   Map<String, dynamic> toJson() {
//     return {
//       'callDate': callDate.toIso8601String(),
//       'callType': callType,
//     };
//   }
// }

class CallData {
  final Duration talkTime;

  final Duration breakTime;
  final Duration idleTime;
  final Duration wrapUpTime;
  final Duration loginTime;

  CallData({
    required this.talkTime,
    required this.breakTime,
    required this.idleTime,
    required this.wrapUpTime,
    required this.loginTime,
  });
}
