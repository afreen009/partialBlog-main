// import 'package:admob_flutter/admob_flutter.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:google_signin_example/database/bookmark_database.dart';
import 'package:google_signin_example/database/databasehelep.dart';
import 'package:google_signin_example/database/db_model.dart';
import 'package:google_signin_example/page/post_details.dart';
import 'package:intl/intl.dart';
import 'package:share/share.dart';

import '../database.dart';
import '../model/post_entity.dart';
import 'helpers.dart';
// import '../widgets/helpers.dart';

class PostListItem extends StatefulWidget {
  final PostEntity post;
  final bool read;
  PostListItem(this.post, {this.read});

  @override
  _PostListItemState createState() => _PostListItemState();
}

class _PostListItemState extends State<PostListItem> {
  // SharingPost share;
  Color logoGreen = Color(0xff25bcbb);
  // final FirebaseServices firebaseService = FirebaseServices.instance;
  FirebasesData fData = FirebasesData.instance;
  // AdmobInterstitial interstitial;
  String _selectedChoices;
  // AdmobReward reward;
  GlobalKey<ScaffoldState> scaffoldState = GlobalKey();

  @override
  void initState() {
    // getStatus();
    super.initState();

    // interstitial = AdmobInterstitial(
    //   adUnitId: AdMobServices.interstitialId,
    //   listener: (AdmobAdEvent event, Map<String, dynamic> args) {
    //     if (event == AdmobAdEvent.closed) interstitial.load();
    //     handleEvent(event, args, 'Interstitial', context);
    //   },
    // );
    //   reward = AdmobReward(
    //       adUnitId: AdMobServices.rewardId,
    //       listener: (event, args) {
    //         if (event == AdmobAdEvent.rewarded) {
    //           print('rewarded');
    //           handleEvent(event, args, 'Reward', context);
    //           // FirebasesData().updateUserPresence(points:);
    //         } else if (event == AdmobAdEvent.closed) {
    //           print('reward closed');
    //         }
    //       });
    //   reward.load();
  }

  // void handleEvent(AdmobAdEvent event, Map<String, dynamic> args, String adType,
  //     BuildContext context) async {
  //   switch (event) {
  //     case AdmobAdEvent.loaded:
  //       showSnackBar('New Admob $adType Ad loaded!');
  //       break;
  //     case AdmobAdEvent.opened:
  //       showSnackBar('Admob $adType Ad opened!');
  //       break;
  //     case AdmobAdEvent.closed:
  //       showSnackBar('Admob $adType Ad closed!');
  //       break;
  //     case AdmobAdEvent.failedToLoad:
  //       showSnackBar('Admob $adType failed to load. :(');
  //       break;
  //     case AdmobAdEvent.rewarded:
  //       {
  //         UserProvider _userProvider =
  //             Provider.of<UserProvider>(context, listen: false);
  //         _userProvider.updatePoint(50);
  //         break;
  //       }
  //       // showDialog(
  //       //   context: scaffoldState.currentContext,
  //       //   builder: (BuildContext context) {
  //       //     return WillPopScope(
  //       //       child: AlertDialog(
  //       //         content: Column(
  //       //           mainAxisSize: MainAxisSize.min,
  //       //           children: <Widget>[
  //       //             Text('Reward callback fired. Thanks Andrew!'),
  //       //             Text('Type: ${args['type']}'),
  //       //             Text('Amount: ${args['amount']}'),
  //       //           ],
  //       //         ),
  //       //       ),
  //       //       onWillPop: () async {
  //       //         scaffoldState.currentState.hideCurrentSnackBar();
  //       //         return true;
  //       //       },
  //       //     );
  //       //   },
  //       // );
  //       break;
  //     default:
  //   }
  // }

  void showSnackBar(String content) {
    scaffoldState.currentState.showSnackBar(
      SnackBar(
        content: Text(content),
        duration: Duration(milliseconds: 1500),
      ),
    );
  }

  void _select(String choice) {
    setState(() {
      _selectedChoices = choice;
    });
    // showSnackBar(choice);
  }

