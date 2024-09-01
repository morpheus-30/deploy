import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:seeds_ai_callmate_web_app/models/customer_history_model.dart';
import 'package:seeds_ai_callmate_web_app/models/customers_model.dart';
import 'package:seeds_ai_callmate_web_app/providers/customers_provider.dart';
import 'package:seeds_ai_callmate_web_app/providers/history_provider.dart';
import 'package:seeds_ai_callmate_web_app/widgets/custom_text.dart';
import 'package:timelines/timelines.dart';
import 'package:url_launcher/url_launcher.dart';

class Timelines extends StatefulWidget {
  const Timelines({super.key});

  @override
  State<Timelines> createState() => _TimelinesState();
}

class _TimelinesState extends State<Timelines> {
  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<HistoryProvider>(context);
    final customerProvider = Provider.of<CustomerProvider>(context);

    if (provider.isLoading) {
      return const Scaffold(
        body: Center(child: CircularProgressIndicator()), // Or a shimmer effect
      );
    }

    if (provider.errorMessage != null) {
      return Scaffold(
        body: Center(child: Text(provider.errorMessage!)),
      );
    }

    final selectedCustomer = customerProvider.selectedCustomer;
    final timelines = provider.histories;

    // If no data is available, show a message
    if (timelines.isEmpty) {
      return Scaffold(
        backgroundColor: const Color(0xffF5F6F9),
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              SvgPicture.asset(
                'assets/svg/history_data.svg', // Ensure this path is correct
                width: 80,
                height: 80,
              ),
              const SizedBox(height: 20),
              CustomText(text: 'No Data to display'),
            ],
          ),
        ),
      );
    }

    // Sort the timelines by date in descending order
    timelines.sort((a, b) => b.date.compareTo(a.date));

    return Scaffold(
      backgroundColor: const Color(0xffF5F6F9),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 0),
          child: FixedTimeline.tileBuilder(
            theme: TimelineTheme.of(context).copyWith(
              connectorTheme: const ConnectorThemeData(
                color: Colors.grey,
                space: 40,
                thickness: 0.5,
                indent: 5,
              ),
              indicatorTheme: const IndicatorThemeData(color: Colors.blue),
            ),
            builder: TimelineTileBuilder.connectedFromStyle(
              nodePositionBuilder: (context, index) => 0.10,
              indicatorPositionBuilder: (context, index) => 0,
              contentsAlign: ContentsAlign.basic,
              itemCount: timelines.length,
              oppositeContentsBuilder: (context, index) {
                final DateTime date = timelines[index].date;
                final String formattedTime = DateFormat('hh:mma').format(date);

                String dateLabel;
                final now = DateTime.now();

                if (now.day == date.day &&
                    now.month == date.month &&
                    now.year == date.year) {
                  dateLabel = 'Today';
                } else if (now.subtract(const Duration(days: 1)).day ==
                        date.day &&
                    now.subtract(const Duration(days: 1)).month == date.month &&
                    now.subtract(const Duration(days: 1)).year == date.year) {
                  dateLabel = 'Yesterday';
                } else {
                  dateLabel = DateFormat('MMM dd').format(date);
                }

                return Padding(
                  padding: const EdgeInsets.all(0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      CustomText(
                        text: formattedTime,
                        style: const TextStyle(
                          fontSize: 14,
                          color: Colors.grey, // Large font for time
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      CustomText(
                        text: dateLabel,
                        style: const TextStyle(
                          fontSize: 12, // Smaller font for date
                          color: Colors.grey,
                        ),
                      ),
                    ],
                  ),
                );
              },
              contentsBuilder: (context, index) => Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
                margin: const EdgeInsets.only(bottom: 20),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(8),
                  color: Colors.white,
                  border: Border.all(color: Colors.white, width: 3),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Content1(
                      timeline: timelines[index],
                      customer: selectedCustomer,
                    ),
                    const SizedBox(height: 10),
                    Content2(timeline: timelines[index]),
                  ],
                ),
              ),
              connectorStyleBuilder: (context, index) =>
                  ConnectorStyle.solidLine,
              indicatorStyleBuilder: (context, index) => IndicatorStyle.dot,
            ),
          ),
        ),
      ),
    );
  }
}

