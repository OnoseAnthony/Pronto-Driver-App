import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fronto_rider/DataHandler/appData.dart';
import 'package:fronto_rider/Screens/Dashboard/homeScreen.dart';
import 'package:fronto_rider/Screens/Onboarding/addEmailAddress.dart';
import 'package:fronto_rider/Screens/Onboarding/verifyPhoneNumber.dart';
import 'package:fronto_rider/Services/firebase/firestore.dart';
import 'package:fronto_rider/SharedWidgets/dialogs.dart';
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
                  true) {
            //New user so we create an instance

            //create an instance of the database service to create user profile and set isDriver to true for the driver

            showToast(context, 'Authentication Successful. Please wait',
                Colors.green);

            await DatabaseService(firebaseUser: user, context: context)
                .updateUserProfileData(true, 'New', 'Driver', '');

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
            //Returning user so we check if the user is a driver: NB for this app the user must be a driver so isDriver must be true
            if (await DatabaseService(firebaseUser: user, context: context)
                .checkUserIsDriver()) {
              //returning user that's a driver, we show toast and then navigate to home screen
              showToast(context, 'Authentication Successful. Please wait',
                  Colors.green);

              //provide the user info to the provider
              Provider.of<AppData>(context, listen: false)
                  .updateFirebaseUser(user);

              //GOTO HOME SCREEN
              Navigator.pushReplacement(context,
                  MaterialPageRoute(builder: (context) => HomeScreen()));
            } else {
              Navigator.pop(context);
              Navigator.pop(context);

              //Since isDriver is false we show a dialog a toast to the user and then logout the user
              showToast(
                  context, 'Access Denied!!! Only drivers allowed', Colors.red);

              await signOut();
            }
          }
        },
        verificationFailed: (FirebaseAuthException exception) {
          print(exception);
        },
        codeSent: (String verificationID, [int forceResendingToken]) {
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
