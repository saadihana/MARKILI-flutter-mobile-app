import 'package:flutter/material.dart';
import 'package:mydoctorpage/views/screens/signup/signUpDoctorPageOne.dart';
import 'package:mydoctorpage/views/screens/signup/signUpPatientPageOne.dart';
import 'package:mydoctorpage/views/themes/colors.dart';

class SignChooseScreen extends StatefulWidget {
  const SignChooseScreen({super.key});

  static const String pageRoute = '/signchoose_screen.dart';

  @override
  State<SignChooseScreen> createState() => _SignChooseScreenState();
}

class _SignChooseScreenState extends State<SignChooseScreen> {
  bool isPatient = true;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      body: Container(
        width: double.infinity,
        decoration: const BoxDecoration(
           gradient: LinearGradient(
            colors: [
              backgroundGradient1,
              backgroundGradient2,

           
            ],
            begin: Alignment.bottomRight,
            end: Alignment.topLeft,
            
          ),
        
        ),
        child: Center(
          child: Stack(
            children: [
              Column(
                children: [
                  const SizedBox(height: 40),
                       const Text(
                        "Inscrivez-vous",
                        style: TextStyle(
                          fontSize: 32,
                          fontWeight: FontWeight.bold,
                          color: Color(0xFF03045E),
                        ),
                        textAlign: TextAlign.center,
                      ),
                  const SizedBox(height: 5),
                  Image.asset(
                    "assets/images/doctorandschedule.png",
                  ),
                  const SizedBox(height: 5),
                  const Text(
                        "Continuer en tant que",
                        style: TextStyle(
                          fontSize: 21,
                          fontWeight: FontWeight.w300,
                          color: Color(0xFF03045E),
                        ),
                        textAlign: TextAlign.left,
                      ),
                  const SizedBox(height: 20),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      GestureDetector(
                        onTap: () {
                          setState(() {
                            isPatient = true;
                          });
                        },
                        child: AnimatedContainer(
                          duration: const Duration(milliseconds: 300),
                          curve: Curves.easeInOut,
                          width: 160.0,
                          height: 50.0,
                          decoration: BoxDecoration(
                            color: isPatient
                                ? const Color(0xFF03045E)
                                : Colors.transparent,
                            borderRadius: BorderRadius.circular(20.0),
                            border: Border.all(
                              color: const Color(0xFF03045E),
                              width: 2.0,
                            ),
                          ),
                          child: const Center(
                            child: Text(
                              "Patient",
                              style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.w500,
                                color: Color.fromARGB(255, 255, 255, 255),
                              ),
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(width: 10),
                      GestureDetector(
                        onTap: () {
                          setState(() {
                            isPatient = false;
                          });
                        },
                        child: AnimatedContainer(
                          duration: const Duration(milliseconds: 300),
                          curve: Curves.easeInOut,
                          width: 160.0,
                          height: 50.0,
                          decoration: BoxDecoration(
                            color: !isPatient
                                ? const Color(0xFF03045E)
                                : Colors.transparent,
                            borderRadius: BorderRadius.circular(20.0),
                            border: Border.all(
                              color:
                                  const Color(0xFF03045E),
                              width: 2.0,
                            ),
                          ),
                          child: const Center(
                            child: Text(
                              "Médecin",
                              style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.w500,
                              color: Color.fromARGB(255, 255, 255, 255),
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 150),
                  ElevatedButton(
                    onPressed: () {
                      if (isPatient) {
                        Navigator.pushNamed(context, SignUpPatient.pageRoute);
                      } else {
                        Navigator.pushNamed(context, SignUpDoctor.pageRoute);
                      }
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF03045E),
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(
                        vertical: 15.0,
                        horizontal: 140.0,
                      ),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12.0),
                      ),
                      elevation: 0,
                    ),
                    child: const Text(
                      "Suivant",
                      style: TextStyle(
                        fontSize: 20,
                        // fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