///////////////////////////////

class Content1 extends StatelessWidget {
  final CustomerHistories timeline;
  final Customer? customer;

  const Content1({super.key, required this.timeline, this.customer});

  @override
  Widget build(BuildContext context) {
    // Determine the background color based on the action value
    Color? getActionColor(String? action) {
      switch (action) {
        case 'New':
          return Colors.red[400]!.withOpacity(0.8);
        case 'Follow-Up':
          return Colors.blue[400];
        case 'Completed':
          return Colors.green[600];
        case 'Interaction':
          return Colors.purple[600]!.withOpacity(0.8);
        default:
          return const Color(
              0xfff5f6f9); // Default color if action is not matched
      }
    }

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 30, vertical: 10),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(4),
                  color: const Color(0xfff5f6f9), // Default color for category
                ),
                child: CustomText(text: customer?.category ?? 'No Category'),
              ),
              const SizedBox(width: 10),
              Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 30, vertical: 10),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(4),
                  color: getActionColor(
                      timeline.action ?? ''), // Dynamic color based on action
                ),
                child: CustomText(
                  text: timeline.action,
                  style: const TextStyle(color: Colors.white),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

///////////////////////////////////

class Content2 extends StatelessWidget {
  final CustomerHistories timeline;

  const Content2({super.key, required this.timeline});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: double.infinity,
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 15),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(4),
              color: const Color(0xfff5f6f9),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                CustomText(
                  text: timeline.notes.isNotEmpty
                      ? timeline.notes
                      : "No notes found",
                ),
              ],
            ),
          ),
          const SizedBox(height: 10),
          // ..._buildExtraFields(timeline.extraFields),
        ],
      ),
    );
  }

  List<Widget> _buildExtraFields(Map<String, dynamic>? extraFields) {
    if (extraFields == null) {
      return [
        CustomText(text: "No extra fields available"),
      ];
    }

    return extraFields.entries.map((entry) {
      return Padding(
        padding: const EdgeInsets.symmetric(vertical: 5),
        child: Row(
          children: [
            CustomText(text: "${entry.key}:"),
            const SizedBox(width: 10),
            CustomText(text: entry.value.toString()),
          ],
        ),
      );
    }).toList();
  }
}

////////////////////////////////////////////

class CallLogsTimeline extends StatefulWidget {
  const CallLogsTimeline({Key? key}) : super(key: key);

  @override
  State<CallLogsTimeline> createState() => _CallLogsTimelineState();
}

class _CallLogsTimelineState extends State<CallLogsTimeline> {
  Future<List<DocumentSnapshot>> fetchcustomerCallLogs(
      String phoneNumber) async {
    final customerProvider =
        Provider.of<CustomerProvider>(context, listen: false);
    final organizationID = customerProvider.organizationId;
    final agentID = customerProvider.selectedAgentID;

    print('Fetching call logs for phone number: $phoneNumber');
    print('Organization ID: $organizationID');
    print('Agent ID: ${agentID.isEmpty ? "Not set" : agentID}');

    if (organizationID == null || organizationID.isEmpty) {
      print('Error: Organization ID is empty.');
      return [];
    }

    try {
      if (agentID.isNotEmpty) {
        // Fetch call logs for a specific agent
        final querySnapshot = await FirebaseFirestore.instance
            .collection('organizations')
            .doc(organizationID)
            .collection('agents')
            .doc(agentID)
            .collection('callLogs')
            .where('phoneNumber', isEqualTo: phoneNumber)
            .orderBy('callDate', descending: true)
            .get();

        print('Fetched ${querySnapshot.docs.length} call logs.');
        return querySnapshot.docs;
      } else {
        // Fetch call logs from all agents
        final agentsSnapshot = await FirebaseFirestore.instance
            .collection('organizations')
            .doc(organizationID)
            .collection('agents')
            .get();

        List<DocumentSnapshot> allCallLogs = [];
        for (var agentDoc in agentsSnapshot.docs) {
          final callLogsSnapshot = await FirebaseFirestore.instance
              .collection('organizations')
              .doc(organizationID)
              .collection('agents')
              .doc(agentDoc.id)
              .collection('callLogs')
              .where('phoneNumber', isEqualTo: phoneNumber)
              .orderBy('callDate', descending: true)
              .get();

          allCallLogs.addAll(callLogsSnapshot.docs);
        }

        // Sort all call logs in descending order by date
        allCallLogs.sort((a, b) => b['callDate'].compareTo(a['callDate']));

        print('Fetched ${allCallLogs.length} call logs.');
        return allCallLogs;
      }
    } catch (e) {
      print('Error fetching call logs: $e');
      return [];
    }
  }

