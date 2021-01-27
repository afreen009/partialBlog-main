import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_signin_example/page/edit_profile.dart';
import 'package:google_signin_example/page/home1.dart';
import 'package:google_signin_example/page/search.dart';
import 'package:google_signin_example/tabs/videos_page1.dart';
import 'package:provider/provider.dart';
import '../services/theme_changer.dart';
import '../tabs/home_tab.dart';

const String testDevice = '';

class HomePage extends StatefulWidget {
  final String displayName;
  final String email;
  final String photoUrl;
  // value.photoUrl,value.email,value.displayName
  HomePage({this.displayName, this.email, this.photoUrl});
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  FirebaseAuth auth = FirebaseAuth.instance;
  int currentIndex = 0;
  bool _switchValue = false;
  Color primaryColor = Color(0xff18203d);
  Color secondaryColor = Color(0xff232c51);
  Color logoGreen = Color(0xff25bcbb);
  String string;
  @override
  void initState() {
    super.initState();

    // _connectivity.initialise();
    // _connectivity.myStream.listen((source) {
    //   setState(() => _source = source);
    // });
  }

  @override
  Widget build(BuildContext context) {
    Color primaryColor = Color(0xff18203d);
    final themeChanger = Provider.of<ThemeChanger>(context);
    return Scaffold(
      resizeToAvoidBottomPadding: false,
      appBar: AppBar(
        automaticallyImplyLeading: false,
        titleSpacing: 8.0,
        title: Text(
          'Genius',
          style: TextStyle(color: Colors.white),
        ),
        centerTitle: false,
        backgroundColor: primaryColor,
        leading: Padding(
          padding: const EdgeInsets.only(left: 10.0),
          child: Container(
              height: 200, width: 200, child: Image.asset('assets/genius.png')),
        ),
        actions: <Widget>[
          Transform.scale(
              scale: .7,
              child: InkWell(
                onTap: () {
                  setState(() {
                    _switchValue = !_switchValue;
                  });
                },
                child: CupertinoSwitch(
                  trackColor: Colors.grey,
                  value: _switchValue,
                  onChanged: (bool value) {
                    setState(() {
                      _switchValue = value;
                      themeChanger.toggle();
                    });
                  },
                ),
              )),
          // IconButton(
          //   icon: Icon(
          //     FontAwesomeIcons.powerOff,
          //     color: Colors.white,
          //   ),
          //   splashColor: Colors.transparent,
          //   highlightColor: Colors.transparent,
          //   onPressed: () => signOutUser().then((value) {
          //     Navigator.of(context).pushAndRemoveUntil(
          //         MaterialPageRoute(builder: (context) => LoginScreen()),
          //         (Route<dynamic> route) => false);
          //   }),
          // ),
        ],
      ),
      body: IndexedStack(
        index: currentIndex,
        children: <Widget>[
          Articles(),
          SearchPage(),
          HomeTab(),
          VideoPlayerApp(),
          SettingsUI()
        ],
      ),
      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        backgroundColor: primaryColor,
        unselectedItemColor: Colors.white,
        currentIndex: currentIndex,
        onTap: (index) {
          setState(() {
            currentIndex = index;
          });
        },
        items: [
          BottomNavigationBarItem(
            icon: Icon(
              FontAwesomeIcons.home,
              size: 18,
            ),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(
              Icons.search,
              size: 18,
            ),
            label: 'search',
          ),
          BottomNavigationBarItem(
            icon: Icon(
              Icons.article,
              size: 18,
            ),
            label: 'articles',
          ),
          BottomNavigationBarItem(
            icon: Icon(
              FontAwesomeIcons.video,
              size: 18,
            ),
            label: 'Videos',
          ),
          // BottomNavigationBarItem(
          //   icon: InkWell(
          //     onTap: () => signOutUser().then((value) {
          //       Navigator.of(context).pushAndRemoveUntil(
          //           MaterialPageRoute(builder: (context) => Welcome()),
          //           (Route<dynamic> route) => false);
          //     }),
          //     child: Icon(
          //       FontAwesomeIcons.powerOff,
          //     ),
          //   ),
          //   label: 'Log Out',
          // ),
          BottomNavigationBarItem(
            icon: Icon(
              Icons.person,
              size: 20,
            ),
            label: 'Profile',
          ),
        ],
      ),
    );
  }

  @override
  void dispose() {
    // _connectivity.disposeStream();
    super.dispose();
  }
}
