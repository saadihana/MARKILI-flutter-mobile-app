import 'package:flutter/material.dart';
import 'package:mydoctorpage/views/themes/colors.dart';
import 'dart:math';

class EmptySlot extends StatelessWidget {
  int hourMax;
  EmptySlot({required this.hourMax});

  Duration getRandomTime() {
    final random = Random();
    int hour = random.nextInt(hourMax);
    int min = random.nextInt(60);
    return Duration(hours: hour, minutes: min);
  }

  String formatDuration(Duration duration) {
    int hours = duration.inHours;
    int minutes = duration.inMinutes % 60; // To get minutes within the hour

    return '${hours.toString().padLeft(2, '0')}:${minutes.toString().padLeft(2, '0')}';
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 30,
      width: 70,
      margin: const EdgeInsets.all(4),
      decoration: BoxDecoration(
        border: Border.all(color: blue),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Center(child: Text(formatDuration(getRandomTime()).toString())),
    );
  }
}

class GenerateSlots extends StatefulWidget {
  final int numOfEmptySlots;
  final int hourMaxx;

  const GenerateSlots({
    required this.numOfEmptySlots,
    required this.hourMaxx,
    Key? key,
  }) : super(key: key);

  @override
  State<GenerateSlots> createState() => _GenerateSlotsState();
}

class _GenerateSlotsState extends State<GenerateSlots> {
  TimeOfDay? selectedSlot;
  int count = 0;
  @override
  Widget build(BuildContext context) {
    List<TimeOfDay> timeSlots = [];
    // Morning
    if (widget.hourMaxx == 11) {
      for (int hour = 8; hour <= 11; hour++) {
        for (int minute = 0; minute < 60; minute += 20) {
          timeSlots.add(TimeOfDay(
              hour: hour, minute: minute)); // Every 20 minutes in the morning
        }
      }
    }
    // Afternoon
    else if (widget.hourMaxx == 14) {
      for (int hour = 12; hour <= 14; hour++) {
        for (int minute = 0; minute < 60; minute += 20) {
          timeSlots.add(TimeOfDay(
              hour: hour, minute: minute)); // Every 20 minutes in the morning
        } // Afternoon time slots
      }
    }
    // Evening
    else if (widget.hourMaxx == 18) {
      for (int hour = 17; hour <= 18; hour++) {
        for (int minute = 0; minute < 60; minute += 20) {
          timeSlots.add(TimeOfDay(
              hour: hour, minute: minute)); // Every 20 minutes in the morning
        } // Evening time slots
      }
    }

    return Wrap(
      spacing: 8.0, 
      runSpacing: 4.0,
      children: timeSlots.map((timeSlot) {
        bool isSelected =
            timeSlot == selectedSlot; // Check if the slot is selected
        return GestureDetector(
          onTap: () {
            setState(() {
              selectedSlot = timeSlot; // Update the selected slot
            });
          },
          child: Container(
            width: 120,
            height: 40,
            alignment: Alignment.center,
            decoration: BoxDecoration(
              color: isSelected
                  ? dark_bleu
                  : Colors.white, // Highlight if selected
              borderRadius: BorderRadius.circular(12),
            ),
            child: Text(
              '${timeSlot.format(context)}',
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.bold,
                color: isSelected
                    ? Colors.white
                    : Colors.black, // Adjust text color
              ),
              textAlign: TextAlign.center,
            ),
          ),
        );
      }).toList(),
    );
  }
}
