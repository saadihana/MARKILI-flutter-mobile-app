import 'package:flutter/material.dart';
import 'package:mydoctorpage/views/themes/colors.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;

import '../widgets/PatientCard.dart';
import '../widgets/BottomBar.dart';

class PatientScreen extends StatefulWidget {
  const PatientScreen({super.key});

  @override
  State<PatientScreen> createState() => _PatientScreenState();
}

class _PatientScreenState extends State<PatientScreen> {
  int _currentIndex = 0;
  bool _showAppointmentDetails = false;
  List<dynamic> _appointments = [];
  String _patientName = '';

  @override
  void initState() {
    super.initState();
    _fetchPatientDetails();
  }

  Future<void> _fetchPatientDetails() async {
    try {
      final response = await http.get(
        Uri.parse('http://localhost:5001/patient?patientid=104'),
      );
      if (response.statusCode == 200) {
        var data = jsonDecode(response.body);
        setState(() {
          _patientName = data['name'];
        });
      }
    } catch (e) {
      print('Error fetching patient details: $e');
    }
  }

  Future<void> _fetchAppointments() async {
    try {
      final response = await http.get(
        Uri.parse('http://localhost:5001/patient_appointments?patientid=104'),
      );
      if (response.statusCode == 200) {
        setState(() {
          _appointments = jsonDecode(response.body);
          _showAppointmentDetails = true;
        });
      } else {
        print('Failed to fetch appointments');
      }
    } catch (e) {
      print('Error fetching appointments: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Navigator.of(context).pop(),
        ),
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      body: Container(
        height: 1000,
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [
              backgroundGradient1,
              backgroundGradient2,
            ],
            begin: Alignment.bottomRight,
            end: Alignment.topLeft,
          ),
        ),
        child: SafeArea(
          child: SingleChildScrollView(
            child: Column(
              children: [
                const SizedBox(height: 25),
                PatientCard(
                  name: _patientName.isEmpty ? 'Loading...' : _patientName,
                  img: '/doctor_default_background.png',
                ),
                const SizedBox(height: 50),
                ElevatedButton(
                  onPressed: _fetchAppointments,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: dark_purple,
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(
                        horizontal: 70, vertical: 25),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                    elevation: 5,
                  ),
                  child: const Text(
                    "Mes rendez-vous",
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w400,
                    ),
                  ),
                ),
                const SizedBox(height: 60),
                if (_showAppointmentDetails)
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16.0),
                    child: Table(
                      border: TableBorder.all(color: dark_bleu),
                      columnWidths: const {
                        0: FlexColumnWidth(1),
                        1: FlexColumnWidth(1.5),
                        2: FlexColumnWidth(1.5),
                        3: FlexColumnWidth(1.5),
                      },
                      children: [
                        TableRow(
                          decoration: BoxDecoration(
                            color: dark_purple,
                          ),
                          children: [
                            _headerCell("Date"),
                            _headerCell("Médecin"),
                            _headerCell("Spécialité"),
                            _headerCell("Localistion"),
                          ],
                        ),
                        ..._appointments.map((appointment) => TableRow(
                              decoration: BoxDecoration(
                                color: backgroundGradient2.withOpacity(0.2),
                              ),
                              children: [
                                _appointmentInfoCell(appointment['appointmenttime']),
                                _appointmentInfoCell(appointment['doctor_name']),
                                _appointmentInfoCell(appointment['speciality']),
                                _appointmentInfoCell(appointment['address']),
                              ],
                            )),
                      ],
                    ),
                  ),
              ],
            ),
          ),
        ),
      ),
      bottomNavigationBar: BottomNavBar(
        currentIndex: _currentIndex,
        onTap: (index) {
          setState(() {
            _currentIndex = index;
          });
        },
      ),
    );
  }

  Widget _headerCell(String title) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Text(
        title,
        textAlign: TextAlign.center,
        style: const TextStyle(
          fontSize: 16,
          fontWeight: FontWeight.bold,
          color: Colors.white,
        ),
      ),
    );
  }

  Widget _appointmentInfoCell(String value) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Text(
        value,
        textAlign: TextAlign.center,
        style: const TextStyle(
          fontSize: 14,
          fontWeight: FontWeight.w500,
          color: dark_bleu,
        ),
      ),
    );
  }
}