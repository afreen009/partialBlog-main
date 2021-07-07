import 'dart:convert';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_facebook_login/flutter_facebook_login.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:google_signin_example/database.dart';
import 'package:google_signin_example/model/user_credential.dart';
import 'package:google_signin_example/states/current_user.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;

import '../states/current_user.dart';

class AuthenticationProvider extends ChangeNotifier {
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;
  final GoogleSignIn _googleSignIn = GoogleSignIn();
  FirebasesData _firebasesData = FirebasesData.instance;
  Future<SharedPreferences> _prefs = SharedPreferences.getInstance();
  static final FacebookLogin facebookSignIn = new FacebookLogin();

// Get stream of the User
  Stream<User> get userStreamStatus => this._firebaseAuth.authStateChanges();

  //for storing users credential
  Future<void> _saveUserInPrefs(UserData user) async {
    print("inside prefs");
    (await _prefs).setString('user_data', user.toString());
    notifyListeners();
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
      // print(gAuth.credential);
      if (gAuth.user != null) {
        (await _prefs).setString('userId', gAuth.user.uid);
        //Here we give default value to the user once not data is yet stored
        bool check = await this._firebasesData.retrieveUser(gAuth.user.uid);
        print("check$check");
        print(gAuth.user);
        await _saveUser(gAuth, check);
        print((await _prefs).getString('user_data'));
      }
    } catch (e) {
      throw Exception(e.toString());
    }
  }

  //SignIn with Facebook
  Future signInWithFacebook() async {
    try {
      final FacebookLoginResult result = await facebookSignIn.logIn(['email']);
      //"C:\Users\Admin\.android\debug.keystore" | "C:\Users\Admin\Desktop\openssl-0.9.8k_WIN32\bin\openssl" sha1 -binary | "C:\Users\Admin\Desktop\openssl-0.9.8k_WIN32\bin\openssl" base64
      switch (result.status) {
        case FacebookLoginStatus.loggedIn:
          final FacebookAccessToken accessToken = result.accessToken;
          final graphResponse = await http.get(
              'https://graph.facebook.com/v3.2/me?fields=first_name,picture&access_token=${accessToken.token}');
          final profile = jsonDecode(graphResponse.body);
          print(profile);
          print(profile['first_name']);
          final AuthCredential credential =
              FacebookAuthProvider.credential(accessToken.token);
          // this._firebaseAuth.signOut();
          UserCredential fAuth =
              await this._firebaseAuth.signInWithCredential(credential);
          print(fAuth.additionalUserInfo.profile);
          if (fAuth.user != null) {
            print(fAuth.user);
            bool check = await this._firebasesData.retrieveUser(fAuth.user.uid);
            print("check$check");
            // this._firebaseAuth.signOut();
            await _saveFbUser(fAuth, check);
          }

          print('''
             Logged in!

             Token: ${accessToken.token}
             User id: ${accessToken.userId}
             Expires: ${accessToken.expires}
             Permissions: ${accessToken.permissions}
             Declined permissions: ${accessToken.declinedPermissions}
             ''');
          // await _saveFbUser(profile);
          break;
        case FacebookLoginStatus.cancelledByUser:
          print('Login cancelled by the user.');
          break;
        case FacebookLoginStatus.error:
          print('Something went wrong with the login process.\n'
              'Here\'s the error Facebook gave us: ${result.errorMessage}');
          break;
      }
    } catch (e) {
      throw Exception(e.toString());
    }
  }

