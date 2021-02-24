import 'package:flutter/material.dart';
import 'package:google_signin_example/tabs/video2.dart';
import 'package:google_signin_example/tabs/video3.dart';
import 'package:google_signin_example/tabs/video4.dart';
import 'package:google_signin_example/tabs/videosPage.dart';

class VideoTab extends StatefulWidget {
  @override
  _VideoTabState createState() => _VideoTabState();
}

class _VideoTabState extends State<VideoTab>
    with SingleTickerProviderStateMixin {
  TabController _tabController;
  Color primaryColor = Color(0xff18203d);
  Color secondaryColor = Color(0xff232c51);
  Color logoGreen = Color(0xff25bcbb);
  @override
  void initState() {
    super.initState();
    _tabController = TabController(
      length: 4,
      vsync: this,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      child: DefaultTabController(
        length: 4,
        child: Center(
          child: Column(
            children: [
              Container(
                color: secondaryColor,
                child: TabBar(
                  labelColor: Colors.white,
                  indicatorColor: Colors.white,
                  // controller: _tabController,
                  tabs: <Widget>[
                    Tab(
                      child: Text(
                        'Engine Junkies',
                        style: TextStyle(
                            fontSize: 12,
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                            shadows: [
                              BoxShadow(
                                color: Color.fromRGBO(0, 0, 0, 0.15),
                                offset: Offset(0, 5),
                                blurRadius: 10.0,
                              )
                            ]),
                      ),
                    ),
                    Tab(
                      child: Text(
                        'Insurance',
                        style: TextStyle(
                            fontSize: 12,
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                            shadows: [
                              BoxShadow(
                                color: Color.fromRGBO(0, 0, 0, 0.15),
                                offset: Offset(0, 5),
                                blurRadius: 10.0,
                              )
                            ]),
                      ),
                    ),
                    Tab(
                      child: Text(
                        'Books',
                        style: TextStyle(
                            fontSize: 12,
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                            shadows: [
                              BoxShadow(
                                color: Color.fromRGBO(0, 0, 0, 0.15),
                                offset: Offset(0, 5),
                                blurRadius: 10.0,
                              )
                            ]),
                      ),
                    ),
                    Tab(
                      child: Text(
                        'Festivals',
                        style: TextStyle(
                            fontSize: 12,
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                            shadows: [
                              BoxShadow(
                                color: Color.fromRGBO(0, 0, 0, 0.15),
                                offset: Offset(0, 5),
                                blurRadius: 10.0,
                              )
                            ]),
                      ),
                    ),
                  ],
                ),
              ),
              Expanded(
                child: Container(
                  // color: Colors.white,
                  child: TabBarView(
                    children: [
                      VideoPlayerApp(),
                      Video2(),
                      Video3(),
                      Video4(),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
