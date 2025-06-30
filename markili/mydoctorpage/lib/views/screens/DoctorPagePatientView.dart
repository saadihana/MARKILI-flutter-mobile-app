import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mydoctorpage/bloc/calendar_bloc.dart';
import 'package:mydoctorpage/bloc/calendar_state.dart';
import 'package:mydoctorpage/views/themes/colors.dart';
import 'package:mydoctorpage/views/widgets/CalendarPatient.dart';
import 'package:mydoctorpage/views/widgets/DoctorcardModify.dart';
import 'package:mydoctorpage/views/widgets/CalendarDoctor.dart';

class DoctorPatient extends StatelessWidget {
  const DoctorPatient({super.key});

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
                const Calendarpatient(),
                const Padding(padding: EdgeInsets.all(16)),
              // ElevatedButton(
              //   onPressed: () {
              //      // Copy to clipboard
              //     WidgetsBinding.instance.addPostFrameCallback((_) {
              //       showDialog(
              //         context: context,
              //         builder: (context) => AlertDialog(
              //           title: const Text(
              //             "Succès",
              //             style: TextStyle(color: Colors.green),
              //           ),
              //           content: const Text(
              //               "Vous recevrez une confirmation dans quelques heures."),
              //           actions: [
              //             TextButton(
              //               onPressed: () => Navigator.of(context).pop(),
              //               child:
              //                   Text("OK", style: TextStyle(color: dark_bleu)),
              //             ),
              //           ],
              //         ),
              //       );
              //     });
              //   },
              //   style: ElevatedButton.styleFrom(
              //     backgroundColor: dark_bleu,
              //     foregroundColor: Colors.white,
              //     padding:
              //         const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
              //     shape: RoundedRectangleBorder(
              //       borderRadius: BorderRadius.circular(8),
              //     ),
              //     elevation: 5,
              //   ),
              //   child: const Text(
              //     "Prenez un rendez-vous",
              //     style: TextStyle(
              //       fontSize: 16,
              //       fontWeight: FontWeight.w400,
              //     ),
              //   ),
              // ),
                const SizedBox(height: 20),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

