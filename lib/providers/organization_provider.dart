import 'package:flutter/material.dart';
import 'package:seeds_ai_callmate_web_app/models/organization_model.dart';
import 'package:seeds_ai_callmate_web_app/services/firestore_service.dart';

// class OrganizationProvider with ChangeNotifier {
//   final FirestoreService _firestoreService = FirestoreService();
//   Organization? _organization;

//   Organization? get organization => _organization;

//   Future<void> fetchOrganization(String organizationID) async {
//     _organization = await _firestoreService.getOrganization(organizationID);
//     notifyListeners();
//   }
// }

class OrganizationProvider with ChangeNotifier {
  final FirestoreService _firestoreService;
  Organization? _organization;

  OrganizationProvider(this._firestoreService);

  Organization? get organization => _organization;

  Future<void> fetchOrganization(String organizationID) async {
    try {
      _organization = await _firestoreService.getOrganization(organizationID);
      print('Fetched organization: ${_organization?.companyName}');
      notifyListeners();
    } catch (e) {
      print("Error fetching organization: $e");
    }
  }
}
