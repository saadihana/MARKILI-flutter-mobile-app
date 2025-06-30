import 'package:flutter/material.dart';
import 'package:mydoctorpage/views/themes/colors.dart';
import 'package:table_calendar/table_calendar.dart';

class Calendar extends StatefulWidget {
  const Calendar({super.key});

  @override
  State<Calendar> createState() => _CalendarState();
}

class _CalendarState extends State<Calendar> {
  DateTime today = DateTime.now();
  void _onDaySelected(DateTime selectedDay, DateTime focusedDay) {
    setState(() {
      today = selectedDay;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(

        // padding: EdgeInsets.only(right:18),
        child: Column(
      children: [
        TableCalendar(
            locale: "en_US",
            headerStyle: HeaderStyle(
              formatButtonVisible: false,
              titleCentered: true,
            ),
            availableGestures: AvailableGestures.all,
            selectedDayPredicate: (day) => isSameDay(day, today),
            focusedDay: today,
            firstDay: DateTime.utc(2024, 10, 16),
            lastDay: DateTime(2025, 3, 14),
            onDaySelected: _onDaySelected,
            calendarStyle: CalendarStyle(
              // Change the color of the focused day
              todayDecoration: BoxDecoration(
                color: Colors.blue[900], // Set your desired color for focused days
                shape: BoxShape.circle,
              ),
              // Change the color of selected days
              selectedDecoration: BoxDecoration(
                color:  const Color.fromARGB(255, 53, 115, 167).withOpacity(0.5), // Set your desired color for selected days
                shape: BoxShape.circle,
              ),
            )),
            const SizedBox(height: 20,),
        Container(
          child:
              Text("Time slots available in " + today.toString().split(" ")[0]),
        ),
      ],
    ));
  }
}
