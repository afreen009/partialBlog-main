import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:google_signin_example/states/current_user.dart';
import 'package:shared_preferences/shared_preferences.dart';

class FirebasesData {
  /// The main Firestore user collection
  User usersname = FirebaseAuth.instance.currentUser;

  FirebaseFirestore _instance = FirebaseFirestore.instance;
  String _collectionName = 'users';

  static final FirebasesData instance = FirebasesData._();

  FirebasesData._();

  Future<bool> checkExistanceOfUserData(String userId) async {
    DocumentSnapshot _documentSnapshot =
        await this._instance.collection(this._collectionName).doc(userId).get();
    if (_documentSnapshot.exists) {
      return true;
    }
    return false;
  }

  createOrUpdateUserData(UserData userData, String userId) async {
    // String uid = userId == null ? usersname.uid : userId;
    // print("userid${usersname.uid}");
    print("userid$userId");

    try {
      await this
          ._instance
          .collection('users')
          .doc(userId)
          .set(userData.toJson());
    } catch (e) {
      throw Exception(e.toString());
    }
  }
  //Show me where you create now userData object
  ////create userdata for? i mean where do you initialize user data ? as i said i dint use it

  //What is the method you create for getting user date I mean channel list inside of data

  // storeUserData({@required String userName}) async {
  //   print("uid:$uid");
  //   DocumentReference documentReferencer = userCollection.doc(uid);

  //   UserData user = UserData(
  //     uid: uid,
  //     name: userName,
  //     presence: true,
  //     lastSeenInEpoch: DateTime.now().millisecondsSinceEpoch,
  //   );

  //   var data = user.toJson();
  //   print(data);
  //   await documentReferencer.set(data).whenComplete(() {
  //     print("data:$data");
  //     print("User data added");
  //   }).catchError((e) => print(e));

  //   SharedPreferences prefs = await SharedPreferences.getInstance();
  //   prefs.setString('user_name', userName);

  //   updateUserPresence();
  // }

  Future<DocumentSnapshot> retrieveUser(String userId) async {
    // return await databaseReference.child
    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      String userids = prefs.get('userId');
      DocumentSnapshot _doc = await this._instance.doc("users/$userids").get();
      if (_doc.exists) {
        return _doc;
      }
      return null;
    } catch (e) {
      throw Exception(e.toString());
    }
  }

  Stream<DocumentSnapshot> getData() async* {
    yield* this._instance.collection('users').doc(usersname.uid).snapshots();
  }

  // updateUserPresence({int points, String channel}) async {
  //   var id = usersname.uid;
  //   print('inside update$id');
  //   print('points:$points');
  //   Map<String, dynamic> data = {
  //     'name': userName,
  //     'points': points,
  //     'channel': channel == null ? channel : channel
  //   };
  //   try {
  //     // await userCollection.doc(id).set(data,SetOptions.merge());
  //     userCollection
  //         .doc(id)
  //         .set(data, SetOptions(merge: true))
  //         .whenComplete(() => print('Updated your presence.'))
  //         .catchError((e) => print('not updated'));
  //     var getdata = getData();
  //     print(getdata);
  //     // databaseReference
  //     //     .child(id)
  //     //     .update(data)
  //     //     .whenComplete(() => print('Updated your presence.'))
  //     //     .catchError((e) => print(e));
  //   } catch (e) {
  //     print(e.toString());
  //   }
  //   CollectionReference userCollection =
  //       FirebaseFirestore.instance.collection('users');
  //   DatabaseReference databaseReference = FirebaseDatabase.instance.reference();
  //   Map<String, dynamic> presenceStatusTrue = {
  //     'presence': true,
  //     'last_seen': DateTime.now().millisecondsSinceEpoch,
  //   };

  //   await databaseReference
  //       .child(uid)
  //       .update(presenceStatusTrue)
  //       .whenComplete(() => print('Updated your presence.'))
  //       .catchError((e) => print(e));

  //   Map<String, dynamic> presenceStatusFalse = {
  //     'presence': false,
  //     'last_seen': DateTime.now().millisecondsSinceEpoch,
  //   };

  //   databaseReference.child(uid).onDisconnect().update(presenceStatusFalse);
  // }
}
