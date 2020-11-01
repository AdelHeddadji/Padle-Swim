import 'dart:collection';

import 'package:expense_app/model/practice.dart';
import 'package:expense_app/model/practice_set.dart';
import 'package:expense_app/model/practice_bar.dart';
import 'package:expense_app/model/user.dart';
import 'package:expense_app/notifier/auth_notifier.dart';
import 'package:firebase_auth/firebase_auth.dart';

import 'package:flutter/material.dart';

class PracticeNotifier with ChangeNotifier {
  List<Practice> _practiceList = [];
  Practice _currentPractice;
  PracticeSet _currentPracticeSet;
  PracticeBar _currentPracticeBar;
  AuthNotifier authNotifier;

  UnmodifiableListView<Practice> get practiceList =>
      UnmodifiableListView(_practiceList);

  Practice get currentPractice => _currentPractice;
  PracticeSet get currentPracticeSet => _currentPracticeSet;
  PracticeBar get currentPracticeBar => _currentPracticeBar;

  set practiceList(List<Practice> practiceList)  {
    _practiceList = practiceList;
    notifyListeners();
  }

  set currentPractice(Practice practice) {
    _currentPractice = practice;
    notifyListeners();
  }

  set currentPracticeSet(PracticeSet practiceSet) {
    _currentPracticeSet = practiceSet;
    notifyListeners();
  }

  set currentPracticeBar(PracticeBar practiceBar) {
    _currentPracticeBar = practiceBar;
    notifyListeners();
  }

  addPractice(Practice practice) {
    _practiceList.insert(0, practice);
    notifyListeners();
  }

  deletePractice(Practice practice){
    _practiceList.removeWhere((_practice) => _practice.id == practice.id);
    notifyListeners();
  }

  addPracticeSet(PracticeSet practiceSet) {
    _currentPractice.sets.add(practiceSet);
    notifyListeners();
  }

  addPracticeBar(PracticeBar practiceBar) {
    _currentPracticeSet.bars.add(practiceBar);
    notifyListeners();
  }

  popPracticeSet() {
    _currentPractice.sets.removeLast();
    notifyListeners();
  }

  popPracticeBar() {
    _currentPracticeSet.bars.removeLast();
    notifyListeners();
  }
}