  // Future<List<DbModel>> getStatus() async {
  //   db = await PersonDatabaseProvider.db.getAllPersons();
  //   // print("db:$db");
  //   finalDblist.clear();
  //   for (int i = 0; i < db.length; i++) {
  //     if (finalDblist.contains(db[i].name))
  //       continue;
  //     else {
  //       finalDblist.add(db[i].name);
  //     }
  //   }
  //   // print("final$finalDblist");
  //   return db;
  // }

  sharePost(
    BuildContext context,
  ) {
    //widget.post.link);
    final RenderBox box = context.findRenderObject();
    Share.share(widget.post.title + '\n' + widget.post.link,
        subject: widget.post.link,
        sharePositionOrigin: box.localToGlobal(Offset.zero) & box.size);
  }

  Color primaryColor = Color(0xff18203d);
  Color secondaryColor = Color(0xff232c51);

  @override
  Widget build(BuildContext context) {
    // //post.image);

    // reward = AdmobReward(
    //     adUnitId: AdMobServices.rewardId,
    //     listener: (event, args) {
    //       if (event == AdmobAdEvent.rewarded) {
    //         print('rewarded');
    //         handleEvent(event, args, 'Reward');
    //         // FirebasesData().updateUserPresence(points:);
    //       }
    //     });
    String imageUrl = widget.post.image;
    String title = widget.post.title;
    bool check = title.contains('&#8217;');
    bool checkHyphen = title.contains('&#8211;');
    String newString = '';

    if (check) {
      final find = '&#8217;';
      final replaceWith = "'";
      setState(() {
        newString = widget.post.title.replaceAll(find, replaceWith);
      });
    } else if (checkHyphen) {
      final find = '&#8211;';
      final replaceWith = "-";
      setState(() {
        newString = widget.post.title.replaceAll(find, replaceWith);
      });
    } else {
      setState(() {
        newString = widget.post.title;
      });
    }
    return Padding(
      padding: const EdgeInsets.symmetric(
        horizontal: 5.0,
      ),
      child: GestureDetector(
        onTap: () async {
          DateTime date = DateTime.now();
          var newDt = DateFormat.yMMMEd().format(date);

          //storing data locally - SQFLITE
          await PersonDatabaseProvider.db.addPersonToDatabase(DbModel(
            name: widget.post.title,
            date: widget.post.date,
          ));

          Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) => PostDetails(
                        widget.post,
                      )));
        },
        child: Container(
          // decoration: BoxDecoration(
          //     // borderRadius: BorderRadius.circular(10),
          //     // color: Colors.blueGrey[100],
          //     border: Border(
          //   bottom: BorderSide(
          //     color: Colors.grey[300],
          //     width: 0.5,
          //   ),
          // ),),
          padding: EdgeInsets.all(5),
          child: Column(
            children: [
              Row(
                children: <Widget>[
                  Padding(
                    padding: const EdgeInsets.only(right: 14.0),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(8),
                      child: imageUrl.isNotEmpty
                          ? CachedImage(
                              widget.post.image,
                              width: 140,
                              height: 85,
                            )
                          : Container(
                              color: Colors.white,
                              width: 150,
                              height: 85,
                              child: Center(child: Text('no image'))),
                    ),
                  ),
                  // db.contains(widget.pos.title) ? Text("Read") : Text(''),
                  Flexible(
                    child: SizedBox(
                      height: 85.0,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          Row(
                            children: [
                              Expanded(
                                child: Text(
                                  newString,
                                  textAlign: TextAlign.left,
                                  maxLines: 2,
                                  overflow: TextOverflow.ellipsis,
                                  style: TextStyle(
                                      // color: Colors.black,
                                      fontSize: 14,
                                      // shadows: [
                                      //   BoxShadow(
                                      //     color: Colors.grey[300],
                                      //     offset: Offset(0, 5),
                                      //     blurRadius: 10.0,
                                      //   )
                                      // ],
                                      fontWeight: FontWeight
                                          .bold), //TextStyle(color: Colors.black, fontWeight: FontWeight.bold, fontSize: 18.0, fontFamily: 'Roboto'),
                                ),
                              ),
                              // SizedBox(),
                              widget.read
                                  ? Text('Read',
                                      style: TextStyle(
                                          color: Colors.white,
                                          fontSize: 12,
                                          shadows: [
                                            BoxShadow(
                                              color: Colors.black87,
                                              offset: Offset(0, 5),
                                              blurRadius: 10.0,
                                            )
                                          ],
                                          fontWeight: FontWeight.bold))
                                  : Text('')
                            ],
                          ),
                          Row(
                            children: [
                              SizedBox(
                                width: 5,
                              ),
                              Flexible(
                                child: Text(widget.post.category,
                                    textAlign: TextAlign.start,
                                    maxLines: 3,
                                    overflow: TextOverflow.ellipsis,
                                    style: TextStyle(
                                        color: Colors.grey,
                                        fontSize: 12,
                                        shadows: [
                                          BoxShadow(
                                            color: Colors.black12,
                                            offset: Offset(0, 5),
                                            blurRadius: 10.0,
                                          )
                                        ],
                                        fontWeight: FontWeight.bold)),
                              ),
                              Spacer(),
                              GestureDetector(
                                  onTap: () async {
                                    DateTime date = DateTime.now();
                                    var newDt =
                                        DateFormat.yMMMEd().format(date);
                                    //storing data locally - SQFLITE
                                    await BookMarkDatabase.bd
                                        .addPersonToDatabase(DbModel(
                                      name: widget.post.title,
                                      date: newDt,
                                    ));
                                    addBookMarks();
                                  },
                                  child: Container(
                                    height: 30,
                                    width: 30,
                                    decoration: BoxDecoration(
                                        shape: BoxShape.circle,
                                        border:
                                            Border.all(color: Colors.white60)),
                                    child: Center(
                                        child: Icon(
                                      Icons.bookmark_border_outlined,
                                      size: 16,
                                    )),
                                  )),
                              SizedBox(
                                width: 5,
                              ),
                              GestureDetector(
                                  onTap: () async {
                                    setState(() {
                                      sharePost(context);
                                    });
                                    //storing data locally - SQFLITE
                                    await PersonDatabaseProvider.db
                                        .addPersonToDatabase(DbModel(
                                      name: widget.post.title,
                                      date: widget.post.date,
                                    ));
                                  },
                                  child: Container(
                                    height: 30,
                                    width: 30,
                                    decoration: BoxDecoration(
                                        shape: BoxShape.circle,
                                        border:
                                            Border.all(color: Colors.white60)),
                                    child: Center(
                                        child: Icon(
                                      Icons.send,
                                      size: 16,
                                    )),
                                  )
                                  // child: CircleAvatar(
                                  //   radius: 12,
                                  //   backgroundColor: Colors.white,
                                  //   // child: Container(
                                  //   //     height: 16,
                                  //   //     child: Center(
                                  //   //         child: Image.asset('assets/share.png')))
                                  //   child: Icon(
                                  //     Icons.send,
                                  //     color: primaryColor,
                                  //     size: 16,
                                  //   ),
                                  // ),
                                  ),
                              // GestureDetector(
                              //   onTap: () {
                              //     BookMarks bookMarks = BookMarks(
                              //         postsId: widget.post.id.toString(),
                              //         categoryId: widget.post.title);
                              //     addBookMarks(bookMarks);
                              //   },
                              //   child: Icon(
                              //     Icons.bookmark_border_outlined,
                              //     size: 20,
                              //   ),
                              // ),
                            ],
                          ),
                          // Text(widget.post.category,
                          //     textAlign: TextAlign.end,
                          //     overflow: TextOverflow.ellipsis,
                          //     style: TextStyle(color: Colors.white38))
                        ],
                      ),
                    ),
                  )
                ],
              ),
              SizedBox(
                height: 15,
              )
            ],
          ),
        ),
      ),
    );
  }

  addBookMarks() async {
    //'inside add method');
    // await firebaseService.saveDataBookMark(data);
    Fluttertoast.showToast(
      msg: "Saved",
      toastLength: Toast.LENGTH_SHORT,
      gravity: ToastGravity.CENTER,
    );
  }

  @override
  void dispose() {
    // interstitial?.dispose();
    // reward?.dispose();
    super.dispose();
  }
}
