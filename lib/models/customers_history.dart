// class History {
//   final String action;
//   final String date;
//   final Map<String, dynamic> extraFields;
//   // final String field1;
//   // final String field2;
//   final String notes;

//   History({
//     required this.action,
//     required this.date,
//     required this.extraFields,
//     // required this.field1,
//     // required this.field2,
//     required this.notes,
//   });

//   factory History.fromFirestore(Map<String, dynamic> data) {
//     return History(
//       action: data['action'],
//       date: data['date'],
//       extraFields: data['extraFields'],
//       // field1: data['field1'],
//       // field2: data['field2'],
//       notes: data['notes'],
//     );
//   }

//   Map<String, dynamic> toFirestore() {
//     return {
//       'action': action,
//       'date': date,
//       'extraFields': extraFields,
//       // 'field1': field1,
//       // 'field2': field2,
//       'notes': notes,
//     };
//   }
// }
