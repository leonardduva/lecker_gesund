import 'package:flutter/material.dart';
import 'package:lecker_gesund/screens/details_screen.dart';
import 'package:lecker_gesund/services/database_service.dart';
import 'package:lecker_gesund/widgets/grid_recipe_card.dart';
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
    DatabaseService _databaseService = DatabaseService();

    return favRecipeList != null
        ? SingleChildScrollView(
            scrollDirection: Axis.vertical,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.fromLTRB(17, 10, 0, 5),
                  child: Text(
                    'YOUR FAVORITES',
                    style: Theme.of(context).textTheme.headline5,
                  ),
                ),
                favRecipeList.isEmpty
                    ? Center(
                        child: Text('No Fvorites yet'),
                      )
                    : Padding(
                        padding: const EdgeInsets.fromLTRB(5, 0, 10, 0),
                        child: Container(
                          child: GridView.builder(
                            gridDelegate:
                                SliverGridDelegateWithFixedCrossAxisCount(
                              crossAxisCount: 2,
                            ),
                            physics: ClampingScrollPhysics(),
                            shrinkWrap: true,
                            itemCount: favRecipeList.length,
                            itemBuilder: (context, index) {
                              return GridRecipeCard(
                                tag: "feedcard" + index.toString(),
                                liked: true,
                                title: favRecipeList[index]?.title,
                                description: favRecipeList[index]?.description,
                                time: favRecipeList[index]?.time,
                                image: favRecipeList[index]?.imageUrl,
                                //people: favRecipeList[index]?.people,
                                onTap: () {
                                  // Navigator.push(
                                  //   context,
                                  //   ScaleRoute(
                                  //       page: DetailsScreen(
                                  //     recipeModel: recipeList[index],
                                  //   )),
                                  // );
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) => DetailsScreen(
                                        recipeModel: favRecipeList[index],
                                        tag: "feedcard" + index.toString(),
                                      ),
                                    ),
                                  );
                                },
                                onFav: () {
                                  _databaseService.delFavoriteRecipe(
                                      recipeId: favRecipeList[index].recipeId);
                                  print('recipe deleted');
                                },
                              );
                            },
                          ),
                        ),
                      ),
              ],
            ),
          )
        : Center(
            child: CircularProgressIndicator(),
          );
  }
}
