import 'package:expense_app/api/practice_api.dart';
import 'package:expense_app/model/user.dart';
import 'package:expense_app/notifier/usernotify.dart';
import 'package:flutter/material.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:provider/provider.dart';

import 'notifier/auth_notifier.dart';
import 'notifier/team_notifier.dart';

class SideDrawer extends StatefulWidget {
  const SideDrawer({Key key}) : super(key: key);
  @override
  _SideDrawerState createState() => _SideDrawerState();
}

class _SideDrawerState extends State<SideDrawer> {
  User currentUser;
  bool idk = true;

  @override
  void initState() {
    UserNotifier userNotifier =
        Provider.of<UserNotifier>(context, listen: false);
    getUserInfo(userNotifier);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    // User currentUser;
    AuthNotifier authNotifier =
        Provider.of<AuthNotifier>(context, listen: false);
    UserNotifier userNotifier =
        Provider.of<UserNotifier>(context, listen: false);
    TeamNotifier teamNotifier =
        Provider.of<TeamNotifier>(context, listen: false);
    getUserInfo(userNotifier);
    return Container(
      child: SafeArea(
        child: Drawer(
          child: Column(
            children: [
              Expanded(
                  child: ListView(
                children: [
                  UserAccountsDrawerHeader(
                    accountEmail: Text(authNotifier.user.email),
                    accountName: Text(authNotifier.user.displayName),
                    otherAccountsPictures: [
                      Icon(Icons.home),
                      Icon(Icons.ac_unit)
                    ],
                    currentAccountPicture: CircleAvatar(
                      backgroundImage: NetworkImage(
                          'https://static.politico.com/dims4/default/5104086/2147483647/resize/1160x%3E/quality/90/?url=https%3A%2F%2Fstatic.politico.com%2F5e%2F36%2F20d9fdcd4d8ab0e0b2add5e77371%2Fap20178460172749-1.jpg'),
                    ),
                  ),
                  ListTile(
                    title: Text('Home'),
                    leading: Icon(Icons.home),
                    onTap: () => Navigator.pushReplacementNamed(
                      context,
                      'home',
                    ),
                  ),
                  ListTile(
                    title: Text('Settings'),
                    leading: Icon(Icons.settings),
                    onTap: () => Navigator.pushNamed(
                      context,
                      'settings',
                    ),
                  ),
                  ListTile(
                      title: Text('Team'),
                      leading: Icon(MdiIcons.swim),
                      onTap: () {
                        if (userNotifier.userList[0].teamID == null) {
                          Navigator.pushNamed(context, 'search');
                        } else
                          Navigator.pushNamed(context, 'team');
                      }),
                  // if (userNotifier.userList[0].isCoach == true)
                  //   CircularProgressIndicator(),
                  ListTile(
                    title: Text('Manage Team'),
                    leading: Icon(MdiIcons.briefcase),
                    onTap: () => Navigator.pushNamed(context, 'manage'),
                  ),
                ],
              )),
            ],
          ),
        ),
      ),
    );
  }
}
