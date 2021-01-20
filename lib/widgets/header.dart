import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:lecker_gesund/models/user_model.dart';
import 'package:lecker_gesund/utils/constants.dart';
import 'package:provider/provider.dart';

class Header extends StatelessWidget with PreferredSizeWidget {
  @override
  final Size preferredSize;
  final Function onTap;

  Header({
    this.onTap,
    Key key,
  })  : preferredSize = Size.fromHeight(56.0),
        super(key: key);

  @override
  Widget build(BuildContext context) {
    final UserModel userModel = Provider.of<UserModel>(context);
    return SafeArea(
      child: Column(
        children: [
          Container(
            color: Colors.transparent,
            child: ListTile(
              title: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Hi, ${userModel?.username ?? ''}',
                      style: TextStyle(
                        fontSize: 20.0,
                        fontWeight: FontWeight.bold,
                      )),
                  Text(
                    'What are you cooking today?',
                    style: TextStyle(
                      fontSize: 16.0,
                    ),
                  ),
                ],
              ),
              trailing: GestureDetector(
                onTap: onTap,
                child: Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(45.0),
                    border: Border.all(
                      color: Theme.of(context).accentColor,
                      width: 2,
                    ),
                  ),
                  child: Material(
                    shape: CircleBorder(),
                    clipBehavior: Clip.antiAlias,
                    child: CachedNetworkImage(
                      fit: BoxFit.cover,
                      imageUrl: userModel?.photoUrl ?? avatarPlaceholderImage,
                      progressIndicatorBuilder:
                          (context, url, downloadProgress) =>
                              CircularProgressIndicator(
                                  value: downloadProgress.progress),
                      errorWidget: (context, url, error) => Icon(Icons.error),
                    ),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
//
