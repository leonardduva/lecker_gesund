import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class FavoritesScreen extends StatefulWidget {
  FavoritesScreen({Key key}) : super(key: key);

  @override
  _FavoritesScreenState createState() => _FavoritesScreenState();
}

class _FavoritesScreenState extends State<FavoritesScreen> {
  @override
  Widget build(BuildContext context) {
    final List favRecipeList = null; //Provider.of<List>(context);
    return favRecipeList != null
        ? Container(
            child: Center(child: Text('{favRecipeList[0].recipeId}')),
          )
        : Center(
            child: CircularProgressIndicator(),
          );
  }
}
