import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:syncfusion_flutter_calendar/calendar.dart';
import 'package:mydoctorpage/bloc/calendar_bloc.dart';
import 'package:mydoctorpage/bloc/calendar_state.dart';
import 'package:mydoctorpage/bloc/calendar_event.dart';

class CalendarDoctor extends StatelessWidget {
  const CalendarDoctor({Key? key}) : super(key: key);

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
                  return GestureDetector(
                    onTap: () => _showConfirmationDialog(
                      context, 
                      time, 
                      isBusy, 
                      state.selectedDate!,
                    ),
                    child: Card(
                      color: isBusy ? Colors.grey : Colors.blue.shade100,
                      child: Center(
                        child: Text(
                          '${time.hour}:${time.minute.toString().padLeft(2, '0')}',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            color: isBusy ? Colors.white : Colors.black,
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
    bool isBusy, 
    DateTime selectedDate,
  ) async {
    final action = isBusy ? 'make this slot available' : 'mark this slot as busy';
    final result = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Confirm Slot Status'),
        content: Text('Do you want to $action?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(false),
            child: Text('Cancel'),
          ),
          TextButton(
            onPressed: () => Navigator.of(context).pop(true),
            child: Text('Confirm'),
          ),
        ],
      ),
    );

    if (result == true) {
      context.read<CalendarBloc>().add(
        ToggleSlotStatusEvent(time, selectedDate, 14),
      );
    }
  }
}
