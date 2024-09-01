import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:seeds_ai_callmate_web_app/models/call_data.dart';
import 'package:seeds_ai_callmate_web_app/models/employee_calllogs_model.dart';
import 'package:seeds_ai_callmate_web_app/services/firestore_service.dart';
import 'package:shared_preferences/shared_preferences.dart';

class CallLogsProvider with ChangeNotifier {
  final FirestoreService firestoreService;
  String _selectedTab = 'Outbound';
  List<EmployeeCallLogs> _callLogs = [];

  final List<EmployeeCallLogs> _filteredCallLogs = [];
  final List<EmployeeCallLogs> _missedCallLogs = [];
  Map<String, String> _agents = {};
  int missedCallCount = 0;
  bool _isLoading = false;
  String? _errorMessage;
  String? _selectedAgent;
  String? _selectedEmployeeId;
  DateTimeRange? _selectedDateRange;

  CallLogsProvider(this.firestoreService);

  String get selectedTab => _selectedTab;
  String? get selectedEmployeeId => _selectedEmployeeId;
  String? get selectedAgent => _selectedAgent;
  DateTimeRange? get selectedDateRange => _selectedDateRange;
  List<EmployeeCallLogs> get callLogs => _callLogs;
  List<EmployeeCallLogs> get missedCallLogs => _missedCallLogs;
  List<EmployeeCallLogs> get filteredCallLogs => _filteredCallLogs;
  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;
  Map<String, String> get agents => _agents;

  final Map<DateTime, Map<String, int>> _callCounts = {};
  Map<DateTime, Map<String, int>> get callCounts => _callCounts;

  final bool _loading = true;
  bool get loading => _loading;

  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  final Map<String, int> _incomingCalls = {};
  final Map<String, int> _outgoingCalls = {};
  // String _selectedTab = 'Inbound'; // Default tab

  // String get selectedTab => _selectedTab;

  void setTab(String tab) {
    _selectedTab = tab;
    notifyListeners();
  }

// Import this for DateFormat if necessary

  Future<void> fetchCallLog() async {
    _incomingCalls.clear();
    _outgoingCalls.clear();

    try {
      final querySnapshot = await _firestore.collectionGroup('callLogs').get();

      for (var doc in querySnapshot.docs) {
        final data = doc.data();
        String callDateString = data['callDate']; // Assume this is a string

        // Parse the string to DateTime
        DateTime callDate = DateTime.parse(callDateString);
        final formattedDate = DateFormat('yyyy-MM-dd').format(callDate);
        final callType = data['callType'];

        if (callType == 'CallType.incoming') {
          _incomingCalls[formattedDate] =
              (_incomingCalls[formattedDate] ?? 0) + 1;
        } else if (callType == 'CallType.outgoing') {
          _outgoingCalls[formattedDate] =
              (_outgoingCalls[formattedDate] ?? 0) + 1;
        }
      }

      notifyListeners();
    } catch (e) {
      print('Error fetching call logs: $e');
    }
  }

  Map<String, int> getDailyCallCounts(String callType) {
    return callType == 'CallType.incoming' ? _incomingCalls : _outgoingCalls;
  }

  List<EmployeeCallLogs> get filteredCallLog {
    final callType =
        _selectedTab == 'Outbound' ? 'CallType.outgoing' : 'CallType.incoming';

    return _callLogs.where((log) => log.callType == callType).toList();
  }

  // void setTab(String tab) {
  //   _selectedTab = tab;
  //   print('Selected tab changed to: $tab');
  //   notifyListeners();
  // }

  void setCallLogs(List<EmployeeCallLogs> logs) {
    _callLogs = logs;
    notifyListeners();
  }

  void setDateRange(DateTimeRange? dateRange) {
    _selectedDateRange = dateRange;
    _fetchCallLogs();
  }

  void setSelectedEmployee(String? employeeId) {
    _selectedEmployeeId = employeeId;
    _fetchCallLogs();
  }

