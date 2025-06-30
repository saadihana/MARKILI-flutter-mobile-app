import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

// --- Events ---
abstract class SignupPatientEvent extends Equatable {
  const SignupPatientEvent();

  @override
  List<Object?> get props => [];
}

class SignupPatientPageSubmitted extends SignupPatientEvent {
  final String name;
  final String surname;
  final String email;
  final String password;

  const SignupPatientPageSubmitted({
    required this.name,
    required this.surname,
    required this.email,
    required this.password,
  });

  @override
  List<Object?> get props => [name, surname, email, password];
}

// --- States ---
abstract class SignupPatientState extends Equatable {
  const SignupPatientState();

  @override
  List<Object?> get props => [];
}

class SignupPatientInitial extends SignupPatientState {}

class SignupPatientLoading extends SignupPatientState {}

class SignupPatientSuccess extends SignupPatientState {
  final String message;
  
  const SignupPatientSuccess(this.message);
  
  @override
  List<Object?> get props => [message];
}

class SignupPatientFailure extends SignupPatientState {
  final String error;

  const SignupPatientFailure(this.error);

  @override
  List<Object?> get props => [error];
}

// --- Bloc ---
class SignupPatientBloc extends Bloc<SignupPatientEvent, SignupPatientState> {
  SignupPatientBloc() : super(SignupPatientInitial()) {
    on<SignupPatientPageSubmitted>((event, emit) async {
      emit(SignupPatientLoading());

      final url = Uri.parse('http://10.0.2.2:5000/signup/patient'); // Updated URL for Android emulator
      
      try {
        print('Sending request to: $url'); // Debug print
        print('Request body: ${jsonEncode({
          'name': event.name,
          'surname': event.surname,
          'email': event.email,
          'password': event.password,
        })}'); // Debug print
        
        final response = await http.post(
          url,
          headers: {'Content-Type': 'application/json'},
          body: jsonEncode({
            'name': event.name,
            'surname': event.surname,
            'email': event.email,
            'password': event.password,
          }),
        );

        print('Response status: ${response.statusCode}'); // Debug print
        print('Response body: ${response.body}'); // Debug print

        final responseData = jsonDecode(response.body);
        
        if (response.statusCode == 201) {
          emit(SignupPatientSuccess(responseData['message']));
        } else {
          final error = responseData['error'] ?? 'Unknown error';
          emit(SignupPatientFailure(error));
        }
      } catch (e) {
        print('Error: $e'); // Debug print
        emit(SignupPatientFailure('Failed to connect to server: $e'));
      }
    });
  }
}