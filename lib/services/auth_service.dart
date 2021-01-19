import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:lecker_gesund/model/user_model.dart';
import 'package:lecker_gesund/services/Notifiers/user_model_notifier.dart';

import 'package:lecker_gesund/utils/constants.dart';

class AuthService extends ChangeNotifier {
  final CollectionReference _usersRef =
      FirebaseFirestore.instance.collection('users');
  final FirebaseAuth _auth = FirebaseAuth.instance;
  String errorMessage;
  UserModelNotifier _userModelNotifier = UserModelNotifier();

  // use streams to listen to _auth state
  Stream<User> get user {
    var user = _auth.authStateChanges();
    notifyListeners();
    return user;
  }

  Future<void> signUpUser({
    @required String email,
    @required String password,
    @required String username,
    String displayName,
    ValueChanged<String> onError,
    VoidCallback onSuccess,
  }) async {
    assert(email != null);
    assert(password != null);
    assert(username != null);
    try {
      UserCredential userCredential = await FirebaseAuth.instance
          .createUserWithEmailAndPassword(email: email, password: password);
      print('signed Up complete');

      if (userCredential != null) {
        _usersRef
            .doc(userCredential.user.uid)
            .set({
              "uid": userCredential.user.uid,
              "email": userCredential.user.email,
              "username": username,
              "displayName": displayName,
              "photoUrl":
                  userCredential.user.photoURL ?? avatarPlaceholderImage,
            })
            .then((value) => print("User Added to firestore"))
            .catchError((error) => print("Failed to add user: $error"));
      }
      notifyListeners();
      onSuccess();
    } on FirebaseAuthException catch (e) {
      if (e.code == 'weak-password') {
        print('The password provided is too weak.');
        errorMessage = 'The password provided is too weak.';
      } else if (e.code == 'email-already-in-use') {
        print('The account already exists for that email.');
        errorMessage = 'The account already exists for that email.';
      } else if (e != null) {
        errorMessage = e.toString();
      }
      onError(errorMessage);
    } catch (e) {
      print(e);
      onError(e.toString());
    }
  }

  Future<void> signInUser({
    @required String email,
    @required String password,
    ValueChanged<String> onError,
    VoidCallback onSuccess,
  }) async {
    assert(email != null);
    assert(password != null);
    try {
      await _auth.signInWithEmailAndPassword(email: email, password: password);
      notifyListeners();
      onSuccess();

      print('signed in');
    } on FirebaseAuthException catch (e) {
      if (e.code == 'user-not-found') {
        print('No user found for that email.');
        errorMessage = 'No user found for that email.';
      } else if (e.code == 'wrong-password') {
        print('Wrong password provided for that user.');
        errorMessage = 'Wrong password provided for that user.';
      } else if (e != null) {
        errorMessage = e.toString();
      }
      onError(errorMessage);
    } catch (e) {
      onError(e.toString());
    }
  }

  Future<void> signOutUser() async {
    try {
      await _auth.signOut();
      _userModelNotifier.setUserModel(null);
      notifyListeners();
      print('signed out');
    } catch (e) {
      print(e);
      errorMessage = e;
    }
  }

  initializeCurrentUser() async {
    DocumentSnapshot snapshot =
        await _usersRef.doc(_auth.currentUser.uid).get();

    UserModel userModel = UserModel.fromJson(snapshot.data());

    if (userModel != null) {
      _userModelNotifier.prints();
      print(userModel.email);
      _userModelNotifier.setUserModel(userModel);
      print(userModel.email);
    }
  }
}
