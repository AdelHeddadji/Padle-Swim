import 'package:expense_app/model/practice.dart';
import 'package:expense_app/notifier/practice_notifier.dart';
import 'package:expense_app/screens/home.dart';
import 'package:expense_app/screens/practice_form.dart';
import 'package:expense_app/screens/tabs.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../api/practice_api.dart';

class PracticeDetail extends StatefulWidget {
  
  @override
  _PracticeDetailState createState() => _PracticeDetailState();
}

class _PracticeDetailState extends State<PracticeDetail> {
  
  // showAlertDialog(BuildContext context) {
  //    PracticeNotifier practiceNotifier =
  //       Provider.of<PracticeNotifier>(context, listen: false);
  //   _onPracticeDeleted(Practice practice){
  //     Navigator.pop(context);
  //     practiceNotifier.deletePractice(practice);
  //   }
  // Widget cancelButton = FlatButton(
  //   child: Text("Cancel"),
  //   onPressed:  () {
  //     Navigator.pop(context);
  //   },
  // );
  // Widget continueButton = FlatButton(
  //   child: Text("Continue"),
  //   onPressed:  () {
  //     setState(() {

  //     Navigator.of(context).push(MaterialPageRoute(builder: (context) {
  //       return Tabs();
  //     }
  //     ));
  //     deletePractice(practiceNotifier.currentPractice, _onPracticeDeleted);
  //     });
  //   },
  // );
  // AlertDialog alert = AlertDialog(
  //   shape: RoundedRectangleBorder(
  //           borderRadius: BorderRadius.all(Radius.circular(32.0))),
  //   title: Text("Delete"),
  //   content: Text("Are you sure you want to delete this practice?"),
  //   actions: [
  //     cancelButton,
  //     continueButton,
  //   ],
  // );
  // showDialog(
  //   context: context,
  //   builder: (BuildContext context) {
  //     return alert;
  //   },
  // );
// }

  @override
  Widget build(BuildContext context) {
    PracticeNotifier practiceNotifier =
        Provider.of<PracticeNotifier>(context, listen: false);
    _onPracticeDeleted(Practice practice){
      Navigator.pop(context);
      practiceNotifier.deletePractice(practice);
    }
    return Scaffold(
      // backgroundColor: Colors.lightBlue[100],
      appBar: AppBar(
        // backgroundColor: Colors.indigo[800],
        title: Text(practiceNotifier.currentPractice.title),
      ),
      body: Center(
        child: Container(
          child: ListView(
            children: <Widget>[
              Card(
                elevation: 10,
                child: Padding(
                  padding: const EdgeInsets.all(10.0),
                  child: Text(
                    'Total Distance = ' +
                        practiceNotifier.currentPractice.totalDistance
                            .toString(),
                    style: TextStyle(fontSize: 23, fontWeight: FontWeight.bold),
                  ),
                ),
              ),
              Container(
                height: 300,
                width: double.infinity,
                child: Card(
                  elevation: 10,
                  child: Padding(
                    padding: const EdgeInsets.all(10),
                    child: Text(
                      practiceNotifier.currentPractice.journal,
                      style: TextStyle(fontSize: 18),
                    ),
                  ),
                ),
              ),
              for (int x = 0;
                  x < practiceNotifier.currentPractice.sets.length;
                  x++)
                Container(
                  child: Card(
                    elevation: 10,
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        Text(
                          practiceNotifier.currentPractice.sets[x].rounds
                                  .toString() +
                              ' x ',
                          style: TextStyle(
                              fontSize: 18, fontWeight: FontWeight.bold),
                        ),
                        Text(
                          '(',
                          textScaleFactor: practiceNotifier
                                  .currentPractice.sets[x].bars.length
                                  .toDouble() *
                              2,
                          style: TextStyle(
                            fontWeight: FontWeight.w200,
                          ),
                        ),
                        Column(
                          children: <Widget>[
                            for (int y = 0;
                                y <
                                    practiceNotifier
                                        .currentPractice.sets[x].bars.length;
                                y++)
                              Text(
                                practiceNotifier
                                        .currentPractice.sets[x].bars[y].reps
                                        .toString() +
                                    ' x ' +
                                    practiceNotifier.currentPractice.sets[x]
                                        .bars[y].distance
                                        .toString() +
                                    ' ' +
                                    practiceNotifier
                                        .currentPractice.sets[x].bars[y].stroke
                                        .toString() +
                                    ' ' +
                                    practiceNotifier.currentPractice.sets[x]
                                        .bars[y].swimType
                                        .toString() +
                                    ' ' +
                                    ' on ' +
                                    practiceNotifier.currentPractice.sets[x]
                                        .bars[y].interval
                                        .toString(),
                                style: TextStyle(
                                    fontSize: 18, fontWeight: FontWeight.bold),
                              ),
                          ],
                        ),
                        Text(
                          ')',
                          textScaleFactor: practiceNotifier
                                  .currentPractice.sets[x].bars.length
                                  .toDouble() *
                              2,
                          style: TextStyle(
                            fontWeight: FontWeight.w200,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
            ],
          ),
        ),
      ),
      floatingActionButton: Column(
        mainAxisAlignment: MainAxisAlignment.end,
        children: <Widget>[
          FloatingActionButton(
              heroTag: 'button1',
              child: Icon(Icons.edit),
              onPressed: () {
                Navigator.of(context).push(MaterialPageRoute(builder: (context) {
                  return PracticeForm(
                    isUpdating: true,
                  );
                }));
              }),
              SizedBox(height:20,),
               FloatingActionButton(
              heroTag: 'button2',
              child: Icon(Icons.delete),
              backgroundColor: Colors.red,
              onPressed: () =>  deletePractice(practiceNotifier.currentPractice, _onPracticeDeleted)
              ),
        ],
      ),
    );
  }
}
