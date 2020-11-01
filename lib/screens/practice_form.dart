import 'dart:io';
import 'package:expense_app/api/practice_api.dart';
import 'package:expense_app/model/practice.dart';
import 'package:expense_app/model/practice_bar.dart';
import 'package:expense_app/model/practice_set.dart';
import 'package:expense_app/notifier/practice_notifier.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

const _stroke = [
  'Free',
  'Back',
  'Fly',
  'Breast',
  'I.M',
  'Stroke',
  'Kick',
  'Pull',
  'Drill',
  'Scull'
];
const _type = ['Aerobic', 'Sprint', 'Fast', 'Strong', 'Easy'];

typedef void FieldChangedCallback(String title);
typedef void ShowWidgetCallback(BuildContext context);
typedef void DateChangedCallback(DateTime pickedDate);
typedef void RoundsChangedCallback(String rounds, int setIndex);
typedef void SetChangeCallback();
typedef void BarChangeCallback(int setIndex);
typedef void BarFieldChangeCallback(int setIndex, int barIndex, var newValue);
// typedef void IntervalChangeCallback(
//     int setIndex, int barIndex, BuildContext context);

class TitleField extends StatefulWidget {
  TitleField({
    this.title,
    this.onTitleChanged,
    this.event,
  });

  final String title;
  final FieldChangedCallback onTitleChanged;
  final Practice event;

  @override
  _TitleFieldState createState() => _TitleFieldState();
}

class _TitleFieldState extends State<TitleField> {
  @override
  Widget build(BuildContext context) {
    return TextFormField(
      decoration: InputDecoration(labelText: 'Title'),
      initialValue: widget.title,
      autocorrect: true,
      keyboardType: TextInputType.text,
      style: TextStyle(fontSize: 20),
      validator: (String value) {
        if (value.isEmpty) {
          return 'Title is required';
        }
        return null;
      },
      onSaved: (String value) {
        widget.onTitleChanged(value);
      },
    );
  }
}

class DistanceField extends StatefulWidget {
  DistanceField({this.distance, this.onTotalDistanceChanged});

  final String distance;
  final FieldChangedCallback onTotalDistanceChanged;

  @override
  _DistanceFieldState createState() => _DistanceFieldState();
}

class _DistanceFieldState extends State<DistanceField> {
  @override
  Widget build(BuildContext context) {
    return TextFormField(
      decoration: InputDecoration(labelText: 'Total Distance'),
      initialValue: widget.distance,
      autocorrect: true,
      keyboardType: TextInputType.number,
      style: TextStyle(fontSize: 20),
      validator: (String value) {
        if (value.isEmpty) {
          return 'Total Distance is required';
        }
        return null;
      },
      onSaved: (String value) {
        widget.onTotalDistanceChanged(value);
      },
    );
  }
}

class DateField extends StatelessWidget {
  DateField({this.context, this.selectedDate, this.onDateChanged});

  final BuildContext context;
  final DateTime selectedDate;
  final DateChangedCallback onDateChanged;
  Widget build(BuildContext context) {
    return Container(
      height: 50,
      child: Card(
        elevation: 10,
        child: Row(
          children: <Widget>[
            Expanded(
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text(
                  selectedDate == null
                      ? 'No Date Chosen!'
                      : 'Picked Date: ${DateFormat.yMd().format(selectedDate)}',
                ),
              ),
            ),
            FlatButton(
              textColor: Theme.of(context).primaryColor,
              child: Text(
                'Choose Date',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  color: Colors.amber,
                ),
              ),
              onPressed: () => _presentDatePicker(context, onDateChanged),
            ),
          ],
        ),
      ),
    );
  }
}

void _presentDatePicker(
    BuildContext context, DateChangedCallback onDateChanged) {
  showDatePicker(
    context: context,
    initialDate: DateTime.now(),
    firstDate: DateTime(2019),
    lastDate: DateTime.now(),
  ).then((pickedDate) {
    if (pickedDate == null) {
      return;
    }
    onDateChanged(pickedDate);
  });
  print('...');
}

