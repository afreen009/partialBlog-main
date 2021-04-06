import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_signin_example/database/mypoints.dart';
import 'package:google_signin_example/providers/authentication_provider.dart';
import 'package:google_signin_example/services/theme_changer.dart';
import 'package:google_signin_example/widget/signin.dart';
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
  sharedPreferences() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    email = prefs.getString('email');
    photoUrl = prefs.getString('photoUrl');
    displayName = prefs.getString('displayName');
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    sharedPreferences();
  }

  @override
  Widget build(BuildContext context) {
    final user = FirebaseAuth.instance.currentUser;
    final themeChanger = Provider.of<ThemeChanger>(context);
    return Scaffold(
      body: Container(
        padding: EdgeInsets.only(left: 16, right: 16),
        child: ListView(
          children: [
            Center(
              child: Stack(
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
                ],
              ),
            ),
            SizedBox(
              height: 35,
            ),
            buildTextField("Full Name", user.displayName, false),
            buildTextField("E-mail", user.email, false),
            Container(
              height: 30,
              // color: Colors.pink,
              child: Row(
                children: [
                  // SizedBox(
                  //   width: 10,
                  // ),
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
                          // trackColor: Colors.black,
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
            RaisedButton(
              onPressed: () {
                Provider.of<AuthenticationProvider>(context).signOut();
              },
              child: Text('log out'),
            ),
            SizedBox(
              height: 35,
            ),
            // GestureDetector(
            //   onTap: () {
            //     Navigator.push(context,
            //         MaterialPageRoute(builder: (context) => MyPoints()));
            //   },
            //   child: Row(
            //     children: [
            //       Text("Saved Posts",
            //           style: TextStyle(
            //             fontSize: 16,
            //             fontWeight: FontWeight.bold,
            //             // color: Colors.black,
            //           )),
            //       Spacer(),
            //       Icon(
            //         Icons.arrow_forward_ios,
            //         color: Colors.black,
            //       )
            //     ],
            //   ),
            // )
            // InkWell(
            //   child: Text('Log out',
            //       style: TextStyle(
            //         fontSize: 16,
            //         fontWeight: FontWeight.bold,
            //         // color: Colors.black,
            //       )),
            //   onTap: () {
            //     GoogleSignInProvider().logout();
            //     // signOutGoogle();
            //     // Navigator.push(context,
            //     //     MaterialPageRoute(builder: (context) => Welcome()));
            //   },
            // ),
            // Row(
            //   mainAxisAlignment: MainAxisAlignment.spaceBetween,
            //   children: [
            //     OutlineButton(
            //       padding: EdgeInsets.symmetric(horizontal: 50),
            //       shape: RoundedRectangleBorder(
            //           borderRadius: BorderRadius.circular(20)),
            //       onPressed: () {},
            //       child: Text("CANCEL",
            //           style: TextStyle(
            //               fontSize: 14,
            //               letterSpacing: 2.2,
            //               color: Colors.black)),
            //     ),
            //     RaisedButton(
            //       onPressed: () {},
            //       color: Colors.green,
            //       padding: EdgeInsets.symmetric(horizontal: 50),
            //       elevation: 2,
            //       shape: RoundedRectangleBorder(
            //           borderRadius: BorderRadius.circular(20)),
            //       child: Text(
            //         "SAVE",
            //         style: TextStyle(
            //             fontSize: 14,
            //             letterSpacing: 2.2,
            //             color: Colors.white),
            //       ),
            //     )
            //   ],
            // )
          ],
        ),
      ),
    );
  }

  Widget buildTextField(
      String labelText, String placeholder, bool isPasswordTextField) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 35.0),
      child: TextField(
        obscureText: isPasswordTextField ? showPassword : false,
        decoration: InputDecoration(
            suffixIcon: isPasswordTextField
                ? IconButton(
                    onPressed: () {
                      setState(() {
                        showPassword = !showPassword;
                      });
                    },
                    icon: Icon(
                      Icons.remove_red_eye,
                      // color: Colors.grey,
                    ),
                  )
                : null,
            contentPadding: EdgeInsets.only(bottom: 3),
            labelText: labelText,
            floatingLabelBehavior: FloatingLabelBehavior.always,
            hintText: placeholder,
            hintStyle: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
            )),
      ),
    );
  }
}
