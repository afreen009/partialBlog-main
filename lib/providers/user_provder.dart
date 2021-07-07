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
  var data;
  var check;
  UserProvider(UserData userData) {
    this._userData = userData;
    this._init();
  }

  UserData get user => this._userData;

  // Update user channel list
  updateChannelList(String channel) async {
    if (channel.isNotEmpty) {
      this._userData.channels.add(channel); //Update channel
      await _firebasesData.createOrUpdateUserData(this._userData);
      //Notify listeners
      notifyListeners();
    }
  }

//Update point
  Future updatePoint(int points, {bool isReduce: false}) async {
    print("userData$_userData");
    !isReduce ? _userData.points += points : _userData.points -= points;
    _userData.userId = this._userData.userId;
    _userData.email = this._userData.email;
    await _firebasesData
        .createOrUpdateUserData(this._userData); //Update in cache
    //Notify listeners
    notifyListeners();
  }
  // //Update point
  // updatePoint(int points, {bool isReduce: false}) async {
  //   if ((await _prefs).containsKey('user_data')) {
  //     !isReduce ? _userData.points += points : _userData.points -= points;
  //     print(this._userData);
  //     String ud = (await _prefs).getString('user_data');
  //     print((await _prefs).getString('user_data'));
  //     if (this._userData.userId == "") {
  //       (await _prefs).setString('user_data', ud.toString());
  //       await _firebasesData.createOrUpdateUserData(this._userData);
  //       //TODO
  //     } else {
  //       (await _prefs).setString(
  //           'user_data', this._userData.toString()); //Update in cache
  //       await _firebasesData.createOrUpdateUserData(this._userData);
  //     }

  //     //Notify listeners
  //     notifyListeners();
  //   }
  // }

// Fetch data of user
  Future<void> _init() async {
    // final user = FirebaseAuth.instance.currentUser;
    _firebaseAuth.authStateChanges().listen((_user) async => {
          {print(_user)},
          if (_user != null)
            //Once user already exist then his data are store in cache
            {
              this.data =
                  await this._firebasesData.retrieveUsersData(_user.uid),
              this.check = await this._firebasesData.retrieveUser(_user.uid),
              //No need to fetch data from the store data are store in cache memory
              this._userData = UserData(
                  email: _user.email,
                  name: _user.displayName,
                  userId: _user.uid,
                  pictureUrl: _user.uid,
                  channels: check ? data['channel'] : [],
                  points: check ? data['points'] : 0),
              await this._firebasesData.createOrUpdateUserData(_userData),
              //Notify
              notifyListeners()
            }
        });
  }
}
