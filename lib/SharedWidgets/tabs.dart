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
    padding: EdgeInsets.symmetric(horizontal: 15),
    decoration: BoxDecoration(
        color: containerColor,
        border: Border.all(color: borderColor),
        borderRadius: BorderRadius.circular(15)),
    child: Center(
      child: Text(
        name,
        style: TextStyle(
          fontSize: 14,
          color: textColor,
          fontWeight: FontWeight.bold,
        ),
      ),
    ),
  );
}
