// doctor_list_screen.dart
import 'package:flutter/material.dart';
import 'package:mydoctorpage/views/themes/colors.dart';


class DoctorCard extends StatelessWidget {
  final String doctorName;
  final String specialty;
  final String phonenumber;
  final String location;
  final VoidCallback onTap;

  const DoctorCard({
    super.key,
    required this.doctorName,
    required this.specialty,
    required this.phonenumber,
    required this.location,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(32),
      ),
      child: Container(
        width: MediaQuery.of(context).size.width * 0.901,
        padding: const EdgeInsets.all(12.0),
        decoration: BoxDecoration(
          image: const DecorationImage(
            image: AssetImage('assets/gradient.png'),
            fit: BoxFit.cover,
          ),
          borderRadius: BorderRadius.circular(25),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                const CircleAvatar(
                  radius: 40,
                  backgroundImage: AssetImage('assets/th.jpeg'),
                ),
                const SizedBox(width: 12),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      doctorName,
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: dark_bleu,
                      ),
                    ),
                    Text(
                      specialty,
                      style: const TextStyle(
                        fontSize: 16,
                        color: light_bleu,
                      ),
                    ),
                  ],
                ),
              ],
            ),
            const SizedBox(height: 10),
            Row(
              children: [
                const Icon(Icons.phone, color: info_bleu),
                const SizedBox(width: 4),
                Expanded(
                  child: Text(
                    phonenumber,
                    style: const TextStyle(
                      fontSize: 14,
                      color: info_bleu,
                    ),
                  ),
                ),
              ],
            ),
            Row(
              children: [
                const Icon(Icons.location_on, color: info_bleu),
                const SizedBox(width: 4),
                Expanded(
                  child: Text(
                    location,
                    style: const TextStyle(
                      fontSize: 14,
                      color: info_bleu,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 20),
            Center(
              child: ElevatedButton(
                onPressed: onTap,
                style: ElevatedButton.styleFrom(
                  backgroundColor: dark_bleu,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
                child: const Text(
                  "Prenez un rendez-vous",
                  style: TextStyle(
                    color: Colors.white,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
