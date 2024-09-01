import 'dart:convert';

class CRMField {
  final String name;
  final String type;
  final String field;
  final List<String>? options;

  CRMField({
    required this.name,
    required this.type,
    required this.field,
    this.options,
  });

  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'type': type,
      'field': field,
      if (options != null && options!.isNotEmpty) 'options': options,
    };
  }

  factory CRMField.fromMap(Map<String, dynamic> map) {
    List<String>? parsedOptions;
    if (map['options'] != null) {
      if (map['options'] is List) {
        parsedOptions =
            (map['options'] as List).map((e) => e.toString()).toList();
      } else if (map['options'] is String) {
        try {
          parsedOptions = (jsonDecode(map['options']) as List)
              .map((e) => e.toString())
              .toList();
        } catch (e) {
          print('Error decoding options: $e');
          parsedOptions = null;
        }
      }
    }

    return CRMField(
      name: map['name'] ?? '',
      type: map['type'] ?? '',
      field: map['field'] ?? '',
      options: parsedOptions,
    );
  }
}
