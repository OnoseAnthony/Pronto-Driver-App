import 'package:flutter/material.dart';

createTabBarElement(
  String name,
  Color containerColor,
  Color borderColor,
  Color textColor,
  double width,
) {
  return Container(
    height: 30,
    width: width,
    padding: EdgeInsets.symmetric(horizontal: 10),
    decoration: BoxDecoration(
        color: containerColor,
        border: Border.all(color: borderColor),
        borderRadius: BorderRadius.circular(15)),
    child: Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        Text(
          name,
          style: TextStyle(
            fontSize: 14,
            color: textColor,
            fontWeight: FontWeight.bold,
          ),
        ),
      ],
    ),
  );
}
