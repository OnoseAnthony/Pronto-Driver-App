import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:fronto_rider/SharedWidgets/text.dart';
import 'package:fronto_rider/constants.dart';
import 'package:line_awesome_flutter/line_awesome_flutter.dart';

buildSubmitButton(String text, double radius, bool isPending) {
  return Container(
    height: 45,
    margin: EdgeInsets.symmetric(
      horizontal: 0,
    ),
    padding: EdgeInsets.symmetric(horizontal: 13),
    decoration: BoxDecoration(
      borderRadius: BorderRadius.circular(radius),
      color: isPending ? Color(0xFF27AE60) : kPrimaryColor,
    ),
    child: Center(
      child: Text(
        text,
        style: TextStyle(
          fontWeight: FontWeight.bold,
          fontSize: 14,
          color: kWhiteColor,
        ),
      ),
    ),
  );
}

buildContainerIcon(IconData iconData, Color color) {
  return Container(
      height: 50,
      width: 50,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(100),
        color: color,
      ),
      child: getIcon(iconData, 30, kWhiteColor));
}

getIcon(IconData iconData, double size, Color color) {
  return Icon(
    iconData,
    size: size,
    color: color,
  );
}

buildContainerImage(String imagePath) {
  if (imagePath != null)
    return Container(
      height: 40,
      width: 40,
      decoration:
          BoxDecoration(shape: BoxShape.circle, color: Colors.grey[400]),
      child: CachedNetworkImage(
        height: 40,
        width: 40,
        imageUrl: imagePath,
        placeholder: (context, url) => CircularProgressIndicator(
          valueColor: AlwaysStoppedAnimation<Color>(kPrimaryColor),
        ),
        errorWidget: (context, url, error) => new Icon(Icons.error),
        fit: BoxFit.cover,
      ),
    );
  else
    return Container(
      height: 35,
      width: 35,
      decoration: BoxDecoration(
        color: Colors.grey[400],
        borderRadius: BorderRadius.circular(100),
      ),
    );
}

buildContainerFileImage(File imagePath, Color color) {
  if (imagePath != null)
    return Container(
      height: 50,
      width: 50,
      decoration: BoxDecoration(
        image: DecorationImage(image: FileImage(imagePath), fit: BoxFit.cover),
        borderRadius: BorderRadius.circular(100),
      ),
    );
  else
    return Container(
      height: 35,
      width: 35,
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(100),
      ),
    );
}

buildStreamBuilderNullContainer() {
  return Container(
      child: Center(
          child: Container(
    height: 80,
    decoration: BoxDecoration(
      borderRadius: BorderRadius.circular(5),
      color: kPrimaryColor,
    ),
    child: Padding(
      padding:
          const EdgeInsets.only(top: 8.0, bottom: 8.0, left: 40, right: 20),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        children: <Widget>[
          Icon(
            Icons.info,
            color: kWhiteColor,
            size: 30,
          ),
          SizedBox(
            width: 20,
          ),
          buildTitlenSubtitleText('ERROR!!!', kWhiteColor, 14, FontWeight.bold,
              TextAlign.center, null),
        ],
      ),
    ),
  )));
}

buildNullFutureBuilderStream(context, label) {
  return Container(
      child: Center(
          child: Column(
    crossAxisAlignment: CrossAxisAlignment.center,
    children: [
      Flexible(
        flex: 2,
        child: Container(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              buildTitlenSubtitleText(
                  label == 'package'
                      ? 'No Package'
                      : label == 'notification'
                          ? 'No Notification'
                          : 'No Promotion',
                  Colors.black,
                  20,
                  FontWeight.bold,
                  TextAlign.center,
                  null),
              SizedBox(
                height: 15,
              ),
              buildTitlenSubtitleText(
                  label == 'package'
                      ? 'You do not have any package'
                      : label == 'notification'
                          ? 'You do not have any notification'
                          : 'No recent promotion',
                  Color(0xff787878),
                  13,
                  FontWeight.normal,
                  TextAlign.center,
                  null),
              label != 'promotion'
                  ? buildTitlenSubtitleText(
                      'Tap the button to send a package and receive notifications',
                      Color(0xff787878),
                      13,
                      FontWeight.normal,
                      TextAlign.center,
                      null)
                  : SizedBox(),
              label != 'promotion'
                  ? SizedBox(
                      height: 30,
                    )
                  : SizedBox(),
              label != 'promotion'
                  ? Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 40),
                      child: InkWell(
                        onTap: () {
                          Navigator.pop(context);
                        },
                        child: buildSubmitButton('SEND ITEM', 25.0, false),
                      ),
                    )
                  : SizedBox(),
            ],
          ),
        ),
      ),
    ],
  )));
}

buildStreamBuilderLoader() {
  return Container(
    child: Center(
      child: Container(
        height: 80,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(5),
          color: kPrimaryColor,
        ),
        child: Padding(
          padding: EdgeInsets.only(top: 8.0, bottom: 8.0, left: 40, right: 20),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: <Widget>[
              SpinKitWanderingCubes(
                color: kWhiteColor,
                size: 30.0,
              ),
              SizedBox(
                width: 30,
              ),
              buildTitlenSubtitleText('please wait a moment...', kWhiteColor,
                  14, FontWeight.bold, TextAlign.center, null),
            ],
          ),
        ),
      ),
    ),
  );
}

getDrawerNavigator(context, double size, String title) {
  return Positioned(
    top: size * 0.07,
    left: 15.0,
    child: InkWell(
      onTap: () {
        Navigator.pop(context);
      },
      child: Row(
        children: [
          getIcon(LineAwesomeIcons.times, 20, Colors.black),
          SizedBox(
            width: 25,
          ),
          buildTitlenSubtitleText(
              title, Colors.black, 18, FontWeight.w600, TextAlign.start, null),
        ],
      ),
    ),
  );
}
