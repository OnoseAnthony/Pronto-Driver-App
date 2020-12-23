import 'package:flutter/material.dart';
import 'package:fronto_rider/Screens/Onboarding/addPhoneNumber.dart';
import 'package:fronto_rider/constants.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SplashScreen extends StatelessWidget {
  bool isFirstTime;

  SplashScreen({this.isFirstTime});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: kContainerIconColor,
      body: Container(
        padding: EdgeInsets.symmetric(horizontal: 40),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            InkWell(
              onTap: () async {
                if (isFirstTime) await saveFirstTime();

                Navigator.push(context,
                    MaterialPageRoute(builder: (context) => AddPhoneNumber()));
              },
              child: Container(
                height: 52,
                margin: EdgeInsets.only(bottom: 120.0),
                padding: EdgeInsets.symmetric(horizontal: 13),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(25.0),
                  color: kPrimaryColor,
                ),
                child: Center(
                  child: Text(
                    'LETS   RIDE',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 14,
                      color: kContainerIconColor,
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }


  saveFirstTime() async {
    var sharedPreferences = await SharedPreferences.getInstance();
    sharedPreferences.setBool('isFirstTime', true);
  }
}
