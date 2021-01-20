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
    final List favRecipeList = Provider.of<List>(context);

    return favRecipeList != null
        ? Column(
            children: [
              Center(
                  child: favRecipeList.isEmpty
                      ? Text('No Fvorites yet')
                      : Text('${favRecipeList[0].title}')),
            ],
          )
        : Center(
            child: CircularProgressIndicator(),
          );
  }
}
