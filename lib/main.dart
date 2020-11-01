import 'package:expense_app/notifier/usernotify.dart';
import 'package:expense_app/screens/side/Login.dart';
import 'package:expense_app/screens/side/team/teamProfile.dart';
import 'package:expense_app/screens/side/settings.dart';
import 'package:expense_app/screens/side/team/team_manage.dart';
import 'package:expense_app/screens/side/team/team_search.dart';
import 'package:expense_app/screens/tabs.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import './notifier/auth_notifier.dart';
import 'notifier/practice_notifier.dart';
import 'notifier/team_notifier.dart';

void main() => runApp(
      MultiProvider(
        providers: [
          ChangeNotifierProvider(
            create: (context) => AuthNotifier(),
          ),
          ChangeNotifierProvider(
            create: (context) => PracticeNotifier(),
          ),
          ChangeNotifierProvider(
            create: (context) => TeamNotifier(),
          ),
          ChangeNotifierProvider(
            create: (context) => UserNotifier(),
          ),
        ],
        child: MyApp(),
      ),
    );

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        theme: ThemeData(
            accentColor: Colors.amber,
            fontFamily: 'Quicksand',
            primaryColor: Colors.blue[600],
            brightness: Brightness.dark,
            textTheme: ThemeData.dark().textTheme.copyWith(
                  title: TextStyle(
                      color: Colors.white,
                      fontFamily: 'OpenSans',
                      fontWeight: FontWeight.bold,
                      fontSize: 18),
                  button: TextStyle(color: Colors.white),
                ),
            appBarTheme: AppBarTheme(
              textTheme: ThemeData.light().textTheme.copyWith(
                      title: TextStyle(
                    color: Colors.white,
                    fontFamily: 'OpenSans',
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  )),
            )),
        home: Consumer<AuthNotifier>(
          builder: (context, notifier, child) {
            return notifier.user != null ? Tabs() : Login();
          },
        ),
        routes: {
          'home': (context) => Tabs(),
          'settings': (context) => Settings(),
          'team': (context) => TeamProfile(),
          'manage': (context) => TeamManage(),
          'search': (context) => TeamSearch(),
        });
  }
}
