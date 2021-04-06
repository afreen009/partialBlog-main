import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:google_signin_example/database.dart';
import 'package:google_signin_example/model/user_credential.dart';
import 'package:google_signin_example/states/current_user.dart';
import 'package:html/dom.dart';
import 'package:shared_preferences/shared_preferences.dart';

FirebasesData _firebases = FirebasesData.instance;

class UserProvider extends ChangeNotifier {
  UserData _userData = UserData(name: '', channels: [], points: 0);

  FirebasesData _firebasesData = FirebasesData.instance;
  Future<SharedPreferences> _prefs = SharedPreferences.getInstance();

  UserProvider() {
    this._initUserData();
  }
  // Future<DocumentSnapshot> dataUser = _firebases.retrieveUser('_userId');

  UserData get user => this._userData;

  // Update user channel list
  updateChannelList(String channel) async {
    String userids = (await _prefs).get('userId');
    if (channel.isNotEmpty) {
      if ((await _prefs).containsKey('usersData')) {
        UserCredentials _usercred = UserCredentials.fromJson(
            Map.castFrom(json.decode((await _prefs).getString('usersData'))));
        print("yooooooooo$_usercred");
        this._userData.channels.add(channel);
        await _firebasesData.createOrUpdateUserData(this._userData, userids);
        //Notify listeners
        notifyListeners();
      }
    }
  }

  //{afreen.com}
  //Update point
  updatePoint(int points, {bool isReduce: false}) async {
    !isReduce ? _userData.points += points : _userData.points -= points;
    String userids = (await _prefs).get('userId');
    if ((await _prefs).containsKey('usersData')) {
      UserCredentials _usercred = UserCredentials.fromJson(
          Map.castFrom(json.decode((await _prefs).getString('usersData'))));
      print("inside updatePoint$userids");
      print("yohooooo$_usercred");
      await _firebasesData.createOrUpdateUserData(this._userData, userids);
      //Notify listeners
      notifyListeners();
    }
  }

// Fetch data of user
  void _initUserData() {
    FirebaseAuth.instance.authStateChanges().listen((_user) async => {
          if (_user != null)
            {
              // if ((await _prefs).containsKey('usersData') &&
              //     (await this._firebasesData.retrieveUser(
              //             UserCredentials.fromJson(Map.castFrom(json.decode(
              //                     (await _prefs).getString('usersData'))))
              //                 .userId)) ==
              //         null)
              //   {
              //     //Here we give default value to the user once not data is yet stored
              //     this._firebasesData.createOrUpdateUserData(
              //         UserData(
              //             name: _user.displayName, channels: [], points: 0),
              //         _user.uid)
              //   },
              print((await _prefs).containsKey('usersData')),
              if ((await _prefs).containsKey('usersData'))
                {
                  this._userData =
                      UserData.fromJson((await _firebasesData.retrieveUser(
                    (await _prefs).get('userId'),
                  ))
                          ?.data()),
                  notifyListeners()
                }
            }
        });
  }
}
