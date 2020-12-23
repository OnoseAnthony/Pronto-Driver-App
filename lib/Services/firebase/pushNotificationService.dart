import 'dart:io';

import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:fronto_rider/Screens/Dashboard/homeScreen.dart';
import 'package:fronto_rider/Services/firebase/auth.dart';
import 'package:fronto_rider/Services/firebase/firestore.dart';

class NotificationService {
  BuildContext context;

  NotificationService({this.context});

  final FirebaseMessaging _firebaseMessaging = FirebaseMessaging();

  Future initializeService() async {
    if (Platform.isIOS) {
      _firebaseMessaging
          .requestNotificationPermissions(IosNotificationSettings());
    }

    _firebaseMessaging.configure(
      onMessage: (Map<String, dynamic> message) async {
        print("onMessage: $message");
      },
      onLaunch: (Map<String, dynamic> message) async {
        getSubmittedStreamBuilder();
      },
      onResume: (Map<String, dynamic> message) async {
        getSubmittedStreamBuilder();
      },
    );
  }

  getSubmittedStreamBuilder() {
    Navigator.push(
        context, MaterialPageRoute(builder: (context) => HomeScreen()));
  }

  Future getTokenString() async {
    String getTokenString = await _firebaseMessaging.getToken();

    if (getTokenString != null) {
      await DatabaseService(
              firebaseUser: AuthService().getCurrentUser(), context: context)
          .updateTokenStrings(getTokenString);
    }
  }
}
