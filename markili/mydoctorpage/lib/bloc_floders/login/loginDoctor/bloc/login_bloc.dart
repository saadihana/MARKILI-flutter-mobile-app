import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

// --- States ---
abstract class LoginState extends Equatable {
  const LoginState();

  @override
  List<Object?> get props => [];
}

class LoginInitial extends LoginState {}

class LoginLoading extends LoginState {}

class LoginSuccess extends LoginState {
  final Map<String, dynamic> userData;

  const LoginSuccess(this.userData);

  @override
  List<Object?> get props => [userData];
}

class LoginFailure extends LoginState {
  final String error;

  const LoginFailure(this.error);

  @override
  List<Object?> get props => [error];
}

// --- Events ---
abstract class LoginEvent extends Equatable {
  const LoginEvent();

  @override
  List<Object?> get props => [];
}

class LoginSubmitted extends LoginEvent {
  final String email;
  final String password;

  const LoginSubmitted({required this.email, required this.password});

  @override
  List<Object?> get props => [email, password];
}

// --- Bloc ---
class LoginBloc extends Bloc<LoginEvent, LoginState> {
  LoginBloc() : super(LoginInitial()) {
    on<LoginSubmitted>(_onLoginSubmitted);
  }

  Future<void> _onLoginSubmitted(
    LoginSubmitted event,
    Emitter<LoginState> emit,
  ) async {
    emit(LoginLoading());

    try {
      final response = await http.post(
        Uri.parse('http://10.0.2.2:5000/login/doctor'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          'email': event.email,
          'password': event.password,
        }),
      );

      print('Login Response: ${response.body}'); // Debug print

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        emit(LoginSuccess(data['user']));
      } else {
        final data = jsonDecode(response.body);
        emit(LoginFailure(data['error'] ?? 'Login failed'));
      }
    } catch (e) {
      print('Login Error: $e'); // Debug print
      emit(LoginFailure('Connection error: $e'));
    }
  }
}