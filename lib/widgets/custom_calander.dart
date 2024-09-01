import 'package:calendar_date_picker2/calendar_date_picker2.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:seeds_ai_callmate_web_app/widgets/custom_text.dart';

class CustomCalendar extends StatefulWidget {
  final TextEditingController controller;
  final String title;
  final String hint;
  final IconData prefixIcon;

  const CustomCalendar({
    Key? key,
    required this.controller,
    required this.title,
    this.hint = 'Select date',
    this.prefixIcon = Icons.calendar_today,
  }) : super(key: key);

  @override
  _CustomCalendarState createState() => _CustomCalendarState();
}

class _CustomCalendarState extends State<CustomCalendar> {
  DateTime? _selectedDate;
  List<DateTime?> _dates = [DateTime.now()]; // Initialize the _dates variable

  Future<void> _selectDate(BuildContext context) async {
    await showDialog(
      context: context,
      builder: (BuildContext context) {
        return Dialog(
          child: SizedBox(
            width: 350, // Adjust the width as needed
            height: 350, // Adjust the height as needed
            child: Column(
              // crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                CalendarDatePicker2(
                  config: CalendarDatePicker2Config(
                    calendarType: CalendarDatePicker2Type.single,
                    selectedDayTextStyle: const TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.w700,
                    ),
                    selectedDayHighlightColor: Colors.blue[500],
                    centerAlignModePicker: true,
                    // customModePickerIcon:
                    //     const SizedBox(), // Make it square-shaped
                    // initialDate: DateTime.now(),
                    firstDate: DateTime(2020),
                    lastDate: DateTime(2030),
                  ),
                  value: _dates,
                  onValueChanged: (dates) {
                    setState(() {
                      _dates = dates;
                      _selectedDate = dates.isNotEmpty ? dates[0] : null;
                      widget.controller.text = _selectedDate != null
                          ? DateFormat('MMMM d, y').format(_selectedDate!)
                          : '';
                    });
                    Navigator.of(context).pop();
                  },
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        CustomText(
          text: widget.title,
          style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
        ),
        const SizedBox(height: 5),
        Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(8),
            color: Colors.white,
            border: Border.all(color: Colors.grey.withOpacity(0.3), width: 1),
          ),
          width: 250,
          child: TextField(
            controller: widget.controller,
            decoration: InputDecoration(
              border: InputBorder.none,
              hintText: widget.hint,
              hintStyle: const TextStyle(color: Colors.grey),
              prefixIcon: Padding(
                padding: const EdgeInsets.only(
                    left: 12.0, right: 8.0), // Adjust the padding as needed
                child: Icon(
                  widget.prefixIcon,
                  color: Colors.grey,
                ),
              ),
              prefixIconConstraints: const BoxConstraints(
                minWidth: 0,
                minHeight: 0,
              ),
              contentPadding: const EdgeInsets.symmetric(
                  vertical: 14.0), // Adjust vertical padding as needed
            ),
            readOnly: true,
            onTap: () => _selectDate(context),
          ),
        ),
      ],
    );
  }
}
