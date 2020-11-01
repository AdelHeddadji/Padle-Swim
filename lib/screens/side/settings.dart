import 'dart:io';

import 'package:expense_app/api/practice_api.dart';
import 'package:expense_app/model/user.dart';
import 'package:expense_app/notifier/auth_notifier.dart';
import 'package:expense_app/notifier/usernotify.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class Settings extends StatefulWidget {

  final bool isUpdating = true;
  @override
  _SettingsState createState() => _SettingsState();
}

class _SettingsState extends State<Settings> {
  bool isSwitched = false;
  User _currentUser;
  File _imageFile;
  final GlobalKey<FormState> _settingsKey = GlobalKey<FormState>();
  final GlobalKey<ScaffoldState> _scaffoldSettingsKey = GlobalKey<ScaffoldState>();

  @override
  void initState() {
    super.initState();
    UserNotifier userNotifier = Provider.of<UserNotifier>(context, listen: false);
    if (userNotifier.userList[0] != null) {
      _currentUser = userNotifier.userList[0];
    } else {
      _currentUser = User();
    }

  }

  textFieldMaker(String label, String initialValue, String input) {
    return Container(
      height: 50,
      padding: EdgeInsets.symmetric(horizontal: 20),
      child: Row(
        children: [
          Container(
            width: MediaQuery.of(context).size.width * .3,
            child: Text(
              label,
              style: TextStyle(fontSize: 17),
            ),
          ),
          Container(
            height: 20,
            width: MediaQuery.of(context).size.width * .55,
            child: TextFormField(
              initialValue: initialValue,
              onSaved: (String value) {
                input = value;
              },
            ),
          ),
        ],
      ),
    );
  }

  _onUserUploaded( User user) {
    UserNotifier userNotifier = Provider.of<UserNotifier>(context, listen: false);
    userNotifier.addUser(user);
    Navigator.pop(context);
  }

  _saveUser() {
    print('saveUser Called');
    if (!_settingsKey.currentState.validate()) {
      return;
    }

    _settingsKey.currentState.save();

    print('form saved');

    uploadUserAndImage(_currentUser, widget.isUpdating, _imageFile, _onUserUploaded);
    print("userName: ${_currentUser.userName}");
    print("firstName: ${_currentUser.firstName}");
    print("lastName: ${_currentUser.lastName}");
    print("email ${_currentUser.email}");
  }

  @override
  Widget build(BuildContext context) {
    AuthNotifier authNotifier =
        Provider.of<AuthNotifier>(context, listen: false);
    UserNotifier userNotifier =
        Provider.of<UserNotifier>(context, listen: false);
    getUserInfo(userNotifier);
    return Scaffold(
      key: _scaffoldSettingsKey,
      appBar: AppBar(
        title: Text('Settings'),
      ),
      body: SingleChildScrollView(
        child: Form(
          key: _settingsKey,
          child: Column(
            children: [
              SizedBox(
                height: 20,
              ),
              Container(
                height: 100,
                child: Row(
                  children: [
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 15),
                      child: CircleAvatar(
                        radius: 40,
                        backgroundImage: NetworkImage(
                          'https://static.politico.com/dims4/default/5104086/2147483647/resize/1160x%3E/quality/90/?url=https%3A%2F%2Fstatic.politico.com%2F5e%2F36%2F20d9fdcd4d8ab0e0b2add5e77371%2Fap20178460172749-1.jpg',
                        ),
                        backgroundColor: Colors.blue,
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 15, vertical: 25),
                      child: Column(
                        children: [
                          Text(
                            authNotifier.user.displayName,
                            style: TextStyle(fontSize: 25),
                          ),
                          Text('Crow Canyon Sharks',
                              style:
                                  TextStyle(fontSize: 15, color: Colors.grey))
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(height: 10),
              Container(
                child: Text(
                  'Update/Edit all your personal information',
                  style: TextStyle(color: Colors.grey),
                ),
              ),
              SizedBox(height: 10),
              textFieldMaker('Username', userNotifier.userList[0].userName,
                  _currentUser.userName),
              textFieldMaker(
                  'Email', userNotifier.userList[0].email, _currentUser.email),
              textFieldMaker('First Name', userNotifier.userList[0].firstName,
                  _currentUser.firstName),
              textFieldMaker('Last Name', userNotifier.userList[0].lastName,
                  _currentUser.lastName),
              ListTile(
                title: Text(
                  'Yards/Meters',
                  style: TextStyle(fontSize: 17),
                ),
                trailing: CupertinoSwitch(
                  value: isSwitched,
                  onChanged: (bool value) {
                    setState(() {
                      isSwitched = value;
                    });
                  },
                ),
                onTap: () {
                  setState(() {
                    isSwitched = !isSwitched;
                  });
                },
              ),
              SizedBox(
                height: 20,
              ),
              GestureDetector(
                child: Container(
                  alignment: Alignment.center,
                  width: MediaQuery.of(context).size.width * 0.5,
                  padding: EdgeInsets.symmetric(vertical: 15),
                  decoration: BoxDecoration(
                      color: Colors.blue,
                      borderRadius: BorderRadius.circular(30)),
                  child: Text(
                    'Update',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 20,
                    ),
                  ),
                ),
                onTap: () => _saveUser(),
              ),
              SizedBox(
                height: 20,
              ),
              GestureDetector(
                child: Container(
                  alignment: Alignment.center,
                  width: MediaQuery.of(context).size.width * 0.5,
                  padding: EdgeInsets.symmetric(vertical: 15),
                  decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(30)),
                  child: Text(
                    'Log Out',
                    style: TextStyle(
                      color: Colors.black87,
                      fontSize: 20,
                    ),
                  ),
                ),
                onTap: () => signOut(authNotifier),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
