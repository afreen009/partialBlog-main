import 'dart:async';

import 'package:admob_flutter/admob_flutter.dart';
import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:google_signin_example/database.dart';
import 'package:google_signin_example/providers/user_provder.dart';
import 'package:google_signin_example/widget/helpers.dart';
import 'package:google_signin_example/widget/post_card.dart';
import 'package:provider/provider.dart';
import 'package:shimmer/shimmer.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:circular_countdown_timer/circular_countdown_timer.dart';
import '../admob.dart';
import '../model/post_entity.dart';
import 'package:rflutter_alert/rflutter_alert.dart';

class PostDetails extends StatefulWidget {
  final PostEntity post;
  PostDetails(
    this.post,
  );

  @override
  _PostDetailsState createState() => _PostDetailsState();
}

class _PostDetailsState extends State<PostDetails> {
  FirebasesData fData = FirebasesData.instance;
  bool change = false;
  AnimationController controller;
  CountDownController _controller = CountDownController();
  bool _clicked = false;

  // void _showToast(BuildContext context) {
  //   final scaffold = Scaffold.of(context);
  //   scaffold.showSnackBar(
  //     SnackBar(
  //       content: const Text('+10 points added'),
  //       // action: SnackBarAction(
  //       //     label: 'UNDO', onPressed: scaffold.hideCurrentSnackBar),
  //     ),
  //   );
  // }

  @override
  void initState() {
    super.initState();
  }

  changeStatus() {
    if (mounted) {
      setState(() {
        change = true;
      });
    }
  }

  void handleEvent(
      AdmobAdEvent event, Map<String, dynamic> args, String adType) {
    switch (event) {
      case AdmobAdEvent.loaded:
        print('New Admob $adType Ad loaded!');
        break;
      case AdmobAdEvent.opened:
        print('Admob $adType Ad opened!');
        break;
      case AdmobAdEvent.closed:
        print('Admob $adType Ad closed!');
        break;
      case AdmobAdEvent.failedToLoad:
        print('Admob $adType failed to load. :(');
        break;
      case AdmobAdEvent.rewarded:
        break;
      default:
    }
  }

