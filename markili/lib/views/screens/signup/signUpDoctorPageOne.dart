import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../screens/signup/signUpDoctorPageTwo.dart';
import '../../screens/login/loginDoctor.dart';

import '../../../bloc_folders/signup/signup_doctor/bloc/signup_bloc.dart';

class SignUpDoctor extends StatefulWidget {
  const SignUpDoctor({super.key});
  static const String pageRoute = '/signUpDoctor.dart';

  @override
  State<SignUpDoctor> createState() => _SignUpDoctorState();
}

class _SignUpDoctorState extends State<SignUpDoctor> {
  final TextEditingController nameController = TextEditingController();
  final TextEditingController surnameController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController confirmPasswordController =
      TextEditingController();

  final _formKey = GlobalKey<FormState>();

  void _submitForm() {
    if (_formKey.currentState!.validate()) {
      final bloc = context.read<SignupBloc>();
      bloc.add(SignupDoctorPageOneSubmitted(
        name: nameController.text,
        surname: surnameController.text,
        email: emailController.text,
        password: passwordController.text,
      ));
      Navigator.pushNamed(context, SignDoctor.pageRoute);
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<SignupBloc, SignUpState>(
      listener: (context, state) {
        if (state is PersonalInfoValid) {
          Navigator.pushNamed(context, SignDoctor.pageRoute);
        } else if (state is SignUpError) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(state.message)),
          );
        }
      },
      child: Scaffold(
        body: Stack(
          children: [
            Positioned.fill(
              child: Image.asset(
                "assets/images/background.png", // Make sure this image is large enough
                fit: BoxFit.cover,
              ),
            ),
            // Add back arrow button in the top left corner
            Positioned(
              top: 40,
              left: 10,
              child: IconButton(
                icon: Icon(Icons.arrow_back, color: Colors.white, size: 30),
                onPressed: () => Navigator.pop(context), // Go back to the previous page
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(top: 100), // Adjust padding for the form
              child: SingleChildScrollView(
                child: Form(
                  key: _formKey,
                  child: Column(
                    children: [
                      const SizedBox(height: 20),
                      const Text(
                        "Créer un compte - Docteur",
                        style: TextStyle(
                            fontSize: 24, fontWeight: FontWeight.bold),
                      ),
                      const SizedBox(height: 20),
                      CustomTextField(
                        controller: nameController,
                        icon: Icons.person,
                        hintText: 'Nom',
                        validator: (value) => value == null || value.isEmpty
                            ? 'Entrez votre nom'
                            : null,
                      ),
                      const SizedBox(height: 15),
                      CustomTextField(
                        controller: surnameController,
                        icon: Icons.person_outline,
                        hintText: 'Prénom',
                        validator: (value) => value == null || value.isEmpty
                            ? 'Entrez votre prénom'
                            : null,
                      ),
                      const SizedBox(height: 15),
                      CustomTextField(
                        controller: emailController,
                        icon: Icons.email,
                        hintText: 'Email',
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Entrez votre email';
                          }
                          final emailRegex =
                              RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$');
                          if (!emailRegex.hasMatch(value)) {
                            return 'Entrez un email valide';
                          }
                          return null;
                        },
                      ),
                      const SizedBox(height: 15),
                      CustomTextField(
                        controller: passwordController,
                        icon: Icons.lock,
                        hintText: 'Mot de passe',
                        isPassword: true,
                        validator: (value) => value == null || value.length < 6
                            ? 'Le mot de passe doit contenir au moins 6 caractères'
                            : null,
                      ),
                      const SizedBox(height: 15),
                      CustomTextField(
                        controller: confirmPasswordController,
                        icon: Icons.lock,
                        hintText: 'Confirmer le mot de passe',
                        isPassword: true,
                        validator: (value) => value != passwordController.text
                            ? 'Les mots de passe ne correspondent pas'
                            : null,
                      ),
                      const SizedBox(height: 20),
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
                          'Suivant',
                          style: TextStyle(fontSize: 20),
                        ),
                      ),
                      const SizedBox(height: 10),
                      TextButton(
                        onPressed: () {
                          Navigator.pushNamed(context, LoginDoctor.pageRoute);
                        },
                        child: const Text(
                          'Vous avez un compte? Se connecter',
                          style: TextStyle(
                            color: Color(0xFF03045E),
                            fontSize: 18,
                          ),
                        ),
                      ),
                      const SizedBox(height: 20),
                      Center(
                        child: Image.asset("assets/images/twodocs.png"),
                      ),
                      const SizedBox(height: 20),
                    ],
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
  final TextEditingController controller;
  final String hintText;
  final bool isPassword;
  final String? Function(String?)? validator;

  const CustomTextField({
    super.key,
    required this.icon,
    required this.controller,
    required this.hintText,
    this.isPassword = false,
    this.validator,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(
          horizontal: 40.0), // Padding for horizontal spacing
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
          contentPadding: const EdgeInsets.symmetric(
              vertical: 15, horizontal: 10), // Adjust padding as needed
        ),
        validator: validator,
      ),
    );
  }
}