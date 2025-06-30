import 'package:flutter/material.dart';
import 'package:mydoctorpage/views/themes/colors.dart';


class CategoryCard extends StatelessWidget {
  final String categoryName;
  final String description;
  final String imagePath;

  const CategoryCard({
    super.key,
    required this.categoryName,
    required this.description,
    required this.imagePath,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(32),
      ),
      elevation: 10,
      margin: const EdgeInsets.all(10.0),
      child: Center(
        child: Container(
          height: 170,
          padding: const EdgeInsets.all(16.0),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(20),
          ),
          child: Center(
            child: Row(
              children: [
                const SizedBox(width: 16),
                // Text details
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        categoryName,
                        style: const TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          color: dark_bleu,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        description,
                        style: const TextStyle(
                          fontSize: 14,
                          color: info_bleu,
                        ),
                      ),
                    ],
                  ),
                ),
                Image.asset(
                  imagePath,
                  width: 120,
                  height: 120,
                  fit: BoxFit.contain,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
