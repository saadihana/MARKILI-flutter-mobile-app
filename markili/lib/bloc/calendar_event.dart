

// calendar_bloc.dart
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

// Events
abstract class CalendarEvent extends Equatable {
  const CalendarEvent();
  @override
  List<Object> get props => [];
}

class SelectDateEvent extends CalendarEvent {
  final DateTime selectedDate;
  const SelectDateEvent(this.selectedDate);

  @override
  List<Object> get props => [selectedDate];
}

class FetchBusySlotsEvent extends CalendarEvent {
  final DateTime date;
  final int doctorId;
  const FetchBusySlotsEvent(this.date, this.doctorId);

  @override
  List<Object> get props => [date, doctorId];
}

class ToggleSlotStatusEvent extends CalendarEvent {
  final DateTime time;
  final DateTime selectedDate;
  final int doctorId;
  const ToggleSlotStatusEvent(this.time, this.selectedDate, this.doctorId);

  @override
  List<Object> get props => [time, selectedDate, doctorId];
}
class BookAppointmentEvent extends CalendarEvent {
  final DateTime selectedDate;
  final DateTime timeSlot;
  final int doctorId;

  BookAppointmentEvent(this.selectedDate, this.timeSlot, this.doctorId);
}

abstract class CalendarPatientEvent {}

class PatientSelectDateEvent extends CalendarPatientEvent {
  final DateTime selectedDate;

  PatientSelectDateEvent(this.selectedDate);
}

class FetchDoctorBusySlotsEvent extends CalendarEvent {
  final String doctorId;
  final DateTime date;

  FetchDoctorBusySlotsEvent(this.doctorId, this.date);
}

class PatientBookAppointmentEvent extends CalendarEvent {
  final String doctorId;
  final DateTime appointmentTime;
  final DateTime selectedDate;

  PatientBookAppointmentEvent({
    required this.doctorId,
    required this.appointmentTime,
    required this.selectedDate,
  });
}

