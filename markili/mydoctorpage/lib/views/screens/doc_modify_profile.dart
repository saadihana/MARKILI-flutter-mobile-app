import 'package:flutter/material.dart';
import 'package:mydoctorpage/views/themes/colors.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class DocModifyProfile extends StatefulWidget {
  const DocModifyProfile({Key? key}) : super(key: key);

  @override
  _DocModifyProfileState createState() => _DocModifyProfileState();
}

class _DocModifyProfileState extends State<DocModifyProfile> {
  final TextEditingController _phoneController = TextEditingController();
  final TextEditingController _locationController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _specialityController = TextEditingController();
  
  bool _isLoading = true;
  final int doctorId = 2; // temporary default doctor 
  
  @override
  void initState() {
    super.initState();
    _fetchDoctorProfile();
  }

  Future<void> _fetchDoctorProfile() async {
    try {
      final response = await http.get(
        Uri.parse('http://localhost:5001/doctors/$doctorId'),
      );

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        setState(() {
          _nameController.text = data['surname'] ?? '';
          _specialityController.text = data['speciality'] ?? '';
          _phoneController.text = data['phonenumber'] ?? '';
          _locationController.text = data['address'] ?? '';
          _emailController.text = data['email'] ?? '';
          _descriptionController.text = data['description'] ?? '';
          _isLoading = false;
        });
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Failed to load doctor profile'),
            backgroundColor: Colors.red,
          ),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Error connecting to server'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  Future<void> _saveProfile() async {
    if (!_validateInputs()) return;

    try {
      final response = await http.put(
        Uri.parse('http://localhost:5001/doctors/$doctorId'),
        headers: {'Content-Type': 'application/json'},
        body: json.encode({
          'surname': _nameController.text,
          'speciality': _specialityController.text,
          'phonenumber': _phoneController.text,
          'address': _locationController.text,
          'email': _emailController.text,
          'description': _descriptionController.text,
        }),
      );

      if (response.statusCode == 200) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Profile Updated Successfully')),
        );
        Navigator.pop(context);
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Failed to update profile'),
            backgroundColor: Colors.red,
          ),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Error connecting to server'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  bool _validateInputs() {
    if (_phoneController.text.isEmpty ||
        _locationController.text.isEmpty ||
        _emailController.text.isEmpty ||
        _nameController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Please fill all fields'),
          backgroundColor: Colors.red,
        ),
      );
      return false;
    }
    return true;
  }

  @override
  void dispose() {
    _phoneController.dispose();
    _locationController.dispose();
    _emailController.dispose();
    _descriptionController.dispose();
    _nameController.dispose();
    _specialityController.dispose();
    super.dispose();
  }

  Widget _buildTextField(String label, TextEditingController controller) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
            color: dark_purple,
          ),
        ),
        const SizedBox(height: 5),
        Container(
          width: 250,
          child: TextField(
            controller: controller,
            decoration: InputDecoration(
              hintStyle: const TextStyle(color: Colors.grey),
              filled: true,
              fillColor: Colors.white,
              contentPadding: const EdgeInsets.symmetric(vertical: 1, horizontal: 10),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: BorderSide.none,
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildIconTextField(
      IconData icon, TextEditingController controller, String placeholder) {
    return Row(
      children: [
        Container(
          margin: EdgeInsets.only(right: 20),
          decoration: BoxDecoration(
            color: dark_purple,
            borderRadius: BorderRadius.circular(20),
          ),
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Icon(icon, color: Colors.white),
          ),
        ),
        Expanded(
          child: TextField(
            controller: controller,
            decoration: InputDecoration(
              fillColor: Colors.white,
              filled: true,
              hintText: placeholder,
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: const BorderSide(color: Colors.white, width: 1),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: const BorderSide(color: Colors.white, width: 2),
              ),
            ),
          ),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Navigator.of(context).pop(),
        ),
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      body: Container(
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
        padding: const EdgeInsets.fromLTRB(40, 16, 25, 16),
        child: _isLoading
            ? Center(child: CircularProgressIndicator())
            : ListView(
                children: [
                  Expanded(
                    child: Row(
                      children: [
                        Expanded(
                          flex: 4,
                          child: ClipRRect(
                              borderRadius: BorderRadius.circular(12),
                              child: Image.asset(
                                  '/doctor_default_background.png',
                                  height: 180,
                                  width: 110,
                                  fit: BoxFit.cover)),
                        ),
                        const SizedBox(width: 20),
                        Expanded(
                          flex: 5,
                          child: Column(
                            children: [
                              _buildTextField('Nom', _nameController),
                              const SizedBox(height: 10),
                              _buildTextField('Specialité', _specialityController), // Fixed here
                            ],
                          ),
                        )
                      ],
                    ),
                  ),
                  const SizedBox(height: 40),
                  _buildIconTextField(
                      Icons.phone, _phoneController, "numero de telephone"),
                  const SizedBox(height: 16),
                  _buildIconTextField(Icons.location_on, _locationController,
                      "entrer votre localisation"),
                  const SizedBox(height: 16),
                  _buildIconTextField(
                      Icons.email, _emailController, "entrer votre email"),
                  const SizedBox(height: 24),
                  const Text(
                    "Description",
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: dark_purple,
                    ),
                  ),
                  const SizedBox(height: 7),
                  TextField(
                    controller: _descriptionController,
                    maxLines: 5,
                    decoration: InputDecoration(
                      fillColor: Colors.white,
                      filled: true,
                      hintText: "entrer une description qui vous represente",
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: const BorderSide(color: Colors.white, width: 1),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: const BorderSide(color: Colors.white, width: 2),
                      ),
                    ),
                  ),
                  const SizedBox(height: 22),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.grey[300],
                          foregroundColor: Colors.black,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                        ),
                        onPressed: () => Navigator.pop(context),
                        child: const Text("Annuler"),
                      ),
                      const SizedBox(width: 15),
                      ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: dark_purple,
                          foregroundColor: Colors.white,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                        ),
                        onPressed: _saveProfile,
                        child: const Text("Modifier"),
                      ),
                    ],
                  ),
                ],
              ),
      ),
    );
  }
}