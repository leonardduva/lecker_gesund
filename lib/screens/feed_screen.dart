import 'package:flutter/material.dart';
import 'package:lecker_gesund/screens/details_screen.dart';
import 'package:lecker_gesund/services/database_service.dart';
import 'package:lecker_gesund/utils/scale_transition.dart';
import 'package:lecker_gesund/widgets/category_button.dart';
import 'package:lecker_gesund/widgets/recipe_card.dart';
import 'package:provider/provider.dart';
import 'package:lecker_gesund/model/recipe_model.dart';
import 'package:lecker_gesund/widgets/grid_recipe_card.dart';

class Feed2 extends StatefulWidget {
  @override
  _Feed2State createState() => _Feed2State();
}

class _Feed2State extends State<Feed2> {
  final _databaseService = DatabaseService();
  @override
  Widget build(BuildContext context) {
    final List recipeList = Provider.of<List<RecipeModel>>(context);
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
                            TagChip(title: 'All'),
                            TagChip(title: 'Dinner'),
                            TagChip(title: 'Lunch'),
                            TagChip(title: 'Breakfast'),
                            TagChip(title: 'Breakfast'),
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
                          isFavExists: true,
                          title: recipeList[index].title,
                          description: recipeList[index].description,
                          time: recipeList[index].time,
                          image: recipeList[index].imageUrl,
                          people: recipeList[index].people,
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
                                      )),
                            );
                          },
                          onFav: () {},
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
                          title: recipeList[index].title,
                          description: recipeList[index].description,
                          time: recipeList[index].time,
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
