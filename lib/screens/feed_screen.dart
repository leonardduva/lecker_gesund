import 'package:flutter/material.dart';
import 'package:lecker_gesund/screens/details_screen.dart';
import 'package:lecker_gesund/services/database_service.dart';
import 'package:lecker_gesund/widgets/category_button.dart';
import 'package:lecker_gesund/widgets/recipe_card.dart';
import 'package:lecker_gesund/widgets/search_button_feed.dart';
import 'package:lecker_gesund/widgets/section_title.dart';
import 'package:provider/provider.dart';
import 'package:lecker_gesund/models/recipe_model.dart';
import 'package:lecker_gesund/widgets/grid_recipe_card.dart';

class FeedScreen2 extends StatefulWidget {
  @override
  _FeedScreen2State createState() => _FeedScreen2State();
}

class _FeedScreen2State extends State<FeedScreen2> {
  final _databaseService = DatabaseService();

  @override
  Widget build(BuildContext context) {
    final List recipeList = Provider.of<List<RecipeModel>>(context);
    bool isFav;
    return recipeList != null
        ? SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                Row(
                  children: [
                    SearchButtonFeed(),
                    _buildCategoryItems(),
                  ],
                ),
                SectionTitle(title: 'FEATURED'),
                _buildFeaturedCards(recipeList, isFav),
                SectionTitle(title: 'ALL'),
                _buildGridCards(recipeList, isFav),
              ],
            ),
          )
        : Center(
            child: CircularProgressIndicator(),
          );
  }

  //TODO: implement category filters
  Expanded _buildCategoryItems() {
    return Expanded(
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
    );
  }

  Padding _buildFeaturedCards(List recipeList, bool isFav) {
    return Padding(
      padding: const EdgeInsets.only(left: 5),
      child: Container(
        height: 350,
        child: ListView.builder(
          physics: ClampingScrollPhysics(),
          shrinkWrap: true,
          scrollDirection: Axis.horizontal,
          itemCount: recipeList.length,
          itemBuilder: (context, index) {
            return FutureBuilder(
              future:
                  _databaseService.checkIfFavList(recipeList[index].recipeId),
              builder: (context, snapshot) {
                isFav = snapshot.data;
                return RecipeCard(
                  tag: "feedcard" + index.toString(),
                  liked: isFav ?? false,
                  title: recipeList[index]?.title,
                  description: recipeList[index]?.description,
                  time: recipeList[index]?.time,
                  image: recipeList[index]?.imageUrl,
                  people: recipeList[index]?.people,
                  onTap: () {
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
                    if (snapshot.data == false) {
                      _databaseService.addFavoriteRecipe(
                        recipeModel: recipeList[index],
                      );
                    }
                    if (snapshot.data == true) {
                      _databaseService.delFavoriteRecipe(
                          recipeId: recipeList[index].recipeId);
                      print('recipe deleted');
                    }
                    setState(() {
                      isFav = snapshot.data;
                    });
                  },
                );
              },
            );
          },
        ),
      ),
    );
  }

  Padding _buildGridCards(List recipeList, bool isFav) {
    return Padding(
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
            return FutureBuilder(
              future:
                  _databaseService.checkIfFavList(recipeList[index].recipeId),
              builder: (context, snapshot) {
                isFav = snapshot.data;
                return GridRecipeCard(
                  tag: "gridcard" + index.toString(),
                  liked: isFav ?? false,
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
                  onFav: () {
                    if (snapshot.data == false) {
                      _databaseService.addFavoriteRecipe(
                        recipeModel: recipeList[index],
                      );
                    }
                    if (snapshot.data == true) {
                      _databaseService.delFavoriteRecipe(
                          recipeId: recipeList[index].recipeId);
                      print('recipe deleted');
                    }
                    setState(() {
                      isFav = snapshot.data;
                    });
                  },
                );
              },
            );
          }),
    );
  }
}

// Navigator.push(
//   context,
//   ScaleRoute(
//       page: DetailsScreen(
//     recipeModel: recipeList[index],
//   )),
// );
