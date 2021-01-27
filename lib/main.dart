import 'dart:async';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_signin_example/page/home.dart';
import 'package:google_signin_example/page/home1.dart';
import 'package:google_signin_example/page/home_page.dart';
import 'package:google_signin_example/services/theme_changer.dart';
import 'package:google_signin_example/theme.dart';
import 'package:provider/provider.dart';
import 'package:receive_sharing_intent/receive_sharing_intent.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatefulWidget {
  static final String title = 'Google SignIn';

  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  StreamSubscription _intentDataStreamSubscription;
  List<SharedMediaFile> _sharedFiles;
  String _sharedText;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _intentDataStreamSubscription =
        ReceiveSharingIntent.getTextStream().listen((String value) {
      setState(() {
        _sharedText = value;
      });
    }, onError: (err) {
      print("getLinkStream error: $err");
    });
  }

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider<ThemeChanger>(
      create: (_) => ThemeChanger(),
      child: Builder(builder: (context) {
        final themeChanger = Provider.of<ThemeChanger>(context);
        return MaterialApp(
          debugShowCheckedModeBanner: false,
          title: MyApp.title,
          themeMode: themeChanger.getTheme,
          darkTheme: Style.get(true),
          theme: Style.get(false),
          home: CheckPage(),
        );
      }),
    );
  }
}

class CheckPage extends StatefulWidget {
  @override
  _CheckPageState createState() => _CheckPageState();
}

class _CheckPageState extends State<CheckPage> {
  @override
  Widget build(BuildContext context) {
    return FutureBuilder<FirebaseUser>(
      future: FirebaseAuth.instance.currentUser(),
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          FirebaseUser user = snapshot.data;
          return HomePage();
        } else {
          return Welcome();
        }
        //On debug mode will be able to see the conten(or value ) of obejct and variable on runtime ok, n
      },
    );
  }
}
//Show me the erro which is display about the index
//one min one minsure
