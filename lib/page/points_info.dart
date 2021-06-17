import 'package:flutter/material.dart';
import 'package:google_signin_example/page/view_all.dart';

class PointsInfo extends StatefulWidget {
  @override
  _PointsInfoState createState() => _PointsInfoState();
}

class _PointsInfoState extends State<PointsInfo> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: SafeArea(
        child: Container(
            padding: EdgeInsets.all(10.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Text(
                  "What are Genius Points and how can i use the points i make?",
                  style: TextStyle(fontSize: 30, fontWeight: FontWeight.bold),
                ),
                SizedBox(
                  height: 40,
                ),
                Text(
                    'Genius points are earned by watching any video for more than 30 secs or by watching an unskippable ad.'),
                Text(
                    'when you earn points equal to 1000, you can use it to access any one blogs from'),
                RaisedButton(
                  onPressed: () {
                    Navigator.of(context).push(
                        MaterialPageRoute(builder: (context) => ViewAll()));
                  },
                  child: Text('here'),
                ),
              ],
            )),
      ),
    );
  }
}
