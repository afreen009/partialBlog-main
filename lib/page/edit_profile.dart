import 'dart:async';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_signin_example/database/bookmark_database.dart';
import 'package:google_signin_example/database/db_model.dart';
import 'package:google_signin_example/services/theme_changer.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SettingsUI extends StatelessWidget {
  // final String email;
  // final String photoUrl;
  // final String displayName;
  // SettingsUI({this.email, this.displayName, this.photoUrl});
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: "Setting UI",
      home: EditProfilePage(),
    );
  }
}

class EditProfilePage extends StatefulWidget {
  // final String email;
  // final String photoUrl;
  // final String displayName;
  // EditProfilePage({this.email, this.displayName, this.photoUrl});
  @override
  _EditProfilePageState createState() => _EditProfilePageState();
}

class _EditProfilePageState extends State<EditProfilePage> {
  bool showPassword = false;
  String email;
  String photoUrl;
  String displayName;
  bool _switchValue = false;
  List finalBdlist = [];
  List<DbModel> bd;
  bool stop = false;
  Color logoGreen = Color(0xff25bcbb);
  sharedPreferences() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      email = prefs.getString('email');
      photoUrl = prefs.getString('photoUrl');
      displayName = prefs.getString('displayName');
    });
  }

  @override
  void initState() {
    // TODO: implement initState
    sharedPreferences();
    Timer.periodic(Duration(seconds: 5), (timer) {
      getStatus();
    });
    getStatus();
    Future.delayed(Duration(seconds: 3), () {
      setState(() {
        stop = true;
      });
    });
    super.initState();
  }

  Future<List<DbModel>> getStatus() async {
    bd = await BookMarkDatabase.bd.getAllPersons();
    // print("Bd:$Bd");
    // print('inside finalBd');
    finalBdlist.clear();
    for (int i = 0; i < bd.length; i++) {
      // print(Bd[i].name);
      if (finalBdlist.contains(bd[i].name))
        continue;
      else {
        finalBdlist.add(bd[i].name);
      }
    }
    // print("final$finalBdlist");
    return bd;
  }

  @override
  Widget build(BuildContext context) {
    final user = FirebaseAuth.instance.currentUser;
    final themeChanger = Provider.of<ThemeChanger>(context);
    return Column(
      children: [
        Container(
          height: 200,
          child: Stack(
            children: [
              Positioned(
                top: 30,
                left: 10,
                child: Column(
                  children: [
                    Container(
                      width: 130,
                      height: 130,
                      decoration: BoxDecoration(
                        border: Border.all(
                            width: 4,
                            color: Theme.of(context).scaffoldBackgroundColor),
                        boxShadow: [
                          BoxShadow(
                              spreadRadius: 2,
                              blurRadius: 10,
                              color: Colors.black.withOpacity(0.1),
                              offset: Offset(0, 10))
                        ],
                        shape: BoxShape.circle,
                        image: DecorationImage(
                          fit: BoxFit.cover,
                          image: NetworkImage(user.photoURL),
                        ),
                      ),
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    Text(user.displayName,
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          // color: Colors.black,
                        )),
                  ],
                ),
              ),
              Positioned(
                top: 100,
                left: 240,
                child: Row(
                  children: [
                    Column(
                      children: [
                        Text(
                            finalBdlist.isNotEmpty
                                ? finalBdlist.length.toString()
                                : '0',
                            style: TextStyle(
                              fontSize: 16,
                              // fontWeight: FontWeight.bold,
                              color: Colors.grey[300],
                            )),
                        Text('Posts',
                            style: TextStyle(
                              fontSize: 16,
                              // fontWeight: FontWeight.bold,
                              color: Colors.grey[300],
                            )),
                      ],
                    ),

                    SizedBox(
                      width: 10,
                    ),
                    // RaisedButton(
                    //   onPressed: () {
                    //     AuthenticationProvider.facebookSignIn
                    //         .logOut()
                    //         .then((e) {
                    //       Navigator.of(context).push(
                    //         MaterialPageRoute(
                    //           builder: (context) {
                    //             return Welcome();
                    //           },
                    //         ),
                    //       );
                    //     });
                    //   },
                    //   child: Text('log out'),
                    // )
                    // Column(
                    //   children: [
                    //     Text('0',
                    //         style: TextStyle(
                    //           fontSize: 16,
                    //           // fontWeight: FontWeight.bold,
                    //           color: Colors.grey[300],
                    //         )),
                    //     Text('Points',
                    //         style: TextStyle(
                    //           fontSize: 16,
                    //           // fontWeight: FontWeight.bold,
                    //           color: Colors.grey[300],
                    //         )),
                    //   ],
                    // )
                  ],
                ),
              ),
            ],
          ),
        ),
        SizedBox(
          height: 15,
        ),
        Container(
          // padding: EdgeInsets.symmetric(horizontal: 30),
          height: 30,
          // color: Colors.pink,
          child: Row(
            children: [
              SizedBox(
                width: 30,
              ),
              Text('Theme',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    // color: Colors.black,
                  )),
              Spacer(),
              Transform.scale(
                  scale: .7,
                  child: InkWell(
                    onTap: () {
                      setState(() {
                        _switchValue = !_switchValue;
                      });
                    },
                    child: CupertinoSwitch(
                      trackColor: Colors.white,
                      activeColor: Colors.black,
                      value: _switchValue,
                      onChanged: (bool value) {
                        setState(() {
                          _switchValue = value;
                          themeChanger.toggle();
                        });
                      },
                    ),
                  )),
            ],
          ),
        ),
        SizedBox(
          height: 10,
        ),
        Container(
          decoration: BoxDecoration(
            // color: Theme.of(context).scaffoldBackgroundColor,
            border: Border(
              top: BorderSide(color: Colors.grey[300], width: 0.3),
              bottom: BorderSide(color: Colors.grey[300], width: 0.3),
            ),
          ),
          height: 40,
          child: Center(
              child: Text('Posts',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    // color: Colors.white,
                  ))),
        ),
        Expanded(
            flex: 1,
            child: stop
                ? finalBdlist.isNotEmpty
                    ? ListView.builder(
                        itemCount: finalBdlist.length,
                        itemBuilder: (BuildContext context, int index) {
                          print(finalBdlist[index]);
                          return Column(
                            children: [
                              Container(
                                  // decoration: BoxDecoration(
                                  //   color: Colors.white,
                                  // ),
                                  height: 50,
                                  child: Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: Center(
                                        child: Text(
                                      finalBdlist[index],
                                      // style: TextStyle(color: logoGreen),
                                    )),
                                  )),
                              SizedBox(
                                height: 5,
                              )
                            ],
                          );
                        },
                      )
                    : Center(child: Text("No Posts Saved Yet"))
                : Center(
                    child: CircleAvatar(
                        radius: 20,
                        backgroundColor: Colors.white,
                        child: CircularProgressIndicator()),
                  )),
        // Text(finalBdlist.isNotEmpty ? finalBdlist[0] : 'hi'),
      ],
    );
  }
}

