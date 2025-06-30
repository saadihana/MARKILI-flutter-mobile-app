import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../bloc_folders/signup/signup_patient/bloc/signup_patient_bloc.dart';

class SignPatient extends StatefulWidget {
  const SignPatient({super.key});
  static const String pageRoute = "/sign_patient";

  @override
  _SignPatientState createState() => _SignPatientState();
}

class _SignPatientState extends State<SignPatient> {
  final TextEditingController nameController = TextEditingController();
  final TextEditingController surnameController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController confirmPasswordController = TextEditingController();

  final _formKey = GlobalKey<FormState>();

  void _submitForm() {
    if (_formKey.currentState!.validate()) {
      final bloc = context.read<SignupPatientBloc>();
      bloc.add(SignupPatientPageSubmitted(
        name: nameController.text,
        surname: surnameController.text,
        email: emailController.text,
        password: passwordController.text,
      ));
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<SignupPatientBloc, SignupPatientState>(
  listener: (context, state) {
    if (state is SignupPatientLoading) {
      showDialog(
        context: context,
        barrierDismissible: false,
        builder: (_) => const Center(child: CircularProgressIndicator()),
      );
    } else if (state is SignupPatientSuccess) {
      Navigator.pop(context); // Close loading dialog
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(state.message)), // Show success message
      );
      Navigator.pushReplacementNamed(context, 'HomePage.pageRoute'); // Use pushReplacement to prevent going back
    } else if (state is SignupPatientFailure) {
      if (Navigator.canPop(context)) {
        Navigator.pop(context); // Close loading dialog if it's showing
      }
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(state.error)),
      );
    }
  },
  child: Scaffold(
        body: Stack(
          children: [
            Positioned.fill(
              child: Image.asset(
                "assets/images/background.png", // Background image
                fit: BoxFit.cover,
              ),
            ),
            Positioned(
              top: 40,
              left: 10,
              child: IconButton(
                icon: Icon(Icons.arrow_back, color: Colors.white, size: 30),
                onPressed: () => Navigator.pop(context),
              ),
            ),
            SafeArea(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20.0), // Horizontal padding for form
                child: SingleChildScrollView( // Ensures scrolling when keyboard appears
                  child: Form(
                    key: _formKey,
                    child: Column(
                      children: [
                        const SizedBox(height: 20),
                        const Text(
                          "Créer un compte - Patient", // Translated title
                          style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                        ),
                        const SizedBox(height: 20),
                        CustomTextField(
                          controller: nameController,
                          icon: Icons.person,
                          hintText: 'Nom', // Translated hint text
                          validator: (value) => value == null || value.isEmpty ? 'Entrez votre nom' : null, // Translated error message
                        ),
                        const SizedBox(height: 20),
                        CustomTextField(
                          controller: surnameController,
                          icon: Icons.person_outline,
                          hintText: 'Prénom', // Translated hint text
                          validator: (value) => value == null || value.isEmpty ? 'Entrez votre prénom' : null, // Translated error message
                        ),
                        const SizedBox(height: 20),
                        CustomTextField(
                          controller: emailController,
                          icon: Icons.email,
                          hintText: 'Email',
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Entrez votre email'; // Translated error message
                            }
                            final emailRegex = RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$');
                            if (!emailRegex.hasMatch(value)) {
                              return 'Entrez un email valide'; // Translated error message
                            }
                            return null;
                          },
                        ),
                        const SizedBox(height: 20),
                        CustomTextField(
                          controller: passwordController,
                          icon: Icons.lock,
                          hintText: 'Mot de passe', // Translated hint text
                          isPassword: true,
                          validator: (value) => value == null || value.length < 6 ? 'Le mot de passe doit contenir au moins 6 caractères' : null, // Translated error message
                        ),
                        const SizedBox(height: 20),
                        CustomTextField(
                          controller: confirmPasswordController,
                          icon: Icons.lock_outline,
                          hintText: 'Confirmer le mot de passe', // Translated hint text
                          isPassword: true,
                          validator: (value) => value != passwordController.text ? 'Les mots de passe ne correspondent pas' : null, // Translated error message
                        ),
                        const SizedBox(height: 20),
                        // Button container with 40% width
                        ElevatedButton(
                          onPressed: _submitForm,
                          style: ElevatedButton.styleFrom(
                            backgroundColor: const Color(0xFF03045E),
                            foregroundColor: Colors.white,
                            padding: const EdgeInsets.symmetric(vertical: 20.0, horizontal: 80.0),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12.0),
                            ),
                            elevation: 0,
                          ),
                          child: const Text(
                            "S'inscrire",
                            style: TextStyle(fontSize: 20),
                          ), // Translated button text
                        ),
                        const SizedBox(height: 20),
                        Center(
                          child: Image.asset(
                            "assets/images/twodocs.png",
                          ),
                        ),
                      ],
                    ),
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

class CustomTextField extends StatelessWidget {
  final IconData icon;
  final String hintText;
  final bool isPassword;
  final TextEditingController controller;
  final FormFieldValidator<String>? validator;

  const CustomTextField({
    super.key,
    required this.icon,
    required this.hintText,
    required this.controller,
    this.isPassword = false,
    this.validator,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 40.0), // Padding for horizontal spacing
      child: TextFormField(
        controller: controller,
        obscureText: isPassword,
        style: const TextStyle(
          fontSize: 16, // Set font size
          color: Color(0xFF03045E), // Text color
        ),
        decoration: InputDecoration(
          prefixIcon: Icon(icon),
          hintText: hintText,
          hintStyle: const TextStyle(
            fontSize: 16, // Font size for the hint text
            fontWeight: FontWeight.w300,
            color: Color(0xFF03045E),
          ),
          filled: true,
          fillColor: Colors.white,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
            borderSide: BorderSide.none,
          ),
          contentPadding: const EdgeInsets.symmetric(vertical: 15, horizontal: 10),
        ),
        validator: validator,
      ),
    );
  }
}
