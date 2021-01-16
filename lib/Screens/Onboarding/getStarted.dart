import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:fronto_rider/Screens/wrapper.dart';
import 'package:fronto_rider/Services/firebase/pushNotificationService.dart';
import 'package:fronto_rider/SharedWidgets/buttons.dart';
import 'package:fronto_rider/SharedWidgets/text.dart';
import 'package:fronto_rider/constants.dart';

class GetStarted extends StatefulWidget {
  @override
  _GetStartedState createState() => _GetStartedState();
}

class _GetStartedState extends State<GetStarted> {
  void initState() {
    super.initState();
    getNotificationService(context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: kBackgroundColor,
      body: Stack(
        fit: StackFit.expand,
        children: [
          Container(
            decoration: BoxDecoration(color: kWhiteColor),
          ),
          Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Flexible(
                flex: 2,
                child: Container(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      SizedBox(
                        height: 100,
                      ),
                      CircleAvatar(
                        backgroundColor: kWhiteColor,
                        radius: 120.0,
                        child: SvgPicture.asset(
                          'assets/images/getStarted.svg',
                          semanticsLabel: 'Get Started Logo',
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.only(left: 80, right: 80),
                        child: buildTitlenSubtitleText(
                            'Ride and Earn with Pronto Logistics.',
                            Color(0xFF555555),
                            12,
                            FontWeight.normal,
                            TextAlign.center,
                            null),
                      ),
                      SizedBox(
                        height: 60,
                      ),
                      InkWell(
                        onTap: () {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => Wrapper()));
                        },
                        child: Padding(
                          padding: EdgeInsets.only(left: 40, right: 40),
                          child: buildSubmitButton('LET\'S RIDE', 25.0, false),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Future<void> getNotificationService(context) async {
    await NotificationService(context: context).initializeService();
    setState(() {});
  }
}
