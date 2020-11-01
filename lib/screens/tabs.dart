import 'package:expense_app/api/practice_api.dart';
import 'package:expense_app/model/user.dart';
import 'package:expense_app/notifier/auth_notifier.dart';
import 'package:expense_app/notifier/practice_notifier.dart';
import 'package:expense_app/screens/history.dart';
import 'package:expense_app/screens/home.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../side_drawer.dart';

class Tabs extends StatefulWidget {
  @override
  _TabsState createState() => _TabsState();
}

class _TabsState extends State<Tabs> {
int _index = 0;
  final List<Widget> _tabs = [HomePage(), PracticeHistory()];
  User currentUser;
  // @override
  // void initState() {
  //   PracticeNotifier practiceNotifier =
  //   Provider.of<PracticeNotifier>(context, listen: false);
  //   getRecentPractices(practiceNotifier);
  //   super.initState();
  // }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('ADLE'),
      ),
      drawer: SideDrawer(),
      body: _tabs[_index],
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _index,
        onTap: (index) => setState((){
          _index = index;
        }),
        items: [
        new BottomNavigationBarItem(
          icon: Icon(Icons.home),
          title: Text('Home'),
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.history),
          title: Text('History')
        ),
      ]),
    );
  }
}
