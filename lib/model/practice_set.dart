import 'package:expense_app/model/practice_bar.dart';

class PracticeSet {
  String rounds;
  List<PracticeBar> bars = [];
  PracticeSet()
  {
    bars = [PracticeBar()];
  }

  PracticeSet.fromMap(Map<String, dynamic> data) {
    rounds = data['rounds'].toString();
    bars = (data['bars']as List)?.map((bars) {
      return PracticeBar.fromMap(bars);
    })?.toList() ?? [];
  }
  Map<String, dynamic> toMap() {
    List<Map<String,dynamic>> barsJson = List();
    bars.forEach((brs) => barsJson.add(brs.toMap()));
    return {
      'bars': barsJson,
      'rounds':rounds,
    };
  }
}
