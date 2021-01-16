import 'package:flutter/material.dart';

buildCustomListTile(Widget firstWidget, Widget secondWidget, Widget thirdWidget,
    double width, bool isThirdWidget) {
  return Row(
    crossAxisAlignment: CrossAxisAlignment.center,
    children: [
      firstWidget,
      SizedBox(
        width: width,
      ),
      secondWidget,
      isThirdWidget ? Spacer() : Container(),
      isThirdWidget ? thirdWidget : Container(),
    ],
  );
}
