import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fronto_rider/DataHandler/appData.dart';
import 'package:fronto_rider/Screens/Dashboard/homeScreen.dart';
import 'package:fronto_rider/Screens/Onboarding/addEmailAddress.dart';
import 'package:fronto_rider/Services/firebase/auth.dart';
import 'package:fronto_rider/Services/firebase/firestore.dart';
import 'package:fronto_rider/SharedWidgets/buttons.dart';
import 'package:fronto_rider/SharedWidgets/dialogs.dart';
import 'package:fronto_rider/SharedWidgets/text.dart';
import 'package:fronto_rider/SharedWidgets/textFormField.dart';
import 'package:provider/provider.dart';

class VerifyPhone extends StatefulWidget {
  String phoneNumber;
  String verificationId;
  FirebaseAuth auth;

  VerifyPhone({this.phoneNumber, this.verificationId, this.auth});

  @override
  _VerifyPhoneState createState() => _VerifyPhoneState();
}

class _VerifyPhoneState extends State<VerifyPhone> {
  final _formKey = GlobalKey<FormState>();
  TextEditingController _controller = TextEditingController();
  TextEditingController _controller1 = TextEditingController();
  TextEditingController _controller2 = TextEditingController();
  TextEditingController _controller3 = TextEditingController();
  TextEditingController _controller4 = TextEditingController();
  TextEditingController _controller5 = TextEditingController();

  @override
  void dispose() {
    _controller.dispose();
    _controller1.dispose();
    _controller2.dispose();
    _controller3.dispose();
    _controller4.dispose();
    _controller5.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    double size = MediaQuery.of(context).size.height;
    return Scaffold(
      body: Container(
        padding: EdgeInsets.only(left: 40, right: 40, top: size * 0.07),
        child: SingleChildScrollView(
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                buildTitlenSubtitleText('Enter code', Colors.black, 15,
                    FontWeight.bold, TextAlign.start, null),
                SizedBox(
                  height: 10,
                ),
                Row(
                  children: [
                    buildTitlenSubtitleText(
                        'An SMS code was sent to  ',
                        Colors.black26,
                        13,
                        FontWeight.normal,
                        TextAlign.start,
                        null),
                    buildTitlenSubtitleText(widget.phoneNumber, Colors.black,
                        15, FontWeight.bold, TextAlign.start, null),
                  ],
                ),
                SizedBox(
                  height: 20,
                ),
                InkWell(
                  onTap: () {
                    Navigator.pop(context);
                  },
                  child: buildTitlenSubtitleText(
                      'Edit phone number',
                      Colors.blue,
                      13,
                      FontWeight.normal,
                      TextAlign.start,
                      null),
                ),
                SizedBox(
                  height: 30,
                ),
                Row(
                  mainAxisSize: MainAxisSize.max,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    buildVerifyPhoneNumberField(_controller, context),
                    buildVerifyPhoneNumberField(_controller1, context),
                    buildVerifyPhoneNumberField(_controller2, context),
                    buildVerifyPhoneNumberField(_controller3, context),
                    buildVerifyPhoneNumberField(_controller4, context),
                    buildVerifyPhoneNumberField(_controller5, context),
                  ],
                ),
                SizedBox(
                  height: 100,
                ),
                InkWell(
                  onTap: () async {
                    if (_formKey.currentState.validate()) {
                      showDialog(
                        context: context,
                        barrierDismissible: false,
                        builder: (context) => NavigationLoader(context),
                      );

                      final codeString = _controller.text.trim() +
                          _controller1.text.trim() +
                          _controller2.text.trim() +
                          _controller3.text.trim() +
                          _controller4.text.trim() +
                          _controller5.text.trim();
                      print(codeString);
                      AuthCredential authCredential =
                          PhoneAuthProvider.credential(
                              verificationId: widget.verificationId,
                              smsCode: codeString);

                      UserCredential result = await widget.auth
                          .signInWithCredential(authCredential);

                      User user = result.user;

                      if (user != null &&
                          await DatabaseService(
                                      firebaseUser: user, context: context)
                                  .checkUser() !=
                              true) {
                        print(
                            'New user *************************************************************************************** found');

                        //New user so we create an instance

                        //create an instance of the database service to create user profile and set isDriver to false for the customer

                        showToast(
                            context,
                            'Authentication Successful. Please wait',
                            Colors.green);

                        await DatabaseService(firebaseUser: user)
                            .updateUserProfileData(true, 'New', 'Driver', '');
                        print(user.uid);

                        //provide the user info to the provider
                        Provider.of<AppData>(context, listen: false)
                            .updateFirebaseUser(user);

                        //GOTO EMAIL SCREEN
                        Navigator.pushReplacement(
                            context,
                            MaterialPageRoute(
                                builder: (context) => AddEmailAddress()));
                      } else if (user != null &&
                          await DatabaseService(
                                      firebaseUser: user, context: context)
                                  .checkUser() ==
                              true) {
                        print(
                            'Returning user *************************************************************************************** found');

                        //Returning user so we check if the user is a driver: NB for this app the user must be a driver so isDriver must be true
                        if (await DatabaseService(
                                firebaseUser: user, context: context)
                            .checkUserIsDriver()) {
                          print(
                              'Returning user *************************************************************************************** found ***********************************and is a driver.. Logging in and sending to the home page ');

                          //returning user that's a driver, we show toast and then navigate to home screen
                          showToast(
                              context,
                              'Authentication Successful. Please wait',
                              Colors.green);

                          //provide the user info to the provider
                          Provider.of<AppData>(context, listen: false)
                              .updateFirebaseUser(user);

                          //GOTO HOME SCREEN
                          Navigator.pushReplacement(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => HomeScreen()));
                        } else {
                          print(
                              'Returning user *************************************************************************************** found ***********************************and is a customer.. Logging out  and sending back to the login page ');

                          Navigator.pop(context);
                          Navigator.pop(context);

                          //Since isDriver is true we show  a toast to the user and then logout the user
                          showToast(
                              context,
                              'Access Denied!!! Only drivers allowed',
                              Colors.red);
                          await AuthService().signOut();
                        }
                      }
                    }
                  },
                  child: buildSubmitButton('NEXT', 25, false),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
