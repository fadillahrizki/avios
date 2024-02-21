import 'package:flutter/material.dart';
import '../../components/custom_button.dart';
import '../../constants/custom_color.dart';
import '../../services/firebase_service.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Login extends StatefulWidget {
  const Login({super.key});

  @override
  State<Login> createState() => _LoginState();
}

class _LoginState extends State<Login> {
  final Future<SharedPreferences> _prefs = SharedPreferences.getInstance();
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();

  @override
  void initState() {
    super.initState();
    checkOnBoarding();
  }

  void checkOnBoarding() async {
    final SharedPreferences prefs = await _prefs;
    final bool onBoardingIs = prefs.getBool('onBoarding') ?? false;
    if (onBoardingIs == false) {
      Navigator.pushReplacementNamed(context, '/onboarding');
      return;
    }
  }

  google() async {
    try {
      await FirebaseService.signInWithGoogle();
      if (context.mounted) {
        Navigator.pushReplacementNamed(context, '/');
      }
    } catch (e) {
      print(e);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: CustomColor().background,
      body: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Center(
              child: Text(
                'Avios',
                style: TextStyle(
                  fontSize: 24,
                  color: CustomColor().primary,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            const SizedBox(height: 12),
            Center(
              child: Text(
                'Simple Task Management Application',
                style: TextStyle(
                  fontSize: 16,
                  color: CustomColor().primary,
                ),
              ),
            ),
            const SizedBox(height: 24),
            CustomButton(
              onPressed: () {
                google();
              },
              label: 'Sign In with Google',
              type: 'secondary',
            ),
          ],
        ),
      ),
    );
  }
}
