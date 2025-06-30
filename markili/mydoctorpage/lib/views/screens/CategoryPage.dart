import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mydoctorpage/bloc/category_bloc.dart';
import 'package:mydoctorpage/bloc/category_state.dart';
import 'package:mydoctorpage/views/themes/colors.dart';
import 'package:mydoctorpage/views/widgets/CategoryCard.dart';
import 'package:mydoctorpage/views/widgets/DoctorWidget.dart';
import 'package:mydoctorpage/bloc/doctor_bloc.dart';

class CategoryPage extends StatelessWidget {
  const CategoryPage({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(create: (_) => DoctorBloc()..add(FetchDoctors())),
        // BlocProvider(create: (_) => CategoryBloc()..add(SelectCategory())),
      ],
      child: BlocBuilder<CategoryBloc, CategoryState>(
        builder: (context, currentState) {
          if (currentState is CategorySelected) {
            final categoryName =
                currentState.selectedCategory['name'] ?? 'Unknown';
            final description =
                currentState.selectedCategory['description'] ?? '';
            final imagePath = currentState.selectedCategory['imagePath'] ?? '';

            return Scaffold(
              appBar: AppBar(
                title: Text(categoryName),
                backgroundColor: Colors.white,
              ),
              body: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    CategoryCard(
                      categoryName: categoryName,
                      description: description,
                      imagePath: imagePath,
                    ),
                    const SizedBox(height: 16),
                    const Text(
                      "Doctors in this Category",
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: dark_bleu,
                      ),
                    ),
                    const SizedBox(height: 16),
                    Expanded(
                      child: BlocBuilder<DoctorBloc, DoctorState>(
                        builder: (context, doctorState) {
                          if (doctorState is DoctorLoading) {
                            return const Center(
                                child: CircularProgressIndicator());
                          } else if (doctorState is DoctorLoaded) {
                            final doctors = doctorState.doctors
                                .where((doctor) =>
                                    doctor['speciality'] == categoryName)
                                .toList();
                            if (doctors.isEmpty) {
                              return const Center(
                                  child: Text(
                                      "No doctors available in this category."));
                            }
                            return ListView.builder(
                              itemCount: doctors.length,
                              itemBuilder: (context, index) {
                                final doctor = doctors[index];
                                return DoctorCard(
                                  doctorName: doctor['name'] ?? 'Unknown',
                                  specialty:
                                      doctor['speciality'] ?? 'No Specialty',
                                  phonenumber: doctor['phonenumber'] ??
                                      'No Phone Number',
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
                                child: Text("Failed to load doctors"));
                          }
                        },
                      ),
                    ),
                  ],
                ),
              ),
            );
          }
          return const Scaffold(
            body: Center(child: CircularProgressIndicator()),
          );
        },
      ),
    );
  }
}
