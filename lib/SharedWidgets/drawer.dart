import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fronto_rider/Screens/wrapper.dart';
import 'package:fronto_rider/Services/firebase/auth.dart';
import 'package:fronto_rider/SharedWidgets/buttons.dart';
import 'package:fronto_rider/SharedWidgets/customListTile.dart';
import 'package:fronto_rider/SharedWidgets/dialogs.dart';
import 'package:fronto_rider/SharedWidgets/text.dart';

buildDrawer(
  BuildContext context,
) {
  double size = MediaQuery.of(context).size.width * 0.08;
  Widget _column = Column(
    mainAxisAlignment: MainAxisAlignment.center,
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      buildTitlenSubtitleText(AuthService().getCurrentUser().phoneNumber,
          Colors.black, 18, FontWeight.bold, TextAlign.center, null),
      SizedBox(
        height: 3,
      ),
      buildTitlenSubtitleText(AuthService().getCurrentUser().email, Colors.grey,
          13, FontWeight.normal, TextAlign.center, null),
    ],
  );
  return Container(
    width: MediaQuery.of(context).size.width * 0.80,
    child: Drawer(
      child: Container(
        child: Column(
          children: [
            Container(
              height: 150,
              padding: EdgeInsets.symmetric(horizontal: size * 0.35),
              child: DrawerHeader(
                child: buildCustomListTile(buildContainerIcon(Icons.person),
                    _column, null, 15.0, false),
              ),
            ),
            SizedBox(
              height: 20.0,
            ),
            Padding(
              padding: EdgeInsets.symmetric(
                horizontal: size,
              ),
              child: Column(
                children: [
                  buildCustomListTile(
                      getIcon(Icons.live_help_rounded, 22, Colors.black),
                      buildTitlenSubtitleText('Support', Colors.black, 16,
                          FontWeight.normal, TextAlign.start, null),
                      null,
                      12.0,
                      false),
                  SizedBox(
                    height: 25.0,
                  ),
                  buildCustomListTile(
                      getIcon(Icons.info, 22, Colors.black),
                      buildTitlenSubtitleText('About', Colors.black, 16,
                          FontWeight.normal, TextAlign.start, null),
                      null,
                      12.0,
                      false),
                  SizedBox(
                    height: 25.0,
                  ),
                  InkWell(
                    onTap: () async {
                      showDialog(
                        context: context,
                        barrierDismissible: false,
                        builder: (context) => NavigationLoader(context),
                      );
                      bool isLoggedOut = await AuthService().signOut();
                      if (isLoggedOut)
                        Navigator.pushAndRemoveUntil(
                            context,
                            MaterialPageRoute(builder: (context) => Wrapper()),
                            (route) => false);
                      else {
                        Navigator.pop(context);
                      }
                    },
                    child: buildCustomListTile(
                        getIcon(Icons.login_outlined, 22, Colors.black),
                        buildTitlenSubtitleText('Signout', Colors.black, 16,
                            FontWeight.normal, TextAlign.start, null),
                        null,
                        12.0,
                        false),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    ),
  );
}
