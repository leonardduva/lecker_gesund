import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:lecker_gesund/screens/home.dart';
import 'package:lecker_gesund/screens/login_screen.dart';
import 'package:provider/provider.dart';
import 'package:splashscreen/splashscreen.dart';

class IntroScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final userAuth = context.watch<User>();

    return SplashScreen(
        navigateAfterSeconds: userAuth != null ? Home() : LogInScreen(),
        seconds: 2,
        title: userAuth != null
            ? Text(
                'Welcome back!',
                style: TextStyle(fontWeight: FontWeight.w400, fontSize: 20.0),
              )
            : Text(
                'Welcome!',
                style: TextStyle(fontWeight: FontWeight.w400, fontSize: 20.0),
              ),
        image: Image.asset(
          'assets/images/rsz_logo.png',
          fit: BoxFit.fitHeight,
          height: 120,
        ),
        backgroundColor: Colors.white,
        styleTextUnderTheLoader: TextStyle(),
        photoSize: 150.0,
        onClick: () => print("flutter"),
        loaderColor: Colors.green);
  }
}
