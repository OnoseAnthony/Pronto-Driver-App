import 'package:flutter/material.dart';
import 'package:fronto_rider/SharedWidgets/buttons.dart';
import 'package:fronto_rider/SharedWidgets/text.dart';
import 'package:fronto_rider/constants.dart';

class AboutScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    double size = MediaQuery.of(context).size.height;
    String aboutText =
        'Pronto is a tech solution that connects delivery/courier service providers to customers in real-time. The app serves as a matching point for delivery service users and the closest available dispatch riders, helping to simplify and offer value added services for everyone, everywhere.';
    return Scaffold(
      backgroundColor: kWhiteColor,
      body: Stack(
        children: [
          Container(
            height: size,
            padding: EdgeInsets.only(left: 40, right: 40, top: size * 0.14),
            child: SingleChildScrollView(
              child: Column(
                children: [
                  buildTitlenSubtitleText(aboutText, Colors.black87, 14,
                      FontWeight.normal, null, null)
                ],
              ),
            ),
          ),
          getDrawerNavigator(context, size, 'About'),
        ],
      ),
    );
  }
}
