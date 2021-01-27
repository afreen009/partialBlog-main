import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';

final FirebaseAuth _auth = FirebaseAuth.instance;
final GoogleSignIn googleSignIn = GoogleSignIn();

Future<FirebaseUser> signInWithGoogle() async {
  final GoogleSignInAccount googleSignInAccount = await googleSignIn.signIn();
  final GoogleSignInAuthentication googleSignInAuthentication =
      await googleSignInAccount.authentication;

  final AuthCredential credential = GoogleAuthProvider.getCredential(
      idToken: googleSignInAuthentication.idToken,
      accessToken: googleSignInAuthentication.accessToken);

  final AuthResult authResult = await _auth.signInWithCredential(credential);
  final FirebaseUser user = authResult.user;

  assert(!user.isAnonymous);
  assert(await user.getIdToken() != null);

  final FirebaseUser currentUser = await _auth.currentUser();
  assert(currentUser.uid == user.uid);

  return user;
}

void signOutGoogle() async {
  await googleSignIn.signOut();
}

// import 'package:firebase_auth/firebase_auth.dart';
// import 'package:flutter/cupertino.dart';
// import 'package:flutter/material.dart';
// import 'package:google_sign_in/google_sign_in.dart';

// FirebaseAuth auth = FirebaseAuth.instance;
// final gooleSignIn = GoogleSignIn();
// Color secondaryColor = Color(0xff232c51);
// Color logoGreen = Color(0xff25bcbb);
// // a simple sialog to be visible everytime some error occurs
// showErrDialog(BuildContext context, String err) {
//   // to hide the keyboard, if it is still p
//   FocusScope.of(context).requestFocus(new FocusNode());
//   return showDialog(
//     context: context,
//     barrierColor: Colors.white10,
//     child: AlertDialog(
//       backgroundColor: logoGreen,
//       title: Text(
//         "Error",
//         style: TextStyle(color: Colors.white),
//       ),
//       content: Text(err + ' !!'),
//       actions: <Widget>[
//         RaisedButton(
//           color: secondaryColor,
//           onPressed: () {
//             Navigator.pop(context);
//           },
//           child: Text(
//             "Ok",
//             style: TextStyle(color: Colors.white),
//           ),
//         ),
//       ],
//     ),
//   );
// }

// // many unhandled google error exist
// // will push them soon
// Future<bool> googleSignIn() async {
//   GoogleSignInAccount googleSignInAccount = await gooleSignIn.signIn();

//   if (googleSignInAccount != null) {
//     // GoogleSignInAuthentication googleSignInAuthentication =
//     //     await googleSignInAccount.authentication;

//     // AuthCredential credential = GoogleAuthProvider.getCredential(
//     //     idToken: googleSignInAuthentication.idToken,
//     //     accessToken: googleSignInAuthentication.accessToken);

//     // AuthResult result = await auth.signInWithCredential(credential);

//     FirebaseUser user = await auth.currentUser();
//     print(user.uid);

//     return Future.value(true);
//   }
//   return false;
// }

// // instead of returning true or false
// // returning user to directly access UserID
// Future<FirebaseUser> signin(
//     String email, String password, BuildContext context) async {
//   try {
//     AuthResult result =
//         await auth.signInWithEmailAndPassword(email: email, password: email);
//     FirebaseUser user = result.user;
//     // return Future.value(true);
//     return Future.value(user);
//   } catch (e) {
//     // simply passing error code as a message
//     print(e.code);
//     switch (e.code) {
//       case 'ERROR_INVALID_EMAIL':
//         showErrDialog(context, e.code);
//         break;
//       case 'ERROR_WRONG_PASSWORD':
//         showErrDialog(context, e.code);
//         break;
//       case 'ERROR_USER_NOT_FOUND':
//         showErrDialog(context, e.code);
//         break;
//       case 'ERROR_USER_DISABLED':
//         showErrDialog(context, e.code);
//         break;
//       case 'ERROR_TOO_MANY_REQUESTS':
//         showErrDialog(context, e.code);
//         break;
//       case 'ERROR_OPERATION_NOT_ALLOWED':
//         showErrDialog(context, e.code);
//         break;
//     }
//     // since we are not actually continuing after displaying errors
//     // the false value will not be returned
//     // hence we don't have to check the valur returned in from the signin function
//     // whenever we call it anywhere
//     return Future.value(null);
//   }
// }

