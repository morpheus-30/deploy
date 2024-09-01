import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:seeds_ai_callmate_web_app/providers/call_log_provider.dart';

import 'package:seeds_ai_callmate_web_app/widgets/custom_button.dart';
import 'package:seeds_ai_callmate_web_app/widgets/custom_calander.dart';
import 'package:seeds_ai_callmate_web_app/widgets/custom_dropdown.dart';
import 'package:seeds_ai_callmate_web_app/widgets/custom_text.dart';
import 'package:shimmer/shimmer.dart';
import '../models/employee_calllogs_model.dart';

class CallLogs extends StatefulWidget {
  const CallLogs({super.key});

  @override
  State<CallLogs> createState() => _CallLogsState();
}

class _CallLogsState extends State<CallLogs> {
  final TextEditingController startdateController = TextEditingController();
  final TextEditingController enddateController = TextEditingController();
  String selectedCallType = 'All';
  String selectedAgentName = '';

  @override
  void initState() {
    super.initState();
    final callLogsProvider =
        Provider.of<CallLogsProvider>(context, listen: false);
    callLogsProvider.fetchAgents();
  }

  // bool _isApplyButtonEnabled() {
  //   return startdateController.text.isNotEmpty &&
  //       enddateController.text.isNotEmpty &&
  //       selectedCallType.isNotEmpty &&
  //       selectedAgentName.isNotEmpty;
  // }

  // void _applyFilters() {
  //   if (_isApplyButtonEnabled()) {
  //     final callLogsProvider =
  //         Provider.of<CallLogsProvider>(context, listen: false);

  //     // Parse and format start and end dates
  //     DateTime startDate;
  //     DateTime endDate;
  //     try {
  //       // Assume the date is in the format "MMMM d, yyyy"
  //       print('Parsing start date: ${startdateController.text}');
  //       print('Parsing end date: ${enddateController.text}');
  //       startDate = DateFormat("MMMM d, yyyy").parse(startdateController.text);
  //       endDate = DateFormat("MMMM d, yyyy").parse(enddateController.text);
  //       print('Parsed start date: $startDate');
  //       print('Parsed end date: $endDate');
  //     } catch (e) {
  //       // If parsing fails, show an error message
  //       print('Date parsing failed: $e');
  //       ScaffoldMessenger.of(context).showSnackBar(
  //         SnackBar(
  //             content: Text(
  //                 'Invalid date format. Please use the format "Month Day, Year"')),
  //       );
  //       return;
  //     }

  //     // Format dates to match Firestore 'callDate' format
  //     String formattedStartDate = DateFormat("yyyy-MM-dd").format(startDate);
  //     String formattedEndDate = DateFormat("yyyy-MM-dd").format(endDate);
  //     print('Formatted start date: $formattedStartDate');
  //     print('Formatted end date: $formattedEndDate');

  //     // Determine call type filter
  //     String? callTypeFilter = selectedCallType == 'All'
  //         ? null
  //         : 'CallType.${selectedCallType.toLowerCase()}';
  //     print('Selected call type: $selectedCallType');
  //     print('Call type filter: $callTypeFilter');

  //     // Fetch logs with the applied filters
  //     print('Fetching call logs with filters:');
  //     print('Agent Name: $selectedAgentName');
  //     print('Start Date: $formattedStartDate');
  //     print('End Date: $formattedEndDate');
  //     print('Call Type: $callTypeFilter');

  //     callLogsProvider.fetchCallLogs(
  //       selectedAgentName,
  //       formattedStartDate,
  //       formattedEndDate,
  //       callTypeFilter,
  //       forceRefresh: true,
  //     );
  //   } else {
  //     print('Apply button is not enabled.');
  //   }
  // }