  Future<void> _fetchCallLogs() async {
    print('Fetching call logs...');
    Query query = FirebaseFirestore.instance.collectionGroup('callLogs');

    if (_selectedDateRange != null) {
      query = query
          .where('callDate', isGreaterThanOrEqualTo: _selectedDateRange!.start)
          .where('callDate', isLessThanOrEqualTo: _selectedDateRange!.end);
    }

    if (_selectedEmployeeId != null) {
      query = query.where('employeeId', isEqualTo: _selectedEmployeeId);
    }

    try {
      print('Executing Firestore query...');
      final snapshot = await query.get();
      print('Query executed, processing documents...');

      _callLogs = snapshot.docs
          .map((doc) {
            final data = doc.data();
            if (data is Map<String, dynamic>) {
              return EmployeeCallLogs.fromFirestore(data);
            } else {
              print('Unexpected data format: $data');
              return null;
            }
          })
          .whereType<EmployeeCallLogs>()
          .toList();

////////////////////
      // _filteredCallLogs = _callLogs.where((log) {
      //   final callType = _selectedTab == 'Outbound'
      //       ? 'CallType.outgoing'
      //       : 'CallType.incoming';
      //   return log.callType == callType;
      // }).toList();
////////////////////////
      print('Fetched and processed ${_callLogs.length} call logs.');
      notifyListeners();
    } catch (e) {
      print('Error fetching call logs: $e');
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> fetchCallLogsForAllAgents() async {
    try {
      List<String> agentIds = await firestoreService.fetchAllAgentIds();
      List<EmployeeCallLogs> allCallLogs = [];

      for (String agentId in agentIds) {
        final agentCallLogs = await firestoreService.fetchCallLogs(agentId);
        allCallLogs.addAll(agentCallLogs);
      }

      _callLogs = allCallLogs;
      notifyListeners();
    } catch (e) {
      print('Error fetching call logs for all agents: $e');
    }
  }

  Future<void> fetchAgentCallLogs(String agentName) async {
    try {
      // Fetch all agent IDs
      List<String> agentIds = await firestoreService.fetchAgentIds();

      // Find the agent ID that matches the provided agent name
      String? agentId = agentIds.firstWhere(
        (id) => id.contains(agentName),
        orElse: () => '', // Return an empty string if no match is found
      );

      if (agentId.isNotEmpty) {
        // Fetch call logs for the identified agent
        _callLogs = await firestoreService.fetchCallLogs(agentId);
        notifyListeners();
      } else {
        // Handle the case where no matching agent is found
        print('No matching agent found for name: $agentName');
        _callLogs = []; // Clear the call logs if no agent found
        notifyListeners();
      }
    } catch (e) {
      // Handle any errors during fetching
      print('Error fetching agent call logs: $e');
    }
  }

///////////////////////////
  // Future<void> fetchCallLogs(
  //     String agentName, String startDate, String endDate, String callType,
  //     {bool forceRefresh = false}) async {
  //   print("Fetching call logs for agentName: $agentName");

  //   _isLoading = true;
  //   _errorMessage = null;
  //   notifyListeners();

  //   try {
  //     if (_agents.isEmpty) {
  //       await fetchAgents();
  //     }
  //     String? agentId = _agents[agentName];

  //     if (agentId != null && agentId.isNotEmpty) {
  //       print("Fetching call logs for agentId: $agentId...");
  //       _callLogs = await firestoreService.fetchCallLogs(agentId);
  //       print("Fetched ${_callLogs.length} call logs.");
  //       _filterCallLogs(startDate, endDate, callType);
  //     }
  //     // else {
  //     //   // _errorMessage = "Agent not found.";
  //     //   print("Agent not found for agentName: $agentName");
  //     // }
  //   } catch (e) {
  //     _errorMessage = "Failed to fetch call logs. Please try again.";
  //     print("Error in provider fetching call logs: $e");
  //   } finally {
  //     _isLoading = false;
  //     notifyListeners();
  //   }
  // }

  // void _filterCallLogs(String startDate, String endDate, String callType) {
  //   if (startDate.isNotEmpty && endDate.isNotEmpty) {
  //     DateTime start = DateFormat("MMMM d, yyyy").parse(startDate);
  //     DateTime end =
  //         DateFormat("MMMM d, yyyy").parse(endDate).add(Duration(days: 1));
  //     _callLogs = _callLogs.where((log) {
  //       // Assuming log.callDate is already a DateTime object
  //       return log.callDate.isAfter(start) && log.callDate.isBefore(end);
  //     }).toList();
  //   }

  //   if (callType != 'All') {
  //     String lowercaseCallType = callType.toLowerCase();
  //     _callLogs = _callLogs.where((log) {
  //       String dbCallType = log.callType.toLowerCase();
  //       return dbCallType.contains(lowercaseCallType);
  //     }).toList();
  //   }
  // }

  Future<void> fetchCallLogs(
      String agentName, String startDate, String endDate, String callType,
      {bool forceRefresh = false}) async {
    print("Fetching call logs for agentName: $agentName");

    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      String? cachedData = prefs.getString('callLogs');
      String? lastFetchDate = prefs.getString('lastFetchDate');
      DateTime now = DateTime.now();
      DateTime lastFetch = lastFetchDate != null
          ? DateTime.parse(lastFetchDate)
          : DateTime.fromMillisecondsSinceEpoch(0);

      if (forceRefresh ||
          cachedData == null ||
          now.difference(lastFetch).inDays >= 1) {
        if (_agents.isEmpty) {
          await fetchAgents();
        }
        String? agentId = _agents[agentName];

        if (agentId != null && agentId.isNotEmpty) {
          print("Fetching call logs for agentId: $agentId...");
          _callLogs = await firestoreService.fetchCallLogs(agentId);
          print("Fetched ${_callLogs.length} call logs.");
          await prefs.setString('callLogs',
              jsonEncode(_callLogs.map((log) => log.toFirestore()).toList()));
          await prefs.setString('lastFetchDate', now.toIso8601String());
        }
      } else {
        List<dynamic> jsonData = jsonDecode(cachedData);
        _callLogs = jsonData
            .map((data) => EmployeeCallLogs.fromFirestore(data))
            .toList();
        print("Loaded ${_callLogs.length} call logs from cache.");
      }

      _filterCallLogs(startDate, endDate, callType);
    } catch (e) {
      _errorMessage = "Failed to fetch call logs. Please try again.";
      print("Error in provider fetching call logs: $e");
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  // Future<void> fetchCallLogs(
  //     String agentName, String startDate, String endDate, String callType,
  //     {bool forceRefresh = false}) async {
  //   print("Fetching call logs for agentName: $agentName");

  //   _isLoading = true;
  //   _errorMessage = null;
  //   notifyListeners();

  //   try {
  //     SharedPreferences prefs = await SharedPreferences.getInstance();
  //     String? cachedData = prefs.getString('callLogs');
  //     String? lastFetchDate = prefs.getString('lastFetchDate');
  //     DateTime now = DateTime.now();
  //     DateTime lastFetch = lastFetchDate != null
  //         ? DateTime.parse(lastFetchDate)
  //         : DateTime.fromMillisecondsSinceEpoch(0);

  //     if (forceRefresh ||
  //         cachedData == null ||
  //         now.difference(lastFetch).inDays >= 1) {
  //       if (_agents.isEmpty) {
  //         await fetchAgents();
  //       }
  //       String? agentId = _agents[agentName];

  //       if (agentId != null && agentId.isNotEmpty) {
  //         print("Fetching call logs for agentId: $agentId...");
  //         _callLogs = await firestoreService.fetchCallLogs(agentId);
  //         print("Fetched ${_callLogs.length} call logs.");
  //         await prefs.setString('callLogs', jsonEncode(_callLogs));
  //         await prefs.setString('lastFetchDate', now.toIso8601String());
  //       }
  //     } else {
  //       List<dynamic> jsonData = jsonDecode(cachedData);
  //       _callLogs = jsonData
  //           .map((data) => CallLog.fromJson(data))
  //           .cast<EmployeeCallLogs>()
  //           .toList();
  //       print("Loaded ${_callLogs.length} call logs from cache.");
  //     }

  //     _filterCallLogs(startDate, endDate, callType);
  //   } catch (e) {
  //     _errorMessage = "Failed to fetch call logs. Please try again.";
  //     print("Error in provider fetching call logs: $e");
  //   } finally {
  //     _isLoading = false;
  //     notifyListeners();
  //   }
  // }

  void _filterCallLogs(String startDate, String endDate, String callType) {
    if (startDate.isNotEmpty && endDate.isNotEmpty) {
      DateTime start = DateFormat("MMMM d, yyyy").parse(startDate);
      DateTime end =
          DateFormat("MMMM d, yyyy").parse(endDate).add(Duration(days: 1));
      _callLogs = _callLogs.where((log) {
        // Assuming log.callDate is already a DateTime object
        return log.callDate.isAfter(start) && log.callDate.isBefore(end);
      }).toList();
    }

    if (callType != 'All') {
      String lowercaseCallType = callType.toLowerCase();
      _callLogs = _callLogs.where((log) {
        String dbCallType = log.callType.toLowerCase();
        return dbCallType.contains(lowercaseCallType);
      }).toList();
    }
  }
  /////////////////////////////////////////

  Future<void> fetchAgents() async {
    try {
      _agents = await firestoreService.fetchAgents();
      notifyListeners();
    } catch (e) {
      _errorMessage = "Failed to fetch agents. Please try again.";
      print("Error in provider fetching agents: $e");
    }
  }

  Future<void> fetchMissedCalls() async {
    _isLoading = true;
    notifyListeners();

    try {
      final querySnapshot = await FirebaseFirestore.instance
          .collectionGroup('callLogs')
          .where('callType', isEqualTo: 'CallType.missed')
          .get();

      missedCallCount = querySnapshot.docs.length;
    } catch (e) {
      print('Error fetching missed calls: $e');
      missedCallCount = 0;
    }

    _isLoading = false;
    notifyListeners();
  }

  /////////////////////////////////////
  ///
  ///
  ///

  Future<void> getCallLogsForSelectedAgent() async {
    if (_selectedAgent != null && _selectedAgent!.isNotEmpty) {
      _callLogs = await firestoreService.fetchCallLogs(_selectedAgent!);
      notifyListeners();
    }
  }

  void setSelectedAgent(String? agentId) {
    _selectedAgent = agentId;
    notifyListeners();
    getCallLogsForSelectedAgent();
  }

  Future<void> fetchCallLogsForSelectedAgent() async {
    if (_selectedAgent != null) {
      _callLogs = await firestoreService.fetchCallLogs(_selectedAgent!);
      notifyListeners();
    }
  }

  void setSelectedAgentId(String? agentId) {
    _selectedAgent = agentId;
    notifyListeners();
    fetchCallLogsForSelectedAgent();
  }

  //////////////////////////
  Duration getTotalTalkTime(List<EmployeeCallLogs> logs) {
    // Assuming callDuration is in seconds and converting it to Duration
    return logs.fold(
        Duration.zero, (sum, log) => sum + Duration(seconds: log.callDuration));
  }

  Duration getAverageTalkTime(List<EmployeeCallLogs> logs) {
    if (logs.isEmpty) return Duration.zero;
    return getTotalTalkTime(logs) ~/ logs.length;
  }

  List<EmployeeCallLogs> getInboundCalls() {
    return _filteredCallLogs.where((log) => log.callType == 'Inbound').toList();
  }

  List<EmployeeCallLogs> getOutboundCalls() {
    return _filteredCallLogs
        .where((log) => log.callType == 'Outbound')
        .toList();
  }

  Duration get totalTalkTimeInbound => getTotalTalkTime(getInboundCalls());
  Duration get averageTalkTimeInbound => getAverageTalkTime(getInboundCalls());

  Duration get totalTalkTimeOutbound => getTotalTalkTime(getOutboundCalls());
  Duration get averageTalkTimeOutbound =>
      getAverageTalkTime(getOutboundCalls());
}

// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:flutter/material.dart';
// import 'package:shared_preferences/shared_preferences.dart';
// import 'package:seeds_ai_callmate_web_app/models/employee_calllogs_model.dart';
// import 'package:seeds_ai_callmate_web_app/services/firestore_service.dart';
// import 'dart:convert';

// class CallLogsProvider with ChangeNotifier {
//   final FirestoreService firestoreService;
//   final FirebaseFirestore _firestore = FirebaseFirestore.instance;

//   List<EmployeeCallLogs> _allCallLogs = [];
//   Map<String, String> _agents = {};
//   bool _isLoading = false;
//   String? _errorMessage;
//   String _selectedTab = 'Outbound';
//   String? _selectedAgent;
//   DateTimeRange? _selectedDateRange;

//   CallLogsProvider(this.firestoreService);

//   // Getters
//   List<EmployeeCallLogs> get filteredCallLogs => _getFilteredCallLogs();
//   bool get isLoading => _isLoading;
//   String? get errorMessage => _errorMessage;
//   Map<String, String> get agents => _agents;

//   // Setters
//   void setTab(String tab) {
//     _selectedTab = tab;
//     notifyListeners();
//   }

//   void setDateRange(DateTimeRange? dateRange) {
//     _selectedDateRange = dateRange;
//     notifyListeners();
//   }

//   void setSelectedAgent(String? agentName) {
//     _selectedAgent = agentName;
//     notifyListeners();
//   }

//   // Fetch all call logs once and store locally
//   Future<void> fetchAllCallLogs() async {
//     if (_allCallLogs.isNotEmpty) return; // Fetch only if not already fetched

//     _isLoading = true;
//     notifyListeners();

//     try {
//       // Check if we have a cached version and its age
//       final prefs = await SharedPreferences.getInstance();
//       final lastFetchTime = prefs.getInt('lastCallLogsFetchTime') ?? 0;
//       final currentTime = DateTime.now().millisecondsSinceEpoch;

//       // If cache is less than a day old, use it
//       if (currentTime - lastFetchTime < 24 * 60 * 60 * 1000) {
//         final cachedLogs = prefs.getStringList('cachedCallLogs') ?? [];
//         if (cachedLogs.isNotEmpty) {
//           _allCallLogs = cachedLogs
//               .map((log) => EmployeeCallLogs.fromFirestore(json.decode(log)))
//               .toList();
//           _isLoading = false;
//           notifyListeners();
//           return;
//         }
//       }

//       // Fetch all call logs
//       final querySnapshot = await _firestore.collectionGroup('callLogs').get();

//       _allCallLogs = querySnapshot.docs
//           .map((doc) => EmployeeCallLogs.fromFirestore(
//               doc.data() as Map<String, dynamic>))
//           .toList();

//       // Cache the fetched logs
//       await prefs.setStringList('cachedCallLogs',
//           _allCallLogs.map((log) => json.encode(log.toFirestore())).toList());
//       await prefs.setInt('lastCallLogsFetchTime', currentTime);
//     } catch (e) {
//       _errorMessage = "Failed to fetch call logs. Please try again.";
//       print("Error in provider fetching call logs: $e");
//     } finally {
//       _isLoading = false;
//       notifyListeners();
//     }
//   }

//   // Fetch agents only once
//   Future<void> fetchAgents() async {
//     if (_agents.isNotEmpty) return; // Fetch only if not already fetched

//     try {
//       _agents = await firestoreService.fetchAgents();
//       notifyListeners();
//     } catch (e) {
//       _errorMessage = "Failed to fetch agents. Please try again.";
//       print("Error in provider fetching agents: $e");
//     }
//   }

//   // Filter logs based on current selections
//   List<EmployeeCallLogs> _getFilteredCallLogs() {
//     return _allCallLogs.where((log) {
//       if (_selectedAgent != null && log.name != _selectedAgent) return false;
//       if (_selectedDateRange != null) {
//         if (log.callDate.isBefore(_selectedDateRange!.start) ||
//             log.callDate.isAfter(_selectedDateRange!.end)) return false;
//       }
//       final callType = _selectedTab.toLowerCase();
//       return log.callType.toLowerCase() == callType;
//     }).toList();
//   }

//   // Get missed calls count
//   int getMissedCallsCount() {
//     return _allCallLogs
//         .where((log) => log.callType.toLowerCase() == 'missed')
//         .length;
//   }

//   // Helper methods
//   Duration getTotalTalkTime(List<EmployeeCallLogs> logs) {
//     return logs.fold(
//         Duration.zero, (sum, log) => sum + log.callDurationAsDuration);
//   }

//   Duration getAverageTalkTime(List<EmployeeCallLogs> logs) {
//     if (logs.isEmpty) return Duration.zero;
//     return getTotalTalkTime(logs) ~/ logs.length;
//   }

//   // Computed properties
//   Duration get totalTalkTimeInbound => getTotalTalkTime(filteredCallLogs
//       .where((log) => log.callType.toLowerCase() == 'incoming')
//       .toList());
//   Duration get averageTalkTimeInbound => getAverageTalkTime(filteredCallLogs
//       .where((log) => log.callType.toLowerCase() == 'incoming')
//       .toList());
//   Duration get totalTalkTimeOutbound => getTotalTalkTime(filteredCallLogs
//       .where((log) => log.callType.toLowerCase() == 'outgoing')
//       .toList());
//   Duration get averageTalkTimeOutbound => getAverageTalkTime(filteredCallLogs
//       .where((log) => log.callType.toLowerCase() == 'outgoing')
//       .toList());

//   // Additional computed properties
//   Duration get totalBreakTime => filteredCallLogs.fold(
//       Duration.zero, (sum, log) => sum + log.breakDurationAsDuration);
//   Duration get totalIdleTime => filteredCallLogs.fold(
//       Duration.zero, (sum, log) => sum + log.idleDurationAsDuration);
//   Duration get totalLoginTime => filteredCallLogs.fold(
//       Duration.zero, (sum, log) => sum + log.loginDurationAsDuration);
//   Duration get totalWrapUpTime => filteredCallLogs.fold(
//       Duration.zero, (sum, log) => sum + log.wrapUpDurationAsDuration);

//   double get averageBreakTime =>
//       totalBreakTime.inSeconds / filteredCallLogs.length;
//   double get averageIdleTime =>
//       totalIdleTime.inSeconds / filteredCallLogs.length;
//   double get averageLoginTime =>
//       totalLoginTime.inSeconds / filteredCallLogs.length;
//   double get averageWrapUpTime =>
//       totalWrapUpTime.inSeconds / filteredCallLogs.length;
// }
