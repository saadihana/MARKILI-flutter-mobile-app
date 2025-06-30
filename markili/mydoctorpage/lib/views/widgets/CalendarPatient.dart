import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mydoctorpage/views/themes/colors.dart';
import 'package:syncfusion_flutter_calendar/calendar.dart';
import 'package:mydoctorpage/bloc/calendar_bloc.dart';
import 'package:mydoctorpage/bloc/calendar_state.dart';
import 'package:mydoctorpage/bloc/calendar_event.dart';

class Calendarpatient extends StatefulWidget {
  const Calendarpatient({Key? key}) : super(key: key);

  @override
  _CalendarpatientState createState() => _CalendarpatientState();
}

class _CalendarpatientState extends State<Calendarpatient> {
  Set<DateTime> bookedSlots = {}; // Track booked slots

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<CalendarBloc, CalendarState>(
      builder: (context, state) {
        return Column(
          children: [
            SfCalendar(
              view: CalendarView.month,
              monthViewSettings: MonthViewSettings(),
              onTap: (details) {
                if (details.date != null) {
                  context.read<CalendarBloc>()
                    ..add(SelectDateEvent(details.date!))
                    ..add(FetchBusySlotsEvent(details.date!, 14));
                }
              },
            ),
            if (state.selectedDate != null) ...[
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text(
                  'Available Time Slots for ${state.selectedDate!.toLocal().toString().split(' ')[0]}:',
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                ),
              ),
              GridView.builder(
                shrinkWrap: true,
                physics: NeverScrollableScrollPhysics(),
                padding: const EdgeInsets.all(8.0),
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 7,
                  crossAxisSpacing: 8,
                  mainAxisSpacing: 8,
                ),
                itemCount: state.timeSlots.length,
                itemBuilder: (context, index) {
                  final time = state.timeSlots[index];
                  final isBusy = state.busySlots.contains(time);
                  final isBooked = bookedSlots.contains(time); // Check if booked

                  return GestureDetector(
                    onTap: () {
                      if (!isBusy && !isBooked) {
                        _showConfirmationDialog(
                          context,
                          time,
                          state.selectedDate!,
                        );
                      }
                    },
                    child: Card(
                      color: isBooked
                          ? Colors.green.shade300 // Green when booked
                          : (isBusy ? Colors.grey : Colors.blue.shade100),
                      child: Center(
                        child: Text(
                          '${time.hour}:${time.minute.toString().padLeft(2, '0')}',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            color: isBusy || isBooked ? Colors.white : Colors.black,
                          ),
                        ),
                      ),
                    ),
                  );
                },
              ),
            ] else
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text(
                  'Select a date to view available time slots',
                  style: TextStyle(fontSize: 16),
                ),
              ),
          ],
        );
      },
    );
  }

  Future<void> _showConfirmationDialog(
    BuildContext context,
    DateTime time,
    DateTime selectedDate,
  ) async {
    final result = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Rendez-vous'),
        content: Text('Voulez-vous réserver cet horaire?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(false),
            child: Text('Annuler'),
          ),
          TextButton(
            onPressed: () {
              Navigator.of(context).pop(true);
              setState(() {
                bookedSlots.add(time); // Mark as booked
              });
              context.read<CalendarBloc>().add(
                ToggleSlotStatusEvent(time, selectedDate, 14),
              );
            },
            child: Text('Confirmer'),
          ),
        ],
      ),
    );

    if (result == true) {
      // Appointment has been successfully booked, update the state
      showDialog(
                      context: context,
                      builder: (context) => AlertDialog(
                        title: const Text(
                          "Succès",
                          style: TextStyle(color: Colors.green),
                        ),
                        content: const Text(
                            "Vous recevrez une confirmation dans quelques heures."),
                        actions: [
                          TextButton(
                            onPressed: () => Navigator.of(context).pop(),
                            child:
                                Text("OK", style: TextStyle(color: dark_bleu)),
                          ),
                        ],
      ));
    }
  }
}
