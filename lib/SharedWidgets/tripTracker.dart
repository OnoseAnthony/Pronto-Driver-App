import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:fronto_rider/constants.dart';

buildDestinationTracker(context, bool isCompleted) {
  return Row(
    mainAxisSize: MainAxisSize.max,
    mainAxisAlignment: MainAxisAlignment.center,
    children: [
      isCompleted
          ? Container(
              height: 10,
              width: 10,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: kPrimaryColor,
              ),
            )
          : Container(
        height: 25,
              width: 22,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: kPrimaryColor,
              ),
              child: Padding(
                padding: const EdgeInsets.all(4.0),
                child: SvgPicture.asset(
                  'assets/images/truck.svg',
                  semanticsLabel: 'truck icon',
                ),
              ),
            ),
      Container(
        height: 2,
        width: MediaQuery.of(context).size.height * 0.06,
        color: isCompleted ? kPrimaryColor : Colors.grey[300],
      ),
      Container(
        height: 10,
        width: 10,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: isCompleted ? kPrimaryColor : Colors.grey[300],
        ),
      ),
      Container(
        height: 2,
        width: MediaQuery.of(context).size.height * 0.07,
        color: isCompleted ? kPrimaryColor : Colors.grey[300],
      ),
      Container(
        height: 10,
        width: 10,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: isCompleted ? kPrimaryColor : Colors.grey[300],
        ),
      ),
      Container(
        height: 2,
        width: MediaQuery.of(context).size.height * 0.08,
        color: isCompleted ? kPrimaryColor : Colors.grey[300],
      ),
      isCompleted
          ? Container(
        height: 25,
              width: 22,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: kPrimaryColor,
              ),
              child: Padding(
                padding: const EdgeInsets.all(4.0),
                child: SvgPicture.asset(
                  'assets/images/Vector.svg',
                  semanticsLabel: 'vector icon',
                ),
              ),
            )
          : Container(
              height: 10,
              width: 10,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: Colors.grey[300],
              ),
            ),
    ],
  );
}