  @override
  Widget build(BuildContext context) {
    final customerProvider = Provider.of<CustomerProvider>(context);
    final selectedCustomer = customerProvider.selectedCustomer;

    return FutureBuilder<List<DocumentSnapshot>>(
      future: fetchcustomerCallLogs(selectedCustomer!.phone),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        } else if (snapshot.hasError) {
          return Center(child: Text('Error: ${snapshot.error}'));
        } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                SvgPicture.asset(
                  'assets/svg/calllog_history.svg', // Ensure this path is correct
                  width: 80,
                  height: 80,
                ),
                const SizedBox(height: 20),
                CustomText(text: 'No Data to display'),
              ],
            ),
          );
        }

        final callLogs = snapshot.data!;

        return Scaffold(
          backgroundColor: const Color(0xffF5F6F9),
          body: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 0),
              child: FixedTimeline.tileBuilder(
                theme: TimelineTheme.of(context).copyWith(
                  connectorTheme: const ConnectorThemeData(
                      color: Colors.grey, space: 40, thickness: 0.5, indent: 5),
                  indicatorTheme: const IndicatorThemeData(color: Colors.blue),
                ),
                builder: TimelineTileBuilder.connectedFromStyle(
                  nodePositionBuilder: (context, index) => 0.10,
                  indicatorPositionBuilder: (context, index) => 0,
                  contentsAlign: ContentsAlign.basic,
                  itemCount: callLogs.length,
                  oppositeContentsBuilder: (context, index) {
                    final callDate =
                        DateTime.parse(callLogs[index]['callDate'] as String);
                    final formattedTime = DateFormat('hh:mma').format(callDate);

                    String dateLabel;
                    final now = DateTime.now();

                    if (now.day == callDate.day &&
                        now.month == callDate.month &&
                        now.year == callDate.year) {
                      dateLabel = 'Today';
                    } else if (now.subtract(const Duration(days: 1)).day ==
                            callDate.day &&
                        now.subtract(const Duration(days: 1)).month ==
                            callDate.month &&
                        now.subtract(const Duration(days: 1)).year ==
                            callDate.year) {
                      dateLabel = 'Yesterday';
                    } else {
                      dateLabel = DateFormat('MMM dd').format(callDate);
                    }

                    return Padding(
                      padding: const EdgeInsets.all(0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          CustomText(
                            text: formattedTime,
                            style: const TextStyle(
                              fontSize: 14,
                              color: Colors.grey, // Large font for time
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          CustomText(
                            text: dateLabel,
                            style: const TextStyle(
                              fontSize: 12, // Smaller font for date
                              color: Colors.grey,
                            ),
                          ),
                        ],
                      ),
                    );
                  },
                  contentsBuilder: (context, index) => Container(
                    padding: const EdgeInsets.all(10),
                    margin: const EdgeInsets.only(bottom: 20),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(8),
                      color: Colors.white,
                      border: Border.all(color: Colors.white, width: 3),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        CallContent1(callLog: callLogs[index]),
                        const SizedBox(height: 10),
                        CallContent2(callLog: callLogs[index]),
                      ],
                    ),
                  ),
                  connectorStyleBuilder: (context, index) =>
                      ConnectorStyle.solidLine,
                  indicatorStyleBuilder: (context, index) => IndicatorStyle.dot,
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}

