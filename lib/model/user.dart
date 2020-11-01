import 'package:flutter/material.dart';

class User {
  String userName;
  String email;
  String password;
  String uid;
  String teamID;
  String lastName;
  String firstName;
  String userImage;
  bool isCoach;
  bool isYards;

  User();

  User.fromMap(Map<String, dynamic> data) {
    userName = data['userName'];
    email = data['email'];
    password = data['password'];
    uid = data['uid'];
    teamID = data['teamID'];
    firstName = data['firstName'];
    lastName = data['lastName'];
    userImage = data['userImage'];
    isCoach = data['isCoach'];
    isYards = data['distanceType'];
  }



  Map<String, dynamic> toMap() {
    return {
      'userName': userName,
      'email': email,
      'password': password,
      'uid': uid,
      'teamID': teamID,
      'firstName': firstName,
      'lastName': lastName,
      'userImage': userImage,
      'isCoach': isCoach,
      'distanceType': isYards,
    };
  }
}
