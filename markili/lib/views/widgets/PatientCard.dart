import 'package:flutter/material.dart';
import 'package:mydoctorpage/views/themes/colors.dart';

class PatientCard extends StatefulWidget {
  final String name;
  final String img;

  const PatientCard({
    super.key,
    required this.name,
    required this.img,
    
  });

  @override
  State<PatientCard> createState() => _PatientCardState();
}

class _PatientCardState extends State<PatientCard> {
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        //color: Colors.white,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(12),
            child: Image.asset(
              widget.img,
              height: 150,
              width: 120,
              fit: BoxFit.cover,
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Text(
                  "Profile du patient",
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: dark_bleu,
                    fontSize: 24,
                  ),
                ),
                const SizedBox(height: 16),
                Text(
                  widget.name,
                  style: const TextStyle(
                    fontWeight: FontWeight.w900,
                    color: dark_bleu,
                    fontSize: 18,
                  ),
                ),
                const SizedBox(height: 16),
                Row(
                  children: [
                    IconButton(
                      padding: EdgeInsets.zero,
                      style: IconButton.styleFrom(
                        backgroundColor: dark_purple,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(20),
                        ),
                      ),
                      icon: const Icon(
                        Icons.edit,
                        color: Colors.white,
                      ),
                      onPressed: () {
                        // lead to modify patient page
                      },
                    ),
                    const SizedBox(width: 12),
                    const Expanded(
                      child: Text(
                        "Modifier mes infos",
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: dark_bleu,
                          fontSize: 14,
                        ),
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
