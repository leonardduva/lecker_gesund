import 'package:flutter/material.dart';
import 'package:flutter_signin_button/flutter_signin_button.dart';
import 'package:lecker_gesund/utils/strings_utils.dart';
import 'package:lecker_gesund/widgets/gradient_button.dart';
import 'package:lecker_gesund/services/auth_service.dart';
import 'signup_screen.dart';
import 'home.dart';

class LogInScreen extends StatefulWidget {
  @override
  _LogInScreenState createState() => _LogInScreenState();
}

class _LogInScreenState extends State<LogInScreen> {
  final _formKey = GlobalKey<FormState>();
  final AuthService _authService = AuthService();

  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();

  bool isLoading = false;
  String errorText = '';
  //TODO: implement success message
  String successText = '';
  dynamic borderShape = RoundedRectangleBorder(
    borderRadius: BorderRadius.circular(10.0),
  );

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: SafeArea(
          child: Center(
            heightFactor: 1.2,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Center(
                  child: Image.asset(
                    'assets/images/rsz_logo.png',
                    fit: BoxFit.fitHeight,
                    height: 120,
                  ),
                ),
                Padding(
                  padding: EdgeInsets.all(5.0),
                  child: Form(
                    key: _formKey,
                    child: SingleChildScrollView(
                      child: Column(
                        children: <Widget>[
                          Padding(
                            padding: EdgeInsets.fromLTRB(20, 50, 20, 10),
                            child: TextFormField(
                              controller: emailController,
                              decoration: InputDecoration(
                                hintStyle: TextStyle(
                                    color: Theme.of(context).accentColor),
                                labelText: "Email",
                                enabledBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(10.0),
                                ),
                              ),
                              //TODO: Refactor all Validators
                              validator: (value) {
                                if (value.isEmpty) {
                                  return 'Enter Email Address';
                                } else if (!value.contains('@')) {
                                  return 'Please enter a valid email address!';
                                }
                                return null;
                              },
                            ),
                          ),
                          Padding(
                            padding: EdgeInsets.fromLTRB(20, 10, 20, 0),
                            child: TextFormField(
                              obscureText: true,
                              controller: passwordController,
                              decoration: InputDecoration(
                                labelText: "Password",
                                enabledBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(10.0),
                                ),
                              ),
                              validator: (value) {
                                if (value.isEmpty) {
                                  return 'Enter Password';
                                } else if (value.length < 6) {
                                  return 'Password must be atleast 6 characters!';
                                }
                                return null;
                              },
                            ),
                          ),
                          _buildLoginButton(context),
                        ],
                      ),
                    ),
                  ),
                ),
                Padding(
                    padding: EdgeInsets.all(5.0),
                    child: SignInButton(
                      Buttons.Google,
                      shape: borderShape,
                      text: "Log in with Google",
                      onPressed: () {
                        //TODO: implement google login
                      },
                    )),
                Padding(
                    padding: EdgeInsets.all(5.0),
                    child: SignInButton(
                      Buttons.Apple,
                      shape: borderShape,
                      text: "Log in with Apple",
                      onPressed: () {
                        //TODO: implement apple login
                      },
                    )),
                Row(
                  children: <Widget>[
                    Expanded(
                        child: Divider(
                      color: Colors.grey.shade600,
                    )),
                    const SizedBox(width: 10.0),
                    Text(
                      "OR",
                    ),
                    const SizedBox(width: 10.0),
                    Expanded(
                        child: Divider(
                      color: Colors.grey.shade600,
                    )),
                  ],
                ),
                Padding(
                  padding: EdgeInsets.all(10.0),
                  child: GestureDetector(
                    child: RichText(
                      text: TextSpan(
                        text: 'Don\'t have an account?',
                        style: TextStyle(color: Colors.black, fontSize: 15),
                        children: <TextSpan>[
                          TextSpan(
                            text: ' Sign up',
                            style: TextStyle(
                              color: Theme.of(context).accentColor,
                              fontSize: 15,
                              decoration: TextDecoration.underline,
                              fontWeight: FontWeight.bold,
                            ),
                          )
                        ],
                      ),
                    ),
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => EmailSignUp()),
                      );
                    },
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }

  Padding _buildLoginButton(BuildContext context) {
    return Padding(
      padding: EdgeInsets.all(20.0),
      child: isLoading
          ? CircularProgressIndicator(
              valueColor:
                  AlwaysStoppedAnimation<Color>(Theme.of(context).accentColor),
            )
          : GradientButton(
              title: 'Log in',
              onClicked: () {
                handleLogIn();
              },
            ),
    );
  }

  Future _buildAlertDialog(BuildContext context) {
    return showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text("Error"),
          content: Text('$errorText'),
          actions: [
            FlatButton(
              child: Text("Ok"),
              onPressed: () {
                Navigator.of(context).pop();
                setState(() {
                  isLoading = false;
                });
              },
            )
          ],
        );
      },
    );
  }

  void handleLogIn() {
    if (_formKey.currentState.validate()) {
      setState(() {
        isLoading = true;
      });
      _authService.signInUser(
        email: trim(emailController.text),
        password: passwordController.text,
        onSuccess: () async {
          setState(() {
            successText = 'welcome user';
            print(successText);
            errorText = '';
          });

          //await _authService.initializeCurrentUser();
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (context) => Home()),
          );
        },
        onError: (err) {
          setState(() {
            errorText = err;
            successText = '';
          });
          _buildAlertDialog(context);
        },
      );
    }
  }

  @override
  void dispose() {
    super.dispose();
    emailController.dispose();
    passwordController.dispose();
  }
}
