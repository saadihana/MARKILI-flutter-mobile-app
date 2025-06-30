part of 'doctor_bloc.dart';

@immutable
abstract class DoctorState {}

class DoctorInitial extends DoctorState {}

class DoctorLoading extends DoctorState {}

class DoctorLoaded extends DoctorState {
  final List<dynamic> doctors;

  DoctorLoaded(this.doctors);
}

class DoctorError extends DoctorState {
  final String message;

  DoctorError(this.message);
}

class BusySlotsLoaded extends DoctorState {
  final Set<DateTime> busySlots;

  BusySlotsLoaded(this.busySlots);
}

class SlotStatusUpdated extends DoctorState {
  final String message;

  SlotStatusUpdated(this.message);
}