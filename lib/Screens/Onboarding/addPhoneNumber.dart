import 'package:country_list_pick/country_list_pick.dart';
import 'package:flutter/material.dart';
import 'package:fronto_rider/Services/firebase/auth.dart';
import 'package:fronto_rider/SharedWidgets/buttons.dart';
import 'package:fronto_rider/SharedWidgets/dialogs.dart';
import 'package:fronto_rider/SharedWidgets/text.dart';
import 'package:fronto_rider/SharedWidgets/textFormField.dart';
import 'package:fronto_rider/constants.dart';

class AddPhoneNumber extends StatefulWidget {
  @override
  _AddPhoneNumberState createState() => _AddPhoneNumberState();
}

class _AddPhoneNumberState extends State<AddPhoneNumber> {
  final _formKey = GlobalKey<FormState>();
  var phoneDialCode = '+234';
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
                buildTitlenSubtitleText('Enter your number', Colors.black, 16,
                    FontWeight.w600, TextAlign.start, null),
                SizedBox(
                  height: 10,
                ),
                buildTitlenSubtitleText(
                    'We will send a code to verify your mobile number',
                    Colors.black54,
                    13,
                    FontWeight.normal,
                    TextAlign.start,
                    null),
                SizedBox(
                  height: 30,
                ),
                buildPhoneNumberTextField(
                    'Phone number', _controller, buildCountryDropDown()),
                SizedBox(
                  height: 100,
                ),
                InkWell(
                  onTap: () {
                    showDialog(
                        context: context,
                        barrierDismissible: false,
                        builder: (context) => NavigationLoader(context));
                    if (_formKey.currentState.validate()) {
                      final phoneNumber =
                          phoneDialCode.trim() + _controller.text.trim();
                      AuthService()
                          .createUserWithPhoneAuth(phoneNumber, context);
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

  buildCountryDropDown() {
    return Padding(
      padding: EdgeInsets.only(left: 10.0, right: 10.0),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          CountryListPick(
            appBar: AppBar(
              backgroundColor: kPrimaryColor,
              title: Text('Select Country'),
            ),

            // To disable option set to false
            theme: CountryTheme(
              isShowFlag: true,
              isShowTitle: false,
              isShowCode: true,
              isDownIcon: true,
              showEnglishName: true,
            ),
            // Set default value
            initialSelection: '+234',
            onChanged: (CountryCode code) {
              setState(() {
                phoneDialCode = code.dialCode;
              });
              print(code.name);
              print(code.code);
              print(code.dialCode);
              print(code.flagUri);
            },
          ),
          SizedBox(
            width: 2,
          ),
          Container(
            height: 25,
            child: VerticalDivider(color: Colors.grey[600], thickness: 2),
          ),
        ],
      ),
    );
  }
}