class JournalField extends StatefulWidget {
  JournalField({this.journal, this.onJournalSaved});

  final String journal;
  final FieldChangedCallback onJournalSaved;

  @override
  _JournalFieldState createState() => _JournalFieldState();
}

class _JournalFieldState extends State<JournalField> {
  Widget build(BuildContext context) {
    return Container(
      child: Padding(
        padding: const EdgeInsets.all(10.0),
        child: TextFormField(
          initialValue: widget.journal,
          minLines: 10,
          maxLines: 10,
          autocorrect: true,
          decoration: InputDecoration(
            hintText: 'Journal',
            filled: true,
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.all(Radius.circular(10.0)),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.all(Radius.circular(10.0)),
            ),
          ),
          onSaved: (String value) {
            widget.onJournalSaved(value);
          },
        ),
      ),
    );
  }
}

class EditSetButton extends StatefulWidget {
  @override
  _EditSetButtonState createState() => _EditSetButtonState();
}

class _EditSetButtonState extends State<EditSetButton> {
  @override
  Widget build(BuildContext context) {
    bool _uploadMode = true;
    return Container(
      alignment: Alignment.centerLeft,
      margin: EdgeInsets.symmetric(
        vertical: 8,
      ),
      child: RaisedButton(
        child: Text(_uploadMode ? 'Write Set' : 'Upload Photo'),
        color: Theme.of(context).primaryColor,
        textColor: Theme.of(context).textTheme.button.color,
        onPressed: () {
          setState(() {
            _uploadMode = !_uploadMode;
          });
        },
      ),
    );
  }
}

class AddSetWidget extends StatefulWidget {
  AddSetWidget(
      {this.onSetAdded,
      this.onSetRemoved,
      this.onBarAdded,
      this.onBarRemoved,
      this.onRoundsChanged,
      this.currentSets,
      this.currentSet,
      this.onPracticeSaved,
      this.onRepsChanged,
      this.onDistanceChanged,
      this.onStrokeChanged,
      this.onSwimTypeChanged,
      this.onIntervalChanged});

  final SetChangeCallback onSetAdded;
  final SetChangeCallback onSetRemoved;
  final BarChangeCallback onBarAdded;
  final BarChangeCallback onBarRemoved;
  final RoundsChangedCallback onRoundsChanged;
  final BarFieldChangeCallback onRepsChanged;
  final BarFieldChangeCallback onDistanceChanged;
  final BarFieldChangeCallback onStrokeChanged;
  final BarFieldChangeCallback onSwimTypeChanged;
  final BarFieldChangeCallback onIntervalChanged;
  final List<PracticeSet> currentSets;
  final PracticeSet currentSet;
  final ShowWidgetCallback onPracticeSaved;
  // final IntervalChangeCallback onIntervalChanged;

  @override
  _AddSetWidgetState createState() => _AddSetWidgetState();
}

class _AddSetWidgetState extends State<AddSetWidget> {
  @override
  Widget build(BuildContext context) {
    return Container(
      child: Column(
        children: <Widget>[
          Row(
            children: <Widget>[
              IconButton(
                  icon: Icon(Icons.add), onPressed: () => widget.onSetAdded()),
              IconButton(
                icon: Icon(Icons.remove),
                onPressed: () => widget.onSetRemoved(),
              ),
            ],
          ),
          Container(
            height: 500,
            child: ListView.builder(
              shrinkWrap: true,
              itemCount: widget.currentSets.length,
              scrollDirection: Axis.vertical,
              itemBuilder: (context, index) {
                return SetCard(
                    setIndex: index,
                    onBarAdded: widget.onBarAdded,
                    onBarRemoved: widget.onBarRemoved,
                    onRoundsChanged: widget.onRoundsChanged,
                    currentSet: widget.currentSets[index],
                    onRepsChanged: widget.onRepsChanged,
                    onDistanceChanged: widget.onDistanceChanged,
                    onStrokeChanged: widget.onStrokeChanged,
                    onSwimTypeChanged: widget.onSwimTypeChanged,
                    onIntervalChanged: widget.onIntervalChanged);
              },
            ),
          ),
          Container(
            alignment: Alignment.centerRight,
            margin: EdgeInsets.all(20),
            child: FloatingActionButton(
              heroTag: 'btn1',
              child: Icon(Icons.check),
              onPressed: () {
                widget.onPracticeSaved(context);
                Navigator.of(context).pop();
              },
            ),
          ),
        ],
      ),
    );
  }
}

