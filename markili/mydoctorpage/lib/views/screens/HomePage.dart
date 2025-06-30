import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mydoctorpage/bloc/doctor_bloc.dart';
import 'package:mydoctorpage/bloc/category_event.dart' as event;
import 'package:mydoctorpage/bloc/category_bloc.dart';
import 'package:mydoctorpage/views/widgets/doctorWidget.dart';
import 'package:mydoctorpage/views/widgets/BottomBar.dart';
import 'package:mydoctorpage/views/widgets/CategoryItem.dart';
import 'package:mydoctorpage/views/themes/colors.dart';

class HomePage extends StatefulWidget {
  static const String routeName = "/HomePage";
  const HomePage({super.key});

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  late TextEditingController _searchController;
  late FocusNode _searchFocusNode;

  @override
  void initState() {
    super.initState();
    _searchController = TextEditingController();
    _searchFocusNode = FocusNode();
  }

  @override
  void dispose() {
    _searchController.dispose();
    _searchFocusNode.dispose();
    super.dispose();
  }

  int _selectedIndex = 0;

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
      switch (index) {
        case 0:
          Navigator.pushReplacementNamed(context, '/home');
          break;
        case 1:
          Navigator.pushReplacementNamed(context, '/rdv');
          break;
        case 2:
          _searchFocusNode.requestFocus();
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

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(create: (_) => DoctorBloc()..add(FetchDoctors())),
        BlocProvider(create: (_) => CategoryBloc()),
      ],
      child: Scaffold(
        body: ListView(
          children: [
            Stack(
              children: [
                Container(
                  height: 260,
                  decoration: const BoxDecoration(
                    image: DecorationImage(
                      image: AssetImage('assets/gradient.png'),
                      fit: BoxFit.cover,
                    ),
                    borderRadius: BorderRadius.only(
                      bottomLeft: Radius.circular(50),
                      bottomRight: Radius.circular(50),
                    ),
                  ),
                ),
                Positioned(
                  top: 30,
                  left: 16,
                  right: 16,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      IconButton(
                        icon: const Icon(Icons.menu, color: dark_purple),
                        onPressed: () {},
                      ),
                      const CircleAvatar(
                        backgroundColor: Colors.white,
                        child: Icon(Icons.person, color: dark_purple),
                      ),
                    ],
                  ),
                ),
                const Positioned(
                  top: 100,
                  left: 16,
                  child: Text(
                    "Trouvez votre\nspécialiste",
                    style: TextStyle(
                      fontSize: 26,
                      fontWeight: FontWeight.bold,
                      color: dark_bleu,
                    ),
                  ),
                ),
                Positioned(
                  top: 180,
                  left: 16,
                  right: 16,
                  child: Container(
                    height: 50,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(25),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.grey.withOpacity(0.1),
                          blurRadius: 10,
                          offset: const Offset(0, 5),
                        ),
                      ],
                    ),
                    child: TextField(
                      controller: _searchController,
                      focusNode: _searchFocusNode,
                      decoration: const InputDecoration(
                        hintText: "Chercher un docteur",
                        border: InputBorder.none,
                        prefixIcon: Icon(Icons.search, color: dark_purple),
                        contentPadding: EdgeInsets.symmetric(
                          vertical: 12,
                          horizontal: 16,
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 20),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text(
                        "Catégorie",
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: dark_bleu,
                        ),
                      ),
                      GestureDetector(
                        onTap: () {
                          Navigator.pushNamed(context, '/allcategories');
                        },
                        child: const Text(
                          "Voir Tous",
                          style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.bold,
                            color: dark_purple,
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 20),
                  SizedBox(
                    height: 130,
                    child: ListView(
                      scrollDirection: Axis.horizontal,
                      children: [
                        GestureDetector(
                          onTap: () {
                            context.read<CategoryBloc>().add(
                                  const event.SelectCategory({
                                    'name': 'Cardiologie',
                                    'description':
                                        'Specialists in heart-related conditions.',
                                    'imagePath': 'assets/heart.png',
                                  }),
                                );
                            Navigator.pushNamed(context, '/CategoryPage');
                          },
                          child: CategoryItem(
                            title: 'Cardiology',
                            imagePath: 'assets/heart.png',
                            onTap: () {
                              context.read<CategoryBloc>().add(
                                    const event.SelectCategory({
                                      'name': 'Cardiologie',
                                      'description':
                                          'Specialists in heart-related conditions.',
                                      'imagePath': 'assets/heart.png',
                                    }),
                                  );
                              Navigator.pushNamed(context, '/CategoryPage');
                            },
                          ),
                        ),
                        GestureDetector(
                          onTap: () {
                            context.read<CategoryBloc>().add(
                                  const event.SelectCategory({
                                    'name': 'Dentaire',
                                    'description':
                                        'Specialists in heart-related conditions.',
                                    'imagePath': 'assets/tooth.png',
                                  }),
                                );
                            Navigator.pushNamed(context, '/CategoryPage');
                          },
                          child: CategoryItem(
                            title: 'Dentaire',
                            imagePath: 'assets/tooth.png',
                            onTap: () {
                              context.read<CategoryBloc>().add(
                                    const event.SelectCategory({
                                      'name': 'Dentaire',
                                      'description':
                                          'Specialists in heart-related conditions.',
                                      'imagePath': 'assets/tooth.png',
                                    }),
                                  );
                              Navigator.pushNamed(context, '/CategoryPage');
                            },
                          ),
                        ),
                        GestureDetector(
                          onTap: () {
                            context.read<CategoryBloc>().add(
                                  const event.SelectCategory({
                                    'name': 'Neurologie',
                                    'description':
                                        'Specialists in heart-related conditions.',
                                    'imagePath': 'assets/brain.png',
                                  }),
                                );
                            Navigator.pushNamed(context, '/CategoryPage');
                          },
                          child: CategoryItem(
                            title: 'Neurology',
                            imagePath: 'assets/brain.png',
                            onTap: () {
                              context.read<CategoryBloc>().add(
                                    const event.SelectCategory({
                                      'name': 'Neurologie',
                                      'description':
                                          'Specialists in heart-related conditions.',
                                      'imagePath': 'assets/brain.png',
                                    }),
                                  );
                              Navigator.pushNamed(context, '/CategoryPage');
                            },
                          ),
                        ),
                        GestureDetector(
                          onTap: () {
                            context.read<CategoryBloc>().add(
                                  const event.SelectCategory({
                                    'name': 'Ophtalmologie',
                                    'description':
                                        'Specialists in heart-related conditions.',
                                    'imagePath': 'assets/eye.png',
                                  }),
                                );
                            Navigator.pushNamed(context, '/CategoryPage');
                          },
                          child: CategoryItem(
                            title: 'Ophtalmologie',
                            imagePath: 'assets/eye.png',
                            onTap: () {
                              context.read<CategoryBloc>().add(
                                    const event.SelectCategory({
                                      'name': 'Ophtalmologie',
                                      'description':
                                          'Specialists in heart-related conditions.',
                                      'imagePath': 'assets/eye.png',
                                    }),
                                  );
                              Navigator.pushNamed(context, '/CategoryPage');
                            },
                          ),
                        ),
                        GestureDetector(
                          onTap: () {
                            context.read<CategoryBloc>().add(
                                  const event.SelectCategory({
                                    'name': 'Pneumologie',
                                    'description':
                                        'Specialists in heart-related conditions.',
                                    'imagePath': 'assets/lungs.png',
                                  }),
                                );
                            Navigator.pushNamed(context, '/CategoryPage');
                          },
                          child: CategoryItem(
                            title: 'Pneumologie',
                            imagePath: 'assets/lungs.png',
                            onTap: () {
                              context.read<CategoryBloc>().add(
                                    const event.SelectCategory({
                                      'name': 'Pneumologie',
                                      'description':
                                          'Specialists in heart-related conditions.',
                                      'imagePath': 'assets/lungs.png',
                                    }),
                                  );
                              Navigator.pushNamed(context, '/CategoryPage');
                            },
                          ),
                        ),

                        GestureDetector(
                          onTap: () {
                            context.read<CategoryBloc>().add(
                                  const event.SelectCategory({
                                    'name': 'Orthopediste',
                                    'description':
                                        'Specialists in heart-related conditions.',
                                    'imagePath': 'assets/bones.png',
                                  }),
                                );
                            Navigator.pushNamed(context, '/CategoryPage');
                          },
                          child: CategoryItem(
                            title: 'Orthopediste',
                            imagePath: 'assets/bones.png',
                            onTap: () {
                              context.read<CategoryBloc>().add(
                                    const event.SelectCategory({
                                      'name': 'Orthopediste',
                                      'description':
                                          'Specialists in heart-related conditions.',
                                      'imagePath': 'assets/bones.png',
                                    }),
                                  );
                              Navigator.pushNamed(context, '/CategoryPage');
                            },
                          ),
                        ),

                        GestureDetector(
                          onTap: () {
                            context.read<CategoryBloc>().add(
                                  const event.SelectCategory({
                                    'name': 'Urologie',
                                    'description':
                                        'Specialists in heart-related conditions.',
                                    'imagePath': 'assets/kidneys.png',
                                  }),
                                );
                            Navigator.pushNamed(context, '/CategoryPage');
                          },
                          child: CategoryItem(
                            title: 'Urologie',
                            imagePath: 'assets/kidneys.png',
                            onTap: () {
                              context.read<CategoryBloc>().add(
                                    const event.SelectCategory({
                                      'name': 'Urologie',
                                      'description':
                                          'Specialists in heart-related conditions.',
                                      'imagePath': 'assets/kidneys.png',
                                    }),
                                  );
                              Navigator.pushNamed(context, '/CategoryPage');
                            },
                          ),
                        ),

                        GestureDetector(
                          onTap: () {
                            context.read<CategoryBloc>().add(
                                  const event.SelectCategory({
                                    'name': 'Gastrologie',
                                    'description':
                                        'Specialists in heart-related conditions.',
                                    'imagePath': 'assets/gastro.png',
                                  }),
                                );
                            Navigator.pushNamed(context, '/CategoryPage');
                          },
                          child: CategoryItem(
                            title: 'Gastrologie',
                            imagePath: 'assets/gastro.png',
                            onTap: () {
                              context.read<CategoryBloc>().add(
                                    const event.SelectCategory({
                                      'name': 'Gastrologie',
                                      'description':
                                          'Specialists in heart-related conditions.',
                                      'imagePath': 'assets/gastro.png',
                                    }),
                                  );
                              Navigator.pushNamed(context, '/CategoryPage');
                            },
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text(
                        "Doctors",
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: dark_bleu,
                        ),
                      ),
                      GestureDetector(
                        onTap: () {},
                        child: const Icon(
                          Icons.arrow_forward_ios,
                          color: dark_bleu,
                          size: 15,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  SizedBox(
                    height: 250,
                    child: BlocBuilder<DoctorBloc, DoctorState>(
                      builder: (context, state) {
                        if (state is DoctorLoading) {
                          return const Center(
                              child: CircularProgressIndicator());
                        } else if (state is DoctorLoaded) {
                          final doctors = state.doctors;
                          return ListView.builder(
                            scrollDirection: Axis.horizontal,
                            itemCount: doctors.length,
                            itemBuilder: (context, index) {
                              final doctor = doctors[index];
                              return DoctorCard(
                                doctorName: doctor['name'] ?? 'Unknown',
                                specialty:
                                    doctor['speciality'] ?? 'No Speciality',
                                phonenumber:
                                    doctor['phonenumber'] ?? 'No Phone Number',
                                location:
                                    doctor['address'] ?? 'Unknown Address',
                                onTap: () {
                                  Navigator.pushNamed(
                                    context,
                                    '/DoctorPagePatientView',
                                    arguments: doctor,
                                  );
                                },
                              );
                            },
                          );
                        } else {
                          return const Center(
                            child: Text("Failed to load doctors"),
                          );
                        }
                      },
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
        bottomNavigationBar: BottomNavBar(
          currentIndex: _selectedIndex,
          onTap: _onItemTapped,
        ),
      ),
    );
  }
}
