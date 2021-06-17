import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_facebook_login/flutter_facebook_login.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_signin_example/providers/authentication_provider.dart';
import 'package:google_signin_example/widget/signin.dart';
import 'package:provider/provider.dart';
// import 'package:flutter_facebook_login/flutter_facebook_login.dart';

class FacebookButton extends StatefulWidget {
  @override
  _FacebookButtonState createState() => _FacebookButtonState();
}

class _FacebookButtonState extends State<FacebookButton> {
  static final FacebookLogin facebookSignIn = new FacebookLogin();
  // final facebookLogin = FacebookLogin();
  @override
  Widget build(BuildContext context) => Container(
        padding: EdgeInsets.all(4),
        child: OutlineButton.icon(
          label: Text(
            'Sign In With Facebook',
            style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 20,
                color: Colors.grey[200]),
          ),
          shape: StadiumBorder(),
          padding: EdgeInsets.symmetric(horizontal: 12, vertical: 8),
          highlightedBorderColor: Colors.black,
          borderSide: BorderSide(color: Colors.grey[200]),
          textColor: Colors.black,
          icon: FaIcon(FontAwesomeIcons.facebook, color: Colors.blueGrey),
          onPressed: () async {
            await Provider.of<AuthenticationProvider>(context, listen: false)
                .signInWithFacebook();
          },
        ),
      );
}
// onFBLogin() async {
//     final result = await facebookLogin.logIn(['email']);
//     switch (result.status) {
//       case FacebookLoginStatus.loggedIn:
//         final token = result.accessToken;
//         final response = await http.get(
//             "https://graph.facebook.com/v2.12/me?fields=name,picture,email&access_token=$token");
//         final data1 = json.decode(response.body);
//         print(data);
//         setState(() {
//           _isLogin = true;
//           data = data1;
//         });
//         break;
//       case FacebookLoginStatus.cancelledByUser:
//         setState(() {
//           _isLogin = false;
//         });
//         break;
//       case FacebookLoginStatus.error:
//         setState(() {
//           _isLogin = false;
//         });
//         break;
//     }
// }
