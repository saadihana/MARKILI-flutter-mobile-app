import 'package:flutter/material.dart';
import 'package:mydoctorpage/views/screens/AllCategories.dart';
import 'package:mydoctorpage/views/screens/DoctorPageDoctorView.dart';
import 'package:mydoctorpage/views/screens/DoctorPagePatientView.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:mydoctorpage/views/screens/HomePage.dart';
import 'package:mydoctorpage/views/screens/PatientScreen.dart';
import 'views/screens/signchoose_screen/signchoose_screen.dart';
import 'package:mydoctorpage/views/screens/doc_modify_profile.dart';
import 'views/screens/signup/signUpDoctorPageOne.dart';
import 'views/screens/signup/signUpPatientPageOne.dart';
import 'views/screens/signup/signUpPatientPageTwo.dart';
import 'views/screens/signup/signUpDoctorPageTwo.dart';
import 'views/screens/login/loginDoctor.dart';
import 'views/screens/login/loginPatient.dart';
import 'package:mydoctorpage/bloc/category_bloc.dart';
import './bloc_folders/signup/signup_doctor/bloc/signup_bloc.dart';
import './bloc_folders/signup/signup_patient/bloc/signup_patient_bloc.dart';
import './bloc_folders/login/loginDoctor/bloc/login_bloc.dart' as doctor_bloc;
import './bloc_folders/login/loginPatient/bloc/login_bloc.dart' as patient_bloc;


void main() {
  runApp(const MainApp());
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(create: (_) => SignupBloc()), // Doctor signup
        BlocProvider(create: (_) => SignupPatientBloc()), // Patient signup
        BlocProvider(create: (_) => doctor_bloc.LoginBloc()), // Doctor login
        BlocProvider(create: (_) => patient_bloc.LoginBloc()), // Patient login
        BlocProvider(create: (_) => CategoryBloc()),
      ],
      child: MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        textTheme: GoogleFonts.poppinsTextTheme(),
      ),
      home: const SignChooseScreen(),
      routes: {
        // HomePage.pageRoute: (ctx) => const HomePage(),
        SignChooseScreen.pageRoute: (ctx) => const SignChooseScreen(),
        SignUpPatient.pageRoute: (ctx) => const SignUpPatient(),
        SignPatient.pageRoute: (ctx) => const SignPatient(),
        SignUpDoctor.pageRoute: (ctx) => const SignUpDoctor(),
        SignDoctor.pageRoute: (ctx) => const SignDoctor(),
        Logindoctor.pageRoute: (ctx) => const Logindoctor(),
        Loginpatient.pageRoute: (ctx) => const Loginpatient(),
        '/home': (context) => const HomePage(),
        HomePage.routeName: (context) => const HomePage(),
        '/DoctorPagePatientView': (context) => const DoctorPage(),
        '/rdv': (context) => const DoctorDoctor(),
        '/CategoryPage': (context) => const CategoryPage(),
        '/allcategories': (context) => const Allcategories(),
        '/doc_modify_profile': (context) => const DocModifyProfile(),
        '/PatientScreen': (context) => const PatientScreen(),
        '/CategoryPage': (context) => BlocProvider.value(
              value: BlocProvider.of<CategoryBloc>(context),
              child: const CategoryPage(),
            ),
      },
      ),
    );
  }
}

