import 'dart:convert';
import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';
import 'package:http/http.dart' as http;

part 'doctor_event.dart';
part 'doctor_state.dart';

class DoctorBloc extends Bloc<DoctorEvent, DoctorState> {
  DoctorBloc() : super(DoctorInitial()) {
    on<FetchDoctors>((event, emit) async {
      emit(DoctorLoading());
      try {
        final response =
            await http.get(Uri.parse('http://localhost:5001/doctors'));
        if (response.statusCode == 200) {
          final doctors = jsonDecode(response.body);
          emit(DoctorLoaded(doctors));
        } else {
          emit(DoctorError('Failed to fetch doctors'));
        }
      } catch (e) {
        emit(DoctorError('An error occurred: $e'));
      }
    });

    on<FetchBusySlots>((event, emit) async {
      emit(DoctorLoading());
      try {
        final response = await http.get(
            Uri.parse('http://localhost:5001/busy_slots?date=${event.date}'));
        if (response.statusCode == 200) {
          final List<dynamic> busySlotsData = jsonDecode(response.body);
          Set<DateTime> busySlots =
              busySlotsData.map((slot) => DateTime.parse(slot)).toSet();
          emit(BusySlotsLoaded(busySlots));
        } else {
          emit(DoctorError('Failed to fetch busy slots'));
        }
      } catch (e) {
        emit(DoctorError('An error occurred: $e'));
      }
    });

    ;
  }
}
