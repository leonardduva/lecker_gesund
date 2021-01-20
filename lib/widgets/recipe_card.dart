import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:lecker_gesund/utils/constants.dart';
import 'package:lecker_gesund/utils/strings_utils.dart';

class RecipeCard extends StatelessWidget {
  final String title;
  final String description;
  final String image;
  final String time;
  final String tag;
  final String people;
  final Function onTap;
  final Function onFav;

  final bool liked;

  RecipeCard(
      {this.title,
      this.description,
      this.image,
      this.time,
      this.tag,
      this.people,
      this.onTap,
      this.onFav,
      this.liked});

  @override
  Widget build(BuildContext context) {
    // // AppConfig _ac = AppConfig(context);

    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: EdgeInsets.only(left: 0, right: 10),
        height: 350,
        width: 220,
        child: Stack(
          children: <Widget>[
            Positioned(
              right: 0,
              bottom: 0,
              child: Container(
                height: 340,
                width: 210,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(34),
                  color: Theme.of(context).primaryColor.withOpacity(0.6),
                ),
              ),
            ),
            Positioned(
              top: 0,
              left: -8,
              child: Hero(
                tag: tag,
                child: Material(
                  elevation: 8.0,
                  shape: CircleBorder(),
                  color: Colors.transparent,
                  clipBehavior: Clip.antiAliasWithSaveLayer,
                  child: Container(
                    child: CachedNetworkImage(
                      fit: BoxFit.cover,
                      imageUrl: image,
                      progressIndicatorBuilder:
                          (context, url, downloadProgress) =>
                              CircularProgressIndicator(
                                  value: downloadProgress.progress),
                      errorWidget: (context, url, error) => Icon(Icons.error),
                    ),
                    height: 154,
                    width: 180,
                  ),
                ),
              ),
            ),
            Positioned(
              right: 5,
              top: 65,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Row(
                    children: <Widget>[
                      Icon(
                        Icons.access_time,
                        color: Colors.black,
                        size: 20,
                      ),
                      SizedBox(
                        width: 5,
                      ),
                      Text(
                        '$time °',
                        style: Theme.of(context).textTheme.headline6.copyWith(
                            fontSize: 12,
                            color: kBlackColor,
                            fontWeight: FontWeight.w500),
                      ),
                    ],
                  ),
                  SizedBox(
                    height: 5,
                  ),
                  Row(
                    children: <Widget>[
                      Icon(
                        Icons.people,
                        color: Colors.black,
                        size: 20,
                      ),
                      SizedBox(
                        width: 5,
                      ),
                      Text('$people',
                          style: Theme.of(context).textTheme.headline6.copyWith(
                              fontSize: 12,
                              color: kBlackColor,
                              fontWeight: FontWeight.w500)),
                    ],
                  ),
                ],
              ),
            ),
            Positioned(
              top: 180,
              left: 24,
              child: Container(
                width: 186,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Text(
                      capitalizeFirstofEach(title), maxLines: 2,
                      overflow: TextOverflow.ellipsis,

                      style: Theme.of(context).textTheme.headline6.copyWith(
                          fontSize:
                              18), //Theme.of(context).textTheme.bodyText1,
                    ),
                    SizedBox(height: 20),
                    Container(
                      width: 186,
                      child: Text(
                        capitalizeFirst(description),
                        overflow: TextOverflow.ellipsis,
                        maxLines: 3,
                        style: Theme.of(context).textTheme.subtitle2,
                      ),
                    ),
                  ],
                ),
              ),
            ),
            Positioned(
              right: 5,
              bottom: 5,
              child: IconButton(
                icon: Icon(
                  liked
                      ? Icons.favorite_rounded
                      : Icons.favorite_border_outlined,
                  color: Theme.of(context).accentColor,
                ),
                onPressed: onFav,
              ),
              // child: FavButton(
              //   isFavExists: isFavExists,
              //   onPressed: onFav,
              // ),
            ),
          ],
        ),
      ),
    );
  }
}
