import 'dart:collection';

import 'package:expense_app/model/user.dart';
import 'package:firebase_auth/firebase_auth.dart';

import 'package:flutter/material.dart';

class AuthNotifier with ChangeNotifier {
  FirebaseUser _user;
  User _currentUser;
  List<User> _userList;

  FirebaseUser get user => _user;
  User get currentUser => _currentUser;

  UnmodifiableListView<User> get userList => UnmodifiableListView(_userList);

  void setUser(FirebaseUser user) {
    _user = user;
    notifyListeners();
  }

  set currentUser(User user) {
    _currentUser = user;
    notifyListeners();
  }

  set userList(List<User> userList) {
    _userList = userList;
    notifyListeners();
  }
}


