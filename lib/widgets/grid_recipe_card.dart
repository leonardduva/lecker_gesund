import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:lecker_gesund/utils/constants.dart';
import 'package:lecker_gesund/utils/strings_utils.dart';

class GridRecipeCard extends StatelessWidget {
  final String title;
  final String description;
  final String image;
  final String time;
  final Function onTap;
  final String tag;
  final bool liked;
  final Function onFav;

  const GridRecipeCard(
      {this.title,
      this.description,
      this.image,
      this.time,
      this.onTap,
      this.tag,
      this.onFav,
      this.liked});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(10.0, 10, 5.0, 5),
      child: GestureDetector(
        onTap: onTap,
        child: Container(
          child: Stack(
            children: <Widget>[
              Positioned(
                child: Container(
                  height: 180,
                  width: 180,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(20),
                    color: Theme.of(context).primaryColor.withOpacity(0.6),
                  ),
                ),
              ),
              Positioned(
                top: 0,
                left: 35,
                child: Hero(
                  tag: tag,
                  child: Material(
                    elevation: 12.0,
                    shape: CircleBorder(),
                    clipBehavior: Clip.antiAliasWithSaveLayer,
                    color: Colors.transparent,
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
                      height: 100,
                      width: 100,
                    ),
                  ),
                ),
              ),
              Positioned(
                bottom: 8,
                left: 15,
                child: Container(
                  //color: Colors.red,
                  width: 142,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Text(
                        capitalizeFirstofEach(title),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: Theme.of(context).textTheme.headline6.copyWith(
                            fontSize:
                                16), //Theme.of(context).textTheme.bodyText1,
                      ),
                      SizedBox(height: 5),
                      Container(
                        width: 110,
                        child: Text(
                          capitalizeFirst(description),
                          overflow: TextOverflow.ellipsis,
                          maxLines: 1,
                          style: TextStyle(
                            color: kTextColor.withOpacity(.65),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              Positioned(
                right: 0,
                bottom: -5,
                child: IconButton(
                  icon: Icon(
                    liked
                        ? Icons.favorite_rounded
                        : Icons.favorite_border_outlined,
                    color: Theme.of(context).accentColor,
                  ),
                  onPressed: onFav,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
