import 'package:flutter/material.dart';
import 'package:fronto_rider/Services/firebase/auth.dart';
import 'package:fronto_rider/Services/firebase/firestore.dart';
import 'package:fronto_rider/SharedWidgets/buttons.dart';
import 'package:fronto_rider/SharedWidgets/customListTile.dart';
import 'package:fronto_rider/SharedWidgets/dialogs.dart';
import 'package:fronto_rider/SharedWidgets/text.dart';
import 'package:fronto_rider/SharedWidgets/textFormField.dart';
import 'package:fronto_rider/constants.dart';
import 'package:url_launcher/url_launcher.dart';

class SupportScreen extends StatefulWidget {
  @override
  _SupportScreenState createState() => _SupportScreenState();
}

class _SupportScreenState extends State<SupportScreen> {
  TextEditingController titleController = TextEditingController();
  TextEditingController descriptionController = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  @override
  void dispose() {
    super.dispose();
    titleController.dispose();
    descriptionController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    double size = MediaQuery.of(context).size.height;
    return Scaffold(
      backgroundColor: kWhiteColor,
      body: Stack(
        children: [
          Container(
            height: size,
            padding: EdgeInsets.only(left: 40, right: 40, top: size * 0.14),
            child: SingleChildScrollView(
              child: Form(
                key: _formKey,
                child: Column(
                  children: [
                    InkWell(
                      onTap: () {
                        launch("mailto:support@pronto.com");
                      },
                      child: buildCustomListTile(
                          buildContainerIcon(Icons.person, kPrimaryColor),
                          buildTitlenSubtitleText(
                              'support@pronto.com',
                              Colors.black,
                              14,
                              FontWeight.w700,
                              TextAlign.center,
                              null),
                          null,
                          15.0,
                          false),
                    ),
                    SizedBox(
                      height: 30,
                    ),
                    buildEmailTextField(
                        'Complaint Title', titleController, TextInputType.text),
                    SizedBox(
                      height: 30,
                    ),
                    buildEmailTextField('Complaint Description',
                        descriptionController, TextInputType.multiline),
                    SizedBox(
                      height: 70,
                    ),
                    InkWell(
                      onTap: () async {
                        if (_formKey.currentState.validate()) {
                          showDialog(
                            context: context,
                            builder: (context) => NavigationLoader(context),
                          );
                          bool isSubmitted = await DatabaseService(
                                  firebaseUser: AuthService().getCurrentUser(),
                                  context: context)
                              .submitQuery(titleController.text.trim(),
                                  descriptionController.text.trim());

                          if (isSubmitted) {
                            Navigator.pop(context);
                            showToast(context, 'Query submitted successfully',
                                kPrimaryColor, false);
                          } else {
                            Navigator.pop(context);
                            showToast(
                                context,
                                'Error occurred. Try again later!!',
                                kErrorColor,
                                true);
                          }
                        }
                      },
                      child: buildSubmitButton('SEND', 25.0, false),
                    ),
                  ],
                ),
              ),
            ),
          ),
          getDrawerNavigator(context, size, 'Support'),
        ],
      ),
    );
  }
}
