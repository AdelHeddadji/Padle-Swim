import 'package:expense_app/api/practice_api.dart';
import 'package:expense_app/notifier/auth_notifier.dart';
import 'package:expense_app/notifier/practice_notifier.dart';
import 'package:expense_app/screens/side/team/memberslist.dart';
import 'package:flutter/material.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:provider/provider.dart';

import '../../practice_form.dart';

class TeamManage extends StatefulWidget {
  @override
  _TeamManageState createState() => _TeamManageState();
}

class _TeamManageState extends State<TeamManage> {
  @override
  void initState() {
    PracticeNotifier practiceNotifier =
        Provider.of<PracticeNotifier>(context, listen: false);
    getRecentPractices(practiceNotifier);
    super.initState();
  }

  listTileMaker(String title, IconData icon, Widget path) {
    return ListTile(
      leading: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 15),
        child: Icon(
          icon,
          size: 40,
        ),
      ),
      title: Text(
        title,
        style: TextStyle(fontSize: 18),
      ),
      trailing: Icon(
        Icons.arrow_forward_ios,
        size: 20,
      ),
      onTap: () {
        Navigator.of(context).push(MaterialPageRoute(builder: (context) {
          return path;
        }));
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    AuthNotifier authNotifier =
        Provider.of<AuthNotifier>(context, listen: false);
    PracticeNotifier practiceNotifier = Provider.of<PracticeNotifier>(context);
    return Scaffold(
        appBar: AppBar(
          title: Text('Manage Team'),
        ),
        body: Column(
          children: [
            SizedBox(
              height: 30,
            ),
            Container(
              // height: 100,
              child: Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 15),
                    child: CircleAvatar(
                      radius: 50,
                      backgroundImage: NetworkImage(
                        'https://static.politico.com/dims4/default/5104086/2147483647/resize/1160x%3E/quality/90/?url=https%3A%2F%2Fstatic.politico.com%2F5e%2F36%2F20d9fdcd4d8ab0e0b2add5e77371%2Fap20178460172749-1.jpg',
                      ),
                      backgroundColor: Colors.blue,
                    ),
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  Center(
                    child: Text(
                      'Crow Canyon Sharks',
                      style: TextStyle(fontSize: 18),
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(
              height: 50,
            ),
            listTileMaker('Member Requests', Icons.people, PracticeForm(isUpdating: null)),
            listTileMaker('Add Coaches', Icons.person_add, PracticeForm(isUpdating: null)),
            listTileMaker('Members List', Icons.list, MembersList()),
            SizedBox(height: 10,),
            Container(
              decoration: BoxDecoration(borderRadius: BorderRadius.circular(10)),
              child: RaisedButton(
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text('Add Team Practice',style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),),
                ),
                onPressed: () {
                  practiceNotifier.currentPractice = null;
                  Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (context) {
                        return PracticeForm(
                          isUpdating: false,
                        );
                      },
                    ),
                  );
                },
              ),
            )
          ],
        ));
  }
}
