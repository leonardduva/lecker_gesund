import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:lecker_gesund/model/recipe_model.dart';
import 'package:lecker_gesund/utils/strings_utils.dart';

class DetailsScreen extends StatelessWidget {
  DetailsScreen({this.recipeModel, this.tag});
  final RecipeModel recipeModel;
  final String tag;

  @override
  Widget build(BuildContext context) {
    // use splite to seperate steps after split('char')
    List<String> descriptionList = split(recipeModel.description);
    List<String> ingredientsList = split(recipeModel.ingredients);

    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding:
              const EdgeInsets.only(left: 20, right: 20, top: 0, bottom: 20),
          child: Column(
            children: <Widget>[
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  GestureDetector(
                      onTap: () {
                        Navigator.of(context).pop();
                      },
                      child: Icon(
                        Icons.arrow_back_ios,
                        color: Theme.of(context).iconTheme.color,
                      )),
                  SizedBox(),
                ],
              ),
              Expanded(
                child: SingleChildScrollView(
                  scrollDirection: Axis.vertical,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Center(
                        child: Hero(
                          tag: tag,
                          child: Material(
                            elevation: 20.0,
                            shape: CircleBorder(),
                            color: Colors.transparent,
                            clipBehavior: Clip.antiAlias,
                            child: Container(
                              child: CachedNetworkImage(
                                fit: BoxFit.cover,
                                imageUrl: recipeModel.imageUrl,
                                progressIndicatorBuilder:
                                    (context, url, downloadProgress) =>
                                        CircularProgressIndicator(
                                            value: downloadProgress.progress),
                                errorWidget: (context, url, error) =>
                                    Icon(Icons.error),
                              ),
                              height: 225,
                              width: 225,
                            ),
                          ),
                        ),
                      ),
                      SizedBox(height: 32),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(capitalizeFirst(recipeModel.title),
                              style: Theme.of(context).textTheme.headline4),
                          SizedBox(height: 8),
                          Row(
                            children: [
                              Icon(
                                Icons.access_time,
                                color: Colors.black,
                                size: 20,
                              ),
                              SizedBox(
                                width: 12,
                              ),
                              Text(
                                "${recipeModel.time} minutes",
                                style: Theme.of(context)
                                    .textTheme
                                    .subtitle2
                                    .copyWith(color: Colors.black),
                              ),
                            ],
                          ),
                          SizedBox(height: 8),
                          Row(
                            children: [
                              Icon(
                                Icons.people,
                                color: Colors.black,
                                size: 20,
                              ),
                              SizedBox(
                                width: 12,
                              ),
                              Text(
                                "${recipeModel.people} people",
                                style: Theme.of(context)
                                    .textTheme
                                    .subtitle2
                                    .copyWith(color: Colors.black),
                              ),
                            ],
                          ),
                          SizedBox(height: 32),
                          Text('Ingredients',
                              style: Theme.of(context).textTheme.headline6),
                          SizedBox(height: 8),
                          ...ingredientsList.map((item) => Text(
                                capitalizeFirstofEach(trim(item)),
                              )),
                          SizedBox(height: 24),
                          Text('Directions',
                              style: Theme.of(context).textTheme.headline6),
                          SizedBox(height: 8),
                          ...descriptionList.map(
                            (item) => Column(
                              children: [
                                Row(
                                  children: [
                                    Text(
                                      // get the index of every item & start from 1
                                      '${descriptionList.indexOf(item) + 1}',
                                      style: Theme.of(context)
                                          .textTheme
                                          .headline4
                                          .copyWith(
                                              color: Theme.of(context)
                                                  .accentColor),
                                    ),
                                    SizedBox(width: 8),
                                    Expanded(
                                      child: Container(
                                        child: Text(
                                          capitalizeFirst(trim(item)),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                                SizedBox(height: 12),
                              ],
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.symmetric(vertical: 8.0),
                            child: Row(
                              children: <Widget>[
                                Container(
                                  padding: EdgeInsets.all(10),
                                  decoration: BoxDecoration(
                                    border: Border.all(width: 0.5),
                                    borderRadius: BorderRadius.circular(20),
                                  ),
                                  child: Center(
                                    child: Row(
                                      children: <Widget>[
                                        Text(
                                          "Favorite",
                                          style: Theme.of(context)
                                              .textTheme
                                              .button,
                                        ),
                                        SizedBox(width: 10),
                                        Icon(
                                          Icons.favorite_border,
                                          color: Theme.of(context).accentColor,
                                        ),
                                      ],
                                    ),
                                  ),
                                )
                              ],
                            ),
                          )
                        ],
                      )
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
