import 'package:flutter/material.dart';
import 'package:fronto_rider/SharedWidgets/buttons.dart';
import 'package:fronto_rider/SharedWidgets/text.dart';
import 'package:line_awesome_flutter/line_awesome_flutter.dart';

class EmptyScreen extends StatelessWidget {
  String screenName;

  EmptyScreen({@required this.screenName});

  @override
  Widget build(BuildContext context) {
    double size = MediaQuery.of(context).size.height;
    return Scaffold(
      body: Stack(
        children: [
          Container(),
          Positioned(
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
                      screenName == 'support' ? 'Support' : 'About',
                      Colors.black,
                      18,
                      FontWeight.w600,
                      TextAlign.start,
                      null),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
