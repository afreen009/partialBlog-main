import 'package:cloud_firestore/cloud_firestore.dart';
import 'dart:async';

import 'package:google_signin_example/model/users.dart';

class FirebaseServices {
  static final FirebaseFirestore _firebaseFirestore =
      FirebaseFirestore.instance;
  static final FirebaseServices instance = FirebaseServices._();

// Internal constructor
  FirebaseServices._();

  Future<void> saveDataUser(Users data) {
    _firebaseFirestore.collection('users').add(data.toJson());
    return null;
  }

  Future<void> saveDataBookMark(BookMarks data) {
    _firebaseFirestore.collection('bookmarks').add(data.toJson());
    return null;
  }
}
