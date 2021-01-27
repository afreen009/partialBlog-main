// import 'package:firebase_auth/firebase_auth.dart';
// import 'package:flutter/material.dart';
// import 'package:font_awesome_flutter/font_awesome_flutter.dart';
// import 'package:form_field_validator/form_field_validator.dart';
// import 'package:google_fonts/google_fonts.dart';
// import 'package:google_signin_example/page/home.dart';
// import 'package:google_signin_example/page/home_page.dart';
// import 'package:google_signin_example/screens/auth/auth.dart';
// import 'package:google_signin_example/screens/auth/widgets/signup.dart';

// class LoginScreen extends StatefulWidget {
//   @override
//   _LoginScreenState createState() => _LoginScreenState();
// }

// class _LoginScreenState extends State<LoginScreen> {
//   String email;
//   String password;
//   final FirebaseAuth auth = FirebaseAuth.instance;
//   bool isSignIn = false;
//   bool google = false;
//   GlobalKey<FormState> formkey = GlobalKey<FormState>();

//   void login() {
//     if (formkey.currentState.validate()) {
//       formkey.currentState.save();
//       signin(email, password, context).then((value) {
//         if (value != null) {
//           Navigator.pushReplacement(
//               context,
//               MaterialPageRoute(
//                 builder: (context) => HomePage(),
//               ));
//         }
//       });
//     }
//   }

//   final Color primaryColor = Color(0xff18203d);

//   final Color secondaryColor = Color(0xff232c51);

//   final Color logoGreen = Color(0xff25bcbb);

//   final TextEditingController nameController = TextEditingController();

//   final TextEditingController passwordController = TextEditingController();

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//         appBar: AppBar(
//           backgroundColor: Colors.transparent,
//           automaticallyImplyLeading: false,
//           elevation: 0,
//         ),
//         backgroundColor: primaryColor,
//         body: SafeArea(
//           child: Container(
//             alignment: Alignment.topCenter,
//             margin: EdgeInsets.symmetric(horizontal: 30),
//             child: SingleChildScrollView(
//               child: Form(
//                 key: formkey,
//                 child: Column(
//                   mainAxisAlignment: MainAxisAlignment.center,
//                   crossAxisAlignment: CrossAxisAlignment.center,
//                   children: <Widget>[
//                     Text(
//                       'Sign in to Genius and continue',
//                       textAlign: TextAlign.center,
//                       style: GoogleFonts.openSans(
//                           color: Colors.white, fontSize: 28),
//                     ),
//                     SizedBox(height: 20),
//                     Text(
//                       'Enter your email and password below ',
//                       textAlign: TextAlign.center,
//                       style: GoogleFonts.openSans(
//                           color: Colors.white, fontSize: 14),
//                     ),
//                     SizedBox(
//                       height: 30,
//                     ),
//                     Container(
//                       margin:
//                           EdgeInsets.symmetric(horizontal: 10, vertical: 10),
//                       height: 150,
//                       width: 300,
//                       decoration: BoxDecoration(
//                           borderRadius: BorderRadius.circular(5),
//                           color: Colors.white),
//                       child: Column(
//                         mainAxisAlignment: MainAxisAlignment.center,
//                         children: [
//                           _buildEmailField(),
//                           _buildPasswordField(),
//                         ],
//                       ),
//                     ),
//                     SizedBox(height: 30),
//                     MaterialButton(
//                       elevation: 0,
//                       minWidth: double.maxFinite,
//                       height: 50,
//                       onPressed: login,
//                       color: logoGreen,
//                       child: Text('Login',
//                           style: TextStyle(color: Colors.white, fontSize: 16)),
//                       textColor: Colors.white,
//                     ),
//                     // MaterialButton(
//                     //   elevation: 0,
//                     //   minWidth: double.maxFinite,
//                     //   height: 50,
//                     //   onPressed: login,
//                     //   color: logoGreen,
//                     //   child: Text('Sign Up',
//                     //       style: TextStyle(color: Colors.white, fontSize: 16)),
//                     //   textColor: Colors.white,
//                     // ),
//                     SizedBox(height: 20),
//                     MaterialButton(
//                       elevation: 0,
//                       minWidth: double.maxFinite,
//                       height: 50,
//                       onPressed: () => googleSignIn().whenComplete(() async {
//                         FirebaseUser user =
//                             await FirebaseAuth.instance.currentUser();
//                         if (user.isEmailVerified) {
//                           Navigator.of(context).pushReplacement(
//                               MaterialPageRoute(
//                                   builder: (context) => HomePage()));
//                         } else {
//                           return null;
//                         }
//                       }),
//                       color: Colors.blue,
//                       child: Row(
//                         mainAxisAlignment: MainAxisAlignment.center,
//                         children: <Widget>[
//                           Icon(FontAwesomeIcons.google),
//                           SizedBox(width: 10),
//                           Text('Sign-in using Google',
//                               style:
//                                   TextStyle(color: Colors.white, fontSize: 16)),
//                         ],
//                       ),
//                       textColor: Colors.white,
//                     ),
//                     SizedBox(height: 10),
//                     InkWell(
//                       onTap: () {
//                         // Navigator.of(context).pushReplacement(MaterialPageRoute(
//                         //     builder: (context) => SignUpScreen()));
//                       },
//                       child: Text(
//                         'Sign up',
//                         style: TextStyle(color: Colors.white, fontSize: 16),
//                       ),
//                     ),
//                     SizedBox(height: 100),
//                     Align(
//                       alignment: Alignment.bottomCenter,
//                       child: _buildFooterLogo(),
//                     )
//                   ],
//                 ),
//               ),
//             ),
//           ),
//         ));
//   }

