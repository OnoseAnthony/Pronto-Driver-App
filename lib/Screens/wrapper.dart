import 'package:flutter/material.dart';
import 'package:fronto_rider/Screens/Dashboard/homeScreen.dart';
import 'package:fronto_rider/Screens/Onboarding/addPhoneNumber.dart';
import 'package:fronto_rider/Screens/Onboarding/splashScreen.dart';
import 'package:fronto_rider/Services/firebase/auth.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Wrapper extends StatefulWidget {
  @override
  _WrapperState createState() => _WrapperState();
}

class _WrapperState extends State<Wrapper> {
  SharedPreferences sharedPreferences;
  bool userFirstTime = true;

  @override
  void initState() {
    super.initState();
    initSharedPreferences();
  }

  @override
  Widget build(BuildContext context) {
    final user = AuthService().getCurrentUser();
    if (user == null) {
      if (userFirstTime)
        return SplashScreen(isFirstTime: userFirstTime);
      else
        return AddPhoneNumber();
    } else
      return HomeScreen();
  }

  initSharedPreferences() async {
    sharedPreferences = await SharedPreferences.getInstance();
    final isFirstTime = sharedPreferences.getBool('isFirstTime');
    if (isFirstTime != null)
      setState(() {
        userFirstTime = false;
      });
  }
}
