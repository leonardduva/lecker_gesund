import 'package:flutter/material.dart';
import 'package:lecker_gesund/screens/login_screen.dart';
import 'package:lecker_gesund/services/auth_service.dart';
import 'package:lecker_gesund/widgets/gradient_button.dart';

class EmailSignUp extends StatefulWidget {
  @override
  _EmailSignUpState createState() => _EmailSignUpState();
}

class _EmailSignUpState extends State<EmailSignUp> {
  final _formKey = GlobalKey<FormState>();
  final AuthService _authService = AuthService();

  TextEditingController emailController = TextEditingController();
  TextEditingController nameController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  TextEditingController passwordRepeatController = TextEditingController();

  bool isLoading = false;
  String errorText;
  //TODO: successful info
  String successText;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Center(
          child: Column(
            children: [
              Center(
                child: Image.asset(
                  'assets/images/rsz_logo.png',
                  fit: BoxFit.fitHeight,
                  height: 120,
                ),
              ),
              Form(
                key: _formKey,
                child: SingleChildScrollView(
                  child: Column(
                    children: <Widget>[
                      Padding(
                        padding: EdgeInsets.all(20.0),
                        child: TextFormField(
                          controller: nameController,
                          decoration: InputDecoration(
                            labelText: "Enter User Name",
                            enabledBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10.0),
                            ),
                          ),
                          // TODO:Refactor all validators
                          validator: (value) {
                            if (value.isEmpty) {
                              return 'Enter User Name';
                            }
                            return null;
                          },
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.all(20.0),
                        child: TextFormField(
                          controller: emailController,
                          decoration: InputDecoration(
                            labelText: "Enter Email",
                            enabledBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10.0),
                            ),
                          ),
                          // The validator receives the text that the user has entered.
                          validator: (value) {
                            if (value.isEmpty) {
                              return 'Enter an Email Address';
                            } else if (!value.contains('@')) {
                              return 'Please enter a valid email address';
                            }
                            return null;
                          },
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.all(20.0),
                        child: TextFormField(
                          controller: passwordRepeatController,
                          decoration: InputDecoration(
                            labelText: "Confirm password",
                            enabledBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10.0),
                            ),
                          ),
                          // The validator receives the text that the user has entered.
                          validator: (value) {
                            if (value != passwordController.text) {
                              return "Password doesn't match";
                            }
                            return null;
                          },
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.all(20.0),
                        child: TextFormField(
                          obscureText: true,
                          controller: passwordController,
                          decoration: InputDecoration(
                            labelText: "Enter Password",
                            enabledBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10.0),
                            ),
                          ),
                          // The validator receives the text that the user has entered.
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
                      _buildSingupButton(context),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Padding _buildSingupButton(BuildContext context) {
    return Padding(
      padding: EdgeInsets.all(20.0),
      child: isLoading
          ? CircularProgressIndicator(
              valueColor:
                  AlwaysStoppedAnimation<Color>(Theme.of(context).accentColor),
            )
          : Container(
              height: 60.0,
              width: double.infinity,
              child: GradientButton(
                title: 'Sign Up',
                onClicked: () {
                  handleSignUp();
                  // if (_formKey.currentState.validate()) {
                  //   setState(() {
                  //     isLoading = true;
                  //   });
                  //   _authService.signUpUser(
                  //     email: emailController.text,
                  //     password: passwordController.text,
                  //     username: nameController.text,
                  //     displayName: nameController.text,
                  //     onSuccess: () {
                  //       isLoading = false;
                  //       Navigator.pushReplacement(
                  //         context,
                  //         MaterialPageRoute(
                  //             builder: (context) =>
                  //                 LogInScreen()),
                  //       );
                  //     },
                  //     onError: (err) {
                  //       setState(() {
                  //         errorText = err;
                  //         successText = '';
                  //       });
                  //       buildErrorDialog(context);
                  //     },
                  //   );
                  // }
                },
              ),
            ),
    );
  }

  void handleSignUp() {
    if (_formKey.currentState.validate()) {
      setState(() {
        isLoading = true;
      });
      _authService.signUpUser(
        email: emailController.text,
        password: passwordController.text,
        username: nameController.text,
        displayName: nameController.text,
        onSuccess: () {
          isLoading = false;
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (context) => LogInScreen()),
          );
        },
        onError: (err) {
          setState(() {
            errorText = err;
            successText = '';
          });
          buildErrorDialog(context);
        },
      );
    }
  }

  Future buildErrorDialog(BuildContext context) {
    return showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text("Error"),
          content: Text(errorText),
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

  @override
  void dispose() {
    super.dispose();
    nameController.dispose();
    emailController.dispose();
    passwordController.dispose();
    passwordRepeatController.dispose();
  }
}
