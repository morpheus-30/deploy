// import 'dart:math';

// import 'package:fl_chart/fl_chart.dart';
// import 'package:flutter/material.dart';
// import 'package:provider/provider.dart';
// import 'package:seeds_ai_callmate_web_app/providers/call_log_provider.dart';

// class BarChartSample4 extends StatefulWidget {
//   const BarChartSample4({super.key});

//   @override
//   State<StatefulWidget> createState() => BarChartSample4State();
// }

// class BarChartSample4State extends State<BarChartSample4> {
//   final DateTime startDate = DateTime(2024, 9, 1); // Start from 1st August 2024
//   final DateTime endDate = DateTime(2024, 9, 30); // End at 31st August 2024

//   double maxYValue = 1000.0; // Default maximum Y value set to 1k

//   @override
//   void initState() {
//     super.initState();
//     WidgetsBinding.instance.addPostFrameCallback((_) {
//       Provider.of<CallLogsProvider>(context, listen: false).fetchCallLog();
//     });
//   }

//   void calculateMaxY() {
//     final provider = Provider.of<CallLogsProvider>(context, listen: false);
//     final callType = provider.selectedTab == 'Outbound'
//         ? 'CallType.outgoing'
//         : 'CallType.incoming';

//     final daysInMonth = List.generate(31, (index) => index + 1);
//     double tempMax = 0.0;

//     for (int i = 0; i < daysInMonth.length; i++) {
//       final dailyData = getDailyData(daysInMonth[i], provider, callType);
//       if (dailyData.total > tempMax) {
//         tempMax = dailyData.total;
//       }
//     }

//     // Cap the max Y value at 1k
//     maxYValue = tempMax <= 1000 ? tempMax : 1000;
//     print("Calculated max Y value: $maxYValue"); // Debugging print
//   }

//   Widget bottomTitles(double value, TitleMeta meta) {
//     const style = TextStyle(fontSize: 10);
//     final int day = value.toInt() + 1; // Day of the month

//     // Only show odd dates to prevent overlapping
//     if (day % 2 == 0) {
//       return Container();
//     }

//     final String text = "$day Sep";
//     print("Displaying bottom title for date: $text"); // Debugging print

//     return SideTitleWidget(
//       axisSide: meta.axisSide,
//       child: Text(text, style: style),
//     );
//   }

//   Widget leftTitles(double value, TitleMeta meta) {
//     if (value == meta.max) {
//       return Container();
//     }
//     const style = TextStyle(fontSize: 10);
//     print(
//         "Displaying left title for value: ${meta.formattedValue}"); // Debugging print
//     return SideTitleWidget(
//       axisSide: meta.axisSide,
//       child: Text(meta.formattedValue, style: style),
//     );
//   }

//   @override
//   Widget build(BuildContext context) {
//     final provider = Provider.of<CallLogsProvider>(context);
//     final callType = provider.selectedTab == 'Outbound'
//         ? 'CallType.outgoing'
//         : 'CallType.incoming';

//     calculateMaxY();

//     return AspectRatio(
//       aspectRatio: 3,
//       child: Padding(
//         padding: const EdgeInsets.only(top: 16),
//         child: LayoutBuilder(
//           builder: (context, constraints) {
//             final barsSpace = 4.0 * constraints.maxWidth / 400;
//             final barsWidth = 10.0 * constraints.maxWidth / 400;
//             print(
//                 "Building chart with barsSpace: $barsSpace, barsWidth: $barsWidth"); // Debugging print
//             return BarChart(
//               BarChartData(
//                 maxY: maxYValue, // Dynamically set max Y value
//                 alignment: BarChartAlignment.spaceAround,
//                 barTouchData: BarTouchData(
//                   enabled: true,
//                   touchTooltipData: BarTouchTooltipData(
//                     getTooltipItem: (group, groupIndex, rod, rodIndex) {
//                       final day = group.x + 1;
//                       return BarTooltipItem(
//                         'Aug $day\n',
//                         const TextStyle(
//                           color: Colors.white,
//                           fontWeight: FontWeight.bold,
//                         ),
//                         children: <TextSpan>[
//                           TextSpan(
//                             text: '${rod.toY.toStringAsFixed(1)}',
//                             style: const TextStyle(
//                               color: Colors.yellow,
//                               fontWeight: FontWeight.w500,
//                             ),
//                           ),
//                         ],
//                       );
//                     },
//                   ),
//                 ),
//                 titlesData: FlTitlesData(
//                   show: true,
//                   bottomTitles: AxisTitles(
//                     sideTitles: SideTitles(
//                       showTitles: true,
//                       reservedSize: 28,
//                       // getTitlesWidget: createBottomTitles(startDate),
//                       getTitlesWidget: bottomTitles,
//                     ),
//                   ),
//                   leftTitles: AxisTitles(
//                     sideTitles: SideTitles(
//                       showTitles: true,
//                       reservedSize: 40,
//                       getTitlesWidget: leftTitles,
//                     ),
//                   ),
//                   topTitles: const AxisTitles(
//                     sideTitles: SideTitles(showTitles: false),
//                   ),
//                   rightTitles: const AxisTitles(
//                     sideTitles: SideTitles(showTitles: false),
//                   ),
//                 ),
//                 gridData: FlGridData(
//                   show: true,
//                   checkToShowHorizontalLine: (value) =>
//                       value % 200 == 0, // Adjust grid lines every 200 units
//                   getDrawingHorizontalLine: (value) => FlLine(
//                     color: Colors.amber.withOpacity(0.1),
//                     strokeWidth: 1,
//                   ),
//                   drawVerticalLine: false,
//                 ),
//                 borderData: FlBorderData(
//                   show: false,
//                 ),
//                 groupsSpace: barsSpace,
//                 barGroups: getData(barsWidth, barsSpace, provider, callType),
//               ),
//             );
//           },
//         ),
//       ),
//     );
//   }