class SetCard extends StatefulWidget {
  SetCard(
      {this.setIndex,
      this.onBarAdded,
      this.onBarRemoved,
      this.currentSet,
      this.onRoundsChanged,
      this.onRepsChanged,
      this.onDistanceChanged,
      this.onStrokeChanged,
      this.onSwimTypeChanged,
      this.onIntervalChanged});
  final int setIndex;
  final RoundsChangedCallback onRoundsChanged;
  final BarChangeCallback onBarAdded;
  final BarChangeCallback onBarRemoved;
  final BarFieldChangeCallback onRepsChanged;
  final BarFieldChangeCallback onDistanceChanged;
  final BarFieldChangeCallback onStrokeChanged;
  final BarFieldChangeCallback onSwimTypeChanged;
  final BarFieldChangeCallback onIntervalChanged;
  final PracticeSet currentSet;
  // final IntervalChangeCallback onIntervalChanged;

  @override
  _SetCardState createState() => _SetCardState();
}

class _SetCardState extends State<SetCard> {
  @override
  Widget build(BuildContext context) {
    return Card(
        elevation: 10,
        margin: EdgeInsets.symmetric(
          vertical: 8,
          horizontal: 5,
        ),
        child: Column(
          children: <Widget>[
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Padding(
                  padding: EdgeInsets.all(5),
                ),
                Container(
                  height: 40,
                  width: 90,
                  padding: EdgeInsets.all(2),
                  child: SizedBox(
                    width: 150,
                    height: 60,
                    child: Center(
                      child: Text(
                        'Rounds',
                        textScaleFactor: 1.70,
                      ),
                    ),
                  ),
                ),
                Container(
                  height: 32,
                  width: 40,
                  margin: EdgeInsets.all(10),
                  child: TextFormField(
                      initialValue: widget.currentSet.rounds,
                      keyboardType: TextInputType.number,
                      decoration: InputDecoration(
                        hintText: '',
                      ),
                      onSaved: (String value) {
                        widget.onRoundsChanged(value, widget.setIndex);
                      }),
                ),
              ],
            ),
            Container(
              height: (widget.currentSet.bars.length * 50).toDouble(),
              child: ListView.builder(
                itemBuilder: (context, barIndex) {
                  return PracticeBarRow(
                      setIndex: widget.setIndex,
                      barIndex: barIndex,
                      onRepsChanged: widget.onRepsChanged,
                      onDistanceChanged: widget.onDistanceChanged,
                      onStrokeChanged: widget.onStrokeChanged,
                      onSwimTypeChanged: widget.onSwimTypeChanged,
                      onIntervalChanged: widget.onIntervalChanged,
                      // onIntervalChanged: widget.onIntervalChanged,
                      currentBar: widget.currentSet.bars[barIndex]);
                },
                itemCount: widget.currentSet.bars.length,
                physics: NeverScrollableScrollPhysics(),
                scrollDirection: Axis.vertical,
              ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Container(
                  padding: EdgeInsets.symmetric(horizontal: 5),
                  height: 35,
                  width: 35,
                  child: FloatingActionButton(
                      heroTag: null,
                      child: Icon(Icons.add),
                      onPressed: () => widget.onBarAdded(widget.setIndex)),
                ),
                Container(
                  padding: EdgeInsets.symmetric(horizontal: 5),
                  height: 35,
                  width: 35,
                  child: FloatingActionButton(
                      heroTag: null,
                      child: Icon(Icons.remove),
                      onPressed: () => widget.onBarRemoved(widget.setIndex)),
                )
              ],
            ),
          ],
        ));
  }
}

