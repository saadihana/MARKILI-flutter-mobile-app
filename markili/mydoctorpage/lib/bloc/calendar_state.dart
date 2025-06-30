import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class CalendarState extends Equatable {
  final DateTime? selectedDate;
  final List<DateTime> timeSlots;
  final Set<DateTime> busySlots;

  const CalendarState({
    this.selectedDate,
    this.timeSlots = const [],
    this.busySlots = const {},
  });

  CalendarState copyWith({
    DateTime? selectedDate,
    List<DateTime>? timeSlots,
    Set<DateTime>? busySlots,
  }) {
    return CalendarState(
      selectedDate: selectedDate ?? this.selectedDate,
      timeSlots: timeSlots ?? this.timeSlots,
      busySlots: busySlots ?? this.busySlots,
    );
  }

  @override
  List<Object?> get props => [selectedDate, timeSlots, busySlots];
}

class CalendarPatientState {
  final DateTime? selectedDate;
  final List<DateTime> timeSlots;
  final List<DateTime> busySlots;
  final bool isLoading;
  final String? error;

  const CalendarPatientState({
    this.selectedDate,
    this.timeSlots = const [],
    this.busySlots = const [],
    this.isLoading = false,
    this.error,
  });

  CalendarPatientState copyWith({
    DateTime? selectedDate,
    List<DateTime>? timeSlots,
    List<DateTime>? busySlots,
    bool? isLoading,
    String? error,
  }) {
    return CalendarPatientState(
      selectedDate: selectedDate ?? this.selectedDate,
      timeSlots: timeSlots ?? this.timeSlots,
      busySlots: busySlots ?? this.busySlots,
      isLoading: isLoading ?? this.isLoading,
      error: error ?? this.error,
    );
  }
}