//For saving new user Info on remote db and in cache  memory
  Future<void> _saveUser(UserCredential gAuth, bool status) async {
    try {
      var data = await this._firebasesData.retrieveUsersData(gAuth.user.uid);
      print("datais here : ${data['points']}");
      UserData _userData = UserData(
          name: gAuth.user.displayName,
          channels: [],
          points: 0,
          email: gAuth.user.email,
          pictureUrl: gAuth.user.photoURL,
          userId: gAuth.user.uid);
      this._saveUserInPrefs(_userData);
      // await this._firebasesData.createOrUpdateUserData(_userData);
    } catch (e) {
      throw Exception(e.toString());
    }
  }

  void logout() async {
    await facebookSignIn.logOut();

    print("User Sign Out");
  }

  Future<void> _saveFbUser(UserCredential fAuth, bool status) async {
    try {
      var data = await this._firebasesData.retrieveUsersData(fAuth.user.uid);
      print("datais here : ${data['points']}");
      UserData _userData = UserData(
          name: fAuth.user.displayName,
          channels: [],
          points: 0,
          email: fAuth.user.email,
          pictureUrl: fAuth.user.photoURL,
          userId: fAuth.user.uid);
      // await this._firebasesData.createOrUpdateUserData(_userData);
      this._saveUserInPrefs(_userData);
    } catch (e) {
      throw Exception(e.toString());
    }
  }
}

// import 'dart:convert';

// import 'package:firebase_auth/firebase_auth.dart';
// import 'package:flutter/foundation.dart';
// import 'package:google_sign_in/google_sign_in.dart';
// import 'package:google_signin_example/database.dart';
// import 'package:google_signin_example/model/user_credential.dart';
// import 'package:google_signin_example/states/current_user.dart';
// import 'package:shared_preferences/shared_preferences.dart';

// import '../states/current_user.dart';

// class AuthenticationProvider extends ChangeNotifier {
//   final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;
//   final GoogleSignIn _googleSignIn = GoogleSignIn();
//   FirebasesData _firebasesData = FirebasesData.instance;
//   Future<SharedPreferences> _prefs = SharedPreferences.getInstance();

// // Get stream of the User
//   Stream<User> get userStreamStatus => this._firebaseAuth.authStateChanges();

//   //for storing users credential
//   Future<void> _saveUserInPrefs(UserData user) async {
//     (await _prefs).setString('user_data', user.toString());
//     notifyListeners();
//   }

// //For signin Out User
//   Future<void> signOut() async {
//     if ((await _prefs).containsKey('user_data')) {
//       await this._firebaseAuth.signOut();
//       (await _prefs).remove('user_data');
//     }
//   }

//   //SignIn with Google
//   Future signInWithGoogle() async {
//     try {
//       final GoogleSignInAccount _googleUser = await this._googleSignIn.signIn();
//       final GoogleSignInAuthentication _googleAuth =
//           await _googleUser.authentication;

//       //Get credential of user
//       final _credential = GoogleAuthProvider.credential(
//         accessToken: _googleAuth.accessToken,
//         idToken: _googleAuth.idToken,
//       );

//       UserCredential gAuth =
//           await this._firebaseAuth.signInWithCredential(_credential);
//       if (gAuth.user != null) {
//         //Here we give default value to the user once not data is yet stored
//         await _saveUser(gAuth);
//         print((await _prefs).getString('user_data'));
//       }
//     } catch (e) {
//       throw Exception(e.toString());
//     }
//   }

// //For saving new user Info on remote db and in cache  memory
//   Future<void> _saveUser(UserCredential gAuth) async {
//     try {
//       // bool exists =
//       //     await this._firebasesData.checkExistanceOfUserData(gAuth.user.uid);
//       // if (exists) {
//       //   var data = await this._firebasesData.retrieveUser(gAuth.user.uid);
//       //   UserData _data = UserData(
//       //       name: data.data()['name'],
//       //       channels: data.data()['channel'],
//       //       points: data.data()['points'],
//       //       email: gAuth.user.email,
//       //       pictureUrl: gAuth.user.photoURL,
//       //       userId: gAuth.user.uid);
//       //   print("data:$_data");
//       //   this._saveUserInPrefs(_data);
//       // }
//       UserData _userData = UserData(
//           name: gAuth.user.displayName,
//           channels: [],
//           points: 0,
//           email: gAuth.user.email,
//           pictureUrl: gAuth.user.photoURL,
//           userId: gAuth.user.uid);

//       await this._firebasesData.createOrUpdateUserData(_userData); //Remote save
//       this._saveUserInPrefs(_userData); //Local save
//     } catch (e) {
//       throw Exception(e.toString());
//     }
//   }
// }
