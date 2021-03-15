import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fronto_rider/DataHandler/appData.dart';
import 'package:fronto_rider/Models/users.dart';
import 'package:fronto_rider/Screens/Dashboard/drawerScreens/editProfile.dart';
import 'package:fronto_rider/Screens/wrapper.dart';
import 'package:fronto_rider/Services/firebase/auth.dart';
import 'package:fronto_rider/Services/firebase/firestore.dart';
import 'package:fronto_rider/Services/firebase/pushNotificationService.dart';
import 'package:fronto_rider/SharedWidgets/buttons.dart';
import 'package:fronto_rider/SharedWidgets/dialogs.dart';
import 'package:fronto_rider/SharedWidgets/text.dart';
import 'package:fronto_rider/SharedWidgets/textFormField.dart';
import 'package:fronto_rider/constants.dart';
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
                      Color(0xFF27AE60),
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
                              true &&
                          await DatabaseService(
                                      firebaseUser: user, context: context)
                                  .checkCustomer() !=
                              true) {
                        //New user so we create an instance

                        //create an instance of the database service to create user profile and set isDriver to false for the customer

                        showToast(
                            context,
                            'Authentication Successful. Please wait',
                            kPrimaryColor,
                            false);


                        //provide the user info to the provider
                        Provider.of<AppData>(context, listen: false)
                            .updateFirebaseUser(user);

                        //GOTO PROFILE SCREEN
                        Navigator.pushReplacement(context,
                            MaterialPageRoute(builder: (context) => EditProfile(isFromAuth: true)));
                      } else if (user != null &&
                          await DatabaseService(
                                      firebaseUser: user, context: context)
                                  .checkUser() ==
                              true) {
                        CustomUser _customUser = await DatabaseService(
                                firebaseUser: AuthService().getCurrentUser(),
                                context: context)
                            .getCustomUserData();

                        await DatabaseService(
                                firebaseUser: AuthService().getCurrentUser(),
                                context: context)
                            .updateUserProfileData(
                                _customUser.fName,
                                _customUser.lName,
                                _customUser.photoUrl,
                                _customUser.accountNumber,
                                _customUser.bankName,
                                _customUser.bvn,
                                _customUser.earnings,
                                await NotificationService(context: context)
                                    .getTokenString());

                        //returning user that's a driver, we show toast and then navigate to home screen
                        showToast(
                            context,
                            'Authentication Successful. Please wait',
                            kPrimaryColor,
                            false);

                        //provide the user info to the provider
                        Provider.of<AppData>(context, listen: false)
                            .updateFirebaseUser(user);


                        //check if user has profile set up
                        if (_customUser == null)
                          //GOTO PROFILE SCREEN
                          Navigator.pushReplacement(context,
                              MaterialPageRoute(builder: (context) => EditProfile(isFromAuth: true)));
                        else
                          //GOTO HOME SCREEN
                        Navigator.pushReplacement(
                            context,
                            MaterialPageRoute(
                                builder: (context) => Wrapper(customUser: _customUser,)));
                      } else if (user != null &&
                          await DatabaseService(
                                      firebaseUser: user, context: context)
                                  .checkCustomer() ==
                              true) {

                        //Since user is found in the customer collection and we are on the driver app we assume they want to register as drivers and create a rider profile for them with their customer data access
                        showToast(context, 'Authentication Successful. Please wait',
                            kPrimaryColor, false);

                        //provide the user info to the provider
                        Provider.of<AppData>(context, listen: false)
                            .updateFirebaseUser(user);

                        //GOTO PROFILE SCREEN
                        Navigator.pushReplacement(context,
                            MaterialPageRoute(builder: (context) => EditProfile(isFromAuth: true)));
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
