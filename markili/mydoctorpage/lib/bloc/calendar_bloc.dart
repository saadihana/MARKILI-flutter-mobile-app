import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mydoctorpage/bloc/calendar_event.dart';
import 'package:mydoctorpage/bloc/calendar_state.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class CalendarBloc extends Bloc<CalendarEvent, CalendarState> {
  final int doctorId;

  CalendarBloc(this.doctorId) : super(const CalendarState()) {
    on<SelectDateEvent>(_onSelectDate);
    on<FetchBusySlotsEvent>(_onFetchBusySlots);
    on<ToggleSlotStatusEvent>(_onToggleSlotStatus);
    on<PatientBookAppointmentEvent>(_onBookAppointment); // Add this handler
  }

  void _onSelectDate(SelectDateEvent event, Emitter<CalendarState> emit) {
    final timeSlots = _generateTimeSlots(event.selectedDate);
    emit(state.copyWith(
      selectedDate: event.selectedDate,
      timeSlots: timeSlots,
    ));
  }

  Future<void> _onFetchBusySlots(FetchBusySlotsEvent event, Emitter<CalendarState> emit) async {
    final dateStr = event.date.toIso8601String().split('T')[0];
    final url = Uri.parse('http://localhost:5000/timeslots?doctorid=$doctorId&date=$dateStr');

    try {
      final response = await http.get(url);
      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        final List<dynamic> busy = data['busyslots'] ?? [];
        final Set<DateTime> busySlots = {};

        for (var slot in busy) {
          final timeParts = slot.split(':');
          final busyDate = DateTime(
            event.date.year,
            event.date.month,
            event.date.day,
            int.parse(timeParts[0]),
            int.parse(timeParts[1]),
          );
          busySlots.add(busyDate);
        }

        emit(state.copyWith(busySlots: busySlots));
      } else {
        throw Exception('Failed to load busy slots');
      }
    } catch (error) {
      print("Error fetching busy slots: $error");
    }
  }

  Future<void> _onToggleSlotStatus(ToggleSlotStatusEvent event, Emitter<CalendarState> emit) async {
    final dateStr = event.selectedDate.toIso8601String().split('T')[0];
    final action = state.busySlots.contains(event.time) ? 'remove' : 'add';
    final slot = '${event.time.hour}:${event.time.minute.toString().padLeft(2, '0')}';
    final url = Uri.parse(
      'http://localhost:5000/timeslots?doctorid=$doctorId&date=$dateStr&slot=$slot&action=$action',
    );

    try {
      final response = await http.get(url);
      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        if (data['success']) {
          final updatedBusySlots = Set<DateTime>.from(state.busySlots);
          if (action == 'add') {
            updatedBusySlots.add(event.time);
          } else {
            updatedBusySlots.remove(event.time);
          }
          emit(state.copyWith(busySlots: updatedBusySlots));
        } else {
          throw Exception('Failed to update busy slot');
        }
      } else {
        throw Exception('Failed to update busy slot');
      }
    } catch (error) {
      print("Error updating busy slot: $error");
    }
  }

  // Helper method to generate time slots
  List<DateTime> _generateTimeSlots(DateTime date) {
    final List<DateTime> slots = [];
    DateTime start = DateTime(date.year, date.month, date.day, 9, 0);
    DateTime end = DateTime(date.year, date.month, date.day, 16, 0);
    while (start.isBefore(end)) {
      slots.add(start);
      start = start.add(Duration(minutes: 30));
    }
    return slots;
  }

  // Add a method to handle appointment booking
  Future<void> _onBookAppointment(PatientBookAppointmentEvent event, Emitter<CalendarState> emit) async {
    final dateStr = event.selectedDate.toIso8601String().split('T')[0];
    final slotStr = '${event.appointmentTime.hour}:${event.appointmentTime.minute.toString().padLeft(2, '0')}';
    final url = Uri.parse('http://localhost:5000/bookAppointment?doctorid=${event.doctorId}&date=$dateStr&slot=$slotStr');

    try {
      final response = await http.post(url);
      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        if (data['success']) {
          // Emit a new state showing that the appointment was successfully booked
          emit(state.copyWith(
            timeSlots: List.from(state.timeSlots)..remove(event.appointmentTime), // Remove booked slot
          ));
        } else {
          throw Exception('Failed to book appointment');
        }
      } else {
        throw Exception('Failed to book appointment');
      }
    } catch (error) {
      print("Error booking appointment: $error");
    }
  }
}