class PracticeBarRow extends StatefulWidget {
  PracticeBarRow(
      {this.setIndex,
      this.barIndex,
      this.onRepsChanged,
      this.onDistanceChanged,
      this.onStrokeChanged,
      this.onSwimTypeChanged,
      this.currentBar,
      this.onIntervalChanged});
  final int setIndex;
  final int barIndex;
  final BarFieldChangeCallback onRepsChanged;
  final BarFieldChangeCallback onDistanceChanged;
  final BarFieldChangeCallback onStrokeChanged;
  final BarFieldChangeCallback onSwimTypeChanged;
  final BarFieldChangeCallback onIntervalChanged;
  final PracticeBar currentBar;

  @override
  _PracticeBarRowState createState() => _PracticeBarRowState();
}

class _PracticeBarRowState extends State<PracticeBarRow> {
  // void intervalPicker() {
  //   showModalBottomSheet(
  //       context: context,
  //       builder: (BuildContext builder) {
  //         return StatefulBuilder(
  //             builder: (BuildContext context, StateSetter setState) {
  //           return Container(
  //             child: CupertinoTimerPicker(
  //               mode: CupertinoTimerPickerMode.ms,
  //               minuteInterval: 1,
  //               // initialTimerDuration: initialTimer,
  //               onTimerDurationChanged: (Duration changedtimer) {
  //                 setState(() {
  //                   // initialTimer = changedtimer;
  //                 });
  //               },
  //             ),
  //             height: MediaQuery.of(context).copyWith().size.height / 3,
  //           );
  //         });
  //       });
  // }

  @override
  build(BuildContext context) {
    return Row(mainAxisAlignment: MainAxisAlignment.center, children: <Widget>[
      Padding(
        padding: EdgeInsets.all(9),
      ),
      Container(
        height: 32,
        width: 40,
        child: TextFormField(
          initialValue: widget.currentBar.reps,
          keyboardType: TextInputType.number,
          decoration: InputDecoration(
            hintText: 'Reps',
          ),
          onSaved: (String value) {
            widget.onRepsChanged(widget.setIndex, widget.barIndex, value);
          },
        ),
      ),
      Container(
        height: 32,
        width: 40,
        margin: EdgeInsets.all(6),
        child: TextFormField(
            initialValue: widget.currentBar.distance,
            keyboardType: TextInputType.number,
            decoration: InputDecoration(
              hintText: 'Distance',
            ),
            onSaved: (String value) {
              widget.onDistanceChanged(widget.setIndex, widget.barIndex, value);
            }),
      ),
      DropdownButton<String>(
        items: _stroke.map((String dropDownStringItem) {
          return DropdownMenuItem<String>(
            value: dropDownStringItem,
            child: Text(dropDownStringItem),
          );
        }).toList(),
        onChanged: (String newValueSelected) {
          widget.onStrokeChanged(
              widget.setIndex, widget.barIndex, newValueSelected);
        },
        value: widget.currentBar.stroke,
      ),
      DropdownButton<String>(
        items: _type.map((String stringItem) {
          return DropdownMenuItem<String>(
            value: stringItem,
            child: Text(stringItem),
          );
        }).toList(),
        onChanged: (String valueSelected) {
          widget.onSwimTypeChanged(
              widget.setIndex, widget.barIndex, valueSelected);
        },
        value: widget.currentBar.swimType,
      ),
      // GestureDetector(
      //   onTap: () {
      //     intervalPicker();
      //   },
      // child:
      Container(
        height: 32,
        width: 40,
        margin: EdgeInsets.all(6),
        child: TextFormField(
          initialValue: widget.currentBar.interval,
          decoration: InputDecoration(
            hintText: 'Interval',
          ),
          // onTap: () {
          //   widget.onIntervalChanged(
          //       widget.setIndex, widget.barIndex, context);
          // },
          onSaved: (String value) {
            widget.onIntervalChanged(widget.setIndex, widget.barIndex, value);
          },
        ),
      ),
      // ),
      // MaterialButton(
      //     textColor: Colors.black,
      //     child: Text(
      //       'Interval',
      //       style: TextStyle(
      //         fontWeight: FontWeight.normal,
      //       ),
      //     ),
      //     onPressed: () => widget.onIntervalChanged(widget.setIndex, widget.barIndex, context))
    ]);
  }
}

