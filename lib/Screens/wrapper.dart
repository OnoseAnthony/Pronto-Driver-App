import 'package:flutter/material.dart';
import 'package:fronto_rider/Models/users.dart';
import 'package:fronto_rider/Screens/Dashboard/homeScreen.dart';
import 'package:fronto_rider/Screens/Onboarding/addPhoneNumber.dart';
import 'package:fronto_rider/Services/firebase/auth.dart';
import 'package:fronto_rider/SharedWidgets/text.dart';
import 'package:fronto_rider/constants.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Wrapper extends StatefulWidget {
  CustomUser customUser;
  Wrapper({this.customUser});
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
    if (widget.customUser.isVerified) {
      return HomeScreen();
    }
    else
      return AwaitVerification();
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

class AwaitVerification extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: kBackgroundColor,
      body:  Container(
        padding: EdgeInsets.symmetric(horizontal: 40),
          child: Center(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Flexible(
                    flex: 2,
                    child: Container(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          buildTitlenSubtitleText(
                              'Awaiting Verification',
                              Colors.black,
                              20,
                              FontWeight.bold,
                              TextAlign.center,
                              null),
                          SizedBox(
                            height: 15,
                          ),
                          buildTitlenSubtitleText(
                              'Please visit our office to complete rider verification',
                              Color(0xff787878),
                              13,
                              FontWeight.normal,
                              TextAlign.center,
                              null),
                          buildTitlenSubtitleText(
                              'You\'d be able to accept packages and complete deliveries after successful verification',
                              Color(0xff787878),
                              13,
                              FontWeight.normal,
                              TextAlign.center,
                              null),
                        ],
                      ),
                    ),
                  ),
                ],
              ))),
    );
  }
}

