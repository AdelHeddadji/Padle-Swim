import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:expense_app/model/practice.dart';
import 'package:expense_app/model/team.dart';
import 'package:expense_app/model/user.dart';
import 'package:expense_app/model/user.dart';
import 'package:expense_app/notifier/auth_notifier.dart';
import 'package:expense_app/notifier/practice_notifier.dart';
import 'package:expense_app/notifier/team_notifier.dart';
import 'package:expense_app/notifier/usernotify.dart';
import 'package:expense_app/screens/tabs.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:uuid/uuid.dart';
import 'package:path/path.dart' as path;

login(User user, AuthNotifier authNotifier) async {
  AuthResult authResult = await FirebaseAuth.instance
      .signInWithEmailAndPassword(email: user.email, password: user.password)
      .catchError((error) => print(error.code));

  if (authResult != null) {
    FirebaseUser firebaseUser = authResult.user;

    if (firebaseUser != null) {
      print('Log In: $firebaseUser');
      authNotifier.setUser(firebaseUser);
    }
  }
}

signup(User user, AuthNotifier authNotifier) async {
  AuthResult authResult = await FirebaseAuth.instance
      .createUserWithEmailAndPassword(
          email: user.email, password: user.password)
      .catchError((error) => print(error.code));

  if (authResult != null) {
    UserUpdateInfo updateInfo = UserUpdateInfo();
    updateInfo.displayName = user.userName;

    FirebaseUser firebaseUser = authResult.user;

    if (firebaseUser != null) {
      await firebaseUser.updateProfile(updateInfo);

      await firebaseUser.reload();

      print('Sign up: $firebaseUser');

      FirebaseUser currentUser = await FirebaseAuth.instance.currentUser();
      authNotifier.setUser(currentUser);
      user.uid = currentUser.uid;
      Firestore.instance
          .collection('users')
          .document(currentUser.uid)
          .setData(user.toMap());
    }
  }
}

resetPass(User user, String email, AuthNotifier authNotifier) async {
  try {
    return await FirebaseAuth.instance
        .sendPasswordResetEmail(email: user.email);
  } catch (e) {
    print(e.toString());
  }
}

Future<FirebaseUser> signInWithGoogle(
    BuildContext context, AuthNotifier authNotifier) async {
  final GoogleSignIn _googleSignIn = new GoogleSignIn();

  final GoogleSignInAccount googleSignInAccount = await _googleSignIn.signIn();
  final GoogleSignInAuthentication googleSignInAuthentication =
      await googleSignInAccount.authentication;

  final AuthCredential credential = GoogleAuthProvider.getCredential(
      idToken: googleSignInAuthentication.idToken,
      accessToken: googleSignInAuthentication.accessToken);

  AuthResult result =
      await FirebaseAuth.instance.signInWithCredential(credential);
  FirebaseUser userDetails = result.user;

  if (result == null) {
  } else {
    Navigator.push(context, MaterialPageRoute(builder: (context) => Tabs()));
  }
}

signOut(AuthNotifier authNotifier) async {
  await FirebaseAuth.instance
      .signOut()
      .catchError((error) => print(error.code));

  authNotifier.setUser(null);
}

getTeams(TeamNotifier teamNotifier, dynamic teamId) async {
  QuerySnapshot snapshot =
      await Firestore.instance.collection('teams').where('teamID', isEqualTo: teamId).getDocuments();
    
    Team team;
    snapshot.documents.forEach((document) {
      Team team = Team.fromMap(document.data);
      teamNotifier.currentTeam = team;
    });

    snapshot.documentChanges.map((e) => Team);
    teamNotifier.currentTeam = team;

  List<Team> _teamList = [];

  dynamic nowTeam;

  snapshot.documents.forEach((document) {
    Team team = Team.fromMap(document.data);
    _teamList.add(team);
  });

  teamNotifier.teamList = _teamList;
  teamNotifier.teamList[0] = nowTeam;

  return snapshot;
}

getUserInfo(UserNotifier userNotifier) async {
  FirebaseUser currentUser = await FirebaseAuth.instance.currentUser();
  QuerySnapshot snapshot = await Firestore.instance
      .collection('users')
      .where('uid', isEqualTo: currentUser.uid)
      .getDocuments();

    User user;
  snapshot.documents.forEach((document) {
    User user = User.fromMap(document.data);
    userNotifier.currentUser = user;
  });

  snapshot.documents.map((e) => User);
  userNotifier.currentUser = user;

  List<User> _userList = [];

  snapshot.documents.forEach((document) {
    User user = User.fromMap(document.data);
    _userList.add(user);
  });

  userNotifier.userList = _userList;
}

initializeCurrentUser(AuthNotifier authNotifier) async {
  FirebaseUser firebaseUser = await FirebaseAuth.instance.currentUser();

  if (firebaseUser != null) {
    print(firebaseUser);
    authNotifier.setUser(firebaseUser);
  }
}

getRecentPractices(PracticeNotifier practiceNotifier) async {
  FirebaseUser currentUser = await FirebaseAuth.instance.currentUser();
  DateTime today = new DateTime.now();
  DateTime sevenDaysAgo = today.subtract(new Duration(days: 7));
  QuerySnapshot snapshot = await Firestore.instance
      .collection('practice')
      .where('uid', isEqualTo: currentUser.uid)
      .orderBy('createdAt', descending: true)
      .startAt([today]).endAt([sevenDaysAgo]).getDocuments();

  List<Practice> _practiceList = [];

  snapshot.documents.forEach((document) {
    Practice practice = Practice.fromMap(document.data);
    _practiceList.add(practice);
  });

  practiceNotifier.practiceList = _practiceList;
}


