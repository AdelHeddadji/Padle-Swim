import 'dart:collection';

import 'package:expense_app/model/user.dart';
import 'package:flutter/material.dart';

class UserNotifier with ChangeNotifier {
  List<User> _userList = [];
  User _currentUser;

  UnmodifiableListView<User> get userList => UnmodifiableListView(_userList);

  User get currentUser => _currentUser;

  set userList(List<User> userList) {
    _userList = userList;
    notifyListeners();
  }

  set currentUser(User user) {
    _currentUser = user;
    notifyListeners();
  }

  addUser(User user) {
    _userList.insert(0, user);
    notifyListeners();
  }

  deleteUser(User user) {
    _userList.removeWhere((_user) => _user.uid == user.uid);
    notifyListeners();
  }
}