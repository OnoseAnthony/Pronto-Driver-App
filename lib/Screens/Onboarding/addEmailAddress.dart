import 'package:flutter/material.dart';
import 'package:fronto_rider/Screens/Dashboard/homeScreen.dart';
import 'package:fronto_rider/Services/firebase/auth.dart';
import 'package:fronto_rider/SharedWidgets/buttons.dart';
import 'package:fronto_rider/SharedWidgets/dialogs.dart';
import 'package:fronto_rider/SharedWidgets/text.dart';
import 'package:fronto_rider/SharedWidgets/textFormField.dart';
import 'package:fronto_rider/constants.dart';

class AddEmailAddress extends StatefulWidget {
  @override
  _AddEmailAddressState createState() => _AddEmailAddressState();
}

class _AddEmailAddressState extends State<AddEmailAddress> {
  final _formKey = GlobalKey<FormState>();
  TextEditingController _controller = TextEditingController();

  @override
  void dispose() {
    _controller.dispose();
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
                buildTitlenSubtitleText('Enter your Email Address',
                    Colors.black, 16, FontWeight.w600, TextAlign.start, null),
                SizedBox(
                  height: 40,
                ),
                buildEmailTextField(
                    'Email Address', _controller, TextInputType.emailAddress),
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
                      bool isUpdated = await AuthService()
                          .updateUserEmailAddress(
                              _controller.text.trim(), context);

                      if (isUpdated) {
                        Navigator.pop(context);

                        showToast(
                            context,
                            'Email has been updated successfully!!',
                            kPrimaryColor,
                            false);

                        Navigator.pushReplacement(
                            context,
                            MaterialPageRoute(
                                builder: (context) => HomeScreen()));
                      } else {
                        Navigator.pop(context);

                        showToast(context, 'Error occurred! Try again later',
                            kErrorColor, true);
                      }
                    }
                  },
                  child: buildSubmitButton('NEXT', 25.0, false),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
