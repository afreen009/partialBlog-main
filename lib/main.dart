import 'dart:async';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:google_signin_example/page/home.dart';
import 'package:google_signin_example/page/welcome.dart';
import 'package:google_signin_example/providers/authentication_provider.dart';
import 'package:google_signin_example/providers/user_provder.dart';
import 'package:google_signin_example/states/current_user.dart';
import 'package:provider/provider.dart';
import 'package:shimmer/shimmer.dart';
import 'services/theme_changer.dart';
import 'theme.dart';
import 'package:admob_flutter/admob_flutter.dart';

Future main() async {
  WidgetsFlutterBinding.ensureInitialized();
  Admob.initialize();
  await Firebase.initializeApp();
  runApp(MyApp());
}

class MyApp extends StatefulWidget {
  static final String title = 'Google SignIn';

  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  // StreamSubscription _intentDataStreamSubscription;
  // List<SharedMediaFile> _sharedFiles;
  // String _sharedText;
  @override
  void initState() {
    super.initState();
    // _intentDataStreamSubscription =
    //     ReceiveSharingIntent.getTextStream().listen((String value) {
    //   setState(() {
    //     _sharedText = value;
    //   });
    // }, onError: (err) {});
  }

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider<ThemeChanger>(create: (_) => ThemeChanger()),
        ChangeNotifierProvider<AuthenticationProvider>(
          create: (_) => AuthenticationProvider(),
        ),
        ChangeNotifierProvider<UserProvider>(
          create: (_) => UserProvider(UserData(
              email: '',
              points: 0,
              name: '',
              channels: [],
              userId: '',
              pictureUrl: '')),
        )
      ],
      child: Builder(builder: (context) {
        final ThemeChanger themeChanger = Provider.of<ThemeChanger>(context);
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
  Color logoGreen = Color(0xff25bcbb);
  @override
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: StreamBuilder<User>(
        stream: Provider.of<AuthenticationProvider>(context, listen: false)
            .userStreamStatus,
        builder: (context, userAuthStatus) {
          return _swtichScreen(userAuthStatus);
        },
      ),
    );
  }

  Widget _swtichScreen(AsyncSnapshot<User> userAuthStatus) {
    if (userAuthStatus.connectionState == ConnectionState.waiting) {
      return buildLoading();
    } else if (userAuthStatus.connectionState == ConnectionState.active &&
        userAuthStatus.data != null) {
      return HomePage();
    } else {
      return Welcome();
    }
  }

  Widget buildLoading() => Stack(
        fit: StackFit.expand,
        children: [
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                  height: 100,
                  width: 100,
                  child: Shimmer.fromColors(
                      period: Duration(milliseconds: 1500),
                      baseColor: logoGreen,
                      highlightColor: Colors.grey[300],
                      child: Image.asset('assets/logo.png'))),
              Text("Loading....."),
            ],
          ),
        ],
      );
}
