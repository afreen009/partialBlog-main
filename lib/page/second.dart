import 'package:flutter/material.dart';

class SecondPage extends StatefulWidget {
  @override
  _SecondPageState createState() => _SecondPageState();
}

class _SecondPageState extends State<SecondPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Wordpress OneSignal'),
        elevation: 0,
      ),
      backgroundColor: Colors.grey[200],
      body: Center(
        child: Text('hello'),
      ),
    );
  }
}
