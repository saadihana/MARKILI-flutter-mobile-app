import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import '../../../../services/api_service.dart';

abstract class SignUpState extends Equatable {
  const SignUpState();
  
  @override
  List<Object?> get props => [];
}

class SignUpInitial extends SignUpState {}

class PersonalInfoValid extends SignUpState {}

class ProfessionalInfoValid extends SignUpState {}

class SignUpSuccess extends SignUpState {}

class SignUpError extends SignUpState {
  final String message;
  
  const SignUpError(this.message);
  
  @override
  List<Object?> get props => [message];
}

abstract class SignupEvent extends Equatable {
  const SignupEvent();
  
  @override
  List<Object?> get props => [];
}

class SignupDoctorPageOneSubmitted extends SignupEvent {
  final String name;
  final String surname;
  final String email;
  final String password;

  const SignupDoctorPageOneSubmitted({
    required this.name,
    required this.surname,
    required this.email,
    required this.password,
  });

  @override
  List<Object?> get props => [name, surname, email, password];
}

class SignupDoctorPageTwoSubmitted extends SignupEvent {
  final String speciality;
  final String address;
  final String phone;
  final String description;

  const SignupDoctorPageTwoSubmitted({
    required this.speciality,
    required this.address,
    required this.phone,
    required this.description,
  });

  @override
  List<Object?> get props => [speciality, address, phone, description];
}

class SignupBloc extends Bloc<SignupEvent, SignUpState> {
  final ApiService _apiService = ApiService();
  final Map<String, dynamic> _doctorData = {};

  SignupBloc() : super(SignUpInitial()) {
    on<SignupDoctorPageOneSubmitted>((event, emit) async {
      try {
        // Store the first page data
        _doctorData.addAll({
          'name': event.name,
          'surname': event.surname,
          'email': event.email,
          'password': event.password,
        });
        
        // Emit success state for first page
        emit(PersonalInfoValid());
      } catch (e) {
        emit(SignUpError('Error processing personal information: $e'));
      }
    });

    on<SignupDoctorPageTwoSubmitted>((event, emit) async {
      try {
        // Add the second page data
        _doctorData.addAll({
          'speciality': event.speciality,
          'address': event.address,
          'phone': event.phone,
          'description': event.description,
        });

        // Send complete data to the backend
        final result = await _apiService.registerDoctor(
          doctorData: _doctorData,
        );

        if (result['success']) {
          emit(SignUpSuccess());
        } else {
          emit(SignUpError(result['error']));
        }
      } catch (e) {
        emit(SignUpError('Registration failed: $e'));
      }
    });
  }
}