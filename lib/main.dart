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

import 'network/wp_api.dart';
import 'widget/post_list_item.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatefulWidget {
  static final String title = 'Google SignIn';

  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  // ignore: cancel_subscriptions
  StreamSubscription _intentDataStreamSubscription;
  StreamController<String> _intentStreamController;
  @override
  void initState() {
    // TODO: implement initState
    _intentStreamController = StreamController();
    super.initState();
    _intentDataStreamSubscription =
        ReceiveSharingIntent.getTextStream().listen((String value) {
      //Stream just for performant
      _intentStreamController.add(value);
    }, onError: (err) {
      print("getLinkStream error: $err");
    });
  }

  @override
  void dispose() {
    _intentStreamController.close();
    super.dispose();
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
          home: StreamBuilder<String>(
              initialData: '',
              stream: _intentStreamController.stream,
              builder: (context, snapshot) {
                if ((snapshot.data != null && snapshot.data.isNotEmpty)) {
                  return displayPost(snapshot.data);
                } else {
                  return CheckPage();
                }
              }),
        );
      }),
    );
  }
  //I think all is fine stop the app and rerun it, ok, ping me when done on cool :) thank u so much you're welcome :)
  //u there?ooooooooooooooooooo u there?

  //PostDisplayer
  Widget displayPost(postUrl) {
    return FutureBuilder(
      future: WpApi.getSinglePostDetails(postUrl),
      builder: (BuildContext context, AsyncSnapshot snapshot) {
        if (snapshot.hasData) {
          return PostListItem(snapshot.data);
        } else if (snapshot.connectionState == ConnectionState.waiting ||
            snapshot.connectionState == ConnectionState.active) {
          return Center(
            child: CircularProgressIndicator(),
          );
        }
        return Center(
          child: Text(
            'Post Not found',
            style: Theme.of(context).textTheme.subtitle1,
          ),
        );
      },
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
