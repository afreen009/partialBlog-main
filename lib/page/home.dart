import 'package:dio/dio.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_signin_example/database.dart';
import 'package:google_signin_example/model/post_entity.dart';
import 'package:google_signin_example/network/wp_api.dart';
import 'package:google_signin_example/page/article.dart';
import 'package:google_signin_example/page/edit_profile.dart';
import 'package:google_signin_example/page/explore_page.dart';
import 'package:google_signin_example/page/post_details.dart';
import 'package:google_signin_example/page/view_all.dart';
import 'package:google_signin_example/services/appbar.dart';
import 'package:google_signin_example/widget/config.dart';
import 'package:google_signin_example/widget/login.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:shimmer/shimmer.dart';
import '../services/theme_changer.dart';
import '../tabs/article_tab.dart';
import 'all_videos.dart';
import 'channel_list.dart';
import 'package:bubble_bottom_bar/bubble_bottom_bar.dart';

const String testDevice = '';

class HomePage extends StatefulWidget {
  // final String email;
  // final String photoUrl;
  // // value.photoUrl,value.email,value.displayName
  // HomePage({this.displayName, this.email, this.photoUrl});
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  _HomePageState() {
    dio = Dio();
    _searchText = "";
    names = List();
    filteredNames = List();
    _filter = TextEditingController();
  }
  Dio dio;
  String _searchText;
  List names;
  List filteredNames;
  TextEditingController _filter;
  AppBarSearch appbar;
  // BannerAd _bannerAd;

  // Icon _searchIcon =  Icon(Icons.search);
  FirebaseAuth auth = FirebaseAuth.instance;
  int currentIndex;
  bool _switchValue = false;
  Color primaryColor = Color(0xff18203d);
  Color secondaryColor = Color(0xff232c51);
  Color logoGreen = Color(0xff25bcbb);
  Widget _appBarTitle = Text(
    'Genius',
  );
  String string;
  bool search = false;
  List<PostEntity> data = List<PostEntity>();
  List<PostEntity> posts = List<PostEntity>();
  List tempList = List();
  final user = FirebaseAuth.instance.currentUser;

  @override
  void initState() {
    super.initState();

    currentIndex = 0;
    appbar = AppBarSearch(
      state: this,
      controller: _filter,
    );

    _getNames();

    _filter.addListener(() {
      if (_filter.text.isEmpty) {
        _searchText = "";
        filteredNames = names;
      } else {
        _searchText = _filter.text;
      }
      setState(() {});
    });
  }

  changePage(int index) {
    setState(() {
      currentIndex = index;
    });
  }

  List<PostEntity> comeon = List<PostEntity>();
  Icon _searchIcon = Icon(
    Icons.search,
    // color: Colors.white,
  );

  List<String> url = [
    'https://enginejunkies.com/',
    'http://festivalsofearth.com/',
    'http://insuranceofearth.com/',
    'https://bookworms99.com/'
  ];

