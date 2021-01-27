// import 'package:firebase_auth/firebase_auth.dart';
// import 'package:flutter/material.dart';
// import 'package:form_field_validator/form_field_validator.dart';
// import 'package:google_signin_example/page/home.dart';
// import 'package:google_signin_example/widget/login.dart';
// import 'package:shimmer/shimmer.dart';

// import '../auth.dart';

// class SignUpScreen extends StatefulWidget {
//   @override
//   _SignUpScreenState createState() => _SignUpScreenState();
// }

// class _SignUpScreenState extends State<SignUpScreen> {
//   Color primaryColor = Color(0xff18203d);
//   Color secondaryColor = Color(0xff232c51);
//   Color logoGreen = Color(0xff25bcbb);
//   String email;
//   String password;
//   GlobalKey<FormState> formkey = GlobalKey<FormState>();

//   void handleSignup() {
//     if (formkey.currentState.validate()) {
//       formkey.currentState.save();
//       signUp(email.trim(), password, context).then((value) {
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

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       backgroundColor: primaryColor,
//       body: Center(
//         child: SingleChildScrollView(
//           child: Column(
//             children: <Widget>[
//               Container(
//                   height: 160,
//                   width: 200,
//                   child: Shimmer.fromColors(
//                       baseColor: Colors.grey[300],
//                       highlightColor: logoGreen,
//                       child: Image.asset('assets/genius.png'))),
//               Padding(
//                 padding: EdgeInsets.symmetric(vertical: 20.0),
//                 child: Text(
//                   "Signup",
//                   style: TextStyle(fontSize: 30.0, color: Colors.white),
//                 ),
//               ),
//               Container(
//                 padding: EdgeInsets.all(8.0),
//                 decoration: BoxDecoration(
//                     borderRadius: BorderRadius.circular(8.0),
//                     color: Colors.white),
//                 width: MediaQuery.of(context).size.width * 0.90,
//                 child: Form(
//                   key: formkey,
//                   child: Column(
//                     children: <Widget>[
//                       TextFormField(
//                         decoration: InputDecoration(
//                             border: OutlineInputBorder(), labelText: "Email"),
//                         validator: (_val) {
//                           if (_val.isEmpty) {
//                             return "Can't be empty";
//                           } else {
//                             return null;
//                           }
//                         },
//                         onChanged: (val) {
//                           email = val;
//                         },
//                       ),
//                       Padding(
//                         padding: const EdgeInsets.symmetric(vertical: 15.0),
//                         child: TextFormField(
//                           decoration: InputDecoration(
//                               border: OutlineInputBorder(),
//                               labelText: "Password"),
//                           validator: MultiValidator([
//                             RequiredValidator(
//                                 errorText: "This Field Is Required."),
//                             MinLengthValidator(6,
//                                 errorText: "Minimum 6 Characters Required.")
//                           ]),
//                           onChanged: (val) {
//                             password = val;
//                           },
//                         ),
//                       ),
//                       RaisedButton(
//                         onPressed: handleSignup,
//                         color: Colors.green,
//                         textColor: Colors.white,
//                         child: Text(
//                           "Sign Up",
//                         ),
//                       ),
//                     ],
//                   ),
//                 ),
//               ),
//               MaterialButton(
//                 padding: EdgeInsets.zero,
//                 onPressed: () => googleSignIn().whenComplete(() async {
//                   FirebaseUser user = await FirebaseAuth.instance.currentUser();

//                   Navigator.of(context).pushReplacement(
//                       MaterialPageRoute(builder: (context) => HomePage()));
//                 }),
//                 // child: Image(
//                 //   image: AssetImage('assets/signin.png'),
//                 //   width: 200.0,
//                 // ),
//               ),
//               SizedBox(
//                 height: 10.0,
//               ),
//               InkWell(
//                 onTap: () {
//                   // send to login screen
//                   Navigator.of(context).pushAndRemoveUntil(
//                       MaterialPageRoute(builder: (context) => LoginScreen()),
//                       (Route<dynamic> route) => false);
//                   // Navigator.of(context).push(
//                   //     MaterialPageRoute(builder: (context) => LoginScreen()));
//                 },
//                 child: Text(
//                   "Login Here",
//                   style: TextStyle(color: Colors.white, fontSize: 20),
//                 ),
//               ),
//             ],
//           ),
//         ),
//       ),
//     );
//   }
// }
