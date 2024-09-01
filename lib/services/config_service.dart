import 'package:shared_preferences/shared_preferences.dart';

class ConfigService {
  static const String _organizationIdKey = 'ABC-1234-999';
  // static const String _organizationIdKey = 'currentOrganizationId';
  late SharedPreferences _prefs;

  // Private constructor
  ConfigService._();

  // Singleton instance
  static final ConfigService _instance = ConfigService._();

  // Factory constructor to return the same instance every time
  factory ConfigService() => _instance;

  // Initialize the service
  Future<void> init() async {
    _prefs = await SharedPreferences.getInstance();
  }

  // Getter for the current organization ID
  String? get currentOrganizationId => _prefs.getString(_organizationIdKey);

  // Setter for the current organization ID
  Future<void> setCurrentOrganizationId(String id) async {
    await _prefs.setString(_organizationIdKey, id);
  }

  // Clear the current organization ID
  Future<void> clearCurrentOrganizationId() async {
    await _prefs.remove(_organizationIdKey);
  }
}
