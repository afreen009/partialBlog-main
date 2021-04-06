import 'dart:convert';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:google_signin_example/database.dart';
import 'package:google_signin_example/model/user_credential.dart';
import 'package:google_signin_example/states/current_user.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AuthenticationProvider extends ChangeNotifier {
  UserCredentials _user;
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;
  final GoogleSignIn _googleSignIn = GoogleSignIn();
  bool _isSigningIn = false;
  bool userStatus = false;
  FirebasesData _firebasesData = FirebasesData.instance;
  Future<SharedPreferences> _prefs = SharedPreferences.getInstance();

  AuthenticationProvider() {
    _initAuth();
  }

  Stream<User> get userStreamStatus => this._firebaseAuth.authStateChanges();

  //for storing users credential
  Future<void> saveUserCredentials() async {
    (await _prefs).setString('usersData', this._user.toString());
    (await _prefs).setBool('is_user_logged', this.userStatus);
  }

  //for storing users credential
  Future<void> getUserCredentials() async {
    if ((await _prefs).containsKey('usersData')) {
      String _userStringify = (await _prefs).getString('usersData');
      this.userStatus = (await _prefs).getBool('is_user_logged');
      this._user =
          UserCredentials.fromJson(Map.castFrom(json.decode(_userStringify)));
      print("usersGetCred$_user");
      notifyListeners();
    }
  }

  Future<void> signOut() async {
    if ((await _prefs).containsKey('usersData')) {
      await this._firebaseAuth.signOut();
      this._user = null;
      this.userStatus = false;
      (await _prefs).remove('usersData');
      (await _prefs).remove('is_user_logged');
    }
  }

  // for getting user uthentication status
  Future<bool> get isUserSignIn async =>
      (await _prefs).containsKey('usersData') &&
              (await _prefs).getBool('is_user_logged') == true
          ? true
          : false;

  _initAuth() async {
    if (await this.isUserSignIn) {
      this.getUserCredentials();
    }
  }

  UserCredentials get user => _user;
  bool get isSignin => _isSigningIn;

  _changeIsSignIn() {
    this._isSigningIn = !this._isSigningIn;
    notifyListeners();
  }

  //SignIn with Google
  Future signInWithGoogle() async {
    User user;
    try {
      this._changeIsSignIn();

      final GoogleSignInAccount _googleUser = await this._googleSignIn.signIn();
      final GoogleSignInAuthentication _googleAuth =
          await _googleUser.authentication;

      //Get credential of user

      final _credential = GoogleAuthProvider.credential(
        accessToken: _googleAuth.accessToken,
        idToken: _googleAuth.idToken,
      );

      UserCredential gauth =
          await this._firebaseAuth.signInWithCredential(_credential);
      this._user = UserCredentials(
          userId: gauth.user.uid,
          email: gauth.user.email,
          name: gauth.user.displayName,
          pictureUrl: gauth.user.photoURL);
      print("user: $_user");
      print("userid: ${_user.userId}");
      if (_user != null) {
        print('user is not null');
        //Get the userId
        ((await _prefs)).setString('userId', _user.userId);
        String _userId;

        if ((await _prefs).containsKey('usersData')) {
          print('contains user');
          _userId = UserCredentials.fromJson(
                  Map.castFrom(json.decode((await _prefs).getString('user'))))
              .userId;
        }
        _userId = _user.userId;
        dynamic _response =
            (await this._firebasesData.retrieveUser(_userId))?.data();
        if (_response == null) {
          print("does not container userid");
          //Here we give default value to the user once not data is yet stored
          UserData _userData =
              UserData(name: _user.name, channels: [], points: 0);
          print(_userData);
          this._firebasesData.createOrUpdateUserData(_userData, _userId);
        }

        this.saveUserCredentials();
        this.userStatus = true;
        _changeIsSignIn();
      }
    } catch (e) {
      throw Exception(e.toString());
    }
  }
}
