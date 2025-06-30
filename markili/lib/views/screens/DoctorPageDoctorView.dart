import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mydoctorpage/bloc/calendar_bloc.dart';
import 'package:mydoctorpage/bloc/calendar_state.dart';
import 'package:mydoctorpage/views/themes/colors.dart';
import 'package:mydoctorpage/views/widgets/DoctorcardModify.dart';
import 'package:mydoctorpage/views/widgets/CalendarDoctor.dart';

class DoctorDoctor extends StatelessWidget {
  const DoctorDoctor({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BlocProvider(
        create: (context) => CalendarBloc(14),
        child: Container(
          child: SingleChildScrollView(
            child: Column(
              children: [
                const DoctorCardModify(),
                const SizedBox(height: 20),
                Center(
                  child: Text(
                    "Jours Disponibles",
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: dark_bleu,
                      fontSize: 20,
                    ),
                  ),
                ),
                const SizedBox(height: 20),
                const CalendarDoctor(),
                const SizedBox(height: 20),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
