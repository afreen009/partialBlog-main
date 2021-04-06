import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_signin_example/widget/signin.dart';
import 'package:provider/provider.dart';
// import 'package:flutter_facebook_login/flutter_facebook_login.dart';
import 'package:http/http.dart' as http;

class FacebookButton extends StatefulWidget {
  @override
  _FacebookButtonState createState() => _FacebookButtonState();
}

class _FacebookButtonState extends State<FacebookButton> {
  // static final FacebookLogin facebookSignIn = new FacebookLogin();
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
            //     final FacebookLoginResult result =
            //         await facebookSignIn.logIn(['email']);

            //     switch (result.status) {
            //       case FacebookLoginStatus.loggedIn:
            //         final FacebookAccessToken accessToken = result.accessToken;
            //         final graphResponse = await http.get(
            //             'https://graph.facebook.com/v2.12/me?fields=first_name,picture&access_token=${accessToken.token}');
            //         final profile = jsonDecode(graphResponse.body);
            //         print(profile);
            //         print(profile['first_name']);
            //         setState(() {});
            //         print('''
            //  Logged in!

            //  Token: ${accessToken.token}
            //  User id: ${accessToken.userId}
            //  Expires: ${accessToken.expires}
            //  Permissions: ${accessToken.permissions}
            //  Declined permissions: ${accessToken.declinedPermissions}
            //  ''');
            //         break;
            //       case FacebookLoginStatus.cancelledByUser:
            //         print('Login cancelled by the user.');
            //         break;
            //       case FacebookLoginStatus.error:
            //         print('Something went wrong with the login process.\n'
            //             'Here\'s the error Facebook gave us: ${result.errorMessage}');
            //         break;
            // }
          },
        ),
      );
}
