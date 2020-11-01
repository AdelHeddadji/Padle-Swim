import 'package:expense_app/api/practice_api.dart';
import 'package:expense_app/model/practice.dart';
import 'package:expense_app/notifier/practice_notifier.dart';
import 'package:expense_app/screens/detail.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:table_calendar/table_calendar.dart';

class PracticeHistory extends StatefulWidget {
  @override
  _PracticeHistoryState createState() => _PracticeHistoryState();
}

class _PracticeHistoryState extends State<PracticeHistory> {
  CalendarController _controller;
  Map<DateTime, List<dynamic>> _events = {};
  List _selectedEvents;
  Practice currentPractice;

  @override
  void initState() {
    PracticeNotifier _practiceNotifier =
        Provider.of<PracticeNotifier>(context, listen: false);
    getPractices(_practiceNotifier);
    _events = _groupEvents(_practiceNotifier.practiceList);
    _controller = CalendarController();
    _selectedEvents = [];
    super.initState();
  }

  Map<DateTime, List<dynamic>> _groupEvents(List<Practice> events) {
    Map<DateTime, List<dynamic>> data = {};
    events.forEach((event) {
      DateTime date = DateTime(event.createdAt.toDate().year,
          event.createdAt.toDate().month, event.createdAt.toDate().day, 12);
      if (data[date] == null) data[date] = [];
      data[date].add(event);
    });
    return data;
  }

  Widget _buildEventList() {
    PracticeNotifier _practiceNotifier =
        Provider.of<PracticeNotifier>(context, listen: false);
    getPractices(_practiceNotifier);
    return Container(
      height: 300,
      child: ListView(
        children: _selectedEvents
            .map(
              (event) => Card(
                margin: EdgeInsets.symmetric(
                  vertical: 8,
                  horizontal: 5,
                ),
                child: ListTile(
                  leading: CircleAvatar(
                    radius: 30,
                    backgroundColor: Theme.of(context).primaryColor,
                    foregroundColor: Colors.white,
                    child: Padding(
                      padding: EdgeInsets.all(6),
                      child: FittedBox(
                        child: Text(
                          event.totalDistance.toString() + 'Y',
                          style: TextStyle(
                            decorationColor: Colors.amber,
                          ),
                        ),
                      ),
                    ),
                  ),
                  title: Text(event.title),
                  subtitle: Text(
                    DateFormat.yMMMMd().format(event.createdAt.toDate()),
                  ),
                  onTap: () {
                    _practiceNotifier.currentPractice = event;
                    Navigator.of(context)
                        .push(MaterialPageRoute(builder: (context) {
                      return PracticeDetail();
                    }));
                  },
                ),
              ),
            )
            .toList(),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    PracticeNotifier _practiceNotifier =
        Provider.of<PracticeNotifier>(context, listen: false);
    getPractices(_practiceNotifier);
    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          children: <Widget>[
            Card(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(15.0),
              ),
              child: TableCalendar(
                events: _groupEvents(_practiceNotifier.practiceList),
                availableCalendarFormats: const {CalendarFormat.month: 'Month'},
                calendarStyle: CalendarStyle(
                    weekendStyle: TextStyle(color: Colors.white),
                    weekdayStyle: TextStyle(color: Colors.white),
                    canEventMarkersOverflow: true,
                    markersColor: Colors.white,
                    todayColor: Colors.indigo[800],
                    selectedColor: Theme.of(context).primaryColor,
                    todayStyle: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 18.0,
                        color: Colors.white)),
                daysOfWeekStyle: DaysOfWeekStyle(
                  weekdayStyle: TextStyle(color: Colors.white),
                  weekendStyle: TextStyle(color: Colors.white),
                ),
                headerStyle: HeaderStyle(
                  headerPadding: EdgeInsets.all(12),
                  centerHeaderTitle: true,
                  titleTextStyle: TextStyle(fontSize: 20, color: Colors.white),
                  formatButtonVisible: false,
                  leftChevronIcon:
                      Icon(Icons.chevron_left, color: Colors.white),
                  rightChevronIcon:
                      Icon(Icons.chevron_right, color: Colors.white),
                ),
                onDaySelected: (date, events) {
                  setState(() {
                    _selectedEvents = events;
                  });
                },
                builders: CalendarBuilders(
                  outsideWeekendDayBuilder: (context, date, events) {
                    return Center(
                      child: Text(
                        date.day.toString(),
                        style: TextStyle(color: Colors.grey),
                      ),
                    );
                  },
                  todayDayBuilder: (context, date, events) => Container(
                    margin: const EdgeInsets.all(4.0),
                    alignment: Alignment.center,
                    decoration: BoxDecoration(
                        color: Colors.indigo[800], shape: BoxShape.circle),
                    child: Text(
                      date.day.toString(),
                      style: TextStyle(color: Colors.white),
                    ),
                  ),
                  selectedDayBuilder: (context, date, events) => Container(
                    margin: const EdgeInsets.all(4.0),
                    alignment: Alignment.center,
                    decoration: BoxDecoration(
                        color: Colors.blue, shape: BoxShape.circle),
                    child: Text(
                      date.day.toString(),
                      style: TextStyle(color: Colors.white),
                    ),
                  ),
                ),
                calendarController: _controller,
              ),
            ),
            _buildEventList(),
          ],
        ),
      ),
    );
  }
}