//   _buildFooterLogo() {
//     return Column(
//       children: [
//         Row(
//           mainAxisAlignment: MainAxisAlignment.center,
//           children: <Widget>[
//             CircleAvatar(
//               backgroundColor: Colors.white,
//               child: Image.asset(
//                 'assets/genius.png',
//                 height: 100,
//               ),
//             ),
//             Text(' Genius',
//                 textAlign: TextAlign.center,
//                 style: GoogleFonts.openSans(
//                     color: Colors.white,
//                     fontSize: 20,
//                     fontWeight: FontWeight.bold)),
//           ],
//         ),
//         SizedBox(
//           height: 15,
//         ),
//         Text('Terms and Conditions',
//             style: GoogleFonts.openSans(
//               color: Colors.grey[600],
//               fontSize: 15,
//             )),
//       ],
//     );
//   }

//   _buildEmailField() {
//     return Expanded(
//       flex: 1,
//       child: Container(
//         padding: EdgeInsets.symmetric(horizontal: 10, vertical: 5),
//         // decoration: BoxDecoration(
//         //     color: secondaryColor, border: Border.all(color: Colors.blue)),
//         child: TextFormField(
//           decoration: InputDecoration(
//               border: OutlineInputBorder(),
//               labelText: "Email",
//               focusColor: Colors.white,
//               fillColor: Colors.yellow),
//           validator: MultiValidator([
//             RequiredValidator(errorText: "This Field Is Required"),
//             EmailValidator(errorText: "Invalid Email Address"),
//           ]),
//           onChanged: (val) {
//             email = val;
//           },
//         ),
//       ),
//     );
//   }

//   _buildPasswordField() {
//     return Expanded(
//       flex: 1,
//       child: Container(
//         padding: EdgeInsets.symmetric(horizontal: 10, vertical: 5),
//         // decoration: BoxDecoration(
//         //     color: secondaryColor, border: Border.all(color: Colors.blue)),
//         child: TextFormField(
//           obscureText: true,
//           decoration: InputDecoration(
//               border: OutlineInputBorder(), labelText: "Password"),
//           validator: MultiValidator([
//             RequiredValidator(errorText: "Password Is Required"),
//             MinLengthValidator(6, errorText: "Minimum 6 Characters Required"),
//           ]),
//           onChanged: (val) {
//             password = val;
//           },
//         ),
//       ),
//     );
//   }
// }
