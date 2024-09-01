class Organization {
  final String organizationID;
  final String companyName;
  final String email;
  final String mobileNumber;
  final String name;
  final String salesCode;

  Organization({
    required this.organizationID,
    required this.companyName,
    required this.email,
    required this.mobileNumber,
    required this.name,
    required this.salesCode,
  });

  factory Organization.fromFirestore(Map<String, dynamic> data) {
    return Organization(
      organizationID: data['organizationID'] ?? '',
      companyName: _capitalizeFirstLetter(data['companyName'] ?? ''),
      email: _capitalizeFirstLetter(data['email'] ?? ''),
      mobileNumber: _capitalizeFirstLetter(data['mobileNumber'] ?? ''),
      name: _capitalizeFirstLetter(data['name'] ?? ''),
      salesCode: _capitalizeFirstLetter(data['salesCode'] ?? ''),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'organizationID': organizationID,
      'companyName': companyName,
      'email': email,
      'mobileNumber': mobileNumber,
      'name': name,
      'salesCode': salesCode,
    };
  }

  static String _capitalizeFirstLetter(String text) {
    if (text.isEmpty) return text;
    return text[0].toUpperCase() + text.substring(1).toLowerCase();
  }
}
