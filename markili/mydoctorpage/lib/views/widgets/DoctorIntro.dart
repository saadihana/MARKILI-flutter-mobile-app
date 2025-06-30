import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:mydoctorpage/views/screens/DoctorPagePatientView.dart';
import 'package:mydoctorpage/views/themes/colors.dart';


class DoctorIntro extends StatelessWidget {
  final String name;
  final String surname;
  final String speciality;
  final String phone;
  final String email;
  final String address;
  final String image;
  final String description;

  const DoctorIntro({
    super.key,
    required this.name,
    required this.surname,
    required this.speciality,
    required this.phone,
    required this.email,
    required this.address,
    required this.image,
    required this.description,
  });


  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(10),
      child: Column(children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Column(
              children: [
                ClipRRect(
                    borderRadius: BorderRadius.circular(12),
                    child: Image.asset(image, height: 200, width: 150, fit: BoxFit.cover)),
              ],
            ),
            const SizedBox(width: 20),
            Expanded(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Text(
                    '$name $surname', // Combine name and surname
                    style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: dark_bleu,
                        fontSize: 35),
                  ),
                  const SizedBox(height: 18),
                  Text(
                    speciality,
                    style: TextStyle(
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
                            Clipboard.setData(ClipboardData(text: phone)); // Copy to clipboard
                            showDialog(
                              context: context,
                              builder: (context) => AlertDialog(
                                content: Text("Phone number $phone copied to clipboard."),
                              ),
                            );
                            Future.delayed(const Duration(seconds: 1), () {
                              Navigator.of(context).pop();
                            });
                          },
                          color: blue,
                          icon: const Icon(Icons.phone),
                        ),
                        IconButton(
                            onPressed: () {
                              openGoogleMaps(37.7749, -122.4194);
                            },
                            color: blue,
                            icon: const Icon(Icons.pin_drop)),
                        IconButton(
                            onPressed: () {
                              Clipboard.setData(ClipboardData(text: email)); // Copy to clipboard
                              showDialog(
                                context: context,
                                builder: (context) => AlertDialog(
                                  content: Text("Email $email copied to clipboard."),
                                ),
                              );
                              Future.delayed(const Duration(seconds: 1), () {
                                Navigator.of(context).pop();
                              });
                            },
                            color: blue,
                            icon: const Icon(Icons.email)),
                      ]),
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
                  description, // Display the description passed from the database
                ),
              ),
            ],
          ),
        ),
      ]),
    );
  }
}
