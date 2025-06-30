part of 'doctor_bloc.dart';

@immutable
sealed class DoctorEvent {}
class FetchDoctors extends DoctorEvent {}
class FetchBusySlots extends DoctorEvent {
  final String date;

  FetchBusySlots(this.date);
}

class UpdateSlotStatus extends DoctorEvent {
  final String date;
  final String time;
  final bool isBusy;

  UpdateSlotStatus(this.date, this.time, this.isBusy);
}