import 'dart:convert';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:google_signin_example/database.dart';
import 'package:google_signin_example/states/current_user.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../states/current_user.dart';

class UserProvider extends ChangeNotifier {
  UserData _userData;
  FirebasesData _firebasesData = FirebasesData.instance;
  FirebaseAuth _firebaseAuth = FirebaseAuth.instance;
  Future<SharedPreferences> _prefs = SharedPreferences.getInstance();

  UserProvider() {
    this._init();
  }

  UserData get user => this._userData;

  // Update user channel list
  updateChannelList(String channel) async {
    if (channel.isNotEmpty) {
      if ((await _prefs).containsKey('user_data')) {
        this._userData.channels.add(channel); //Update channel
        await _firebasesData.createOrUpdateUserData(this._userData);
        (await _prefs).setString(
            'user_data', this._userData.toString()); //Update in cache
        //Notify listeners
        notifyListeners();
      }
    }
  }

  //Update point
  updatePoint(int points, {bool isReduce: false}) async {
    if ((await _prefs).containsKey('user_data')) {
      !isReduce ? _userData.points += points : _userData.points -= points;
      await _firebasesData.createOrUpdateUserData(this._userData);
      (await _prefs)
          .setString('user_data', this._userData.toString()); //Update in cache
      //Notify listeners
      notifyListeners();
    }
  }

// Fetch data of user
  void _init() {
    _firebaseAuth.authStateChanges().listen((_user) async => {
          if (_user != null)
            //Once user already exist then his data are store in cache
            {
              if ((await _prefs).containsKey('user_data'))
                {
                  //No need to fetch data from the store data are store in cache memory
                  this._userData = UserData.fromJson(Map.castFrom(
                      json.decode((await _prefs).get('user_data')))),
                  //Notify
                  notifyListeners()
                }
            }
        });
  }
}
