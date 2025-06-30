import 'package:flutter/material.dart';
import 'package:mydoctorpage/views/screens/login/loginPatient.dart';
import 'package:mydoctorpage/views/screens/signup/signUpPatientPageTwo.dart';

class SignUpPatient extends StatefulWidget {
  const SignUpPatient({super.key});
  static const String pageRoute = '/signUpPatient.dart';

  @override
  State<SignUpPatient> createState() => _SignUpPatientState();
}

class _SignUpPatientState extends State<SignUpPatient> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      body: Stack(
        children: [
          // Background Image
          Positioned.fill(
            child: Image.asset(
              "assets/images/background.png",
              fit: BoxFit.cover, // Ensures the background image covers the whole screen
            ),
          ),
          // Arrow back button positioned above the background image
          Positioned(
            top: 40,
            left: 10,
            child: IconButton(
              icon: Icon(Icons.arrow_back, color: Colors.white, size: 30),
              onPressed: () => Navigator.pop(context),
            ),
          ),
          // Form content
          Padding(
            padding: const EdgeInsets.only(top: 100), // Adjust top padding to avoid overlap with the arrow
            child: ListView(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              children: [
                const Text(
                  "S'inscrire",
                  textAlign: TextAlign.start,
                  style: TextStyle(
                    fontSize: 32,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF03045E),
                  ),
                ),
                const SizedBox(height: 20),
                const Text(
                  "Patient",
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.w400,
                    color: Color(0xFF03045E),
                  ),
                ),
                const SizedBox(height: 20),
                Center(
                  child: Image.asset(
                    "assets/images/twodocs.png",
                  ),
                ),
                const SizedBox(height: 20),
                SocialButton(
                  icon: Icons.g_mobiledata,
                  label: 'Continuer avec Google',
                  onPressed: () {},
                ),
                const SizedBox(height: 10),
                SocialButton(
                  icon: Icons.facebook,
                  label: 'Continuer avec Facebook',
                  onPressed: () {},
                ),
                const SizedBox(height: 10),
                SocialButton(
                  icon: Icons.apple,
                  label: 'Continuer avec Apple',
                  onPressed: () {},
                ),
                const SizedBox(height: 10),
                const Text(
                  'ou',
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 10),
                ElevatedButton(
                  onPressed: () {
                    Navigator.pushNamed(context, SignPatient.pageRoute);
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF03045E),
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(
                        vertical: 20.0, horizontal: 40.0),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12.0),
                    ),
                    elevation: 0,
                  ),
                  child: const Text(
                    "S'inscrire avec un email",
                    style: TextStyle(fontSize: 20),
                  ), // Translated button text
                ),
                Center(
                  child: TextButton(
                    onPressed: () {
                      Navigator.pushNamed(context, Loginpatient.pageRoute);
                    },
                    child: const Text(
                      'Vous avez un compte ? Connectez-vous',
                      style: TextStyle(
                        color: Color(0xFF03045E),
                        fontSize: 16,
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 20),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class SocialButton extends StatelessWidget {
  final IconData icon;
  final String label;
  final VoidCallback onPressed;

  const SocialButton({
    super.key,
    required this.icon,
    required this.label,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: SizedBox(
        width: 350, // Limiter la largeur du bouton
        child: ElevatedButton.icon(
          onPressed: onPressed,
          icon: Icon(icon),
          label: Text(label),
          style: ElevatedButton.styleFrom(
            backgroundColor: const Color.fromARGB(255, 255, 255, 255),
            foregroundColor: const Color(0xFF03045E),
            padding: const EdgeInsets.symmetric(
                vertical: 15.0), // Ajuster le padding
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(11.0),
            ),
            elevation: 0,
          ),
        ),
      ),
    );
  }
}
