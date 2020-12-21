import 'package:flutter/material.dart';
import 'package:fronto_rider/Screens/Dashboard/homeScreen.dart';
import 'package:fronto_rider/Screens/Onboarding/splashScreen.dart';
import 'package:fronto_rider/Services/firebase/auth.dart';

class Wrapper extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final user = AuthService().getCurrentUser();
    if (user == null)
      return SplashScreen();
    else
      return HomeScreen();
  }
}