  void _applyFilters() {
    final callLogsProvider =
        Provider.of<CallLogsProvider>(context, listen: false);

    String? formattedStartDate;
    String? formattedEndDate;

    // Parse and format dates if they are provided
    if (startdateController.text.isNotEmpty &&
        enddateController.text.isNotEmpty) {
      try {
        DateTime startDate =
            DateFormat("MMMM d, yyyy").parse(startdateController.text);
        DateTime endDate =
            DateFormat("MMMM d, yyyy").parse(enddateController.text);

        formattedStartDate = DateFormat("yyyy-MM-dd").format(startDate);
        formattedEndDate = DateFormat("yyyy-MM-dd").format(endDate);

        print('Formatted start date: $formattedStartDate');
        print('Formatted end date: $formattedEndDate');
      } catch (e) {
        print('Date parsing failed: $e');
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
              content: Text(
                  'Invalid date format. Please use the format "Month Day, Year"')),
        );
        return;
      }
    }

    // Determine call type filter (remove 'CallType.' prefix if present)
    String? callTypeFilter = selectedCallType == 'All'
        ? null
        : selectedCallType.replaceFirst('CallType.', '');

    print('Selected call type: $selectedCallType');
    print('Call type filter: $callTypeFilter');

    // Use null for agent name if 'All' is selected
    String? agentNameFilter =
        selectedAgentName == 'All' ? null : selectedAgentName;

    print('Fetching call logs with filters:');
    print('Agent Name: $agentNameFilter');
    print('Start Date: $formattedStartDate');
    print('End Date: $formattedEndDate');
    print('Call Type: $callTypeFilter');

    // callLogsProvider.fetchCallLogs(
    //   agentNameFilter,
    //   formattedStartDate,
    //   formattedEndDate,
    //   callTypeFilter,
    //   // forceRefresh: true,
    // );
  }

  @override
  Widget build(BuildContext context) {
    final callLogsProvider = Provider.of<CallLogsProvider>(context);

    // print('Call Logs Count: ${callLogsProvider.callLogs.length}');
    // print('Is Loading: ${callLogsProvider.isLoading}');
    // print('Error Message: ${callLogsProvider.errorMessage}');
    String? formattedStartDate;
    String? formattedEndDate;

    // Parse and format dates if they are provided
    if (startdateController.text.isNotEmpty &&
        enddateController.text.isNotEmpty) {
      try {
        DateTime startDate =
            DateFormat("MMMM d, yyyy").parse(startdateController.text);
        DateTime endDate =
            DateFormat("MMMM d, yyyy").parse(enddateController.text);

        formattedStartDate = DateFormat("yyyy-MM-dd").format(startDate);
        formattedEndDate = DateFormat("yyyy-MM-dd").format(endDate);

        print('Formatted start date: $formattedStartDate');
        print('Formatted end date: $formattedEndDate');
      } catch (e) {
        print('Date parsing failed: $e');
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
              content: Text(
                  'Invalid date format. Please use the format "Month Day, Year"')),
        );
        return SizedBox();
      }
    }
    return Scaffold(
      backgroundColor: Colors.white,
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            CustomText(
              text: "Call Logs",
              style: const TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 18,
              ),
            ),
            const SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                CustomCalendar(
                  controller: startdateController,
                  title: 'Start Date',
                  hint: 'Select date',
                  prefixIcon: Icons.calendar_today_outlined,
                ),
                const SizedBox(width: 10),
                CustomCalendar(
                  controller: enddateController,
                  title: 'End Date',
                  hint: 'Select date',
                  prefixIcon: Icons.calendar_today_outlined,
                ),
                const SizedBox(width: 10),
                Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    CustomText(
                      text: 'Select Call Type',
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 14,
                      ),
                    ),
                    const SizedBox(height: 5),
                    CustomDropdown(
                      items: const [
                        {'value': 'All'},
                        {'value': 'Incoming'},
                        {'value': 'Outgoing'},
                        {'value': 'Missed'},
                        {'value': 'Rejected'},
                      ],
                      hintText: 'All',
                      onSelected: (String value) {
                        setState(() {
                          selectedCallType = value;
                        });
                      },
                    ),
                  ],
                ),
                const SizedBox(width: 10),
                Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    CustomText(
                      text: 'Employee',
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 14,
                      ),
                    ),
                    const SizedBox(height: 5),
                    Consumer<CallLogsProvider>(
                      builder: (context, provider, child) {
                        return CustomDropdown(
                          firestorePath: '/organizations/ABC-1234-999/agents',
                          hintText: 'Select Employee',
                          onSelected: (String value) {
                            setState(() {
                              selectedAgentName = value;
                            });
                          },
                        );
                      },
                    ),
                  ],
                ),
                const SizedBox(width: 10),
                CustomButton(
                  elevatedButtonText: 'Apply',
                  // elevatedButtonCallback: _applyFilters,
                  elevatedButtonCallback: () {
                    callLogsProvider.fetchCallLogs(
                      selectedAgentName,
                      // formattedStartDate,
                      // formattedEndDate,
                      startdateController.text,
                      enddateController.text,
                      selectedCallType,
                      // forceRefresh: true,
                    );
                  },
                  elevatedButtonStyle: ElevatedButton.styleFrom(
                    backgroundColor: Colors.black,
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                    textStyle: const TextStyle(fontWeight: FontWeight.bold),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 20),

            // Header Row Section
            if (callLogsProvider.callLogs.isNotEmpty)
              Container(
                padding:
                    const EdgeInsets.symmetric(vertical: 20, horizontal: 30),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(8),
                  color: const Color(0xffF9FAFB),
                ),
                child: const Row(
                  children: [
                    Expanded(
                      flex: 2,
                      child: Text(
                        'Name',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 14,
                        ),
                      ),
                    ),
                    Expanded(
                      flex: 2,
                      child: Text(
                        'Time',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 14,
                        ),
                      ),
                    ),
                    Expanded(
                      flex: 1,
                      child: Text(
                        'Duration',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 14,
                        ),
                      ),
                    ),
                    Expanded(
                      flex: 1,
                      child: Text(
                        'Type',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 14,
                        ),
                      ),
                    ),
                    Expanded(
                      flex: 2,
                      child: Text(
                        'Recordings',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 14,
                        ),
                      ),
                    ),
                  ],
                ),
              ),

            const SizedBox(height: 10),
            if (callLogsProvider.isLoading)
              Expanded(
                child: Shimmer.fromColors(
                  baseColor: Colors.grey[300]!,
                  highlightColor: Colors.grey[100]!,
                  child: ListView.builder(
                    itemCount: 6,
                    itemBuilder: (context, index) {
                      return Padding(
                        padding: const EdgeInsets.symmetric(vertical: 10),
                        child: Container(
                          height: 60,
                          color: Colors.white,
                        ),
                      );
                    },
                  ),
                ),
              )
            else if (callLogsProvider.errorMessage != null)
              Center(
                child: Text(callLogsProvider.errorMessage!),
              )
            else if (callLogsProvider.callLogs.isEmpty)
              Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    SvgPicture.asset(
                      'assets/svg/no_data.svg', // Ensure this path is correct
                      width: 80,
                      height: 80,
                    ),
                    const SizedBox(height: 20),
                    CustomText(text: 'No Data to display'),
                  ],
                ),
              )
            else
              Expanded(
                child: ListView.builder(
                  shrinkWrap: true,
                  itemCount: callLogsProvider.callLogs.length,
                  itemBuilder: (context, index) {
                    // Sort logs in descending order by date
                    final log = callLogsProvider.callLogs[index];
                    return Column(
                      children: [
                        EmployeeRow(employees: log),
                        const Divider(),
                      ],
                    );
                  },
                ),
              ),
          ],
        ),
      ),
    );
  }
}

