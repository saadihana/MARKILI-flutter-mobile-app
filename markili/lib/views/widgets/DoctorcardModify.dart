import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:mydoctorpage/views/themes/colors.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;

class DoctorCardModify extends StatefulWidget {
  const DoctorCardModify({super.key});

  @override
  State<DoctorCardModify> createState() => _DoctorCardModifyState();
}

class _DoctorCardModifyState extends State<DoctorCardModify> {
  Map<String, dynamic>? doctor;

  @override
  void initState() {
    super.initState();
    _fetchDoctorDetails();
  }

  Future<void> _fetchDoctorDetails() async {
    final url = Uri.parse('http://localhost:5000/doctors');
    try {
      final response = await http.get(url);

      if (response.statusCode == 200) {
        final List<dynamic> doctors = json.decode(response.body);

        final Map<String, dynamic>? foundDoctor = doctors.cast<Map<String, dynamic>>().firstWhere(
          (doc) => doc['doctorid'] == 14,
          orElse: () => {},
        );

        setState(() {
          doctor = foundDoctor;
        });
      } else {
        throw Exception('Failed to fetch doctors');
      }
    } catch (error) {
      print('Error fetching doctor details: $error');
    }
  }

  @override
  Widget build(BuildContext context) {
    return doctor == null
        ? const Center(child: CircularProgressIndicator())
        : Container(
            padding: const EdgeInsets.all(10),
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Column(
                      children: [
                        ClipRRect(
                          borderRadius: BorderRadius.circular(12),
                          child: Image.network(
                            doctor?['image'] ?? 'assets/th.jpeg',
                            height: 200,
                            width: 150,
                            fit: BoxFit.cover,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(width: 20),
                    Expanded(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: [
                              IconButton(
                                onPressed: () {
                                  Navigator.pushReplacementNamed(context, '/doc_modify_profile');
                                },
                                color: blue,
                                icon: const Icon(Icons.mode_edit_sharp),
                                highlightColor: Colors.white,
                              ),
                            ],
                          ),
                          Text(
                            "${doctor?['name']} ${doctor?['surname']}",
                            style: const TextStyle(
                              fontWeight: FontWeight.bold,
                              color: dark_bleu,
                              fontSize: 35,
                            ),
                          ),
                          const SizedBox(height: 18),
                          Text(
                            doctor?['speciality'] ?? "Unknown Speciality",
                            style: const TextStyle(
                              fontWeight: FontWeight.bold,
                              color: dark_bleu,
                            ),
                          ),
                          const SizedBox(height: 30),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: [
                              IconButton(
                                onPressed: () {
                                  Clipboard.setData(
                                      ClipboardData(text: doctor?['phonenumber']));
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    SnackBar(content: Text("Phone number copied!")),
                                  );
                                },
                                color: blue,
                                icon: const Icon(Icons.phone),
                              ),
                              IconButton(
                                onPressed: () {
                                  Navigator.pushReplacementNamed(context, '/map_view');
                                },
                                color: blue,
                                icon: const Icon(Icons.pin_drop),
                              ),
                              IconButton(
                                onPressed: () {
                                  Clipboard.setData(ClipboardData(text: doctor?['email']));
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    SnackBar(content: Text("Email copied!")),
                                  );
                                },
                                color: blue,
                                icon: const Icon(Icons.email),
                              ),
                            ],
                          ),
                        ],
                      ),
                    )
                  ],
                ),
                const SizedBox(width: 25),
                Container(
                  margin: const EdgeInsets.all(7),
                  width: double.infinity,
                  child: Row(
                    children: [
                      Expanded(
                        child: Text(
                          doctor?['description'] ??
                              "No description available for this doctor.",
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          );
  }
}
