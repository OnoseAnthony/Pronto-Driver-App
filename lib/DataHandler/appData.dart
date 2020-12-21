import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:fronto_rider/Models/users.dart';

class AppData extends ChangeNotifier {
  User firebaseUser;

  CustomUser userInfo;

  updateFirebaseUser(User user) {
    firebaseUser = user;
    notifyListeners();
  }

  updateUserInfo(CustomUser user) {
    userInfo = user;
    notifyListeners();
  }
}
