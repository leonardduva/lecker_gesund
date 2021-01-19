import 'package:flutter/material.dart';
import 'package:lecker_gesund/model/user_model.dart';

class UserModelNotifier with ChangeNotifier {
  UserModel _userModel;

  UserModel get userModel => _userModel;

  int i = 0;
  void prints() {
    print(' userModel before set ${_userModel?.username}');
    print('newUser before set ${userModel?.username}');
  }

  void setUserModel(UserModel userModel) {
    _userModel = userModel;
    i++;
    notifyListeners();
    print('after set ${_userModel?.username}');
    print('after set ${_userModel?.email}');
    print('after set ${_userModel?.uid}');
    print('after set ${_userModel?.photoUrl}');
    print('after i $i');
    print('newUser after set ${userModel?.username}');
  }
}
