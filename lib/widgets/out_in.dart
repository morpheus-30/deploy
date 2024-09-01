import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:seeds_ai_callmate_web_app/models/call_data.dart';
import 'package:seeds_ai_callmate_web_app/providers/dashboard_provider.dart';
// import 'package:seeds_ai_callmate_web_app/screens/dashboard.dart';

class OutInBound extends StatefulWidget {
  const OutInBound({super.key});

  @override
  State<OutInBound> createState() => _OutInBoundState();
}

class _OutInBoundState extends State<OutInBound> {
  @override
  Widget build(BuildContext context) {
    return Consumer<DashboardProvider>(
      builder: (context, model, child) {
        return Container(
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(8.0),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.1),
                blurRadius: 4.0,
                spreadRadius: 1.0,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          padding: const EdgeInsets.all(8.0),
          child: Column(
            children: [
              Row(
                children: ['Outbound', 'Inbound'].map((tab) {
                  return Padding(
                    padding: const EdgeInsets.only(right: 16.0),
                    child: InkWell(
                      onTap: () => model.setTab(tab),
                      child: Column(
                        children: [
                          Text(
                            tab,
                            style: TextStyle(
                              fontWeight: model.selectedTab == tab
                                  ? FontWeight.bold
                                  : FontWeight.normal,
                            ),
                          ),
                          if (model.selectedTab == tab)
                            Container(
                              height: 2,
                              width: 40,
                              color: Theme.of(context).primaryColor,
                            ),
                        ],
                      ),
                    ),
                  );
                }).toList(),
              ),
              const SizedBox(height: 20),
              const Center(
                child: Column(
                  children: [
                    Icon(Icons.bar_chart, size: 100, color: Colors.grey),
                    // Text('No Outbound data recorded'),
                  ],
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildMainContent(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        build(context),
        const SizedBox(height: 20),
        _buildDataSection(context),
      ],
    );
  }

  Widget _buildDataSection(BuildContext context) {
    return Consumer<DashboardProvider>(
      builder: (context, model, child) {
        if (model.selectedTab == 'Outbound') {
          return _buildOutboundSection();
        } else {
          return _buildOutboundSection();
        }
      },
    );
  }

  Widget _buildOutboundSection() {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8.0),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 4.0,
            spreadRadius: 1.0,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 15),
      child: Column(
        children: [
          _buildMetricRow(Icons.call, 'Average talk time', '0m 0s'),
          _buildDivider(),
          _buildMetricRow(
              Icons.chat_bubble_outline_rounded, 'Total talk time', '0m 0s'),
          _buildDivider(),
          _buildMetricRow(Icons.headset, 'Break time', '0m 0s'),
          _buildDivider(),
          _buildMetricRow(Icons.timer, 'Idle time', '0m 0s'),
          _buildDivider(),
          _buildMetricRow(Icons.access_time_filled, 'Wrap up time', '0m 0s'),
          _buildDivider(),
          _buildMetricRow(
              Icons.av_timer_outlined, 'Average login time', '0m 0s'),
        ],
      ),
    );
  }

  Widget _buildMetricRow(IconData iconData, String label, String value) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Row(
          children: [
            Icon(iconData), // Icon widget added here
            const SizedBox(width: 8), // Adjust spacing between icon and text
            Text(label),
          ],
        ),
        Text(value),
      ],
    );
  }

  Widget _buildDivider() {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 8.0),
      height: 1.0,
      color: Colors.grey.withOpacity(0.2), // Adjust opacity as needed
    );
  }
}

// class DashboardModel extends ChangeNotifier {
//   String _selectedDateRange = 'Today';
//   String _selectedTab = 'Outbound';
//   bool _isUnique = true;
//   Map<String, int> _statusData = {
//     'Hot Followup': 0,
//     'Sales Closed': 0,
//     'Cold Followup': 0,
//     'Appointment Fixed': 0,
//     'Not contacted': 0,
//     'Not interested': 0,
//     'Others': 0,
//   };

//   String get selectedDateRange => _selectedDateRange;
//   String get selectedTab => _selectedTab;
//   bool get isUnique => _isUnique;
//   Map<String, int> get statusData => _statusData;

//   void setDateRange(String range) {
//     _selectedDateRange = range;
//     notifyListeners();
//   }

//   void setTab(String tab) {
//     _selectedTab = tab;
//     notifyListeners();
//   }

//   void setUnique(bool value) {
//     _isUnique = value;
//     notifyListeners();
//   }

//   void updateStatusData(Map<String, int> newData) {
//     _statusData = newData;
//     notifyListeners();
//   }

//   void refresh() {
//     // Implement your refresh logic here
//     notifyListeners();
//   }
// }
