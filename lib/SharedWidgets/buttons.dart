import 'package:flutter/material.dart';
import 'package:fronto_rider/constants.dart';

buildSubmitButton(String text, double radius, bool isPending) {
  return Container(
    height: 45,
    margin: EdgeInsets.symmetric(
      horizontal: 0,
    ),
    padding: EdgeInsets.symmetric(horizontal: 13),
    decoration: BoxDecoration(
      borderRadius: BorderRadius.circular(radius),
      color: isPending ? Colors.greenAccent[400] : kPrimaryColor,
    ),
    child: Center(
      child: Text(
        text,
        style: TextStyle(
          fontWeight: FontWeight.bold,
          fontSize: 14,
          color: kContainerIconColor,
        ),
      ),
    ),
  );
}

buildContainerIcon(IconData iconData) {
  return Container(
      height: 50,
      width: 50,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(100),
        color: kPrimaryColor,
      ),
      child: getIcon(iconData, 30, kContainerIconColor));
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
      height: 50,
      width: 50,
      decoration: BoxDecoration(
        image:
            DecorationImage(image: NetworkImage(imagePath), fit: BoxFit.cover),
        borderRadius: BorderRadius.circular(100),
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
