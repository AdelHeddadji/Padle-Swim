import 'dart:collection';
import 'package:expense_app/api/practice_api.dart';
import 'package:expense_app/model/team.dart';
import 'package:flutter/cupertino.dart';

class TeamNotifier with ChangeNotifier {
  List<Team> _teamList = [];
  Team _currentTeam;

  UnmodifiableListView<Team> get teamList => UnmodifiableListView(_teamList);

  Team get currentTeam => _currentTeam;

  set teamList(List<Team> teamList) {
    _teamList = teamList;
    notifyListeners();
  }

  set currentTeam(Team team) {
    _currentTeam = team;
    notifyListeners();
  }

  addTeam(Team team) {
    _teamList.insert(0, team);
    notifyListeners();
  }

  deleteTeam(Team team) {
    _teamList.removeWhere((_team) => _team.teamId == team.teamId);
    notifyListeners();
  }

  Future<void> getData() async {
    return Future.delayed(const Duration(seconds: 1), () {
      List<Team> team = [];
    });
  }

  // Future<void> getData() async {
  //   return Future.delayed(const Duration(seconds: 1), () {
  //     //simulate server get data with delay
  //     List<ChildItem> ch = [];
  //     ch.add(ChildItem(id: 1, name: 'Child 1', idParent: 1));
  //     ch.add(ChildItem(id: 2, name: 'Child 2', idParent: 1));
  //     ch.add(ChildItem(id: 3, name: 'Child 3', idParent: 2));

  //     _children = ch.where((c) => c.idParent == _parentIdx).toList();
  //     //  notifyListeners();
  //   });
}