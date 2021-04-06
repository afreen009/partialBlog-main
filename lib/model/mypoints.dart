// import 'dart:convert';
// import 'dart:math';
// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:http/http.dart' as http;

//     class Authfirestore {
//       final String uid;
//       int points;
//       var dateFromApitme;
//       String lastTimeGotPointsFromFirebase;
//       Authfirestore({this.uid, this.points});

//       Firestore _firestore = Firestore();

//       Future checkPoints() async {
//         await dateApi();
//         if (dateFromApitme != null ) {
//           try {
//             if (lastTimeGotPointsFromFirebase != dateFromApitme && dateFromApitme != null) {
//               await getData();
//               dynamic result = _firestore
//                   .collection('users')
//                   .document('Jm7bx8NOE9Nfx6P8S1wD')
//                   .setData({
//                 'points': points + 1,
//                 'LastTimeGotPoints' :dateFromApitme,
//               });
//               await getData();
//               print(result.toString());
//               trackingData();
//             } else {
//               print('You toke your cridit ');
//             }
//           } catch (e) {
//             print('Error in cehckpoints $e');
//           }
//         }
//       }

//       Future trackingData() async {
//         await Firestore.instance
//             .collection('users')
//             .document('Jm7bx8NOE9Nfx6P8S1wD')
//             .collection('tracking')
//             .document(_randomString(20))
//             .setData({
//           'date': DateTime.now(),
//         });
//       }

//       Future getData() async {
//         await Firestore.instance
//             .collection('users')
//             .document('Jm7bx8NOE9Nfx6P8S1wD')
//             .get()
//             .then((DocumentSnapshot ds) {
//           // points = ds.data;
//           lastTimeGotPointsFromFirebase = ds.data['LastTimeGotPoints'];
//           print('number of points is $points');
//         });

//       }

//       String _randomString(int length) {
//         var rand = new Random();
//     var codeUnits = new List.generate(length, (index) {
//       return rand.nextInt(33) + 89;
//     });

//     return new String.fromCharCodes(codeUnits);
//   }

//   Future dateApi() async {
//     var response =
//         await http.get('http://worldtimeapi.org/api/timezone/Asia/Muscat');
//     if (response != null) {
//       var data0 = jsonDecode(response.body);
//       var data01 = data0['datetime'];
//       dateFromApitme = data01.substring(0, 9);
//     } else {
//       dateFromApitme = null;
//       print('Please Check Your internet');
//     }
//   }
// }
