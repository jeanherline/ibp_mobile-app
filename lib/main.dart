import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:provider/provider.dart';
import 'firebase_options.dart';
import 'package:ibp_app_ver2/screens/Konsulta/form_state_provider.dart';
import 'package:ibp_app_ver2/screens/Konsulta/applicant_profile.dart';
import 'package:ibp_app_ver2/screens/Konsulta/barangay_certificate_of_indigency.dart';
import 'package:ibp_app_ver2/screens/Konsulta/dswd_certificate_of_indigency.dart';
import 'package:ibp_app_ver2/screens/Konsulta/employment_profile.dart';
import 'package:ibp_app_ver2/screens/Konsulta/konsulta_submit.dart';
import 'package:ibp_app_ver2/screens/Konsulta/nature_of_legal_assitance_requested.dart';
import 'package:ibp_app_ver2/screens/Konsulta/pao_disqualification_letter.dart';
import 'package:ibp_app_ver2/screens/home.dart';
import 'package:ibp_app_ver2/screens/login.dart';
import 'package:ibp_app_ver2/screens/Profile/profile.dart';
import 'package:ibp_app_ver2/screens/Profile/edit_profile.dart';
import 'package:ibp_app_ver2/screens/signup.dart';
import 'package:ibp_app_ver2/screens/splash_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(
    ChangeNotifierProvider(
      create: (context) => FormStateProvider(),
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      initialRoute: '/',
      routes: {
        '/': (context) => SplashScreen(),
        '/login': (context) => const Login(),
        '/signup': (context) => const SignUp(),
        '/home': (context) => const Home(),
        '/profile': (context) => const Profile(),
        '/edit_profile': (context) => const EditProfile(),
        '/applicant_profile': (context) => const ApplicantProfile(),
        '/employment_profile': (context) => const EmploymentProfile(),
        '/nature_of_legal_assistance_requested': (context) =>
            const NatureOfLegalAssistanceRequested(),
        '/barangay_certificate_of_indigency': (context) =>
            const BarangayCertificateOfIndigency(),
        '/dswd_certificate_of_indigency': (context) =>
            const DSWDCertificateOfIndigency(),
        '/pao_disqualification_letter': (context) =>
            const PAODisqualificationLetter(),
      },
      onGenerateRoute: (settings) {
        if (settings.name == '/konsulta_submit') {
          final args = settings.arguments as String;
          return MaterialPageRoute(
            builder: (context) => KonsultaSubmit(
              controlNumber: args,
            ),
          );
        }
        assert(false, 'Need to implement ${settings.name}');
        return null;
      },
    );
  }
}
