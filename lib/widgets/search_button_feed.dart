import 'package:flutter/material.dart';

class SearchButtonFeed extends StatelessWidget {
  const SearchButtonFeed({
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      alignment: Alignment.centerLeft,
      margin: EdgeInsets.fromLTRB(15, 15, 0, 15),
      padding: EdgeInsets.symmetric(horizontal: 10, vertical: 15),
      height: 50,
      width: 50,
      decoration: BoxDecoration(
        color: Theme.of(context).primaryColor.withOpacity(0.8),
        borderRadius: BorderRadius.circular(360),
      ),
      child: Center(
        child: Icon(
          Icons.search,
          color: Theme.of(context).accentColor,
        ),
      ),
    );
  }
}