getPractices(PracticeNotifier practiceNotifier) async {
  FirebaseUser currentUser = await FirebaseAuth.instance.currentUser();
  QuerySnapshot snapshot = await Firestore.instance
      .collection('practice')
      .reference()
      .where('uid', isEqualTo: currentUser.uid)
      .getDocuments();

  List<Practice> _practiceList = [];

  snapshot.documents.forEach((document) {
    Practice practice = Practice.fromMap(document.data);
    _practiceList.add(practice);
  });

  practiceNotifier.practiceList = _practiceList;
}

//if isCoach is true allow for other stuff like to add practices.
//if isCoach is true allow for another tab to handle members that want to join, add practices to team.

//gets all teams practices for swimmers

getTeamPractices(PracticeNotifier practiceNotifier, User user) async {
  QuerySnapshot snapshot = await Firestore.instance
      .collection('practice')
      .reference()
      .where('teamID', isEqualTo: user.teamID)
      .getDocuments();
  List<Practice> _practiceList = [];
  snapshot.documents.forEach((document) {
    Practice practice = Practice.fromMap(document.data);
    _practiceList.add(practice);
  });

  practiceNotifier.practiceList = _practiceList;
}

getDate(PracticeNotifier practiceNotifier, DateTime date) async {
  QuerySnapshot db =
      await Firestore.instance.collection('practice').getDocuments();
  List<Practice> _practiceList = [];

  db.documents.forEach((document) {
    Practice practice = Practice.fromMap(document.data);
    _practiceList.add(practice);
  });

  practiceNotifier.practiceList = _practiceList;
}

uploadpracticeAndImage(Practice practice, bool isUpdating, File localFile,
    Function practiceUploaded, DateTime dateTime) async {
  if (localFile != null) {
    print("uploading image");

    var fileExtension = path.extension(localFile.path);
    print(fileExtension);

    var uuid = Uuid().v4();

    final StorageReference firebaseStorageRef = FirebaseStorage.instance
        .ref()
        .child('practice/images/$uuid$fileExtension');

    await firebaseStorageRef
        .putFile(localFile)
        .onComplete
        .catchError((onError) {
      print(onError);
      return false;
    });

    String url = await firebaseStorageRef.getDownloadURL();
    print("download url: $url");
    uploadPractice(practice, isUpdating, practiceUploaded, dateTime,
        imageUrl: url);
  } else {
    print('...skipping image upload');
    uploadPractice(practice, isUpdating, practiceUploaded, dateTime);
  }
}

uploadPractice(Practice practice, bool isUpdating, Function practiceUploaded,
    DateTime dateTime,
    {String imageUrl}) async {
  FirebaseUser currentUser = await FirebaseAuth.instance.currentUser();
  CollectionReference practiceRef = Firestore.instance.collection('practice');

  // FirebaseUser currentUser = await FirebaseAuth.instance.currentUser();

  practice.uid = currentUser.uid;

  if (imageUrl != null) {
    practice.image = imageUrl;
  }

  if (isUpdating) {
    await practiceRef.document(practice.id).updateData(practice.toMap());

    practiceUploaded(practice);

    print('updated practice with id: ${practice.id}');
  } else {
    practice.createdAt = Timestamp.fromDate(dateTime);

    DocumentReference documentRef = await practiceRef.add(practice.toMap());

    practice.id = documentRef.documentID;

    print('uploaded practice successfully: ${practice.toString()}');

    await documentRef.setData(practice.toMap(), merge: true);

    practiceUploaded(practice);
  }
}

uploadUserAndImage(User user, bool isUpdating, File localFile, Function userUploaded) async {
  if (localFile != null) {
    print('uploading image');

    var fileExtension = path.extension(localFile.path);
    print(fileExtension);

    var uuid = Uuid().v4();

    final StorageReference firebaseStorageRef = FirebaseStorage.instance.ref().child('users/userImage/$uuid$fileExtension');

    await firebaseStorageRef.putFile(localFile).onComplete.catchError((onError) {
      print(onError);
      return false;
  });

  String url = await firebaseStorageRef.getDownloadURL();
  print("download url: $url");
  _uploadUserInfo(user, isUpdating, userUploaded, imageUrl: url);
  }
  else {
    print('...skipping image upload');
    _uploadUserInfo(user, isUpdating, userUploaded);
  }
}

_uploadUserInfo(User user, bool isUpdating, Function userUploaded, {String imageUrl}) async {
  CollectionReference userRef = Firestore.instance.collection('users');

  if (imageUrl!= null) {
    user.userImage = imageUrl;
  }

  if (isUpdating) {
    await userRef.document(user.uid).updateData(user.toMap());
  }
  userUploaded(user);
  print('updated user with id: ${user.uid}');
}


deletePractice(Practice practice, Function practiceDeleted) async {
  if (practice.image != null) {
    StorageReference storageReference =
        await FirebaseStorage.instance.getReferenceFromUrl(practice.image);

    print(storageReference.path);

    await storageReference.delete();

    print('image deleted');
  }

  await Firestore.instance
      .collection('practice')
      .document(practice.id)
      .delete();

  practiceDeleted(practice);
}