// // change to Future<FirebaseUser> for returning a user
// Future<FirebaseUser> signUp(
//     String email, String password, BuildContext context) async {
//   try {
//     AuthResult result = await auth.createUserWithEmailAndPassword(
//         email: email, password: email);
//     FirebaseUser user = result.user;
//     return Future.value(user);
//     // return Future.value(true);
//   } catch (error) {
//     switch (error.code) {
//       case 'ERROR_EMAIL_ALREADY_IN_USE':
//         showErrDialog(context, "Email Already Exists");
//         break;
//       case 'ERROR_INVALID_EMAIL':
//         showErrDialog(context, "Invalid Email Address");
//         break;
//       case 'ERROR_WEAK_PASSWORD':
//         showErrDialog(context, "Please Choose a stronger password");
//         break;
//     }
//     return Future.value(null);
//   }
// }

// Future<bool> signOutUser() async {
//   await auth.signOut();
//   return Future.value(true);
//   // FirebaseUser user = await auth.currentUser();
//   // print(user.providerData[1].providerId);
//   // if (user.providerData[1].providerId == 'google.com') {
//   //   await gooleSignIn.disconnect();
//   // }
//   // await auth.signOut();
//   // return Future.value(true);
// }

// // import 'package:animations/animations.dart';
// // import 'package:flutter/foundation.dart';
// // import 'package:flutter/foundation.dart';
// // import 'package:flutter/material.dart';
// // import 'package:google_signin_example/config/palette.dart';
// // import 'package:google_signin_example/home11.dart';
// // import 'package:lit_firebase_auth/lit_firebase_auth.dart';

// // import 'widgets/background_painter.dart';
// // import 'widgets/register.dart';
// // import 'widgets/sign_in.dart';

// // class AuthScreen extends StatefulWidget {
// //   const AuthScreen({Key key}) : super(key: key);

// //   static MaterialPageRoute get route => MaterialPageRoute(
// //         builder: (context) => const AuthScreen(),
// //       );

// //   @override
// //   _AuthScreenState createState() => _AuthScreenState();
// // }

// // class _AuthScreenState extends State<AuthScreen>
// //     with SingleTickerProviderStateMixin {
// //   AnimationController _controller;

// //   ValueNotifier<bool> showSignInPage = ValueNotifier<bool>(true);

// //   @override
// //   void initState() {
// //     _controller =
// //         AnimationController(duration: const Duration(seconds: 2), vsync: this);
// //     super.initState();
// //   }

// //   @override
// //   void dispose() {
// //     _controller.dispose();
// //     super.dispose();
// //   }

// //   @override
// //   Widget build(BuildContext context) {
// //     return Scaffold(
// //       body: LitAuth.custom(
// //         errorNotification: const NotificationConfig(
// //           backgroundColor: Palette.darkBlue,
// //           icon: Icon(
// //             Icons.error_outline,
// //             color: Colors.deepOrange,
// //             size: 32,
// //           ),
// //         ),
// //         onAuthSuccess: () {
// //           Navigator.of(context).pushReplacement(Welcome.route);
// //         },
// //         child: Stack(
// //           children: [
// //             SizedBox.expand(
// //               child: CustomPaint(
// //                 painter: BackgroundPainter(
// //                   animation: _controller,
// //                 ),
// //               ),
// //             ),
// //             Center(
// //               child: ConstrainedBox(
// //                 constraints: const BoxConstraints(maxWidth: 800),
// //                 child: ValueListenableBuilder<bool>(
// //                   valueListenable: showSignInPage,
// //                   builder: (context, value, child) {
// //                     return SizedBox.expand(
// //                       child: PageTransitionSwitcher(
// //                         reverse: !value,
// //                         duration: const Duration(milliseconds: 800),
// //                         transitionBuilder:
// //                             (child, animation, secondaryAnimation) {
// //                           return SharedAxisTransition(
// //                             animation: animation,
// //                             secondaryAnimation: secondaryAnimation,
// //                             transitionType: SharedAxisTransitionType.vertical,
// //                             fillColor: Colors.transparent,
// //                             child: child,
// //                           );
// //                         },
// //                         child: value
// //                             ? SignIn(
// //                                 key: const ValueKey('SignIn'),
// //                                 onRegisterClicked: () {
// //                                   context.resetSignInForm();
// //                                   showSignInPage.value = false;
// //                                   _controller.forward();
// //                                 },
// //                               )
// //                             : Register(
// //                                 key: const ValueKey('Register'),
// //                                 onSignInPressed: () {
// //                                   context.resetSignInForm();
// //                                   showSignInPage.value = true;
// //                                   _controller.reverse();
// //                                 },
// //                               ),
// //                       ),
// //                     );
// //                   },
// //                 ),
// //               ),
// //             )
// //           ],
// //         ),
// //       ),
// //     );
// //   }
// // }