// import 'package:admob_flutter/admob_flutter.dart';
// import 'package:firebase_auth/firebase_auth.dart';
// import 'package:flutter/cupertino.dart';
// import 'package:flutter/material.dart';
// import 'package:google_signin_example/admob.dart';
// import 'package:google_signin_example/database/bookmark_database.dart';
// import 'package:google_signin_example/database/db_model.dart';
// import 'package:google_signin_example/database/mypoints.dart';
// import 'package:google_signin_example/page/points_info.dart';
// import 'package:google_signin_example/page/terms.dart';
// import 'package:google_signin_example/providers/authentication_provider.dart';
// import 'package:google_signin_example/providers/user_provder.dart';
// import 'package:google_signin_example/services/theme_changer.dart';
// import 'package:google_signin_example/widget/signin.dart';
// import 'package:provider/provider.dart';
// import 'package:shared_preferences/shared_preferences.dart';

// class SettingsUI extends StatelessWidget {
//   // final String email;
//   // final String photoUrl;
//   // final String displayName;
//   // SettingsUI({this.email, this.displayName, this.photoUrl});
//   @override
//   Widget build(BuildContext context) {
//     return MaterialApp(
//       debugShowCheckedModeBanner: false,
//       title: "Setting UI",
//       home: EditProfilePage(),
//     );
//   }
// }

