import 'package:animated_splash_screen/animated_splash_screen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:hessen_app/Association%20application/home%20and%20employe%20dashboard/screens/home_page.dart';
import 'package:hessen_app/Association%20application/login%20and%20register/pages/sign_up_page.dart';

class SplashPage extends StatelessWidget {
  const SplashPage({
    super.key,
  });
  static String id = 'splash';

  @override
  Widget build(BuildContext context) {
    return AnimatedSplashScreen(
      splash: Image.asset(
        'assets/images/logo.jpg',
        width: 200,
        // height: 200,
        fit: BoxFit.cover,
      ),
      splashIconSize: 200,
      nextScreen: FirebaseAuth.instance.currentUser != null
          ? const HomePage()
          : const SignUpPage(),
      splashTransition: SplashTransition.slideTransition,
    );
  }
}
