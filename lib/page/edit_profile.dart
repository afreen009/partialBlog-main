import 'package:flutter/material.dart';
import 'package:google_signin_example/screens/auth/auth.dart';

import 'home_page.dart';

class SettingsUI extends StatelessWidget {
  final String email;
  final String photoUrl;
  final String displayName;
  SettingsUI({this.email, this.displayName, this.photoUrl});
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: "Setting UI",
      home: EditProfilePage(
          email: email, displayName: displayName, photoUrl: photoUrl),
    );
  }
}

class EditProfilePage extends StatefulWidget {
  final String email;
  final String photoUrl;
  final String displayName;
  EditProfilePage({this.email, this.displayName, this.photoUrl});
  @override
  _EditProfilePageState createState() => _EditProfilePageState();
}

class _EditProfilePageState extends State<EditProfilePage> {
  bool showPassword = false;
  @override
  Widget build(BuildContext context) {
    print(widget.email);
    print(widget.photoUrl);
    print(widget.displayName);
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
                            image: NetworkImage(
                              widget.photoUrl.toString(),
                            ))),
                    // image: DecorationImage(
                    //     fit: BoxFit.cover,
                    //     image: Image.network()),
                    // child: Image.network(widget.photoUrl.toString()),
                  ),
                  Positioned(
                      bottom: 0,
                      right: 0,
                      child: Container(
                        height: 40,
                        width: 40,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          border: Border.all(
                            width: 4,
                            color: Theme.of(context).scaffoldBackgroundColor,
                          ),
                          color: Colors.green,
                        ),
                        child: Icon(
                          Icons.edit,
                          color: Colors.white,
                        ),
                      )),
                ],
              ),
            ),
            SizedBox(
              height: 35,
            ),
            buildTextField("Full Name", widget.displayName, false),
            buildTextField("E-mail", widget.email, false),
            // SizedBox(
            //   height: 35,
            // ),
            // InkWell(
            //   child: Text('Log out'),
            //   onTap: () {
            //     signOutGoogle();
            //     Navigator.push(context,
            //         MaterialPageRoute(builder: (context) => Welcome()));
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
                      color: Colors.grey,
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
              color: Colors.black,
            )),
      ),
    );
  }
}