class EmployeeRow extends StatefulWidget {
  final EmployeeCallLogs employees;

  const EmployeeRow({
    super.key,
    required this.employees,
  });

  @override
  _EmployeeRowState createState() => _EmployeeRowState();
}

class _EmployeeRowState extends State<EmployeeRow> {
  final AudioPlayer _audioPlayer = AudioPlayer();
  bool _isPlaying = false;
  String _currentUrl = '';

  @override
  void initState() {
    super.initState();
    _audioPlayer.onPlayerStateChanged.listen((PlayerState state) {
      setState(() {
        _isPlaying =
            state == PlayerState.playing; // Update according to PlayerState
      });
    });
  }

  void _togglePlayback(String url) async {
    try {
      if (_currentUrl != url) {
        await _audioPlayer.stop();
        await _audioPlayer.play(UrlSource(url));
        _currentUrl = url;
      } else {
        if (_isPlaying) {
          await _audioPlayer.pause();
        } else {
          await _audioPlayer.resume();
        }
      }
    } catch (e) {
      print('Error playing audio: $e');
      // Show an error message to the user
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
            content: Text('Failed to play audio. Please try again later.')),
      );
    }
  }
  // void _togglePlayback(String url) async {
  //   if (_currentUrl != url) {
  //     await _audioPlayer.stop();
  //     await _audioPlayer.play(UrlSource(url));
  //     _currentUrl = url;
  //   } else {
  //     if (_isPlaying) {
  //       await _audioPlayer.pause();
  //     } else {
  //       await _audioPlayer.resume();
  //     }
  //   }
  // }

  String formatCallDuration(int durationInSeconds) {
    final minutes = durationInSeconds ~/ 60;
    final seconds = durationInSeconds % 60;
    return '${minutes} min ${seconds}s';
  }

  String formatDateTime(DateTime dateTime) {
    final today = DateTime.now();
    final yesterday = today.subtract(const Duration(days: 1));

    String time = DateFormat('hh:mma').format(dateTime);
    String date;

    if (DateFormat('MMM dd').format(dateTime) ==
        DateFormat('MMM dd').format(today)) {
      date = 'Today';
    } else if (DateFormat('MMM dd').format(dateTime) ==
        DateFormat('MMM dd').format(yesterday)) {
      date = 'Yesterday';
    } else {
      date = DateFormat('MMM dd').format(dateTime);
    }

    return '$time $date';
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          flex: 2,
          child: Row(
            children: [
              CircleAvatar(
                child: Text(widget.employees.name.isEmpty
                    ? 'U'
                    : widget.employees.name[0]),
              ),
              const SizedBox(width: 10),
              Flexible(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      widget.employees.name.isEmpty
                          ? 'Unknown'
                          : widget.employees.name,
                      style: const TextStyle(fontWeight: FontWeight.bold),
                      overflow: TextOverflow.ellipsis,
                      maxLines: 1,
                    ),
                    Text(widget.employees.phoneNumber)
                    // CustomText(
                    //   text: widget.employees.name,
                    //   style: const TextStyle(fontWeight: FontWeight.bold),
                    // ),
                  ],
                ),
              ),
            ],
          ),
        ),
        Expanded(
          flex: 2,
          child: CustomText(
            text: formatDateTime(widget.employees.callDate),
            style: const TextStyle(fontSize: 14),
          ),
        ),
        Expanded(
          flex: 1,
          child: CustomText(
            text: formatCallDuration(widget.employees.callDuration),
            style: const TextStyle(fontSize: 14),
          ),
        ),
        Expanded(
          flex: 1,
          child: CustomText(
            text: widget.employees.callType,
            style: const TextStyle(fontSize: 14),
          ),
        ),
        Expanded(
          flex: 2,
          child: widget.employees.recordingURL.isEmpty
              ? CustomText(
                  text: 'No Recording',
                  style: const TextStyle(fontSize: 14, color: Colors.grey),
                )
              : GestureDetector(
                  onTap: () {
                    _togglePlayback(widget.employees.recordingURL);
                  },
                  child: Row(
                    children: [
                      Icon(
                        _isPlaying &&
                                _currentUrl == widget.employees.recordingURL
                            ? Icons.pause_circle_filled
                            : Icons.play_circle_fill,
                        size: 30,
                        color: _isPlaying &&
                                _currentUrl == widget.employees.recordingURL
                            ? Colors.red
                            : Colors.green,
                      ),
                      const SizedBox(width: 10),
                      const Text(
                        'Recording',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 14,
                        ),
                      ),
                    ],
                  ),
                ),
        ),
      ],
    );
  }
}
