import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:lecker_gesund/models/user_model.dart';
import 'package:lecker_gesund/screens/login_screen.dart';
import 'package:lecker_gesund/services/auth_service.dart';
import 'package:lecker_gesund/utils/app_config.dart';
import 'package:lecker_gesund/utils/theme_notifyer.dart';
import 'package:provider/provider.dart';
import 'package:lecker_gesund/utils/strings_utils.dart';

class NavigateDrawer extends StatefulWidget {
  @override
  _NavigateDrawerState createState() => _NavigateDrawerState();
}

class _NavigateDrawerState extends State<NavigateDrawer> {
  @override
  Widget build(BuildContext context) {
    AppConfig _ac = AppConfig(context);
    final UserModel userModel = Provider.of<UserModel>(context);
    double drawerSize = _ac.rH(35);
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(30),
          bottomLeft: Radius.circular(30),
        ),
        color: Theme.of(context).primaryColor.withOpacity(0.9),
      ),
      width: drawerSize,
      child: ListView(
        padding: EdgeInsets.zero,
        children: <Widget>[
          UserAccountsDrawerHeader(
            currentAccountPicture: Material(
              shape: CircleBorder(),
              clipBehavior: Clip.antiAlias,
              child: CachedNetworkImage(
                fit: BoxFit.cover,
                imageUrl: userModel.photoUrl,
                progressIndicatorBuilder: (context, url, downloadProgress) =>
                    CircularProgressIndicator(value: downloadProgress.progress),
                errorWidget: (context, url, error) => Icon(Icons.error),
              ),
            ),
            accountEmail: userModel != null
                ? Text('${userModel.email}')
                : CircularProgressIndicator(),
            accountName: userModel != null
                ? Text('${capitalizeFirst(userModel.username)}')
                : CircularProgressIndicator(),
            decoration: BoxDecoration(
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(30),
                ),
                color: Theme.of(context).primaryColor),
          ),
          ListTile(
            leading: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Icon(Icons.lightbulb_outline_sharp, color: Colors.black),
            ),
            title: Text('Dark Mode'),
            trailing: CupertinoSwitch(
              value: context.watch<AppThemeNotifier>().isDarkModeOn,
              onChanged: (_) {
                Provider.of<AppThemeNotifier>(context, listen: false)
                    .updateTheme();
              },
            ),
          ),
          ListTile(
            leading: IconButton(
              icon: Icon(Icons.logout, color: Colors.black),
              onPressed: () => null,
            ),
            title: Text('Log Out'),
            onTap: () {
              Provider.of<AuthService>(context, listen: false)
                  .signOutUser()
                  .then(
                (res) {
                  Navigator.pushAndRemoveUntil(
                      context,
                      MaterialPageRoute(builder: (context) => LogInScreen()),
                      (Route<dynamic> route) => false);
                },
              );
            },
          ),
          SizedBox(
            height: _ac.rH(0.16) * drawerSize,
          ),
          Container(
            width: _ac.rH(6),
            height: _ac.rH(6),
            child: Image(
              image: AssetImage('assets/images/rsz_logo.png'),
            ),
          ),
        ],
      ),
    );
  }
}
