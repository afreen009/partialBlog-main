import 'package:firebase_admob/firebase_admob.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_signin_example/firebaseservice.dart';
import 'package:google_signin_example/model/users.dart';
import 'package:google_signin_example/page/post_details.dart';
import 'package:google_signin_example/page/sharing_post.dart';
import 'package:google_signin_example/screens/video_screen.dart';
import 'package:google_signin_example/services/firebase_service.dart';
import 'package:google_signin_example/widget/helpers.dart';
import 'package:share/share.dart';

import '../model/post_entity.dart';

class HomePost extends StatefulWidget {
  String option;
  PostEntity post;
  bool isFeaturedList;
  List videoList;
  static const List<String> choices = <String>[
    "share to...",
  ];
  HomePost(this.post,
      {this.isFeaturedList = false, this.option, this.videoList});

  @override
  _HomePostState createState() => _HomePostState();
}

class _HomePostState extends State<HomePost> {
  SharingPost share;

  String _selectedChoices;
  Color logoGreen = Color(0xff25bcbb);
  final shareData = SharingPost();
  final FirebaseServices firebaseService = FirebaseServices.instance;
  void _select(String choice) {
    setState(() {
      _selectedChoices = choice;
    });
    // showSnackBar(choice);
  }

  sharePost(
    BuildContext context,
  ) {
    print(widget.post.link);
    final RenderBox box = context.findRenderObject();
    Share.share(widget.post.title + '\n' + widget.post.link,
        subject: widget.post.link,
        sharePositionOrigin: box.localToGlobal(Offset.zero) & box.size);
  }

  shareVideo(
    BuildContext context,
  ) {
    print(widget.videoList[4]);
    final RenderBox box = context.findRenderObject();
    Share.share(widget.videoList[4] + '\n' + widget.videoList[1],
        subject: widget.videoList[4],
        sharePositionOrigin: box.localToGlobal(Offset.zero) & box.size);
  }

  static const MobileAdTargetingInfo targetingInfo = MobileAdTargetingInfo(
    keywords: <String>['flutterio', 'beautiful apps'],
    contentUrl: 'https://flutter.io',
    childDirected: false,
    testDevices: <String>[], // Android emulators are considered test devices
  );
  void showSnackBar(String selection) {
    final snackBarContent = SnackBar(
      content: Text('Selected: $selection'),
      action: SnackBarAction(
        label: 'Undo',
        onPressed: () {
          // Some code to undo the change.
        },
      ),
    );
    // _scaffoldkey.currentState.showSnackBar(snackBarContent);
  }

  addBookMarks(BookMarks data) {
    print('inside add method');
    firebaseService.saveDataBookMark(data);
  }

