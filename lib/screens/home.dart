import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:curved_navigation_bar/curved_navigation_bar.dart';
import 'package:flutter/services.dart';
import 'package:lecker_gesund/model/user_model.dart';
import 'package:lecker_gesund/screens/add_screen.dart';
import 'package:lecker_gesund/screens/favorites_screen.dart';
import 'package:lecker_gesund/widgets/header.dart';
import 'package:provider/provider.dart';
import 'feed_screen.dart';
import 'navigate_drawer.dart';
import 'package:lecker_gesund/utils/strings_utils.dart';
import 'package:lecker_gesund/utils/app_config.dart';

class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  int _pageIndex = 0;
  GlobalKey _bottomNavigationKey = GlobalKey();
  GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  List<Widget> _pages = [
    Feed2(),
    Text('this widget exist only for index momentarily'),
    FavoritesScreen(),
  ];

  @override
  Widget build(BuildContext context) {
    SystemChrome.setEnabledSystemUIOverlays([]);
    AppConfig _ac = AppConfig(context);
    UserModel userModel = context.watch<UserModel>();

    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      key: _scaffoldKey,
      appBar: Header(
        title:
            userModel != null ? '${capitalizeFirst(userModel.username)}' : '',
        onTap: () {
          _scaffoldKey.currentState.openEndDrawer();
        },
      ),
      endDrawerEnableOpenDragGesture: false,
      endDrawer: NavigateDrawer(),
      body: Container(
        child: _pageIndex == 1 ? _pages[_pageIndex - 1] : _pages[_pageIndex],
      ),
      extendBody: true,
      bottomNavigationBar: CurvedNavigationBar(
        height: _ac.rH(7.5),
        color: Colors.white.withOpacity(0.9),
        animationDuration: Duration(
          milliseconds: 200,
        ),
        buttonBackgroundColor: Theme.of(context).primaryColor,
        backgroundColor: Colors.transparent,
        key: _bottomNavigationKey,
        items: <Widget>[
          Icon(
            Icons.home,
            size: 30,
            color:
                _pageIndex == 0 ? Theme.of(context).accentColor : Colors.black,
          ),
          Icon(
            Icons.add,
            size: 30,
            color:
                _pageIndex == 1 ? Theme.of(context).accentColor : Colors.black,
          ),
          Icon(
            Icons.star,
            size: 30,
            color:
                _pageIndex == 2 ? Theme.of(context).accentColor : Colors.black,
          ),
        ],
        onTap: (index) {
          setState(
            () {
              _pageIndex = index;

              if (index == 1) {
                showModalBottomSheet(
                  isScrollControlled: true,
                  context: context,
                  builder: (context) => SingleChildScrollView(
                    child: Container(
                      height: _ac.rH(90),
                      color: Theme.of(context).primaryColor.withOpacity(0.8),
                      padding: EdgeInsets.only(
                          bottom: MediaQuery.of(context).viewInsets.bottom),
                      child: AddScreen(),
                    ),
                  ),
                );
              }
            },
          );
        },
      ),
    );
  }
}
