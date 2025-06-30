import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../bloc_folders/signup/signup_doctor/bloc/signup_bloc.dart';

class SignDoctor extends StatefulWidget {
  const SignDoctor({super.key});
  static const String pageRoute = '/signUpDoctorPageTwo.dart';

  @override
  State<SignDoctor> createState() => _SignDoctorState();
}

class _SignDoctorState extends State<SignDoctor> {
  final _formKey = GlobalKey<FormState>();

  final TextEditingController specialityController = TextEditingController();
  final TextEditingController addressController = TextEditingController();
  final TextEditingController phoneController = TextEditingController();
  final TextEditingController descriptionController = TextEditingController();

  void _submitForm() {
    if (_formKey.currentState!.validate()) {
      final bloc = context.read<SignupBloc>();
      bloc.add(SignupDoctorPageTwoSubmitted(
        speciality: specialityController.text,
        address: addressController.text,
        phone: phoneController.text,
        description: descriptionController.text,
      ));
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<SignupBloc, SignUpState>(
      listener: (context, state) {
        if (state is SignUpSuccess) {
          Navigator.pushNamed(context, '/home');
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Registration successful!')),
          );
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
                "assets/images/background.png",
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
            Padding(
              padding: const EdgeInsets.only(top: 100),
              child: SingleChildScrollView(
                child: Form(
                  key: _formKey,
                  child: Column(
                    children: [
                      const SizedBox(height: 20),
                      const Text(
                        "Détails professionnels",
                        style: TextStyle(
                            fontSize: 24, fontWeight: FontWeight.bold),
                      ),
                      const SizedBox(height: 20),
                      CustomTextField(
                        controller: specialityController,
                        icon: Icons.person_outline,
                        hintText: 'Spécialité',
                        validator: (value) => value == null || value.isEmpty
                            ? 'Entrez votre spécialité'
                            : null,
                      ),
                      const SizedBox(height: 15),
                      CustomTextField(
                        controller: addressController,
                        icon: Icons.location_on_outlined,
                        hintText: 'Adresse',
                        validator: (value) => value == null || value.isEmpty
                            ? 'Entrez votre adresse'
                            : null,
                      ),
                      const SizedBox(height: 15),
                      CustomTextField(
                        controller: phoneController,
                        icon: Icons.phone_outlined,
                        hintText: 'Numéro de téléphone',
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Entrez votre numéro de téléphone';
                          }
                          if (!RegExp(r'^\d{10}$').hasMatch(value)) {
                            return 'Entrez un numéro valide';
                          }
                          return null;
                        },
                      ),
                      const SizedBox(height: 15),
                      CustomTextField(
                        controller: descriptionController,
                        icon: Icons.description_outlined,
                        hintText: 'Description',
                        validator: (value) => value == null || value.isEmpty
                            ? 'Entrez une description'
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
                          'Soumettre',
                          style: TextStyle(fontSize: 20),
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
          contentPadding:
              const EdgeInsets.symmetric(vertical: 15, horizontal: 10),
        ),
        validator: validator,
      ),
    );
  }
}