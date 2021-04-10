import 'dart:convert';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:google_signin_example/database.dart';
import 'package:google_signin_example/model/user_credential.dart';
import 'package:google_signin_example/states/current_user.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../states/current_user.dart';

class AuthenticationProvider extends ChangeNotifier {
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;
  final GoogleSignIn _googleSignIn = GoogleSignIn();
  FirebasesData _firebasesData = FirebasesData.instance;
  Future<SharedPreferences> _prefs = SharedPreferences.getInstance();

// Get stream of the User
  Stream<User> get userStreamStatus => this._firebaseAuth.authStateChanges();

  //for storing users credential
  Future<void> _saveUserInPrefs(UserData user) async {
    (await _prefs).setString('user_data', user.toString());
  }

//For signin Out User
  Future<void> signOut() async {
    if ((await _prefs).containsKey('user_data')) {
      await this._firebaseAuth.signOut();
      (await _prefs).remove('user_data');
    }
  }

  //SignIn with Google
  Future signInWithGoogle() async {
    try {
      final GoogleSignInAccount _googleUser = await this._googleSignIn.signIn();
      final GoogleSignInAuthentication _googleAuth =
          await _googleUser.authentication;

      //Get credential of user
      final _credential = GoogleAuthProvider.credential(
        accessToken: _googleAuth.accessToken,
        idToken: _googleAuth.idToken,
      );

      UserCredential gAuth =
          await this._firebaseAuth.signInWithCredential(_credential);
      if (gAuth.user != null) {
        //Here we give default value to the user once not data is yet stored
        await _saveUser(gAuth);
        print((await _prefs).getString('user_data'));
      }
    } catch (e) {
      throw Exception(e.toString());
    }
  }

//For saving new user Info on remote db and in cache  memory
  Future<void> _saveUser(UserCredential gAuth) async {
    try {
      UserData _userData = UserData(
          name: gAuth.user.displayName,
          channels: [],
          points: 0,
          email: gAuth.user.email,
          pictureUrl: gAuth.user.photoURL,
          userId: gAuth.user.uid);
      await this._firebasesData.createOrUpdateUserData(_userData); //Remote save
      this._saveUserInPrefs(_userData); //Local save
    } catch (e) {
      throw Exception(e.toString());
    }
  }
}
