import 'package:flutter/material.dart';
import 'package:lecker_gesund/model/user_model.dart';

class UserModelNotifier with ChangeNotifier {
  UserModel _userModel;

  UserModel get userModel => _userModel;

  void setUserModel(UserModel userModel) {
    _userModel = userModel;
    notifyListeners();
  }
}
