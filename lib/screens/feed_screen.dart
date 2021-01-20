import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:lecker_gesund/screens/details_screen.dart';
import 'package:lecker_gesund/services/database_service.dart';
import 'package:lecker_gesund/widgets/category_button.dart';
import 'package:lecker_gesund/widgets/recipe_card.dart';
import 'package:provider/provider.dart';
import 'package:lecker_gesund/models/recipe_model.dart';
import 'package:lecker_gesund/widgets/grid_recipe_card.dart';

class FeedScreen extends StatefulWidget {
  @override
  _FeedScreenState createState() => _FeedScreenState();
}

class _FeedScreenState extends State<FeedScreen> {
  final _databaseService = DatabaseService();

  @override
  Widget build(BuildContext context) {
    final CollectionReference _favRecipesRef =
        FirebaseFirestore.instance.collection('favoriteRecipes');
    final List recipeList = Provider.of<List<RecipeModel>>(context);
    final List favRecipeList = Provider.of<List>(context);
    final userId = context.watch<User>().uid;

    // checkFav() {
    //   bool isFav;
    //   isFav =
    //       favRecipeList[0].recipeId == recipeList[0].recipeId ? true : false;
    //   print('i am looking for this $isFav');
    //   print('fav id: ${favRecipeList[0].recipeId}');
    //   print('recipeid: ${recipeList[5].recipeId}');
    //   print(
    //       'document id: ${_favRecipesRef.doc(userId).collection('recipesList').doc(recipeList[5].recipeId)}');
    // }
    _databaseService.checkIfFavList(recipeList[0].recipeId);

    bool checkIfFav(index) {
      bool isFound;
      for (int i = 0; i < recipeList[index].usersFav.length; i++) {
        isFound = recipeList[index].usersFav[i] == userId ? true : false;
      }
      print(isFound);
      return isFound;
    }

    return recipeList != null
        ? SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                Row(
                  children: [
                    Container(
                      alignment: Alignment.centerLeft,
                      margin: EdgeInsets.fromLTRB(15, 15, 0, 15),
                      padding:
                          EdgeInsets.symmetric(horizontal: 10, vertical: 15),
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
                    ),
                    Expanded(
                      child: SingleChildScrollView(
                        scrollDirection: Axis.horizontal,
                        child: Row(
                          children: [
                            CategoryButton(title: 'All'),
                            CategoryButton(title: 'Dinner'),
                            CategoryButton(title: 'Lunch'),
                            CategoryButton(title: 'Breakfast'),
                            CategoryButton(title: 'Breakfast'),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
                Padding(
                  padding: const EdgeInsets.fromLTRB(15, 0, 8, 20),
                  child: Text(
                    'Tages Rezepte',
                    style: Theme.of(context).textTheme.headline5,
                  ),
                ),

                Padding(
                  padding: const EdgeInsets.only(left: 5),
                  child: Container(
                    height: 350,
                    child: ListView.builder(
                      physics: ClampingScrollPhysics(),
                      shrinkWrap: true,
                      scrollDirection: Axis.horizontal,
                      itemCount: recipeList.length,
                      itemBuilder: (context, index) {
                        return RecipeCard(
                          tag: "feedcard" + index.toString(),
                          liked: recipeList[index].liked,
                          title: recipeList[index]?.title,
                          description: recipeList[index]?.description,
                          time: recipeList[index]?.time,
                          image: recipeList[index]?.imageUrl,
                          people: recipeList[index]?.people,
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
                                  recipeModel: recipeList[index],
                                  tag: "feedcard" + index.toString(),
                                ),
                              ),
                            );
                          },
                          onFav: () {
                            if (checkIfFav(index) == false) {
                              _databaseService.addFavoriteRecipe(
                                recipeModel: recipeList[index],
                                onSuccess: () {
                                  print('added to favorites');
                                },
                              );
                            }
                            if (checkIfFav(index) == true) {
                              _databaseService.delFavoriteRecipe(
                                  recipeId: recipeList[index].recipeId);
                            }
                          },
                        );
                      },
                    ),
                  ),
                ),
                //
                Padding(
                  padding: const EdgeInsets.fromLTRB(15, 20, 0, 15),
                  child: Text(
                    'Alle',
                    style: Theme.of(context).textTheme.headline5,
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.fromLTRB(5, 0, 10, 0),
                  child: GridView.builder(
                      physics: NeverScrollableScrollPhysics(),
                      shrinkWrap: true,
                      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 2,
                        mainAxisSpacing: 2,
                      ),
                      itemCount: recipeList.length,
                      itemBuilder: (context, index) {
                        return GridRecipeCard(
                          tag: "gridcard" + index.toString(),
                          liked: recipeList[index].liked,
                          title: recipeList[index]?.title,
                          description: recipeList[index]?.description,
                          time: recipeList[index]?.time,
                          image: recipeList[index]?.imageUrl,
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => DetailsScreen(
                                        recipeModel: recipeList[index],
                                        tag: "gridcard" + index.toString(),
                                      )),
                            );
                          },
                          onFav: () {},
                        );
                      }),
                ),
              ],
            ),
          )
        : Center(
            child: CircularProgressIndicator(),
          );
  }
}
