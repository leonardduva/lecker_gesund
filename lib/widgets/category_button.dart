import 'package:flutter/material.dart';

class CategoryButton extends StatelessWidget {
  final String title;
  const CategoryButton({
    this.title,
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    bool selected = false;
    return Padding(
      padding: const EdgeInsets.all(4.0),
      child: FilterChip(
          backgroundColor: Color.fromRGBO(217, 217, 217, 1),
          disabledColor: Colors.transparent,
          showCheckmark: true,
          selected: selected,
          selectedColor: Colors.teal[100],
          label: Container(
            height: 45.0,
            child: Center(
              child: Text(title),
            ),
          ),
          onSelected: (bool value) {
            selected = !selected;
          }),
    );
  }
}
