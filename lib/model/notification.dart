import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';

class Notification extends StatefulWidget {
  @override
  _NotificationState createState() => _NotificationState();
}

class _NotificationState extends State<Notification> {
  final _firebaseMessaging = FirebaseMessaging();
  String _message = 'generating message';
  String _token = 'generating token';
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _firebaseMessaging.configure(
      onMessage: (Map<String, dynamic> message) async {
        setState(() {
          _message = '$message';
        });
      },
      onLaunch: (Map<String, dynamic> message) async {
        setState(() {
          _message = '$message';
        });
      },
      onResume: (Map<String, dynamic> message) async {
        setState(() {
          _message = '$message';
        });
      },
    );
    _firebaseMessaging.getToken().then((String token) {
      assert(token != null);
      setState(() {
        _token = '$token';
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container();
  }
}
