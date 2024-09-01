import 'package:flutter/material.dart';
import 'package:seeds_ai_callmate_web_app/models/employee_calllogs_model.dart';
import 'package:seeds_ai_callmate_web_app/services/firestore_service.dart';

class DashboardProvider with ChangeNotifier {
  FirestoreService firestoreService;
  List<EmployeeCallLogs> _callLogs = [];
  String _selectedTab = 'Outbound';
  bool _isUnique = true;

  // Map<String, int> _statusData = {};

  // Map<String, int> get statusData => _statusData;
  bool get isUnique => _isUnique;

  DashboardProvider(this.firestoreService) {
    // _initializeStatusData();
  }

  List<EmployeeCallLogs> get outboundCalls =>
      _callLogs.where((log) => log.callType == 'Outbound').toList();
  List<EmployeeCallLogs> get inboundCalls =>
      _callLogs.where((log) => log.callType == 'Inbound').toList();
  String get selectedTab => _selectedTab;

  void setUnique(bool value) {
    _isUnique = value;
    notifyListeners();
  }

  setTab(String tab) {
    _selectedTab = tab;
    notifyListeners();
  }

  // Future<void> fetchCallLogs(String agentName) async {
  //   try {
  //     List<String> agentIds = await firestoreService.fetchAgentIds();
  //     String? agentId = agentIds.firstWhere(
  //       (id) => id.contains(agentName),
  //       orElse: () => '',
  //     );

  //     if (agentId.isNotEmpty) {
  //       _callLogs = await firestoreService.fetchCallLogs(agentId);
  //       notifyListeners();
  //     }
  //   } catch (e) {
  //     // Handle error
  //   }
  // }

  Future<void> fetchCallLogs(String agentName) async {
    try {
      // Fetch agent IDs and find the relevant agent ID
      List<String> agentIds = await firestoreService.fetchAgentIds();
      String? agentId = agentIds.firstWhere(
        (id) => id.contains(agentName),
        orElse: () => '',
      );

      if (agentId.isNotEmpty) {
        // Fetch call logs for the specific agent ID
        List<EmployeeCallLogs> callLogs =
            await firestoreService.fetchCallLogs(agentId);
        _callLogs = callLogs;
        notifyListeners();
      }
    } catch (e) {
      // Handle error
      print('Error fetching call logs: $e');
    }
  }

  Duration getTotalTalkTime(List<EmployeeCallLogs> calls) {
    return calls.fold<Duration>(
      Duration.zero,
      (previous, call) => previous + call.callDurationAsDuration,
    );
  }

  Duration getAverageTalkTime(List<EmployeeCallLogs> calls) {
    if (calls.isEmpty) return Duration.zero;

    final totalDuration = calls.fold<Duration>(
      Duration.zero,
      (previous, call) => previous + call.callDurationAsDuration,
    );

    if (totalDuration.inSeconds == 0) {
      return Duration.zero;
    } else {
      return totalDuration ~/ calls.length;
    }
  }

  Duration getTotalBreakTime() {
    return getTotalTimeFromLogs((log) => log.breakDurationAsDuration);
  }

  Duration getTotalIdleTime() {
    return getTotalTimeFromLogs((log) => log.idleDurationAsDuration);
  }

  Duration getAverageLoginTime() {
    return getTotalTimeFromLogs((log) => log.loginDurationAsDuration);
  }

  Duration getTotalWrapUpTime() {
    return getTotalTimeFromLogs((log) => log.wrapUpDurationAsDuration);
  }

  Duration getTotalTimeFromLogs(
      Duration Function(EmployeeCallLogs) durationGetter) {
    return _callLogs.fold(
        Duration.zero, (total, log) => total + durationGetter(log));
  }

  // int getTotalStatusCount() {
  //   return _statusData.values.fold(0, (sum, count) => sum + count);
  // }

  // Future<void> _initializeStatusData() async {
  //   try {
  //     List<Map<String, dynamic>> categories =
  //         await firestoreService.fetchCategories();
  //     _statusData = {for (var category in categories) category['value']: 0};
  //     notifyListeners();
  //   } catch (e) {
  //     // Handle error if needed
  //     print('Error initializing status data: $e');
  //   }
  // }
}
