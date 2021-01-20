import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:lecker_gesund/models/recipe_model.dart';
import 'package:lecker_gesund/models/user_model.dart';
import 'package:lecker_gesund/screens/intro_screen.dart';
import 'package:lecker_gesund/services/database_service.dart';
import 'package:lecker_gesund/utils/theme_notifyer.dart';
import 'package:provider/provider.dart';
import 'utils/app_theme.dart';
import 'package:lecker_gesund/services/auth_service.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(
    MultiProvider(
      providers: [
        //TODO:implement Shared Preferences Package
        ChangeNotifierProvider<AppThemeNotifier>(
            create: (_) => AppThemeNotifier()),
        ChangeNotifierProvider<AuthService>(create: (_) => AuthService()),
        // ChangeNotifierProvider<UserModelNotifier>(
        //     create: (_) => UserModelNotifier()),
        StreamProvider<User>.value(value: AuthService().user),
        StreamProvider<List<RecipeModel>>.value(
            value: DatabaseService().recipes),
        StreamProvider<List>.value(value: DatabaseService().favRecipes),
        FutureProvider<UserModel>(create: (_) => DatabaseService().userModel),
      ],
      child: MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'lecker+gesund',
      theme: context.watch<AppThemeNotifier>().isDarkModeOn
          ? AppTheme.darkTheme
          : AppTheme.lightTheme,
      home: IntroScreen(),
    );
  }
}
