import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fronto_rider/DataHandler/appData.dart';
import 'package:fronto_rider/Models/users.dart';
import 'package:fronto_rider/Screens/Onboarding/addEmailAddress.dart';
import 'package:fronto_rider/Screens/Onboarding/verifyPhoneNumber.dart';
import 'package:fronto_rider/Screens/wrapper.dart';
import 'package:fronto_rider/Services/firebase/firestore.dart';
import 'package:fronto_rider/Services/firebase/pushNotificationService.dart';
import 'package:fronto_rider/SharedWidgets/dialogs.dart';
import 'package:fronto_rider/constants.dart';
import 'package:provider/provider.dart';

class AuthService {
  final FirebaseAuth auth = FirebaseAuth.instance;

  Future createUserWithPhoneAuth(
      String phoneNumber, BuildContext context) async {
    auth.verifyPhoneNumber(
        phoneNumber: phoneNumber,
        timeout: Duration(seconds: 60),
        verificationCompleted: (AuthCredential credential) async {
          Navigator.pop(context);

          showDialog(
            context: context,
            barrierDismissible: false,
            builder: (context) => NavigationLoader(context),
          );

          UserCredential result = await auth.signInWithCredential(credential);

          User user = result.user;

          if (user != null &&
              await DatabaseService(firebaseUser: user, context: context)
                      .checkUser() !=
                  true &&
              await DatabaseService(firebaseUser: user, context: context)
                      .checkCustomer() !=
                  true) {
            //New user so we create an instance

            //create an instance of the database service to create user profile and set isDriver to true for the driver

            showToast(context, 'Authentication Successful. Please wait',
                kPrimaryColor, false);

            await DatabaseService(firebaseUser: user, context: context)
                .updateUserProfileData(
                    'New',
                    'Rider',
                    '',
                    '',
                    '',
                    '',
                    '0.00',
                    await NotificationService(context: context)
                        .getTokenString());

            //provide the user info to the provider
            Provider.of<AppData>(context, listen: false)
                .updateFirebaseUser(user);

            //GOTO EMAIL SCREEN
            Navigator.pushReplacement(context,
                MaterialPageRoute(builder: (context) => AddEmailAddress()));
          } else if (user != null &&
              await DatabaseService(firebaseUser: user, context: context)
                      .checkUser() ==
                  true) {
            CustomUser _customUser = await DatabaseService(
                    firebaseUser: getCurrentUser(), context: context)
                .getCustomUserData();

            await DatabaseService(
                    firebaseUser: getCurrentUser(), context: context)
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
            showToast(context, 'Authentication Successful. Please wait',
                kPrimaryColor, false);

            //provide the user info to the provider
            Provider.of<AppData>(context, listen: false)
                .updateFirebaseUser(user);

            //check if user has email set up
            if (getCurrentUser().email == null)
              Navigator.pushReplacement(context,
                  MaterialPageRoute(builder: (context) => AddEmailAddress()));
            else
              //GOTO HOME SCREEN
              Navigator.pushReplacement(
                  context, MaterialPageRoute(builder: (context) => Wrapper()));
          } else if (user != null &&
              await DatabaseService(firebaseUser: user, context: context)
                      .checkCustomer() ==
                  true) {
            Navigator.pop(context);

            //Since user is found in the customer collection and we are on the driver app we revoke access
            showToast(context, 'Access Denied!!! Only drivers allowed',
                kErrorColor, true);

            await signOut();
          }
        },
        verificationFailed: (FirebaseAuthException exception) {
          Navigator.pop(context);
          showToast(context, 'Authentication Failed. Try again Later',
              kErrorColor, true);
        },
        codeSent: (String verificationID, [int forceResendingToken]) {
          //pop the dialog before navigating
          Navigator.pop(context);
          //NAVIGATE TO THE SCREEN WHERE THEY CAN ENTER THE CODE SENT
          Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) => VerifyPhone(
                        phoneNumber: phoneNumber,
                        verificationId: verificationID,
                        auth: auth,
                      )));
        },
        codeAutoRetrievalTimeout: (String verificationId) {});
  }

  Future<bool> updateUserEmailAddress(String emailAddress, context) async {
    User user = auth.currentUser;
    if (user != null)
      try {
        await user.updateEmail(emailAddress);
        Provider.of<AppData>(context, listen: false).updateFirebaseUser(user);
        return Future.value(true);
      } catch (e) {
        return Future.value(false);
      }
  }

  User getCurrentUser() {
    return auth.currentUser;
  }

  Future<bool> signOut() async {
    User user = auth.currentUser;
    if (user != null)
      try {
        await auth.signOut();
        return Future.value(true);
      } catch (e) {
        return Future.value(false);
      }
  }
}
