import 'package:flutter/material.dart';
import 'package:fronto_rider/SharedWidgets/buttons.dart';

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
                color: Colors.blue,
              ),
            )
          : Container(
              height: 25,
              width: 22,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: Colors.blue,
              ),
              child: getIcon(Icons.message, 10, Colors.white),
            ),
      Container(
        height: 2,
        width: MediaQuery.of(context).size.height * 0.06,
        color: isCompleted ? Colors.blue : Colors.grey[300],
      ),
      Container(
        height: 10,
        width: 10,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: isCompleted ? Colors.blue : Colors.grey[300],
        ),
      ),
      Container(
        height: 2,
        width: MediaQuery.of(context).size.height * 0.07,
        color: isCompleted ? Colors.blue : Colors.grey[300],
      ),
      Container(
        height: 10,
        width: 10,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: isCompleted ? Colors.blue : Colors.grey[300],
        ),
      ),
      Container(
        height: 2,
        width: MediaQuery.of(context).size.height * 0.08,
        color: isCompleted ? Colors.blue : Colors.grey[300],
      ),
      isCompleted
          ? Container(
              height: 25,
              width: 22,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: Colors.blue,
              ),
              child: getIcon(Icons.message, 10, Colors.white),
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