  InterstitialAd myInterstitialAd = InterstitialAd(
    adUnitId: InterstitialAd.testAdUnitId,
    targetingInfo: targetingInfo,
    listener: (MobileAdEvent event) {
      print("InterstitialAd event is $event");
    },
  );
  @override
  Widget build(BuildContext context) {
    Color primaryColor = Color(0xff18203d);
    Color secondaryColor = Color(0xff232c51);
    // print(post);
    Size size = MediaQuery.of(context).size;
    double width = widget.isFeaturedList ? size.width * 0.4 : size.width;
    double fwidth = widget.isFeaturedList ? size.width * 0.5 : size.width;
    return Padding(
      padding: EdgeInsets.all(widget.isFeaturedList ? 10.0 : 5.0),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(widget.isFeaturedList ? 10.0 : 0.0),
        child: Material(
          elevation: 14.0,
          borderRadius: BorderRadius.circular(10.0),
          shadowColor: Theme.of(context).primaryColor.withOpacity(.5),
          child: Row(
            children: [
              GestureDetector(
                onTap: () {
                  myInterstitialAd
                    ..load()
                    ..show(
                      anchorType: AnchorType.bottom,
                      anchorOffset: 0.0,
                      horizontalCenterOffset: 0.0,
                    );
                  if (widget.isFeaturedList)
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => PostDetails(widget.post)));
                },
                child: Container(
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(15),
                      gradient:
                          LinearGradient(begin: Alignment.bottomRight, colors: [
                        Colors.black.withOpacity(.9),
                        Colors.black.withOpacity(.1),
                      ])),
                  height: 200.0,
                  width: widget.option == 'top' ? width : fwidth,
                  child: Stack(
                    children: <Widget>[
                      widget.post.image.isNotEmpty
                          ? CachedImage(
                              widget.post.image,
                              width: widget.option == 'top' ? width : fwidth,
                              height: size.height,
                            )
                          : Center(
                              child: Container(
                                  height: 100,
                                  width: 100,
                                  child: Text('no image')),
                            ),
                      widget.option == 'top'
                          ? Container()
                          : Positioned(
                              left: 10,
                              top: 10,
                              child: Container(
                                height: 25,
                                width: 25,
                                decoration: BoxDecoration(
                                    color: Colors.grey[200],
                                    borderRadius: BorderRadius.circular(10)),
                                child: PopupMenuButton(
                                  color: Colors.white,
                                  onSelected: (_select) => sharePost(context),
                                  padding: EdgeInsets.zero,
                                  // initialValue: choices[_selection],
                                  itemBuilder: (BuildContext context) {
                                    return HomePost.choices
                                        .map((String choice) {
                                      return PopupMenuItem<String>(
                                        value: choice,
                                        child: Text(choice),
                                      );
                                    }).toList();
                                  },
                                ),
                              )),
                      widget.option == 'top'
                          ? Container()
                          : Positioned(
                              right: 0,
                              child: CategoryPill(post: widget.post),
                            ),
                      widget.option == 'top'
                          ? Container()
                          : Positioned(
                              bottom: 0,
                              right: 0,
                              child: GestureDetector(
                                onTap: () {
                                  BookMarks bookMarks = BookMarks(
                                      postsId: widget.post.id.toString(),
                                      categoryId: widget.post.category);
                                  Fluttertoast.showToast(
                                    msg: "Saved",
                                    toastLength: Toast.LENGTH_SHORT,
                                    gravity: ToastGravity.CENTER,
                                  );
                                  addBookMarks(bookMarks);
                                },
                                child: Container(
                                  padding: EdgeInsets.symmetric(
                                    horizontal: 10,
                                  ),
                                  decoration: BoxDecoration(
                                      color: Colors.amber[200],
                                      borderRadius: BorderRadius.only(
                                          topLeft: Radius.circular(10))),
                                  height: 25,
                                  width: 50,
                                  child: Center(
                                    child: Icon(
                                      FontAwesomeIcons.bookmark,
                                      color: Colors.grey[600],
                                      size: 18,
                                    ),
                                  ),
                                ),
                              ),
                            )
                      // Positioned(
                      //   child: Hero(tag: '${post.id}_author', child: Author(post: post)),
                      // )
                    ],
                  ),
                ),
              ),
              widget.option != 'top' && widget.videoList != []
                  ? SizedBox(
                      width: 20,
                    )
                  : Container(),
              widget.option != 'top' && widget.videoList != []
                  ? GestureDetector(
                      onTap: () {
                        if (widget.isFeaturedList)
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (_) =>
                                  VideoScreen(id: widget.videoList[0]),
                            ),
                          );
                      },
                      child: Container(
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(15),
                            gradient: LinearGradient(
                                begin: Alignment.bottomRight,
                                colors: [
                                  Colors.black.withOpacity(.9),
                                  Colors.black.withOpacity(.1),
                                ])),
                        height: 200.0,
                        width: fwidth,
                        child: Stack(
                          children: <Widget>[
                            CachedImage(
                              widget.videoList[3],
                              width: fwidth,
                              height: size.height,
                            ),
                            Positioned(
                                top: 30,
                                bottom: 30,
                                left: 5,
                                right: 5,
                                child: CircleAvatar(
                                    backgroundColor: Colors.white70,
                                    foregroundColor: Colors.red,
                                    child: Center(
                                        child: Icon(FontAwesomeIcons.play)))),
                            widget.option != 'top'
                                ? Container()
                                : Positioned(
                                    left: 10,
                                    top: 10,
                                    child: Container(
                                      height: 25,
                                      width: 25,
                                      decoration: BoxDecoration(
                                          color: Colors.grey[200],
                                          borderRadius:
                                              BorderRadius.circular(10)),
                                      child: PopupMenuButton(
                                        color: Colors.white,
                                        onSelected: (_select) =>
                                            shareVideo(context),
                                        padding: EdgeInsets.zero,
                                        // initialValue: choices[_selection],
                                        itemBuilder: (BuildContext context) {
                                          return HomePost.choices
                                              .map((String choice) {
                                            return PopupMenuItem<String>(
                                              value: choice,
                                              child: Text(choice),
                                            );
                                          }).toList();
                                        },
                                      ),
                                    )),
                            Positioned(
                                left: 10,
                                top: 10,
                                child: Container(
                                  height: 25,
                                  width: 25,
                                  decoration: BoxDecoration(
                                      color: Colors.grey[200],
                                      borderRadius: BorderRadius.circular(10)),
                                  child: PopupMenuButton(
                                    color: Colors.white,
                                    onSelected: (_select) => sharePost(context),
                                    padding: EdgeInsets.zero,
                                    // initialValue: choices[_selection],
                                    itemBuilder: (BuildContext context) {
                                      return HomePost.choices
                                          .map((String choice) {
                                        return PopupMenuItem<String>(
                                          value: choice,
                                          child: Text(choice),
                                        );
                                      }).toList();
                                    },
                                  ),
                                )),
                            // Positioned(
                            //   child: Hero(tag: '${post.id}_author', child: Author(post: post)),
                            // )
                          ],
                        ),
                      ),
                    )
                  : Container(),
            ],
          ),
        ),
      ),
    );
  }
}

class CategoryPill extends StatelessWidget {
  const CategoryPill({
    Key key,
    @required this.post,
  }) : super(key: key);

  final PostEntity post;

  @override
  Widget build(BuildContext context) {
    Color primaryColor = Color(0xff18203d);
    return Padding(
      padding: const EdgeInsets.only(right: 5.0),
      child: Opacity(
        opacity: 0.8,
        child: MaterialButton(
          height: 26.0,
          minWidth: 40,
          onPressed: () {},
          color: primaryColor,
          child: Text(post.category.toUpperCase(),
              style: TextStyle(
                color: Colors.white,
                fontSize: 12.0,
              )),
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(20.0)),
        ),
      ),
    );
  }
}

class Author extends StatelessWidget {
  const Author({
    Key key,
    @required this.post,
  }) : super(key: key);

  final PostEntity post;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Row(
        children: <Widget>[
          ClipRRect(
            borderRadius: BorderRadius.circular(6.0),
            child: Image.network(
              post.extra.author[0].avatar,
              height: 26.0,
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(left: 8.0),
            child: Text(
              post.extra.author[0].name,
              style: TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
                fontSize: 14.0,
                shadows: <Shadow>[
                  Shadow(
                    offset: Offset(1.0, 1.0),
                    blurRadius: 5.0,
                    color: Colors.black,
                  ),
                  Shadow(
                    offset: Offset(1.0, 1.0),
                    blurRadius: 8.0,
                    color: Colors.black,
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
