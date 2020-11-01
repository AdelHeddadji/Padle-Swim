import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:expense_app/model/practice_set.dart';

class Practice {
  String id;
  String title;
  String totalDistance;
  String journal;
  String uid;
  Timestamp createdAt;
  List<PracticeSet> sets = [];
  String image;
  bool favorite = false;
  Practice(){
    sets = [PracticeSet()];
  }

  Practice.fromMap(Map<dynamic, dynamic> data) {
    id = data['id'];
    uid = data['uid'];
    title = data['title'];
    favorite = data['favorite'];
    totalDistance = data['totalDistance'];
    journal = data['journal'];
    createdAt = data['createdAt'];
    sets = (data['Sets'] as List).map((sets) {
      return PracticeSet.fromMap(sets);
    }).toList();
    image = data['image'];
  }



  Map<String, dynamic> toMap() {
    List<Map<String,dynamic>> setsJson = List();
    sets.forEach((sts) => setsJson.add(sts.toMap()));
    return {
      'id': id,
      'title': title,
      'favorite': favorite,
      'uid': uid,
      'totalDistance': totalDistance,
      'journal': journal,
      'createdAt': createdAt,
      'Sets': setsJson,
      'image': image,
    };
  }
}
