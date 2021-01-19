import 'package:flutter/material.dart';

class GradientButton extends StatefulWidget {
  GradientButton({
    this.command,
  });

  final Function command;

  @override
  _GradientButtonState createState() => _GradientButtonState();
}

class _GradientButtonState extends State<GradientButton> {
  bool isTapped = false;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: widget.command,
      onTapDown: (_) {
        setState(() {
          isTapped = true;
        });
      },
      onTapUp: (_) {
        setState(() {
          isTapped = false;
        });
      },
      child: Container(
        height: 60.0,
        width: double.infinity,
        decoration: BoxDecoration(
          boxShadow: isTapped
              ? [
                  BoxShadow(
                    //color: Color(0xffffcd5d).withOpacity(0.5),
                    color: Theme.of(context).accentColor.withOpacity(0.3),
                    spreadRadius: 5,
                    blurRadius: 20,
                    offset: Offset(0, 10), // changes position of shadow
                  ),
                ]
              : null,
          borderRadius: BorderRadius.circular(10),
          gradient: LinearGradient(
            //colors: [Color(0xffffcd5d), Color(0xffFFD200)],
            //colors: [Color(0xff42FCDB), Color(0xff3EE577)],
            colors: [
              Theme.of(context).accentColor,
              Theme.of(context).accentColor.withOpacity(0.7)
            ],
            begin: Alignment.centerLeft,
            end: Alignment.centerRight,
          ),
        ),
        child: Center(
          child: Text(
            "Login",
            style: TextStyle(
              fontSize: 18.0,
              color: Colors.black,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ),
    );
  }
}
// background-color #7cffcb;
// background-image linear-gradient(315deg, #7cffcb 0%, #74f2ce 74%);background-image: linear-gradient( 135deg, #70F570 10%, #49C628 100%);
