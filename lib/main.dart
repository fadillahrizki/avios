import 'package:avios/screens/main_navigation.dart';
import 'package:avios/screens/onboarding/onboarding.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'screens/auth/login.dart';
import 'firebase_options.dart';

Future main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  await MobileAds.instance.initialize();

  runApp(const MainApp());
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: "Avios",
      initialRoute: '/startup',
      routes: {
        '/startup': (context) => const Startup(),
        '/onboarding': (context) => const OnBoardingSreen(),
        '/': (context) => const MainNavigation(),
        '/login': (context) => const Login(),
      },
    );
  }
}

class Startup extends StatefulWidget {
  const Startup({super.key});

  @override
  State<Startup> createState() => _StartupState();
}

class _StartupState extends State<Startup> {
  @override
  Widget build(BuildContext context) {
    return StreamBuilder<User?>(
      stream: FirebaseAuth.instance.authStateChanges(),
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          return const MainNavigation();
        } else {
          return const Login();
        }
      },
    );
  }
}
