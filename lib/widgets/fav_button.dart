import 'package:flutter/material.dart';

class FavButton extends StatefulWidget {
  final bool isFavExists;
  final Function onPressed;
  FavButton({this.isFavExists, this.onPressed});

  @override
  _FavButtonState createState() => _FavButtonState(isFav: this.isFavExists);
}

class _FavButtonState extends State<FavButton> {
  bool isFav;
  _FavButtonState({bool isFav}) : this.isFav = isFav ?? false;
  @override
  Widget build(BuildContext context) {
    return IconButton(
      icon: Icon(
        isFav ? Icons.favorite_rounded : Icons.favorite_border_outlined,
        color: Theme.of(context).accentColor,
      ),
      onPressed: () {
        setState(() {
          isFav = !isFav;
          print(isFav);
        });
        widget.onPressed();
      },
    );
  }
}
