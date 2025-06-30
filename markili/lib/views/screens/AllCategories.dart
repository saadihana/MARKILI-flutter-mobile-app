import 'package:flutter/material.dart';
import 'package:mydoctorpage/views/widgets/BottomBar.dart';
import 'package:mydoctorpage/views/widgets/CategoryItem.dart';

class Allcategories extends StatefulWidget {
  const Allcategories({super.key});

  @override
  _AllcategoriesState createState() => _AllcategoriesState();
}

class _AllcategoriesState extends State<Allcategories> {
  int _selectedIndex = 0;

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
      // Navigation logic here
      switch (index) {
        case 0:
          Navigator.pushReplacementNamed(context, '/home');
          break;
        case 1:
          Navigator.pushReplacementNamed(context, '/rdv');
          break;
        case 2:
          Navigator.pushReplacementNamed(context, '/searchDoctor');
          break;
        case 3:
          Navigator.pushReplacementNamed(context, '/notifications');
          break;
        case 4:
          Navigator.pushReplacementNamed(context, '/settings');
          break;
      }
    });
  }

  void _onCategoryPage() {
    print("Navigating to Category Page");
    Navigator.pushNamed(context, '/CategoryPage');
  }

  @override
  Widget build(BuildContext context) {
    // Dummy categories data
    final categories = [
      {'title': 'Dentaire', 'imagePath': 'assets/tooth.png' , 'onTap': '/CategoryPage'},
      {'title': 'Cardiologie', 'imagePath': 'assets/heart.png', 'onTap': '/CategoryHeartPage'},
      {'title': 'Ophtalmologie', 'imagePath': 'assets/eye.png', 'onTap': '/CategoryEyePage'},
      {'title': 'Neurologie', 'imagePath': 'assets/brain.png', 'onTap': '/CategoryBrainPage'},
      {'title': 'Orthopidiste', 'imagePath': 'assets/bones.png', 'onTap': '/CategoryBonesPage'},
      {'title': 'Eurologie', 'imagePath': 'assets/kidneys.png', 'onTap': '/CategoryKidneysPage'},
      {'title': 'Gastronomie', 'imagePath': 'assets/gastro.png', 'onTap': '/CategoryGastroPage'},
      {'title': 'Pneumologie', 'imagePath': 'assets/lungs.png', 'onTap': '/CategoryPneumoPage'},
      {'title': 'Genecologie', 'imagePath': 'assets/geneco.png'},
      {'title': 'Radiologie', 'imagePath': 'assets/radio.png'},
      {'title': 'ORL', 'imagePath': 'assets/orl.png'},
      {'title': 'Endocrinologuie', 'imagePath': 'assets/endocrino.png'},
    ];

    return Scaffold(
      appBar: AppBar(
        title: const Text('All Categories'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: GridView.builder(
          itemCount: categories.length,
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 3,
            crossAxisSpacing: 16.0,
            mainAxisSpacing: 16.0,
          ),
          itemBuilder: (context, index) {
            final category = categories[index];
            return CategoryItem(
              title: category['title']!,
              imagePath: category['imagePath']!,
              onTap: _onCategoryPage,
            );
          },
        ),
      ),
      bottomNavigationBar: BottomNavBar(
        currentIndex: _selectedIndex,
        onTap: _onItemTapped,
      ),
    );
  }
}
