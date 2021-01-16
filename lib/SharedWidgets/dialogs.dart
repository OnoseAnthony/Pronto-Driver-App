import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:fronto_rider/SharedWidgets/buttons.dart';
import 'package:fronto_rider/SharedWidgets/text.dart';
import 'package:fronto_rider/constants.dart';

class LoaderWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return SpinKitWanderingCubes(
      color: Colors.white,
      size: 30.0,
    );
  }
}

Dialog NavigationLoader(BuildContext context) {
  return Dialog(
    elevation: 8,
    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(5)),
    child: Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(5),
        color: kPrimaryColor,
      ),
      height: 80.0,
      child: Padding(
        padding:
            const EdgeInsets.only(top: 8.0, bottom: 8.0, left: 40, right: 20),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: <Widget>[
            LoaderWidget(),
            SizedBox(
              width: 30,
            ),
            buildTitlenSubtitleText('please wait a moment...', kWhiteColor, 14,
                FontWeight.bold, TextAlign.center, null),
          ],
        ),
      ),
    ),
  );
}

showToast(context, String msg, Color color, bool isError) {
  FToast fToast = FToast();
  fToast.init(context);

  Widget toast = Container(
    padding: const EdgeInsets.symmetric(horizontal: 12.0, vertical: 12.0),
    decoration: BoxDecoration(
      borderRadius: BorderRadius.circular(25.0),
      color: color != null ? color : kPrimaryColor,
    ),
    child: Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        getIcon(isError ? Icons.cancel : Icons.check, 20, kWhiteColor),
        SizedBox(
          width: 12.0,
        ),
        buildTitlenSubtitleText(
            msg, Colors.white, 14, FontWeight.normal, TextAlign.start, null)
      ],
    ),
  );

  fToast.showToast(
    child: toast,
    gravity: ToastGravity.TOP,
    toastDuration: Duration(seconds: 4),
  );
}