class CallContent1 extends StatelessWidget {
  final DocumentSnapshot callLog;

  const CallContent1({Key? key, required this.callLog}) : super(key: key);

  String formatCallDuration(int durationInSeconds) {
    final int minutes = durationInSeconds ~/ 60;
    final int seconds = durationInSeconds % 60;
    return '$minutes min ${seconds}s';
  }

  String formatCallType(String type) {
    if (type.isEmpty) return '';
    // Remove "callType." and capitalize the first letter
    final formattedType = type.replaceFirst('callType.', '');
    return formattedType[0].toUpperCase() + formattedType.substring(1);
  }

  @override
  Widget build(BuildContext context) {
    final callData = callLog.data() as Map<String, dynamic>;
    final callDate = DateTime.parse(callData['callDate'] as String);
    final callDuration = callData['callDuration'] as int?;
    final callType = callData['callType'] as String?;
    final recordingURL = callData['recordingURL'] as String?;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(4),
                color: const Color(0xfff5f6f9),
              ),

              child: CustomText(
                  text:
                      "Call Duration: ${callDuration != null ? formatCallDuration(callDuration) : 'N/A'}"),
              // child: Text(
              //   "Call with ${callData['name'] ?? callData['phoneNumber']}",
              //   style: const TextStyle(fontWeight: FontWeight.bold),
              // ),
            ),
            const SizedBox(width: 10),
            Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(4),
                  color: const Color(0xfff5f6f9),
                ),
                child: CustomText(text: formatCallType(callType!))),
          ],
        ),
        const SizedBox(height: 10),
        if (recordingURL != null && recordingURL.isNotEmpty)
          Row(
            children: [
              IconButton(
                icon: const Icon(Icons.play_arrow),
                onPressed: () async {
                  if (await canLaunch(recordingURL)) {
                    await launch(recordingURL);
                  } else {
                    throw 'Could not launch $recordingURL';
                  }
                },
              ),
              const SizedBox(width: 5),
              IconButton(
                icon: const Icon(Icons.pause),
                onPressed: () {
                  // Add functionality for pausing the playback if needed.
                  // Typically, you'd manage this with a more sophisticated media player.
                },
              ),
            ],
          ),
      ],
    );
  }
}

class CallContent2 extends StatelessWidget {
  final DocumentSnapshot callLog;

  const CallContent2({Key? key, required this.callLog}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final callData = callLog.data() as Map<String, dynamic>;

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(4),
        // color: const Color(0xfff5f6f9),
      ),
      child: const Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // CustomText(text: "Duration: ${callData['callDuration']} seconds"),
          // CustomText(text: "Type: ${callData['callType']}"),
          // if (callData['recordingURL'] != null &&
          //     callData['recordingURL'].isNotEmpty)
          //   CustomText(text: "Recording URL: ${callData['recordingURL']}"),
        ],
      ),
    );
  }
}

























// class CallContent2 extends StatelessWidget {
//   final DocumentSnapshot callLog;

//   const CallContent2({super.key, required this.callLog});

//   @override
//   Widget build(BuildContext context) {
//     final callData = callLog.data() as Map<String, dynamic>;

//     print(
//         'Building CallContent2 with duration: ${callData['duration']} minutes');

//     return Padding(
//       padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 0),
//       child: Column(
//         crossAxisAlignment: CrossAxisAlignment.start,
//         children: [
//           Container(
//             width: double.infinity,
//             padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
//             decoration: BoxDecoration(
//               borderRadius: BorderRadius.circular(4),
//               color: const Color(0xfff5f6f9),
//             ),
//             child: Column(
//               crossAxisAlignment: CrossAxisAlignment.start,
//               children: [
//                 CustomText(text: "Duration: ${callData['duration']} minutes"),
//                 CustomText(text: "Type: ${callData['callType']}"),
//               ],
//             ),
//           ),
//           const SizedBox(height: 10),
//         ],
//       ),
//     );
//   }
// }