  // We have to override the default TextController constructor for the state so that it listens for wether there is text in the search bar, and if there is, set the _searchText String to the TExtController input so we can filter the list accordingly.
  _getNames() async {
    // await FirebasesData()
    //     .createUserData(userName: user.displayName, points: 0, channel: '');
    print("burda:${user.displayName}");
    for (int i = 0; i < url.length; i++) {
      WpApi.getPostsList(category: FEATURED_CATEGORY_ID, baseurl: url[i])
          .then((_posts) {
        setState(() {
          comeon.addAll(_posts);
          for (int j = 0; j < comeon.length; j++) {
            //'inside');
            // print("comeon$comeon");
            tempList.add(comeon[j].title);
          }
          //data.length);
        });
      });
    }

    print("templist$tempList");
    names = tempList;
    filteredNames = names;
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // resizeToAvoidBottomPadding: false,
      appBar: AppBar(
        automaticallyImplyLeading: false,
        elevation: 10,
        titleSpacing: 8.0,
        title: _appBarTitle,
        centerTitle: false,
        leading: Padding(
          padding: const EdgeInsets.only(left: 10.0),
          child: Shimmer.fromColors(
            baseColor: logoGreen,
            highlightColor: Colors.blueGrey[300],
            direction: ShimmerDirection.ltr,
            child: Container(
                height: 180, width: 180, child: Image.asset('assets/logo.png')),
          ),
        ),
        actions: <Widget>[
          Padding(
            padding: EdgeInsets.only(right: 8.0),
            child: IconButton(
              icon: _searchIcon,
              // color: Colors.white,
              onPressed: () {
                setState(() {
                  search = !search;
                  _searchPressed();
                });
              },
            ),
          ),
          // Transform.scale(
          //     scale: .7,
          //     child: InkWell(
          //       onTap: () {
          //         setState(() {
          //           _switchValue = !_switchValue;
          //         });
          //       },
          //       child: CupertinoSwitch(
          //         trackColor: Colors.grey,
          //         value: _switchValue,
          //         onChanged: (bool value) {
          //           setState(() {
          //             _switchValue = value;
          //             themeChanger.toggle();
          //           });
          //         },
          //       ),
          //     )),
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
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.of(context)
              .push(MaterialPageRoute(builder: (context) => ViewAll()));
        },
        child: Container(
          height: 35,
          width: 35,
          child: Shimmer.fromColors(
            baseColor: logoGreen,
            highlightColor: Colors.grey[300],
            direction: ShimmerDirection.ltr,
            child: Image.asset(
              'assets/logoTransparent.png',
            ),
          ),
        ),
        // backgroundColor: Colors.white,
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      // bottomNavigationBar: BubbleBottomBar(
      //   opacity: 0.2,
      //   backgroundColor: Colors.white,
      //   borderRadius: BorderRadius.vertical(
      //     top: Radius.circular(16.0),
      //   ),
      //   currentIndex: currentIndex,
      //   hasInk: true,
      //   inkColor: primaryColor,
      //   hasNotch: true,
      //   fabLocation: BubbleBottomBarFabLocation.center,
      //   onTap: changePage,
      //   items: [
      //     BubbleBottomBarItem(
      //       backgroundColor: primaryColor,
      //       icon: Icon(
      //         Icons.home,
      //         color: Colors.black,
      //       ),
      //       activeIcon: Icon(
      //         Icons.home,
      //         color: primaryColor,
      //       ),
      //       title: Text('Home'),
      //     ),
      //     BubbleBottomBarItem(
      //       backgroundColor: primaryColor,
      //       icon: Icon(
      //         Icons.videocam,
      //         color: Colors.black,
      //       ),
      //       activeIcon: Icon(
      //         Icons.videocam,
      //         color: primaryColor,
      //       ),
      //       title: Text('flight'),
      //     ),
      //     BubbleBottomBarItem(
      //       backgroundColor: Colors.indigo,
      //       icon: Icon(
      //         Icons.article,
      //         color: Colors.black,
      //       ),
      //       activeIcon: Icon(
      //         Icons.article,
      //         color: Colors.indigo,
      //       ),
      //       title: Text('Articles'),
      //     ),
      //     BubbleBottomBarItem(
      //       backgroundColor: Colors.deepPurple,
      //       icon: Icon(
      //         Icons.person,
      //         color: Colors.black,
      //       ),
      //       activeIcon: Icon(
      //         Icons.person,
      //         color: Colors.deepPurple,
      //       ),
      //       title: Text('Person'),
      //     ),
      //   ],
      // ),
      // body: (currentIndex == 0)
      //     ? Articles()
      //     : (currentIndex == 1)
      //         ? ViewAll()
      //         : (currentIndex == 1)
      //             ? HomeTab
      //             : Icon(
      //                 Icons.access_time,
      //                 size: 150.0,
      //                 color: Colors.deepPurple,
      //               ),

      body: !search
          ? IndexedStack(
              index: currentIndex,
              children: <Widget>[
                Articles(comeon),
                ArticleTab(),
                ViewAll(
                    // baseurl: [
                    //   'https://Slasherhub.com/',
                    //   'http://Gosportx.com/',
                    //   'http://Gotrekx.com/',
                    //   'https://Gossipwheel.com/',
                    //   'https://Trendznet.com/'
                    // ],
                    // option: 'explore',
                    ),
                VideoTab(),
                EditProfilePage(),
                // SettingsUI()
              ],
            )
          : Container(
              child: _buildList(),
            ),

      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        // backgroundColor: Color(0xFF161b18),
        // unselectedItemColor: Colors.white,
        // selectedItemColor: logoGreen,
        currentIndex: currentIndex,
        onTap: (index) {
          setState(() {
            currentIndex = index;
          });
        },
        showSelectedLabels: false,
        showUnselectedLabels: false,
        items: [
          BottomNavigationBarItem(
            icon: Icon(
              Icons.home_outlined,
              size: 30,
            ),
            label: '',
          ),
          BottomNavigationBarItem(
            icon: Icon(
              Icons.article_outlined,
              size: 30,
            ),
            label: '',
          ),
          BottomNavigationBarItem(
            icon: Icon(
              FontAwesomeIcons.search,
              size: 0,
              // color: Colors.white,
            ),
            label: '',
          ),
          BottomNavigationBarItem(
            icon: Icon(
              Icons.videocam_outlined,
              size: 30,
            ),
            label: '',
          ),
          BottomNavigationBarItem(
            icon: Icon(
              Icons.person_outline,
              size: 30,
            ),
            label: '',
          ),
        ],
      ),
    );
  }

  Widget _buildList() {
    if (_searchText.isNotEmpty) {
      List tempList = List();
      for (int i = 0; i < filteredNames.length; i++) {
        if (filteredNames[i]
            .toLowerCase()
            .contains(_searchText.toLowerCase())) {
          tempList.add(filteredNames[i]);
        }
      }
      filteredNames = tempList;
    }
    return ListView.builder(
      itemCount: names == null ? 0 : filteredNames.length,
      itemBuilder: (BuildContext context, int index) {
        return ListTile(
            title: Text(
              filteredNames[index],
              // style: TextStyle(color: Colors.white),
            ),
            onTap: () {
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => PostDetails(comeon[index])));
            });
      },
    );
  }
  // _buildList() {
  //   if (_searchText.isNotEmpty) {
  //     for (int i = 0; i < filteredNames.length; i++) {
  //       if (filteredNames[i]
  //           .toLowerCase()
  //           .contains(_searchText.toLowerCase())) {
  //         tempList.add(filteredNames[i]);
  //       }
  //     }
  //     filteredNames = tempList;
  //   }
  //   return Container(
  //     child: ListView.builder(
  //       itemCount: names == null ? 0 : filteredNames.length,
  //       itemBuilder: (BuildContext context, int index) {
  //         //"filteredNames.length " + filteredNames.length.toString());
  //         return  ListTile(
  //             title: Text(filteredNames[index]),
  //             onTap: () {
  //               Navigator.push(
  //                   context,
  //                   MaterialPageRoute(
  //                       builder: (context) => PostDetails(data[index])));
  //             });
  //       },
  //     ),
  //   );
  // }

  void _searchPressed() {
    setState(() {
      if (this._searchIcon.icon == Icons.search) {
        this._searchIcon = Icon(Icons.close);
        this._appBarTitle = TextField(
          controller: _filter,
          decoration: InputDecoration(
            border: InputBorder.none,
            hintText: 'search',
            filled: true,
            fillColor: Colors.grey,
            contentPadding:
                const EdgeInsets.only(left: 14.0, bottom: 6.0, top: 8.0),
            focusedBorder: OutlineInputBorder(
              borderSide: BorderSide(color: Colors.red),
              borderRadius: BorderRadius.circular(10.0),
            ),
            enabledBorder: UnderlineInputBorder(
              borderSide: BorderSide(color: Colors.grey),
              borderRadius: BorderRadius.circular(10.0),
            ),
          ),
          // decoration: InputDecoration(
          //     focusColor: Colors.white,
          //     prefixIcon: Icon(Icons.search),
          //     hintText: 'Search......',
          //     fillColor: Colors.white),
        );
      } else {
        this._searchIcon = Icon(
          Icons.search,
        );
        this._appBarTitle = Text(
          'Genius',
        );
        filteredNames = names;
        _filter.clear();
      }
    });
  }
}