class PracticeForm extends StatefulWidget {
  final bool isUpdating;

  PracticeForm({@required this.isUpdating});
  @override
  PracticeFormState createState() => PracticeFormState();
}

class PracticeFormState extends State<PracticeForm> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  Practice _currentPractice;
  String _imageUrl;
  File _imageFile;
  DateTime selectedDate;
  bool _uploadMode = true;

  @override
  void initState() {
    super.initState();
    PracticeNotifier practiceNotifier =
        Provider.of<PracticeNotifier>(context, listen: false);
    if (practiceNotifier.currentPractice != null) {
      _currentPractice = practiceNotifier.currentPractice;
    } else {
      _currentPractice = Practice();
    }
    _imageUrl = _currentPractice.image;
  }

  _showImage() {
    if (_imageFile == null && _imageUrl == null) {
      return Text("image placeholder");
    } else if (_imageFile != null) {
      print('showing image from local file');

      return Stack(
        alignment: AlignmentDirectional.bottomCenter,
        children: <Widget>[
          Image.file(
            _imageFile,
            fit: BoxFit.cover,
            height: 250,
          ),
          FlatButton(
            padding: EdgeInsets.all(16),
            color: Colors.black54,
            child: Text(
              'Change Image',
              style: TextStyle(
                  color: Colors.white,
                  fontSize: 22,
                  fontWeight: FontWeight.w400),
            ),
            onPressed: () => _getLocalImage(),
          )
        ],
      );
    } else if (_imageUrl != null) {
      print('showing image from url');

      return Stack(
        alignment: AlignmentDirectional.bottomCenter,
        children: <Widget>[
          Image.network(
            _imageUrl,
            width: MediaQuery.of(context).size.width,
            fit: BoxFit.cover,
            height: 250,
          ),
          FlatButton(
            padding: EdgeInsets.all(16),
            color: Colors.black54,
            child: Text(
              'Change Image',
              style: TextStyle(
                  color: Colors.white,
                  fontSize: 22,
                  fontWeight: FontWeight.w400),
            ),
            onPressed: () => _getLocalImage(),
          )
        ],
      );
    }
  }

  _getLocalImage() async {
    File imageFile = await ImagePicker.pickImage(
        source: ImageSource.gallery, imageQuality: 50, maxWidth: 400);

    if (imageFile != null) {
      setState(() {
        _imageFile = imageFile;
      });
    }
  }

  void _handleTitleChanged(String title) {
    setState(() => _currentPractice.title = title);
  }

  void _handleTotalDistanceChanged(String distance) {
    setState(() => _currentPractice.totalDistance = distance);
  }

  void _handleDateChanged(DateTime pickedDate) {
    setState(() => selectedDate = pickedDate);
  }

  void _handleJournalSaved(String journal) {
    setState(() => _currentPractice.journal = journal);
  }

  void _handleRoundsChanged(String rounds, int setIndex) {
    setState(() {
      _currentPractice.sets[setIndex].rounds = rounds;
    });
  }

  void _handleSetAdded() {
    setState(() => _currentPractice.sets.add(PracticeSet()));
  }

  void _handleSetRemoved() {
    setState(() => _currentPractice.sets.removeLast());
  }

  void _handleBarAdded(int setIndex) {
    setState(() => _currentPractice.sets[setIndex].bars.add(PracticeBar()));
  }

  void _handleBarRemoved(int setIndex) {
    setState(() => _currentPractice.sets[setIndex].bars.removeLast());
  }

  void _handleRepsChanged(setIndex, barIndex, value) {
    setState(() {
      _currentPractice.sets[setIndex].bars[barIndex].reps = value;
    });
  }

  void _handleDistanceChanged(setIndex, barIndex, value) {
    setState(() {
      _currentPractice.sets[setIndex].bars[barIndex].distance = value;
    });
  }

  void _handleStrokeChanged(setIndex, barIndex, newValueSelected) {
    setState(() {
      _currentPractice.sets[setIndex].bars[barIndex].stroke = newValueSelected;
    });
  }

  void _handleSwimTypeChanged(setIndex, barIndex, valueSelected) {
    setState(() {
      _currentPractice.sets[setIndex].bars[barIndex].swimType = valueSelected;
    });
  }

  void _handleIntervalChanged(setIndex, barIndex, value) {
    // showModalBottomSheet(
    //     context: context,
    //     builder: (BuildContext builder) {
    //       return Container(
    //         child: CupertinoTimerPicker(
    //           mode: CupertinoTimerPickerMode.ms,
    //           minuteInterval: 1,
    //           initialTimerDuration:
    //               _currentPractice.sets[setIndex].bars[barIndex].initialTimer,
    //           onTimerDurationChanged: (Duration changedTimer) {
    //             setState(() {
    //               _currentPractice.sets[setIndex].bars[barIndex].initialTimer =
    //                   changedTimer;
    //             });
    //           },
    //         ),
    //         height: MediaQuery.of(context).copyWith().size.height / 3,
    //       );
    //     });
    setState(() {
      _currentPractice.sets[setIndex].bars[barIndex].interval = value;
      // _currentPracticeBar.interval = value;
    });
  }

  _onPracticeUploaded(Practice practice) {
    PracticeNotifier practiceNotifier =
    Provider.of<PracticeNotifier>(context, listen: false);
    practiceNotifier.addPractice(practice);
    Navigator.pop(context);
  }

  savePractice(context) {
    if (!_formKey.currentState.validate()) {
      return;
    }

    _formKey.currentState.save();

    uploadpracticeAndImage(_currentPractice, widget.isUpdating, _imageFile,
        _onPracticeUploaded, selectedDate);

    print('title: ${_currentPractice.title}');
    print('total Distance: ${_currentPractice.totalDistance}');
    print('sets: ${_currentPractice.sets.toString()}');
    print('Journal: ${_currentPractice.journal}');
    print('Date: ${_currentPractice.createdAt}');
    Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Practice Form'),
        actions: [
          IconButton(
            icon: Icon(Icons.check),
            onPressed: () {
              savePractice(context);
            },
          )
        ],
      ),
      body: SingleChildScrollView(
        child: Form(
          key: _formKey,
          autovalidate: true,
          child: Padding(
            padding: const EdgeInsets.all(5.0),
            child: Column(
              children: <Widget>[
                SizedBox(
                  height: 10,
                ),
                TitleField(
                    title: _currentPractice.title,
                    onTitleChanged: _handleTitleChanged),
                DistanceField(
                    distance: _currentPractice.totalDistance,
                    onTotalDistanceChanged: _handleTotalDistanceChanged),
                DateField(
                    context: context,
                    selectedDate: selectedDate,
                    onDateChanged: _handleDateChanged),
                JournalField(
                    journal: _currentPractice.journal,
                    onJournalSaved: _handleJournalSaved),
                Container(
                  alignment: Alignment.centerLeft,
                  margin: EdgeInsets.symmetric(
                    vertical: 8,
                  ),
                  child: RaisedButton(
                    child: Text(_uploadMode ? 'Write Set' : 'Upload Photo'),
                    color: Theme.of(context).primaryColor,
                    textColor: Theme.of(context).textTheme.button.color,
                    onPressed: () {
                      setState(() {
                        _uploadMode = !_uploadMode;
                      });
                    },
                  ),
                ),
                AddSetWidget(
                    onSetAdded: _handleSetAdded,
                    onSetRemoved: _handleSetRemoved,
                    onBarAdded: _handleBarAdded,
                    onBarRemoved: _handleBarRemoved,
                    onRoundsChanged: _handleRoundsChanged,
                    currentSets: _currentPractice.sets,
                    onPracticeSaved: savePractice,
                    onRepsChanged: _handleRepsChanged,
                    onDistanceChanged: _handleDistanceChanged,
                    onStrokeChanged: _handleStrokeChanged,
                    onSwimTypeChanged: _handleSwimTypeChanged,
                    onIntervalChanged: _handleIntervalChanged),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