//   List<BarChartGroupData> getData(double barsWidth, double barsSpace,
//       CallLogsProvider provider, String callType) {
//     final List<BarChartGroupData> barGroups = [];
//     final daysInMonth = List.generate(31, (index) => index + 1);

//     for (int i = 0; i < daysInMonth.length; i++) {
//       final day = daysInMonth[i];
//       final dailyData = getDailyData(day, provider, callType);
//       print(
//           "Creating bar for day $day with total: ${dailyData.total}"); // Debugging print

//       // Determine the portions of the rod based on value
//       double below50 = min(dailyData.total, 50); // Convert to double
//       double above50 = max(dailyData.total - 50, 0); // Convert to double

//       barGroups.add(
//         BarChartGroupData(
//           x: i,
//           barsSpace: barsSpace,
//           barRods: [
//             BarChartRodData(
//               toY: dailyData.total, // Convert to double
//               rodStackItems: [
//                 // Blue for values up to 50
//                 BarChartRodStackItem(0, below50, Colors.blue),
//                 // Red for values above 50
//                 if (above50 > 0)
//                   BarChartRodStackItem(below50, dailyData.total, Colors.red),
//               ],
//               width: barsWidth,
//               borderRadius: BorderRadius.zero,
//             ),
//           ],
//         ),
//       );
//     }

//     return barGroups;
//   }

//   DailyData getDailyData(int day, CallLogsProvider provider, String callType) {
//     final formattedDate =
//         '2024-08-${day.toString().padLeft(2, '0')}'; // Format date as YYYY-MM-DD
//     final dailyCalls = provider.getDailyCallCounts(callType);
//     final count = dailyCalls[formattedDate] ?? 0;
//     return DailyData(day, count.toDouble()); // Convert to double
//   }
// }

// class DailyData {
//   final int day;
//   final double total;

//   DailyData(this.day, this.total);
// }

import 'dart:math';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:intl/intl.dart';
import 'package:seeds_ai_callmate_web_app/providers/call_log_provider.dart';

class BarChartSample4 extends StatefulWidget {
  const BarChartSample4({super.key});

  @override
  State<StatefulWidget> createState() => BarChartSample4State();
}

class BarChartSample4State extends State<BarChartSample4> {
  late DateTime startDate;
  late DateTime endDate;

  double maxYValue = 1000.0;

  @override
  void initState() {
    super.initState();
    // Set dynamic start and end dates
    final now = DateTime.now();
    startDate = DateTime(now.year, now.month, 1);
    endDate = DateTime(now.year, now.month + 1, 0);

    WidgetsBinding.instance.addPostFrameCallback((_) {
      Provider.of<CallLogsProvider>(context, listen: false).fetchCallLog();
    });
  }

  void calculateMaxY() {
    final provider = Provider.of<CallLogsProvider>(context, listen: false);
    final callType = provider.selectedTab == 'Outbound'
        ? 'CallType.outgoing'
        : 'CallType.incoming';

    final daysInMonth = endDate.difference(startDate).inDays + 1;
    double tempMax = 0.0;

    for (int i = 0; i < daysInMonth; i++) {
      final dailyData = getDailyData(i, provider, callType);
      if (dailyData.total > tempMax) {
        tempMax = dailyData.total;
      }
    }

    maxYValue = tempMax <= 1000 ? tempMax : 1000;
    print("Calculated max Y value: $maxYValue");
  }

