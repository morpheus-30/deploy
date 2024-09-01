// class CustomerHistory {
//   final String date;
//   final String notes;
//   final String status;
//   final Map<String, dynamic> extraFields;

//   CustomerHistory({
//     required this.date,
//     required this.notes,
//     required this.status,
//     required this.extraFields,
//   });

//   factory CustomerHistory.fromFirestore(Map<String, dynamic> data) {
//     return CustomerHistory(
//       date: data['date'] ?? '',
//       notes: data['notes'] ?? '',
//       status: data['status'] ?? '',
//       extraFields: data['extraFields'] ?? {},
//     );
//   }
// }

// class CustomerHistory {
//   final String action;
//   final DateTime date;
//   final String notes;
//   final Map<String, dynamic>? extraFields;

//   CustomerHistory({
//     required this.action,
//     required this.date,
//     required this.notes,
//     this.extraFields,
//   });

//   // Convert to Map for Firestore or any database
//   Map<String, dynamic> toMap() {
//     return {
//       'action': action,
//       'date': date.toIso8601String(),
//       'notes': notes,
//       'extraFields': extraFields,
//     };
//   }

//   // Create a CustomerHistory object from a Map (e.g., from Firestore)
//   factory CustomerHistory.fromMap(Map<String, dynamic> map) {
//     return CustomerHistory(
//       action: map['action'] ?? '',
//       date: DateTime.parse(map['date']),
//       notes: map['notes'] ?? '',
//       extraFields: Map<String, dynamic>.from(map['extraFields'] ?? {}),
//     );
//   }
// }

// class CustomerHistory {
//   final String action;
//   final DateTime date;
//   final String notes;
//   final Map<String, dynamic>? extraFields;

//   CustomerHistory({
//     required this.action,
//     required this.date,
//     required this.notes,
//     this.extraFields,
//   });

//   // Convert to Map for Firestore or any database
//   Map<String, dynamic> toMap() {
//     return {
//       'action': action,
//       'date': date.toIso8601String(),
//       'notes': notes,
//       'extraFields': extraFields ?? {}, // Default to empty map if null
//     };
//   }

//   // Create a CustomerHistory object from a Map (e.g., from Firestore)
//   factory CustomerHistory.fromMap(Map<String, dynamic> map) {
//     return CustomerHistory(
//       action: map['action'] ?? '',
//       date: map['date'] != null ? DateTime.parse(map['date']) : DateTime.now(),
//       notes: map['notes'] ?? '',
//       extraFields: map['extraFields'] != null
//           ? Map<String, dynamic>.from(map['extraFields'])
//           : {},
//     );
//   }

//   @override
//   bool operator ==(Object other) {
//     if (identical(this, other)) return true;
//     if (runtimeType != other.runtimeType) return false;
//     return other is CustomerHistory &&
//         action == other.action &&
//         date == other.date &&
//         notes == other.notes &&
//         extraFields == other.extraFields;
//   }

//   @override
//   int get hashCode =>
//       action.hashCode ^
//       date.hashCode ^
//       notes.hashCode ^
//       (extraFields?.hashCode ?? 0);
// }

class CustomerHistories {
  final String action;
  final DateTime date;
  final String notes;
  final Map<String, dynamic>? extraFields;

  CustomerHistories({
    required this.action,
    required this.date,
    required this.notes,
    this.extraFields,
  });

  Map<String, dynamic> toMap() {
    return {
      'action': action,
      'date': date.toIso8601String(),
      'notes': notes,
      'extraFields': extraFields,
    };
  }

  factory CustomerHistories.fromMap(Map<String, dynamic> map) {
    return CustomerHistories(
      action: map['action'] ?? '', // Default to empty string if null
      date: map['date'] != null
          ? DateTime.parse(map['date'])
          : DateTime.now(), // Default to current date if null
      notes: map['notes'] ?? '', // Default to empty string if null
      extraFields: map['extraFields'] != null
          ? Map<String, dynamic>.from(map['extraFields'])
          : null, // Handle extraFields as null if not present
    );
  }
}
