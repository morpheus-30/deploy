import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:seeds_ai_callmate_web_app/providers/call_log_provider.dart';
import 'package:seeds_ai_callmate_web_app/widgets/custom_button.dart';
import 'package:seeds_ai_callmate_web_app/widgets/custom_dropdown.dart';
import 'package:syncfusion_flutter_datepicker/datepicker.dart';
import 'package:seeds_ai_callmate_web_app/widgets/custom_text.dart';

class DateRangeSelector extends StatefulWidget {
  final ValueChanged<String>? onDateRangeChanged;

  const DateRangeSelector({super.key, this.onDateRangeChanged});

  @override
  State<DateRangeSelector> createState() => _DateRangeSelectorState();
}

class _DateRangeSelectorState extends State<DateRangeSelector> {
  final DateRangePickerController datePickerController =
      DateRangePickerController();
  DateTimeRange? selectedDateRange;
  String? selectedEmployeeId;
  final List<String> _days = [
    'Today',
    'Y\'Day',
    'Last 7 Days',
    'Last 30 Days',
    // 'Select Range'
  ];
  String _selectedDay = 'Today';

  void _onDaySelected(String day) {
    if (day == 'Select Range') {
      _showDateRangePicker();
    } else {
      setState(() {
        _selectedDay = day;
        _applyPredefinedRange(day);
      });
      context.read<CallLogsProvider>().setDateRange(
          selectedDateRange); // Pass the date range to the provider
    }
  }

  // void _onDaySelected(String day) {
  //   if (day == 'Select Range') {
  //     _showDateRangePicker();
  //   } else {
  //     setState(() {
  //       _selectedDay = day;
  //       _applyPredefinedRange(day);
  //     });
  //     context.read<CallLogsProvider>().setDateRange(selectedDateRange);
  //   }
  // }

  void _applyPredefinedRange(String day) {
    final now = DateTime.now();
    if (day == 'Today') {
      selectedDateRange = DateTimeRange(start: now, end: now);
    } else if (day == 'Y\'Day') {
      final yesterday = now.subtract(Duration(days: 1));
      selectedDateRange = DateTimeRange(start: yesterday, end: yesterday);
    } else if (day == 'Last 7 Days') {
      final lastWeek = now.subtract(Duration(days: 7));
      selectedDateRange = DateTimeRange(start: lastWeek, end: now);
    } else if (day == 'Last 30 Days') {
      final lastMonth = now.subtract(Duration(days: 30));
      selectedDateRange = DateTimeRange(start: lastMonth, end: now);
    }
  }

  Future<void> _showDateRangePicker() async {
    await showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          content: StatefulBuilder(
            builder: (BuildContext context, StateSetter setState) {
              return Container(
                width: 350, // Ensures the container is square
                height: 350,
                child: Column(
                  children: [
                    Expanded(
                      child: SfDateRangePicker(
                        backgroundColor: Colors.transparent,
                        rangeSelectionColor: Colors.blue.shade100,
                        todayHighlightColor: Colors.grey,
                        controller: datePickerController,
                        selectionMode: DateRangePickerSelectionMode.range,
                        onSelectionChanged:
                            (DateRangePickerSelectionChangedArgs args) {
                          if (args.value is PickerDateRange) {
                            setState(() {
                              selectedDateRange = DateTimeRange(
                                start: args.value.startDate!,
                                end:
                                    args.value.endDate ?? args.value.startDate!,
                              );
                            });
                          }
                        },
                      ),
                    ),
                    const SizedBox(height: 10),
                    CustomButton(
                      elevatedButtonText: 'Proceed',
                      elevatedButtonCallback: () {
                        if (selectedDateRange != null) {
                          final startDate = selectedDateRange!.start;
                          final endDate = selectedDateRange!.end;
                          final dateRangeText =
                              '${DateFormat('d MMM yyyy').format(startDate)} - ${DateFormat('d MMM yyyy').format(endDate)}';

                          setState(() {
                            _selectedDay = dateRangeText;
                          });
                          widget.onDateRangeChanged
                              ?.call(selectedDateRange! as String);
                          // widget.onSelectionChanged?.call(dateRangeText);

                          print(
                              'Selected Range: ${selectedDateRange!.start} - ${selectedDateRange!.end}');
                        }
                        Navigator.pop(context);

                        // Implement your apply filter logic here
                        // Retrieve filtered data based on the selected filters
                      },
                      elevatedButtonStyle: ElevatedButton.styleFrom(
                        backgroundColor: Colors.blue,
                        foregroundColor: Colors.white,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(4),
                        ),
                        textStyle: const TextStyle(fontWeight: FontWeight.bold),
                      ),
                    ),
                  ],
                ),
              );
            },
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(8),
            color: Colors.white,
            border: Border.all(color: Colors.grey.withOpacity(0.3)),
          ),
          child: Row(
            children: _days.map((day) {
              return GestureDetector(
                onTap: () => _onDaySelected(day),
                child: Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 10, vertical: 13),
                  decoration: BoxDecoration(
                    color: _selectedDay == day
                        ? const Color(0xFF42516E)
                        : Colors.transparent,
                    borderRadius:
                        _selectedDay == day ? BorderRadius.circular(4) : null,
                  ),
                  child: CustomText(
                    text: day,
                    style: TextStyle(
                      color: _selectedDay == day
                          ? Colors.white
                          : const Color(0xFF42516E),
                      fontWeight: _selectedDay == day
                          ? FontWeight.bold
                          : FontWeight.normal,
                    ),
                  ),
                ),
              );
            }).toList(),
          ),
        ),
        const SizedBox(width: 5),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            CustomDropdown(
              firestorePath: '/organizations/ABC-1234-999/agents',
              hintText: 'Select Employee',
              // onSelected: (String selectedEmployeeId) {
              //   context
              //       .read<CallLogsProvider>()
              //       .setSelectedEmployee(selectedEmployeeId);
              // },
              onSelected: (String? selectedEmployeeId) {
                if (selectedEmployeeId == null || selectedEmployeeId.isEmpty) {
                  // Fetch call logs for all agents if no employee is selected
                  context.read<CallLogsProvider>().fetchCallLogsForAllAgents();
                } else {
                  // Fetch call logs for the selected employee
                  context
                      .read<CallLogsProvider>()
                      .setSelectedEmployee(selectedEmployeeId);
                }
              },
            )
          ],
        ),
        const SizedBox(width: 5),
        CustomButton(
          elevatedButtonText: 'Apply',
          elevatedButtonCallback: () {
            context.read<CallLogsProvider>().setDateRange(selectedDateRange);
            context
                .read<CallLogsProvider>()
                .setSelectedEmployee(selectedEmployeeId);
            // Implement your apply filter logic here
            // Retrieve filtered data based on the selected filters
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
        // const SizedBox(width: 10),
        // Container(
        //   padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
        //   decoration: BoxDecoration(
        //     borderRadius: BorderRadius.circular(4),
        //     color: Colors.white,
        //     border: Border.all(color: Colors.grey.withOpacity(0.3)),
        //   ),
        //   child: const Icon(Icons.refresh, color: Color(0xFF42516E)),
        // ),
      ],
    );
  }
}