  Widget bottomTitles(double value, TitleMeta meta) {
    const style = TextStyle(fontSize: 10);
    final date = startDate.add(Duration(days: value.toInt()));

    // Only show odd dates to prevent overlapping
    if (date.day % 2 == 0) {
      return Container();
    }

    final String text = DateFormat('d MMM').format(date);
    print("Displaying bottom title for date: $text");

    return SideTitleWidget(
      axisSide: meta.axisSide,
      child: Text(text, style: style),
    );
  }

  Widget leftTitles(double value, TitleMeta meta) {
    if (value == meta.max) {
      return Container();
    }
    const style = TextStyle(fontSize: 10);
    print("Displaying left title for value: ${meta.formattedValue}");
    return SideTitleWidget(
      axisSide: meta.axisSide,
      child: Text(meta.formattedValue, style: style),
    );
  }

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<CallLogsProvider>(context);
    final callType = provider.selectedTab == 'Outbound'
        ? 'CallType.outgoing'
        : 'CallType.incoming';

    calculateMaxY();

    return AspectRatio(
      aspectRatio: 3,
      child: Padding(
        padding: const EdgeInsets.only(top: 16),
        child: LayoutBuilder(
          builder: (context, constraints) {
            final barsSpace = 4.0 * constraints.maxWidth / 400;
            final barsWidth = 10.0 * constraints.maxWidth / 400;
            print(
                "Building chart with barsSpace: $barsSpace, barsWidth: $barsWidth");
            return BarChart(
              BarChartData(
                maxY: maxYValue,
                alignment: BarChartAlignment.spaceAround,
                barTouchData: BarTouchData(
                  enabled: true,
                  touchTooltipData: BarTouchTooltipData(
                    getTooltipItem: (group, groupIndex, rod, rodIndex) {
                      final date = startDate.add(Duration(days: group.x));
                      return BarTooltipItem(
                        '${DateFormat('d MMM').format(date)}\n',
                        const TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                        ),
                        children: <TextSpan>[
                          TextSpan(
                            text: '${rod.toY.toStringAsFixed(1)}',
                            style: const TextStyle(
                              color: Colors.yellow,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ],
                      );
                    },
                  ),
                ),
                titlesData: FlTitlesData(
                  show: true,
                  bottomTitles: AxisTitles(
                    sideTitles: SideTitles(
                      showTitles: true,
                      reservedSize: 28,
                      getTitlesWidget: bottomTitles,
                    ),
                  ),
                  leftTitles: AxisTitles(
                    sideTitles: SideTitles(
                      showTitles: true,
                      reservedSize: 40,
                      getTitlesWidget: leftTitles,
                    ),
                  ),
                  topTitles: const AxisTitles(
                    sideTitles: SideTitles(showTitles: false),
                  ),
                  rightTitles: const AxisTitles(
                    sideTitles: SideTitles(showTitles: false),
                  ),
                ),
                gridData: FlGridData(
                  show: true,
                  checkToShowHorizontalLine: (value) => value % 200 == 0,
                  getDrawingHorizontalLine: (value) => FlLine(
                    color: Colors.amber.withOpacity(0.1),
                    strokeWidth: 1,
                  ),
                  drawVerticalLine: false,
                ),
                borderData: FlBorderData(
                  show: false,
                ),
                groupsSpace: barsSpace,
                barGroups: getData(barsWidth, barsSpace, provider, callType),
              ),
            );
          },
        ),
      ),
    );
  }

  List<BarChartGroupData> getData(double barsWidth, double barsSpace,
      CallLogsProvider provider, String callType) {
    final List<BarChartGroupData> barGroups = [];
    final daysInMonth = endDate.difference(startDate).inDays + 1;

    for (int i = 0; i < daysInMonth; i++) {
      final dailyData = getDailyData(i, provider, callType);
      print(
          "Creating bar for day ${dailyData.day} with total: ${dailyData.total}");

      double below50 = min(dailyData.total, 50);
      double above50 = max(dailyData.total - 50, 0);

      barGroups.add(
        BarChartGroupData(
          x: i,
          barsSpace: barsSpace,
          barRods: [
            BarChartRodData(
              toY: dailyData.total,
              rodStackItems: [
                BarChartRodStackItem(0, below50, Colors.blue),
                if (above50 > 0)
                  BarChartRodStackItem(below50, dailyData.total, Colors.red),
              ],
              width: barsWidth,
              borderRadius: BorderRadius.zero,
            ),
          ],
        ),
      );
    }

    return barGroups;
  }

  DailyData getDailyData(
      int dayOffset, CallLogsProvider provider, String callType) {
    final date = startDate.add(Duration(days: dayOffset));
    final formattedDate = DateFormat('yyyy-MM-dd').format(date);
    final dailyCalls = provider.getDailyCallCounts(callType);
    final count = dailyCalls[formattedDate] ?? 0;
    return DailyData(date.day, count.toDouble());
  }
}

class DailyData {
  final int day;
  final double total;

  DailyData(this.day, this.total);
}
