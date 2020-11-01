import 'package:expense_app/model/practice.dart';
import 'package:expense_app/model/user.dart';
import 'package:expense_app/notifier/auth_notifier.dart';
import 'package:expense_app/notifier/practice_notifier.dart';
import 'package:expense_app/screens/detail.dart';
import 'package:expense_app/screens/practice_form.dart';
import 'package:flutter/material.dart';
import 'package:focused_menu/focused_menu.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import '../api/practice_api.dart';
import 'package:focused_menu/modals.dart';
import 'package:charts_flutter/flutter.dart' as charts;

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  Practice practice;
  bool isFavorite = true;
  List<charts.Series<Practice, String>> _seriesBarData;
  List<Practice> mydata;
  User currentUser;
  @override
  void initState() {
    PracticeNotifier practiceNotifier =
        Provider.of<PracticeNotifier>(context, listen: false);
    getRecentPractices(practiceNotifier);
    super.initState();
  }

  _generateData(mydata) {
    _seriesBarData = List<charts.Series<Practice, String>>();
    _seriesBarData.add(
      charts.Series(
        domainFn: (Practice sales, _) =>
            DateFormat.MMMd().format(sales.createdAt.toDate()).toString(),
        measureFn: (Practice sales, _) => int.parse(sales.totalDistance),
        colorFn: (Practice sales, _) =>
            charts.ColorUtil.fromDartColor(Colors.blue),
        id: 'practices',
        data: mydata,
        labelAccessorFn: (Practice row, _) => "${row.title}",
      ),
    );
  }

  Widget _buildChart(BuildContext context, List<Practice> saledata) {
    mydata = saledata;
    _generateData(mydata);
    return Padding(
      padding: EdgeInsets.all(8.0),
      child: Container(
        child: Center(
          child: Column(
            children: <Widget>[
              Text(
                'Weekly Distances',
                style: TextStyle(fontSize: 24.0, fontWeight: FontWeight.bold),
              ),
              SizedBox(
                height: 10.0,
              ),
              Expanded(
                child: charts.BarChart(
                  _seriesBarData,
                  animate: false,
                  domainAxis: charts.OrdinalAxisSpec(
                    renderSpec: new charts.SmallTickRendererSpec(
                      labelStyle: new charts.TextStyleSpec(
                          color: charts.MaterialPalette.white),
                      lineStyle: new charts.LineStyleSpec(
                          color: charts.MaterialPalette.white),
                    ),
                  ),
                  primaryMeasureAxis: new charts.NumericAxisSpec(
                      renderSpec: new charts.GridlineRendererSpec(
                          labelStyle: new charts.TextStyleSpec(
                              color: charts.MaterialPalette.white),
                          lineStyle: new charts.LineStyleSpec(
                              color: charts.MaterialPalette.white))),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    PracticeNotifier practiceNotifier = Provider.of<PracticeNotifier>(context);
    Future<void> _refreshList() async {
      getRecentPractices(practiceNotifier);
    }
    return Scaffold(
        body: RefreshIndicator(
          onRefresh: _refreshList,
          child: ListView(
            children: [
              Container(
                height: MediaQuery.of(context).size.height * 0.4,
                width: MediaQuery.of(context).size.width,
                child: Card(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(15.0),
                  ),
                  child: _buildChart(context, practiceNotifier.practiceList),
                ),
              ),
              new RefreshIndicator(
                child: Container(
                  height: practiceNotifier.practiceList.length * 90.0,
                  child: ListView.builder(
                    physics: NeverScrollableScrollPhysics(),
                    itemBuilder: (context, index) {
                      return Column(
                        children: [
                          FocusedMenuHolder(
                            blurSize: 2,
                            menuWidth: MediaQuery.of(context).size.width * 0.5,
                            menuBoxDecoration: BoxDecoration(
                                color: Colors.grey,
                                borderRadius:
                                    BorderRadius.all(Radius.circular(15.0))),
                            menuOffset: 10,
                            onPressed: () {},
                            menuItems: <FocusedMenuItem>[
                              FocusedMenuItem(
                                  title: Text('Open'),
                                  onPressed: () {
                                    practiceNotifier.currentPractice =
                                        practiceNotifier.practiceList[index];
                                    Navigator.of(context).push(
                                        MaterialPageRoute(builder: (context) {
                                      return PracticeDetail();
                                    }));
                                  },
                                  trailingIcon: Icon(Icons.open_in_new),
                                  backgroundColor: Colors.grey[800]),
                              FocusedMenuItem(
                                title: Text('Favorite'),
                                onPressed: () {},
                                trailingIcon: Icon(Icons.favorite_border),
                                backgroundColor: Colors.grey[800],
                              ),
                              FocusedMenuItem(
                                title: Text('Delete'),
                                onPressed: () {},
                                trailingIcon: Icon(Icons.delete),
                                backgroundColor: Colors.grey[800],
                              ),
                            ],
                            child: Card(
                              margin: EdgeInsets.symmetric(
                                vertical: 8,
                                horizontal: 5,
                              ),
                              child: ListTile(
                                trailing: IconButton(
                                  icon: Icon(practiceNotifier
                                          .practiceList[index].favorite
                                      ? Icons.star
                                      : Icons.star_border),
                                  onPressed: () {
                                    setState(
                                      () {},
                                    );
                                  },
                                ),
                                leading: CircleAvatar(
                                  radius: 30,
                                  backgroundColor: Theme.of(context).primaryColor,
                                  foregroundColor: Colors.white,
                                  child: Padding(
                                    padding: EdgeInsets.all(6),
                                    child: FittedBox(
                                      child: Text(
                                        '${practiceNotifier.practiceList[index].totalDistance}' +
                                            'Y',
                                        style: TextStyle(
                                          decorationColor: Colors.amber,
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                                title: Text(
                                    practiceNotifier.practiceList[index].title),
                                subtitle: Text(
                                  DateFormat.yMMMMd().format(practiceNotifier
                                      .practiceList[index].createdAt
                                      .toDate()),
                                ),
                                onTap: () {
                                  practiceNotifier.currentPractice =
                                      practiceNotifier.practiceList[index];
                                  Navigator.of(context).push(
                                      MaterialPageRoute(builder: (context) {
                                    return PracticeDetail();
                                  }));
                                },
                              ),
                            ),
                          ),
                        ],
                      );
                    },
                    itemCount: practiceNotifier.practiceList.length,
                  ),
                ),
                onRefresh: _refreshList,
              ),
            ],
          ),
        ),
        floatingActionButton: FloatingActionButton(
          child: Icon(Icons.add),
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
        ));
  }
}