  Color logoGreen = Color(0xff25bcbb);
  @override
  Widget build(BuildContext context) {
    // print(post);
    // //post);
    // post.isDetailCard = true;
    return Scaffold(
      // resizeToAvoidBottomPadding: false,
      body: NestedScrollView(
        headerSliverBuilder: (BuildContext context, bool innerBoxIsScrolled) {
          Size size = MediaQuery.of(context).size;
          return <Widget>[
            SliverAppBar(
              iconTheme: IconThemeData(color: Colors.white),
              floating: true,
              expandedHeight: 150.0,
              flexibleSpace: FlexibleSpaceBar(
                background: Stack(
                  children: <Widget>[
                    widget.post.image.isNotEmpty
                        ? CachedImage(
                            widget.post.image,
                            width: size.width,
                            height: size.height,
                          )
                        : Container(
                            color: Colors.white,
                            child: Center(child: Text('no image'))),
                    // Positioned(
                    //   child: Container(
                    //     height: 200,
                    //     decoration: BoxDecoration(
                    //       gradient: LinearGradient(
                    //           begin: Alignment.bottomCenter,
                    //           end: Alignment.topCenter,
                    //           colors: [Colors.amber, Colors.green]),
                    //     ),
                    //   ),
                    // ),
                    Positioned(
                      bottom: 0,
                      child: Author(post: widget.post),
                    ),
                    Positioned(
                      top: 45,
                      right: 10,
                      child: CircularCountDownTimer(
                        width: 50,
                        height: 50,
                        duration: 45,
                        fillColor: Colors.black54,
                        color: Colors.white,
                        controller: _controller,
                        backgroundColor: Colors.white54,
                        strokeWidth: 5.0,
                        strokeCap: StrokeCap.round,
                        isTimerTextShown: true,
                        isReverse: false,
                        onComplete: () {
                          changeStatus();
                        },
                        textStyle:
                            TextStyle(fontSize: 30.0, color: Colors.black),
                      ),
                    ),
                    Positioned(
                      bottom: 35.0,
                      child: Container(
                          width: size.width,
                          child: Column(
                            children: <Widget>[
                              Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Text(
                                  widget.post.title,
                                  textAlign: TextAlign.left,
                                  style: TextStyle(
                                      shadows: [
                                        BoxShadow(
                                          color: Colors.black,
                                          offset: Offset(0, 5),
                                          blurRadius: 10.0,
                                        )
                                      ],
                                      color: Colors.white,
                                      fontWeight: FontWeight.bold,
                                      fontSize: 14.0),
                                ),
                              ),
                            ],
                          )),
                    ),
                    Positioned(
                      bottom: 0,
                      right: 0,
                      child: CategoryPill(post: widget.post),
                    ),
                  ],
                ),
              ),
            )
          ];
        },
        body: Scaffold(
          body: SingleChildScrollView(
            child: Column(
              children: [
                AdmobBanner(
                    adUnitId: AdMobServices.bannerId,
                    adSize: AdmobBannerSize.BANNER),
                AdmobBanner(
                    adUnitId: AdMobServices.bannerId,
                    adSize: AdmobBannerSize.LARGE_BANNER),
                Html(
                  data: widget.post.content,
                  onLinkTap: (url) async {
                    if (await canLaunch(url)) {
                      await launch(url);
                    } else {
                      throw 'Could not launch $url';
                    }
                  },
                  padding: EdgeInsets.all(8.0),
                  linkStyle: const TextStyle(
                    color: Colors.blueAccent,
                    decorationColor: Colors.blueAccent,
                    decoration: TextDecoration.underline,
                  ),
                ),
                AdmobBanner(
                    adUnitId: AdMobServices.bannerId,
                    adSize: AdmobBannerSize.LARGE_BANNER),
                SizedBox(
                  height: 20,
                ),
                Consumer<UserProvider>(
                  builder: (context, userData, child) {
                    return FlatButton(
                      shape: RoundedRectangleBorder(
                          side: BorderSide(
                              color: Colors.grey[600],
                              width: 3,
                              style: BorderStyle.solid),
                          borderRadius: BorderRadius.circular(10)),
                      color: change && !_clicked
                          ? Color(0xFF008B8B)
                          : Colors.grey[600],
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            'Collect',
                            style: TextStyle(
                                shadows: [
                                  BoxShadow(
                                    color: Colors.black,
                                    offset: Offset(0, 5),
                                    blurRadius: 10.0,
                                  )
                                ],
                                // color: Colors.grey[400],
                                fontWeight: FontWeight.bold,
                                fontSize: 22.0),
                          ),
                          Container(
                            height: 60,
                            width: 300,
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text(
                                  '+10 ',
                                  style: TextStyle(
                                      shadows: [
                                        BoxShadow(
                                          color: Colors.black,
                                          offset: Offset(0, 5),
                                          blurRadius: 10.0,
                                        )
                                      ],
                                      // color: Colors.grey[400],
                                      fontWeight: FontWeight.bold,
                                      fontSize: 22.0),
                                ),
                                Container(
                                  height: 60,
                                  width: 60,
                                  child: Shimmer.fromColors(
                                    baseColor: logoGreen,
                                    highlightColor: Colors.grey[300],
                                    direction: ShimmerDirection.ltr,
                                    child: Image.asset(
                                      'assets/logoTransparent.png',
                                    ),
                                  ),
                                ),
                                Text(
                                  ' points',
                                  style: TextStyle(
                                      shadows: [
                                        BoxShadow(
                                          color: Colors.black,
                                          offset: Offset(0, 5),
                                          blurRadius: 10.0,
                                        )
                                      ],
                                      // color: Colors.grey[400],
                                      fontWeight: FontWeight.bold,
                                      fontSize: 22.0),
                                )
                              ],
                            ),
                          )
                        ],
                      ),
                      onPressed: change && !_clicked
                          ? () {
                              if (mounted) {
                                setState(() {
                                  _clicked = true;
                                });
                              }
                              print('redeem');
                              print("here redeem");
                              Fluttertoast.showToast(
                                msg: "+10 points",
                                toastLength: Toast.LENGTH_LONG,
                                gravity: ToastGravity.CENTER,
                              );
                              UserProvider _userProvider =
                                  Provider.of<UserProvider>(context,
                                      listen: false);
                              _userProvider.updatePoint(10);
                            }
                          : () {},
                    );
                  },
                ),
                SizedBox(
                  height: 20,
                ),
                AdmobBanner(
                    adUnitId: AdMobServices.bannerId,
                    adSize: AdmobBannerSize.BANNER),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
// import 'dart:async';

// import 'package:admob_flutter/admob_flutter.dart';
// // import 'package:flutter_native_admob/flutter_native_admob.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter_html/flutter_html.dart';
// // import 'package:google_signin_example/admob.dart';
// import 'package:google_signin_example/database.dart';
// // import 'package:google_signin_example/widget/helpers.dart';
// // import 'package:google_signin_example/widget/post_card.dart';
// import 'package:url_launcher/url_launcher.dart';

// import '../model/post_entity.dart';

// class PostDetails extends StatefulWidget {
//   final PostEntity post;
//   PostDetails(
//     this.post,
//   );

//   @override
//   _PostDetailsState createState() => _PostDetailsState();
// }

// class _PostDetailsState extends State<PostDetails> {
//   FirebasesData fData = FirebasesData.instance;
//   AdmobReward rewardAd;
//   // final _nativeAdmob = NativeAdmob();

//   bool stop = false;
//   void _showToast(BuildContext context) {
//     final scaffold = Scaffold.of(context);
//     scaffold.showSnackBar(
//       SnackBar(
//         content: const Text('+10 points added'),
//         // action: SnackBarAction(
//         //     label: 'UNDO', onPressed: scaffold.hideCurrentSnackBar),
//       ),
//     );
//   }

//   @override
//   void initState() {
//     Future.delayed(Duration(seconds: 1), () {
//       setState(() {
//         stop = true;
//       });
//     });

//     super.initState();
//   }

//   void handleEvent(
//       AdmobAdEvent event, Map<String, dynamic> args, String adType) {
//     switch (event) {
//       case AdmobAdEvent.loaded:
//         print('New Admob $adType Ad loaded!');
//         break;
//       case AdmobAdEvent.opened:
//         print('Admob $adType Ad opened!');
//         break;
//       case AdmobAdEvent.closed:
//         print('Admob $adType Ad closed!');
//         break;
//       case AdmobAdEvent.failedToLoad:
//         print('Admob $adType failed to load. :(');
//         break;
//       case AdmobAdEvent.rewarded:
//         // showDialog(
//         //   context: scaffoldState.currentContext!,
//         //   builder: (BuildContext context) {
//         //     return WillPopScope(
//         //       onWillPop: () async {
//         //         ScaffoldMessenger.of(context).hideCurrentSnackBar();
//         //         return true;
//         //       },
//         //       child: AlertDialog(
//         //         content: Column(
//         //           mainAxisSize: MainAxisSize.min,
//         //           children: <Widget>[
//         //             Text('Reward callback fired. Thanks Andrew!'),
//         //             Text('Type: ${args!['type']}'),
//         //             Text('Amount: ${args['amount']}'),
//         //           ],
//         //         ),
//         //       ),
//         //     );
//         //   },
//         // );
//         break;
//       default:
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     print(widget.post.content);
//     // //post);
//     // post.isDetailCard = true;
//     return Scaffold(
//         body: stop
//             ? SafeArea(
//                 child: SingleChildScrollView(
//                   child: Column(
//                     children: [
//                       // NativeAdmobBannerView(
//                       //   adUnitID: 'ca-app-pub-5029109567391688/9428373004',
//                       //   showMedia: true,
//                       //   style: BannerStyle.dark,
//                       //   contentPadding: EdgeInsets.fromLTRB(9.0, 8.0, 8.0, 8.0),
//                       // ),
//                       // Container(
//                       //   margin: EdgeInsets.only(bottom: 20.0),
//                       //   child: AdmobBanner(
//                       //     adUnitId: AdMobServices.bannerId,
//                       //     adSize: AdmobBannerSize.BANNER,
//                       //     listener: (AdmobAdEvent event, Map<String, dynamic> args) {
//                       //       handleEvent(event, args, 'Banner');
//                       //     },
//                       //     onBannerCreated: (AdmobBannerController controller) {
//                       //       // Dispose is called automatically for you when Flutter removes the banner from the widget tree.
//                       //       // Normally you don't need to worry about disposing this yourself, it's handled.
//                       //       // If you need direct access to dispose, this is your guy!
//                       //       // controller.dispose();
//                       //     },
//                       //   ),
//                       // ),
//                       Html(
//                         data: widget.post.content,
//                         onLinkTap: (url) async {
//                           if (await canLaunch(url)) {
//                             await launch(url);
//                           } else {
//                             throw 'Could not launch $url';
//                           }
//                         },
//                         padding: EdgeInsets.all(8.0),
//                         linkStyle: const TextStyle(
//                           color: Colors.blueAccent,
//                           decorationColor: Colors.blueAccent,
//                           decoration: TextDecoration.underline,
//                         ),
//                       ),
//                       // FlatButton(
//                       //   color: Color(0xFF0d1117),
//                       //   child: Text(
//                       //     'click to redeem points',
//                       //     style: TextStyle(color: Colors.white),
//                       //   ),
//                       //   onPressed: () {
//                       //     print('redeem');
//                       //     int points = this.points + 50;
//                       //     Map<String, dynamic> data = {
//                       //       'points': points,
//                       //     };
//                       //     fData.userCollection
//                       //         .doc(fData.usersname.uid)
//                       //         .set(data, SetOptions(merge: true))
//                       //         .then((e) {
//                       //       print('redeemed');
//                       //       _showToast(context);
//                       //     });
//                       //   },
//                       // )
//                     ],
//                   ),
//                 ),
//               )
//             : Center(
//                 child: CircleAvatar(
//                     radius: 20,
//                     backgroundColor: Colors.white,
//                     child: CircularProgressIndicator()),
//               )
//         // resizeToAvoidBottomPadding: false,
//         // body: NestedScrollView(
//         //   headerSliverBuilder: (BuildContext context, bool innerBoxIsScrolled) {
//         //     Size size = MediaQuery.of(context).size;
//         //     return <Widget>[
//         //       SliverAppBar(
//         //         iconTheme: IconThemeData(color: Colors.white),
//         //         floating: true,
//         //         expandedHeight: 100.0,
//         //         flexibleSpace: FlexibleSpaceBar(
//         //           background: Stack(
//         //             children: <Widget>[
//         //               post.image.isNotEmpty
//         //                   ? CachedImage(
//         //                       post.image,
//         //                       width: size.width,
//         //                       height: size.height,
//         //                     )
//         //                   : Container(
//         //                       color: Colors.white,
//         //                       child: Center(child: Text('no image'))),
//         //               // Positioned(
//         //               //   child: Container(
//         //               //     height: 200,
//         //               //     decoration: BoxDecoration(
//         //               //       gradient: LinearGradient(
//         //               //           begin: Alignment.bottomCenter,
//         //               //           end: Alignment.topCenter,
//         //               //           colors: [Colors.amber, Colors.green]),
//         //               //     ),
//         //               //   ),
//         //               // ),
//         //               Positioned(
//         //                 bottom: 0,
//         //                 child: Author(post: post),
//         //               ),
//         //               Positioned(
//         //                 bottom: 35.0,
//         //                 child: Container(
//         //                     width: size.width,
//         //                     child: Column(
//         //                       children: <Widget>[
//         //                         Padding(
//         //                           padding: const EdgeInsets.all(8.0),
//         //                           child: Text(
//         //                             post.title,
//         //                             textAlign: TextAlign.left,
//                             style: TextStyle(
//                                 shadows: [
//                                   BoxShadow(
//                                     color: Colors.black,
//                                     offset: Offset(0, 5),
//                                     blurRadius: 10.0,
//                                   )
//                                 ],
//                                 color: Colors.white,
//                                 fontWeight: FontWeight.bold,
//                                 fontSize: 18.0),
//         //                           ),
//         //                         ),
//         //                       ],
//         //                     )),
//         //               ),
//         //               Positioned(
//         //                 bottom: 0,
//         //                 right: 0,
//         //                 child: CategoryPill(post: post),
//         //               ),
//         //             ],
//         //           ),
//         //         ),
//         //       )
//         //     ];
//         //   },
//         //   body: Scaffold(
//         //     body: SingleChildScrollView(
//         //       child: Column(
//         //         children: [
//         //           Html(
//         //             data: post.content,
//         //             onLinkTap: (url) async {
//         //               if (await canLaunch(url)) {
//         //                 await launch(url);
//         //               } else {
//         //                 throw 'Could not launch $url';
//         //               }
//         //             },
//         //             padding: EdgeInsets.all(8.0),
//         //             linkStyle: const TextStyle(
//         //               color: Colors.blueAccent,
//         //               decorationColor: Colors.blueAccent,
//         //               decoration: TextDecoration.underline,
//         //             ),
//         //           ),
//         //           // FlatButton(
//         //           //   color: Color(0xFF0d1117),
//         //           //   child: Text(
//         //           //     'click to redeem points',
//         //           //     style: TextStyle(color: Colors.white),
//         //           //   ),
//         //           //   onPressed: () {
//         //           //     print('redeem');
//         //           //     int points = this.points + 50;
//         //           //     Map<String, dynamic> data = {
//         //           //       'points': points,
//         //           //     };
//         //           //     fData.userCollection
//         //           //         .doc(fData.usersname.uid)
//         //           //         .set(data, SetOptions(merge: true))
//         //           //         .then((e) {
//         //           //       print('redeemed');
//         //           //       _showToast(context);
//         //           //     });
//         //           //   },
//         //           // )
//         //         ],
//         //       ),
//         //     ),
//         //   ),
//         // ),
//         );
//   }

//   @override
//   void dispose() {
//     // interstitialAd.dispose();
//     super.dispose();
//   }
// }
