import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:seeds_ai_callmate_web_app/models/employee_calllogs_model.dart';
import 'package:seeds_ai_callmate_web_app/providers/call_log_provider.dart';
import 'package:seeds_ai_callmate_web_app/providers/dashboard_provider.dart';
import 'package:seeds_ai_callmate_web_app/providers/organization_provider.dart';
import 'package:seeds_ai_callmate_web_app/services/firestore_service.dart';
import 'package:seeds_ai_callmate_web_app/widgets/bar_chart.dart';
import 'package:seeds_ai_callmate_web_app/widgets/custom_text.dart';
import 'package:seeds_ai_callmate_web_app/widgets/date_range.dart';
import 'package:seeds_ai_callmate_web_app/widgets/status_card.dart';

class DashboardPage extends StatelessWidget {
  const DashboardPage({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => DashboardProvider(
        Provider.of<FirestoreService>(context, listen: false),
      ),
      child: Scaffold(
        backgroundColor: const Color(0xffF2F4F7),
        body: FutureBuilder<List<String>>(
          future: Provider.of<FirestoreService>(context, listen: false)
              .getAllOrganizationIDs(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return Center(child: CircularProgressIndicator());
            }
            if (snapshot.hasError) {
              return Center(child: Text('Error: ${snapshot.error}'));
            }
            if (!snapshot.hasData || snapshot.data!.isEmpty) {
              return Center(
                  child: Text('Something went wrong. Please try again later'));
            }

            // Fetch the first organization ID for simplicity
            final organizationID = snapshot.data!.first;

            return FutureBuilder(
              future: Provider.of<OrganizationProvider>(context, listen: false)
                  .fetchOrganization(organizationID),
              builder: (context, orgSnapshot) {
                if (orgSnapshot.connectionState == ConnectionState.waiting) {
                  return Center(child: CircularProgressIndicator());
                }
                if (orgSnapshot.hasError) {
                  return Center(child: Text('Error: ${orgSnapshot.error}'));
                }

                return LayoutBuilder(
                  builder: (context, constraints) {
                    if (constraints.maxWidth >= 900) {
                      return _buildDesktopView(context);
                    } else {
                      return _buildMobileRestrictionView();
                    }
                  },
                );
              },
            );
          },
        ),
      ),
    );
  }

  Widget _buildDesktopView(BuildContext context) {
    final organization =
        Provider.of<OrganizationProvider>(context).organization;

    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                CustomText(
                  text: organization?.companyName ?? "SeedsAI",
                  style: const TextStyle(
                      fontWeight: FontWeight.bold, fontSize: 24),
                ),
                const Spacer(),
                const DateRangeSelector(),
              ],
            ),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 20),
              child: _buildWideLayout(context),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildMobileRestrictionView() {
    return Center(
      child: Container(
        padding: const EdgeInsets.all(20),
        child: const Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(Icons.desktop_windows, size: 100, color: Colors.grey),
            SizedBox(height: 20),
            Text(
              'This application is only available on desktop view.',
              style: TextStyle(fontSize: 18, color: Colors.grey),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildWideLayout(BuildContext context) {
    return Container(
      color: const Color(0xffF2F4F7),
      child: Padding(
        padding: const EdgeInsets.all(0),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              flex: 1,
              child: _buildMainContent(context),
            ),
            const SizedBox(width: 20),
            const Expanded(
              flex: 1,
              child: StatusCard(),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildMainContent(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildTabBar(context),
        const SizedBox(height: 20),
        _buildCallMetricsSection(context),
        // _buildDataSection(context),
      ],
    );
  }

  Widget _buildTabBar(BuildContext context) {
    return Consumer<CallLogsProvider>(
      builder: (context, provider, child) {
        final callType = provider.selectedTab == 'Outbound'
            ? 'CallType.outgoing'
            : 'CallType.incoming';

        return Container(
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(8.0),
          ),
          padding: const EdgeInsets.all(10),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisSize:
                    MainAxisSize.min, // Ensure Row sizes to fit its children
                children: ['Outbound', 'Inbound'].map((tab) {
                  return Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 10),
                    child: InkWell(
                      onTap: () {
                        provider.setTab(tab);
                        provider.fetchCallLog(); // Fetch data when tab changes
                      },
                      child: Column(
                        children: [
                          Text(
                            tab,
                            style: TextStyle(
                              fontWeight: provider.selectedTab == tab
                                  ? FontWeight.bold
                                  : FontWeight.normal,
                              color: const Color(0xff5A6478),
                            ),
                          ),
                          if (provider.selectedTab == tab)
                            Container(
                              height: 2,
                              width: 50,
                              color: Colors.blue,
                            ),
                        ],
                      ),
                    ),
                  );
                }).toList(),
              ),
              const SizedBox(height: 20),
              const Center(
                child: Padding(
                  padding: EdgeInsets.symmetric(horizontal: 10),
                  child: BarChartSample4(),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildCallMetricsSection(BuildContext context) {
    final callLogsProvider = context.watch<CallLogsProvider>();
    final callLogs = callLogsProvider.callLogs;

//  if (callLogs.isEmpty) {
//     return Center(child: Text('No call logs available.'));
//   }
    // Calculate total and average durations
    final totalDuration =
        callLogs.fold<int>(0, (sum, log) => sum + log.callDuration);
    final averageDuration =
        callLogs.isNotEmpty ? totalDuration ~/ callLogs.length : 0;

    // Calculate break, idle, wrap-up, and login times
    final breakTime =
        callLogs.fold<int>(0, (sum, log) => sum + log.breakDuration);
    final idleTime =
        callLogs.fold<int>(0, (sum, log) => sum + log.idleDuration);
    final wrapUpTime =
        callLogs.fold<int>(0, (sum, log) => sum + log.wrapUpDuration);
    final loginTime = callLogs.isNotEmpty
        ? callLogs.fold<int>(0, (sum, log) => sum + log.loginDuration) ~/
            callLogs.length
        : 0;

    // Debug print statements
    print('Total Duration: $totalDuration');
    print('Average Duration: $averageDuration');
    print('Break Time: $breakTime');
    print('Idle Time: $idleTime');
    print('Wrap Up Time: $wrapUpTime');
    print('Login Time: $loginTime');

    // Ensure no NaN values are present
    if (totalDuration.isNaN ||
        averageDuration.isNaN ||
        breakTime.isNaN ||
        idleTime.isNaN ||
        wrapUpTime.isNaN ||
        loginTime.isNaN) {
      print('Error: One or more computed durations are NaN.');
      return const SizedBox.shrink(); // Handle the case where NaN is detected
    }

    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8.0),
      ),
      padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 15),
      child: Column(
        children: [
          _buildMetricRow(Icons.phone_enabled_rounded, 'Average talk time',
              _formatDuration(Duration(seconds: averageDuration))),
          _buildDivider(),
          _buildMetricRow(Icons.chat_bubble_outline_rounded, 'Total talk time',
              _formatDuration(Duration(seconds: totalDuration))),
        ],
      ),
    );
  }

// Helper function to calculate total talk time
  Duration getTotalTalkTime(List<EmployeeCallLogs> calls) {
    return Duration(
      seconds: calls.fold<int>(
        0,
        (sum, log) => sum + log.callDuration,
      ),
    );
  }

// Helper function to calculate average talk time
  Duration getAverageTalkTime(List<EmployeeCallLogs> calls) {
    if (calls.isEmpty) return Duration.zero;
    final totalTalkTimeInSeconds = calls.fold<int>(
      0,
      (sum, log) => sum + log.callDuration,
    );
    final averageTalkTimeInSeconds = totalTalkTimeInSeconds ~/ calls.length;
    return Duration(seconds: averageTalkTimeInSeconds);
  }

// Helper function to format duration
  String _formatDuration(Duration duration) {
    final minutes = duration.inMinutes;
    final seconds = duration.inSeconds % 60;
    return '$minutes min ${seconds}s';
  }

  Widget _buildMetricRow(IconData iconData, String label, String value) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Row(
          children: [
            Icon(iconData, color: const Color(0xff5A6478)),
            const SizedBox(width: 8),
            Text(
              label,
              style: const TextStyle(
                  fontWeight: FontWeight.w300, color: Color(0xff5A6478)),
            ),
          ],
        ),
        Text(
          value,
          style: const TextStyle(
              fontWeight: FontWeight.w300, color: Color(0xff5A6478)),
        ),
      ],
    );
  }

  Widget _buildDivider() {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 8.0),
      height: 1.0,
      color: Colors.grey.withOpacity(0.2),
    );
  }
}
