class PracticeBar {
  String reps;
  String distance;
  String stroke;
  String swimType;
  String interval;
  PracticeBar() {
    stroke = 'Free';
    swimType = 'Aerobic';
  }

  PracticeBar.fromMap(Map<String, dynamic> data) {
    distance = data['distance'];
    reps = data['reps'];
    stroke = data['stroke'];
    swimType = data['type'];
    interval = data['interval'];
  }
  Map<String, dynamic> toMap() {
      return {
        'reps': reps,
        'distance': distance,
        'stroke': stroke,
        'type': swimType,
        'interval': interval
      };
    }
}



