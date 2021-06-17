import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_signin_example/database/bookmark_database.dart';
import 'package:google_signin_example/database/db_model.dart';
import 'package:google_signin_example/providers/user_provder.dart';
import 'package:google_signin_example/services/theme_changer.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ProfilePage extends StatefulWidget {
  @override
  _ProfilePageState createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  String email;
  String photoUrl;
  String displayName;
  bool _switchValue = false;
  List finalBdlist = [];
  List<DbModel> bd;
  Future<SharedPreferences> _prefs = SharedPreferences.getInstance();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    sharedPreferences();
    getStatus();
    print(photoUrl);
  }

  Future<List<DbModel>> getStatus() async {
    bd = await BookMarkDatabase.bd.getAllPersons();
    // print("Bd:$Bd");
    // print('inside finalBd');
    finalBdlist.clear();
    for (int i = 0; i < bd.length; i++) {
      // print(Bd[i].name);
      if (finalBdlist.contains(bd[i].name))
        continue;
      else {
        finalBdlist.add(bd[i].name);
      }
    }
    // print("final$finalBdlist");
    return bd;
  }

  sharedPreferences() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    print("PhotoUrl:${(await _prefs).getString('profile')}");
    print('inside setstate');
    String emails = (await _prefs).getString('email');
    String photoUrls = (await _prefs).getString('profile');
    String displayNames = (await _prefs).getString('name');
    setState(() {
      email = emails;
      photoUrl = photoUrls;
      displayName = displayNames;
    });
    print(photoUrl);
  }

  @override
  Widget build(BuildContext context) {
    final themeChanger = Provider.of<ThemeChanger>(context);
    return Scaffold(
        body: Column(
      children: [
        Container(
          height: 200,
          child: Stack(
            children: [
              Positioned(
                top: 30,
                left: 10,
                child: Column(
                  children: [
                    Container(
                      width: 130,
                      height: 130,
                      decoration: BoxDecoration(
                        border: Border.all(
                            width: 4,
                            color: Theme.of(context).scaffoldBackgroundColor),
                        boxShadow: [
                          BoxShadow(
                              spreadRadius: 2,
                              blurRadius: 10,
                              color: Colors.black.withOpacity(0.1),
                              offset: Offset(0, 10))
                        ],
                        shape: BoxShape.circle,
                        // image: DecorationImage(
                        //   fit: BoxFit.cover,
                        //   image: NetworkImage(userData.user.pictureUrl),
                        // ),
                      ),
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    Text(displayName,
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          // color: Colors.black,
                        )),
                  ],
                ),
              ),
              Positioned(
                top: 60,
                right: 40,
                child: Row(
                  children: [
                    Column(
                      children: [
                        Text('0',
                            style: TextStyle(
                              fontSize: 16,
                              // fontWeight: FontWeight.bold,
                              // color: Colors.black,
                            )),
                        Text('Posts',
                            style: TextStyle(
                              fontSize: 16,
                              // fontWeight: FontWeight.bold,
                              // color: Colors.black,
                            )),
                      ],
                    ),
                    SizedBox(
                      width: 40,
                    ),
                    Column(
                      children: [
                        Text('0',
                            style: TextStyle(
                              fontSize: 16,
                              // fontWeight: FontWeight.bold,
                              // color: Colors.black,
                            )),
                        Text('Points',
                            style: TextStyle(
                              fontSize: 16,
                              // fontWeight: FontWeight.bold,
                              // color: Colors.black,
                            )),
                      ],
                    )
                  ],
                ),
              ),
            ],
          ),
        ),
        SizedBox(
          height: 15,
        ),
        Container(
          // padding: EdgeInsets.symmetric(horizontal: 30),
          height: 30,
          // color: Colors.pink,
          child: Row(
            children: [
              SizedBox(
                width: 30,
              ),
              Text('Theme',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    // color: Colors.black,
                  )),
              Spacer(),
              Transform.scale(
                  scale: .7,
                  child: InkWell(
                    onTap: () {
                      setState(() {
                        _switchValue = !_switchValue;
                      });
                    },
                    child: CupertinoSwitch(
                      trackColor: Colors.white,
                      activeColor: Colors.black,
                      value: _switchValue,
                      onChanged: (bool value) {
                        setState(() {
                          _switchValue = value;
                          themeChanger.toggle();
                        });
                      },
                    ),
                  )),
            ],
          ),
        ),
        SizedBox(
          height: 10,
        ),
        Container(
          decoration: BoxDecoration(
            // color: Theme.of(context).scaffoldBackgroundColor,
            border: Border(
              top: BorderSide(
                color: Colors.grey[300],
                width: 1.0,
              ),
              bottom: BorderSide(
                color: Colors.grey[300],
                width: 1.0,
              ),
            ),
          ),
          height: 40,
          child: Center(
              child: Text('Posts',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    // color: Colors.white,
                  ))),
        ),
        Center(
            child: Text(finalBdlist.isNotEmpty ? finalBdlist[0] : 'No posts')),
      ],
    ));
  }
}
