import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:fronto_rider/DataHandler/appData.dart';
import 'package:fronto_rider/Models/users.dart';
import 'package:fronto_rider/Services/firebase/auth.dart';
import 'package:fronto_rider/Services/firebase/firestore.dart';
import 'package:fronto_rider/Services/firebase/pushNotificationService.dart';
import 'package:fronto_rider/Services/firebase/storage.dart';
import 'package:fronto_rider/SharedWidgets/buttons.dart';
import 'package:fronto_rider/SharedWidgets/dialogs.dart';
import 'package:fronto_rider/SharedWidgets/text.dart';
import 'package:fronto_rider/SharedWidgets/textFormField.dart';
import 'package:fronto_rider/constants.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';

class EditProfile extends StatefulWidget {
  @override
  _EditProfileState createState() => _EditProfileState();
}

class _EditProfileState extends State<EditProfile> {
  final _formKey = GlobalKey<FormState>();
  TextEditingController firstNameController = TextEditingController();
  TextEditingController lastNameController = TextEditingController();
  TextEditingController accountNumberController = TextEditingController();
  TextEditingController bankNameController = TextEditingController();
  TextEditingController bvnController = TextEditingController();

  File staticProfileImage;
  CustomUser customUser;

  @override
  void dispose() {
    super.dispose();
    firstNameController.dispose();
    lastNameController.dispose();
    accountNumberController.dispose();
    bankNameController.dispose();
    bvnController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    double size = MediaQuery.of(context).size.height;
    customUser = Provider.of<AppData>(context, listen: false).userInfo;
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
                      onTap: () async {
                        var image = await ImagePicker.pickImage(
                            source: ImageSource.gallery, imageQuality: 65);
                        setState(() {
                          staticProfileImage = image;
                        });
                      },
                      child: staticProfileImage == null &&
                              customUser != null &&
                              customUser.photoUrl != ''
                          ? Container(
                              height: 45,
                              width: 45,
                              decoration: BoxDecoration(shape: BoxShape.circle),
                              child: CachedNetworkImage(
                                imageUrl: customUser.photoUrl,
                                placeholder: (context, url) => Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: CircularProgressIndicator(
                                    valueColor: AlwaysStoppedAnimation<Color>(
                                        kPrimaryColor),
                                  ),
                                ),
                                errorWidget: (context, url, error) =>
                                    new Icon(Icons.error),
                                fit: BoxFit.cover,
                              ),
                            )
                          : staticProfileImage != null
                              ? buildContainerFileImage(
                                  staticProfileImage, Colors.grey[400])
                              : buildContainerIcon(Icons.person, kPrimaryColor),
                    ),
                    SizedBox(
                      height: 20,
                    ),
                    buildTitlenSubtitleText(
                        customUser != null
                            ? '${customUser.fName} ${customUser.lName}'
                            : 'Welcome, User',
                        Colors.black,
                        18,
                        FontWeight.w700,
                        TextAlign.center,
                        null),
                    SizedBox(
                      height: 20,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Container(
                          height: 22,
                          width: 22,
                          child: Padding(
                            padding: EdgeInsets.all(2.0),
                            child: SvgPicture.asset(
                              'assets/images/creditCard.svg',
                              semanticsLabel: 'label icon',
                            ),
                          ),
                        ),
                        SizedBox(
                          width: 10,
                        ),
                        buildTitlenSubtitleText(
                            customUser != null
                                ? 'Earnings: \u20A6${customUser.earnings}'
                                : 'Earnings: \u20A60.00',
                            Colors.black,
                            15,
                            FontWeight.normal,
                            TextAlign.center,
                            null),
                      ],
                    ),
                    SizedBox(
                      height: 50,
                    ),
                    buildTextField(
                      'First Name',
                      firstNameController,
                    ),
                    SizedBox(
                      height: 40,
                    ),
                    buildTextField(
                      'Last Name',
                      lastNameController,
                    ),
                    SizedBox(
                      height: 40,
                    ),
                    buildTextField(
                      'Account Number',
                      accountNumberController,
                    ),
                    SizedBox(
                      height: 40,
                    ),
                    buildTextField(
                      'Bank',
                      bankNameController,
                    ),
                    SizedBox(
                      height: 40,
                    ),
                    buildTextField(
                      'BVN',
                      bvnController,
                    ),
                    SizedBox(
                      height: 40,
                    ),
                    InkWell(
                      onTap: () async {
                        if (_formKey.currentState.validate() &&
                            staticProfileImage != null) {
                          showDialog(
                            context: context,
                            builder: (context) => NavigationLoader(context),
                          );

                          bool isSubmitted = await DatabaseService(
                                  firebaseUser: AuthService().getCurrentUser(),
                                  context: context)
                              .updateUserProfileData(
                                  firstNameController.text.trim() ??
                                      customUser.fName,
                                  lastNameController.text.trim() ??
                                      customUser.lName,
                                  await getAndUploadProfileImage(
                                      staticProfileImage),
                                  accountNumberController.text.trim() ??
                                      customUser.accountNumber,
                                  bankNameController.text.trim() ??
                                      customUser.bankName,
                                  bvnController.text.trim() ?? customUser.bvn,
                                  customUser.earnings,
                                  await NotificationService(context: context)
                                      .getTokenString());

                          if (isSubmitted) {
                            Navigator.pop(context);
                            showToast(context, 'profile updated successfully',
                                kPrimaryColor, false);
                          } else {
                            Navigator.pop(context);
                            showToast(
                                context,
                                'Error occurred. Try again later!!',
                                kErrorColor,
                                true);
                          }
                        } else if (_formKey.currentState.validate() &&
                            staticProfileImage == null) {
                          showDialog(
                            context: context,
                            builder: (context) => NavigationLoader(context),
                          );

                          bool isSubmitted = await DatabaseService(
                                  firebaseUser: AuthService().getCurrentUser(),
                                  context: context)
                              .updateUserProfileData(
                                  firstNameController.text.trim() ??
                                      customUser.fName,
                                  lastNameController.text.trim() ??
                                      customUser.lName,
                                  customUser.photoUrl,
                                  accountNumberController.text.trim() ??
                                      customUser.accountNumber,
                                  bankNameController.text.trim() ??
                                      customUser.bankName,
                                  bvnController.text.trim() ?? customUser.bvn,
                                  customUser.earnings,
                                  await NotificationService(context: context)
                                      .getTokenString());

                          if (isSubmitted) {
                            Navigator.pop(context);
                            showToast(context, 'profile updated successfully',
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
                      child: buildSubmitButton('SAVE', 25.0, false),
                    ),
                  ],
                ),
              ),
            ),
          ),
          getDrawerNavigator(context, size, 'Edit Profile'),
        ],
      ),
    );
  }
}
