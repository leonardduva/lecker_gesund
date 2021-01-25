import 'package:flutter/material.dart';

class InputField extends StatelessWidget {
  const InputField({
    Key key,
    @required this.controller,
    this.labelText,
    this.hintText,
    this.validationText,
    this.width,
    this.maxLines = 1,
  }) : super(key: key);

  final TextEditingController controller;
  final String labelText;
  final String hintText;
  final String validationText;
  final double width;
  final int maxLines;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: width,
      child: TextFormField(
        controller: controller,
        keyboardType: TextInputType.multiline,
        maxLines: maxLines,
        decoration: InputDecoration(
          labelText: labelText,
          hintText: hintText,
        ),
        validator: (value) {
          if (value.isEmpty) {
            return validationText;
          }
          return null;
        },
      ),
    );
  }
}
