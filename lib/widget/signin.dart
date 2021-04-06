// import 'package:firebase_auth/firebase_auth.dart';
// import 'package:flutter/material.dart';
// import 'package:google_sign_in/google_sign_in.dart';
// import 'package:google_signin_example/database.dart';
// import 'package:google_signin_example/states/current_user.dart';

// class GoogleSignInProvider extends ChangeNotifier {
//   final FirebasesData _firebasesData = FirebasesData.instance;
//   final googleSignIn = GoogleSignIn();
//   bool _isSigningIn;

//   GoogleSignInProvider() {
//     _isSigningIn = false;
//   }
// //this notifier is what im using plus yes yes locally storing it too
//   bool get isSigningIn => _isSigningIn;

//   set isSigningIn(bool isSigningIn) {
//     _isSigningIn = isSigningIn;
//     notifyListeners();
//   }

//   Future login() async {
//     isSigningIn = true;
//     final user = await googleSignIn.signIn();
//     await googleSignIn.isSignedIn();

//     if (user == null) {
//       isSigningIn = false;
//       return;
//     } else {
//       final googleAuth = await user.authentication;

//       final credential = GoogleAuthProvider.credential(
//         accessToken: googleAuth.accessToken,
//         idToken: googleAuth.idToken,
//       );

//       UserCredential gauth =
//           await FirebaseAuth.instance.signInWithCredential(credential);
//       User users = gauth.user;
//       print(users.uid);
//       print("gggg:${users.email}");

//       isSigningIn = false;
//       if (!(await _firebasesData.checkExistanceOfUserData(users.uid))) {
//         UserData _user = UserData(name: users.displayName);
//         // this._firebasesData.createOrUpdateUserData(_user,users.uid);
//       }
//     }
//   }

//   void logout() async {
//     await googleSignIn.disconnect();
//     FirebaseAuth.instance.signOut();
//   }
// }