// class EditProfilePage extends StatefulWidget {
//   // final String email;
//   // final String photoUrl;
//   // final String displayName;
//   // EditProfilePage({this.email, this.displayName, this.photoUrl});
//   @override
//   _EditProfilePageState createState() => _EditProfilePageState();
// }

// class _EditProfilePageState extends State<EditProfilePage> {
//   bool showPassword = false;
//   String email;
//   String photoUrl;
//   String displayName;
//   bool _switchValue = false;
//   AdmobReward reward;
//   bool availibility = false;
//   List<DbModel> db;
//   List finalBDlist = [];
//   sharedPreferences() async {
//     SharedPreferences prefs = await SharedPreferences.getInstance();
//     email = prefs.getString('email');
//     photoUrl = prefs.getString('profile');
//     displayName = prefs.getString('name');
//   }

//   @override
//   void initState() {
//     // TODO: implement initState

//     sharedPreferences();
//     reward = AdmobReward(
//         adUnitId: AdMobServices.rewardId,
//         listener: (event, args) {
//           if (event == AdmobAdEvent.rewarded) {
//             print('rewarded with points');
//             UserProvider _userProvider =
//                 Provider.of<UserProvider>(context, listen: false);
//             _userProvider.updatePoint(50);
//             setState(() {
//               availibility = false;
//             });
//             // handleEvent(event, args, 'Reward', context);
//             // FirebasesData().updateUserPresence(points:);
//           }
//           if (event == AdmobAdEvent.loaded) {
//             print('ad available');
//             setState(() {
//               availibility = true;
//             });
//           } else if (event == AdmobAdEvent.closed) {
//             print('reward closed');
//             setState(() {
//               availibility = false;
//             });
//           }
//         });
//     reward.load();
//     super.initState();
//   }

//   Future<List<DbModel>> getStatus() async {
//     db = await BookMarkDatabase.bd.getAllPersons();
//     // print("db:$db");
//     // print('inside finaldb');
//     finalBDlist.clear();
//     for (int i = 0; i < db.length; i++) {
//       // print(db[i].name);
//       if (finalBDlist.contains(db[i].name))
//         continue;
//       else {
//         finalBDlist.add(db[i].name);
//       }
//     }
//     // print("final$finalDblist");
//     return db;
//   }

//   void handleEvent(AdmobAdEvent event, Map<String, dynamic> args, String adType,
//       BuildContext context) async {
//     switch (event) {
//       case AdmobAdEvent.loaded:
//         showSnackBar('New Admob $adType Ad loaded!');
//         break;
//       case AdmobAdEvent.opened:
//         showSnackBar('Admob $adType Ad opened!');
//         break;
//       case AdmobAdEvent.closed:
//         showSnackBar('Admob $adType Ad closed!');
//         break;
//       case AdmobAdEvent.failedToLoad:
//         showSnackBar('Admob $adType failed to load. :(');
//         break;
//       case AdmobAdEvent.rewarded:
//         {
//           UserProvider _userProvider =
//               Provider.of<UserProvider>(context, listen: false);
//           _userProvider.updatePoint(50);
//           showSnackBar('You earned 50 points');
//           break;
//         }
//         // showDialog(
//         //   context: scaffoldState.currentContext,
//         //   builder: (BuildContext context) {
//         //     return WillPopScope(
//         //       child: AlertDialog(
//         //         content: Column(
//         //           mainAxisSize: MainAxisSize.min,
//         //           children: <Widget>[
//         //             Text('Reward callback fired. Thanks Andrew!'),
//         //             Text('Type: ${args['type']}'),
//         //             Text('Amount: ${args['amount']}'),
//         //           ],
//         //         ),
//         //       ),
//         //       onWillPop: () async {
//         //         scaffoldState.currentState.hideCurrentSnackBar();
//         //         return true;
//         //       },
//         //     );
//         //   },
//         // );
//         break;
//       default:
//     }
//   }

