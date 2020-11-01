import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:expense_app/model/team.dart';
import 'package:expense_app/notifier/practice_notifier.dart';
import 'package:expense_app/notifier/team_notifier.dart';
import 'package:expense_app/notifier/usernotify.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:expense_app/api/practice_api.dart';
import '../../detail.dart';

class TeamProfile extends StatefulWidget {
  @override
  _TeamProfileState createState() => _TeamProfileState();
}

class _TeamProfileState extends State<TeamProfile> {
  Team currentTeam;
  @override
  Widget build(BuildContext context) {
    PracticeNotifier practiceNotifier = Provider.of<PracticeNotifier>(context);
    getPractices(practiceNotifier);
    UserNotifier userNotifier =
        Provider.of<UserNotifier>(context, listen: false);
    getUserInfo(userNotifier);
    TeamNotifier teamNotifier =
        Provider.of<TeamNotifier>(context, listen: false);
    return Scaffold(
      appBar: AppBar(
        title: Text('Team'),
      ),
      body: StreamBuilder(
        stream: Firestore.instance
            .collection('teams')
            .where('teamID', isEqualTo: userNotifier.userList[0].teamID)
            .snapshots(),
        builder: (context, snapshot) {
          if (snapshot.hasData == null) {
            return Center(
              child: CircularProgressIndicator(),
            );
          }
          final docs = snapshot.data.documents;
          return ListView(
            children: [
              Container(
                child: Column(
                  children: [
                    SizedBox(
                      height: 30,
                    ),
                    Center(
                      child: CircleAvatar(
                        radius: 50,
                        backgroundImage: NetworkImage(
                          docs[0]['teamImage'] != null
                              ? docs[0]['teamImage']
                              : 'https://www.testingxperts.com/wp-content/uploads/2019/02/placeholder-img.jpg',
                        ),
                      ),
                    ),
                    SizedBox(height: 10),
                    Center(
                      child: Text(
                        docs[0]['teamName'],
                        style: TextStyle(fontSize: 18),
                      ),
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    Container(
                      alignment: Alignment.centerLeft,
                      margin: EdgeInsets.symmetric(
                        vertical: 8,
                      ),
                      // child: Center(
                      //   child: RaisedButton(
                      //     child: Text('Join'),
                      //     color: Theme.of(context).primaryColor,
                      //     textColor: Theme.of(context).textTheme.button.color,
                      //     onPressed: () {},
                      //   ),
                      // ),
                    ),
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: <Widget>[
                        SizedBox(
                          width: 10,
                        ),
                        Flexible(
                          fit: FlexFit.tight,
                          child: Container(
                            // color: Colors.blue,
                            height: 50,
                            // width: MediaQuery.of(context).size.width * 0.3,
                            child: Column(
                              children: [
                                Text('50'),
                                Text('Practices'),
                              ],
                            ),
                          ),
                        ),
                        Flexible(
                          fit: FlexFit.tight,
                          child: Container(
                            // color: Colors.yellow,
                            height: 50,
                            // width: MediaQuery.of(context).size.width * 0.3,
                            child: Column(
                              children: [
                                Text('50'),
                                Text('Members'),
                              ],
                            ),
                          ),
                        ),
                        Flexible(
                          fit: FlexFit.tight,
                          child: Container(
                            // color: Colors.green,
                            height: 50,
                            // width: MediaQuery.of(context).size.width * 0.3,
                            child: Column(
                              children: [
                                Text('5'),
                                Text('Coaches'),
                              ],
                            ),
                          ),
                        ),
                        SizedBox(
                          width: 10,
                        )
                      ],
                    ),
                    Divider(
                      color: Colors.white,
                      height: 10,
                    ),

                    // Padding(
                    //   padding: EdgeInsets.symmetric(horizontal: 10.0),
                    //   child: Container(
                    //     height: 1.0,
                    //     width: MediaQuery.of(context).size.width * 1,
                    //     color: Colors.white,
                    //   ),
                    // ),
                  ],
                ),
              ),
              Container(
                height: practiceNotifier.practiceList.length * 90.0,
                child: ListView.separated(
                    physics: NeverScrollableScrollPhysics(),
                    itemBuilder: (BuildContext context, int index) {
                      return ListTile(
                        leading: CircleAvatar(
                          radius: 30,
                          backgroundColor: Theme.of(context).primaryColor,
                          child: Text(
                            '${practiceNotifier.practiceList[index].totalDistance}' +
                                'Y',
                            style: TextStyle(color: Colors.white),
                          ),
                        ),
                        title: Text(
                            '${practiceNotifier.practiceList[index].title}'),
                        subtitle: Text(
                          DateFormat.yMMMMd().format(
                            practiceNotifier.practiceList[index].createdAt
                                .toDate(),
                          ),
                        ),
                        onTap: () {
                          practiceNotifier.currentPractice =
                              practiceNotifier.practiceList[index];
                          Navigator.of(context)
                              .push(MaterialPageRoute(builder: (context) {
                            return PracticeDetail();
                          }));
                        },
                      );
                    },
                    separatorBuilder: (BuildContext context, int index) {
                      return Divider(
                        color: Colors.grey,
                      );
                    },
                    itemCount: practiceNotifier.practiceList.length),
              )
            ],
          );
        },
      ),
    );
  }
}