//   void showSnackBar(String content) {
//     // scaffoldState.currentState.showSnackBar(
//     //   SnackBar(
//     //     content: Text(content),
//     //     duration: Duration(milliseconds: 1500),
//     //   ),
//     // );
//   }
//   @override
//   Widget build(BuildContext context) {
//     final user = FirebaseAuth.instance.currentUser;
//     final themeChanger = Provider.of<ThemeChanger>(context);
//     return Container(
//       height: MediaQuery.of(context).size.height,
//       // padding: EdgeInsets.only(left: 16, right: 16),
//       child: Stack(
//         children: [
//           Positioned(
//             top: 20,
//             left: 20,
//             child: Center(
//               child: Container(
//                 width: 130,
//                 height: 130,
//                 decoration: BoxDecoration(
//                   border: Border.all(
//                       width: 4,
//                       color: Theme.of(context).scaffoldBackgroundColor),
//                   boxShadow: [
//                     BoxShadow(
//                         spreadRadius: 2,
//                         blurRadius: 10,
//                         color: Colors.black.withOpacity(0.1),
//                         offset: Offset(0, 10))
//                   ],
//                   shape: BoxShape.circle,
//                   image: DecorationImage(
//                     fit: BoxFit.cover,
//                     image: NetworkImage(user.photoURL),
//                   ),
//                 ),
//               ),
//             ),
//           ),
//           SizedBox(
//             height: 35,
//           ),
//           Positioned(
//               top: 150,
//               left: 20,
//               child: Text(
//                 user.displayName,
//                 style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
//               )),
//           // buildTextField("Full Name", user.displayName, false),
//           // buildTextField("E-mail", user.email, false),
//           // Positioned(
//           //   top: 200,
//           //   left: 10,
//           //   child: Container(
//           //     height: 30,
//           //     // color: Colors.pink,
//           //     child: Row(
//           //       children: [
//           //         // SizedBox(
//           //         //   width: 10,
//           //         // ),
//           //         Text('Theme',
//           //             style: TextStyle(
//           //               fontSize: 16,
//           //               fontWeight: FontWeight.bold,
//           //               // color: Colors.black,
//           //             )),
//           //         Spacer(),
//           //         Transform.scale(
//           //             scale: .7,
//           //             child: InkWell(
//           //               onTap: () {
//           //                 setState(() {
//           //                   _switchValue = !_switchValue;
//           //                 });
//           //               },
//           //               child: CupertinoSwitch(
//           //                 // trackColor: Colors.black,
//           //                 value: _switchValue,
//           //                 onChanged: (bool value) {
//           //                   setState(() {
//           //                     _switchValue = value;
//           //                     themeChanger.toggle();
//           //                   });
//           //                 },
//           //               ),
//           //             )),
//           //       ],
//           //     ),
//           //   ),
//           // ),
//           // GestureDetector(
//           //   onTap: () async {
//           //     if (await reward.isLoaded) {
//           //       reward.show();
//           //     }
//           //     // Navigator.of(context).push(
//           //     //     MaterialPageRoute(builder: (context) => PointsInfo()));
//           //   },
//           //   child: Container(
//           //     height: 30,
//           //     child: Row(
//           //       children: [
//           //         Text("Earn Genius Points",
//           //             style: TextStyle(
//           //               fontSize: 16,
//           //               fontWeight: FontWeight.bold,
//           //               // color: Colors.black,
//           //             )),
//           //         Spacer(),
//           //         availibility ? Text('available') : Text('wait')
//           //         // Icon(Icons.video_label_sharp)
//           //       ],
//           //     ),
//           //   ),
//           // ),
//           SizedBox(
//             height: 30,
//           ),
//           // GestureDetector(
//           //   onTap: () {
//           //     Navigator.of(context).push(
//           //         MaterialPageRoute(builder: (context) => TermsConditions()));
//           //   },
//           //   child: Text('Terms and Conditions',
//           //       style: TextStyle(
//           //         fontSize: 16,
//           //         fontWeight: FontWeight.bold,
//           //         // color: Colors.black,
//           //       )),
//           // ),
//           SizedBox(
//             height: 35,
//           ),
//           // GestureDetector(
//           //   onTap: () {
//           //     Navigator.push(context,
//           //         MaterialPageRoute(builder: (context) => MyPoints()));
//           //   },
//           //   child: Row(
//           //     children: [
//           //       Text("Saved Posts",
//           //           style: TextStyle(
//           //             fontSize: 16,
//           //             fontWeight: FontWeight.bold,
//           //             // color: Colors.black,
//           //           )),
//           //       Spacer(),
//           //       Icon(
//           //         Icons.arrow_forward_ios,
//           //         color: Colors.black,
//           //       )
//           //     ],
//           //   ),
//           // )
//           // InkWell(
//           //   child: Text('Log out',
//           //       style: TextStyle(
//           //         fontSize: 16,
//           //         fontWeight: FontWeight.bold,
//           //         // color: Colors.black,
//           //       )),
//           //   onTap: () {
//           //     GoogleSignInProvider().logout();
//           //     // signOutGoogle();
//           //     // Navigator.push(context,
//           //     //     MaterialPageRoute(builder: (context) => Welcome()));
//           //   },
//           // ),
//           // Row(
//           //   mainAxisAlignment: MainAxisAlignment.spaceBetween,
//           //   children: [
//           //     OutlineButton(
//           //       padding: EdgeInsets.symmetric(horizontal: 50),
//           //       shape: RoundedRectangleBorder(
//           //           borderRadius: BorderRadius.circular(20)),
//           //       onPressed: () {},
//           //       child: Text("CANCEL",
//           //           style: TextStyle(
//           //               fontSize: 14,
//           //               letterSpacing: 2.2,
//           //               color: Colors.black)),
//           //     ),
//           //     RaisedButton(
//           //       onPressed: () {},
//           //       color: Colors.green,
//           //       padding: EdgeInsets.symmetric(horizontal: 50),
//           //       elevation: 2,
//           //       shape: RoundedRectangleBorder(
//           //           borderRadius: BorderRadius.circular(20)),
//           //       child: Text(
//           //         "SAVE",
//           //         style: TextStyle(
//           //             fontSize: 14,
//           //             letterSpacing: 2.2,
//           //             color: Colors.white),
//           //       ),
//           //     )
//           //   ],
//           // )
//         ],
//       ),
//     );
//   }

//   Widget buildTextField(
//       String labelText, String placeholder, bool isPasswordTextField) {
//     return Padding(
//       padding: const EdgeInsets.only(bottom: 35.0),
//       child: TextField(
//         obscureText: isPasswordTextField ? showPassword : false,
//         decoration: InputDecoration(
//             suffixIcon: isPasswordTextField
//                 ? IconButton(
//                     onPressed: () {
//                       setState(() {
//                         showPassword = !showPassword;
//                       });
//                     },
//                     icon: Icon(
//                       Icons.remove_red_eye,
//                       // color: Colors.grey,
//                     ),
//                   )
//                 : null,
//             contentPadding: EdgeInsets.only(bottom: 3),
//             labelText: labelText,
//             floatingLabelBehavior: FloatingLabelBehavior.always,
//             hintText: placeholder,
//             hintStyle: TextStyle(
//               fontSize: 16,
//               fontWeight: FontWeight.bold,
//             )),
//       ),
//     );
//   }
// }
