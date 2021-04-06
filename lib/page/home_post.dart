import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_signin_example/database/databasehelep.dart';
import 'package:google_signin_example/database/db_model.dart';
import 'package:google_signin_example/firebaseservice.dart';
import 'package:google_signin_example/model/users.dart';
import 'package:google_signin_example/page/post_details.dart';
import 'package:google_signin_example/page/sharing_post.dart';
import 'package:google_signin_example/screens/video_screen.dart';
import 'package:google_signin_example/widget/helpers.dart';
import 'package:intl/intl.dart';
import 'package:share/share.dart';
// import '../database/database_sqlite.dart';
import '../model/post_entity.dart';

class HomePost extends StatefulWidget {
  final String option;
  final PostEntity post;
  final bool isFeaturedList;
  final List videoList;
  // static const List<String> choices = <String>[
  //   "share to...",
  // ];
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
  // final FirebaseServices firebaseService = FirebaseServices.instance;
  List<DbModel> db;
  @override
  void initState() {
    getStatus();
    // TODO: implement initState
    super.initState();
  }

  void _select(String choice) {
    setState(() {
      _selectedChoices = choice;
    });
    // showSnackBar(choice);
  }

  getStatus() async {
    db = await PersonDatabaseProvider.db.getAllPersons();
    // print(db);
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

  addBookMarks(BookMarks data) async {
    print('inside add method');
    // await firebaseService.saveDataBookMark(data);
    Fluttertoast.showToast(
      msg: "Saved",
      toastLength: Toast.LENGTH_SHORT,
      gravity: ToastGravity.CENTER,
    );
  }

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
                onTap: () async {
                  DateTime date = DateTime.now();
                  var newDt = DateFormat.yMMMEd().format(date);

                  //storing data locally - SQFLITE
                  await PersonDatabaseProvider.db.addPersonToDatabase(DbModel(
                    name: widget.post.title,
                    date: widget.post.date,
                  ));

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
                                  color: Colors.white,
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
                                    onSelected: (value) {
                                      print(value);
                                      if (value == 'share') {
                                        setState(() {
                                          sharePost(context);
                                        });
                                      } else {
                                        BookMarks bookMarks = BookMarks(
                                            postsId: widget.post.id.toString(),
                                            categoryId: widget.post.category);
                                        addBookMarks(bookMarks);
                                      }
                                    },
                                    padding: EdgeInsets.zero,
                                    // initialValue: choices[_selection],
                                    itemBuilder: (_) => <PopupMenuItem<String>>[
                                      new PopupMenuItem<String>(
                                          child: new Text('Share'),
                                          value: 'share'),
                                      new PopupMenuItem<String>(
                                          child: new Text('Save'),
                                          value: 'save'),
                                    ],
                                    // itemBuilder: (BuildContext context) {
                                    //   return PostCard.choices.map((String choice) {
                                    //     return PopupMenuItem<String>(
                                    //       value: choice,
                                    //       child: Text(choice),
                                    //     );
                                    //   }).toList();
                                    // },
                                  ))),
                      widget.option == 'top'
                          ? Positioned(
                              bottom: 0,
                              top: 90,
                              child: Container(
                                  width: 150,
                                  color: primaryColor,
                                  child: Padding(
                                    padding: const EdgeInsets.only(
                                        left: 8.0, right: 8.0, top: 8.0),
                                    child: Text(
                                      widget.post.title,
                                      textAlign: TextAlign.left,
                                      maxLines: 2,
                                      overflow: TextOverflow.ellipsis,
                                      style: TextStyle(
                                          color: Colors.white,
                                          fontSize: 12,
                                          fontWeight: FontWeight.bold),
                                    ),
                                  )),
                            )
                          : Container,
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

                                  addBookMarks(bookMarks);
                                },
                                child: Container(
                                  padding: EdgeInsets.symmetric(
                                    horizontal: 10,
                                  ),
                                  decoration: BoxDecoration(
                                      color: Colors.amber[200],
                                      borderRadius: BorderRadius.only(
                                          bottomRight: Radius.circular(10),
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
                                          onSelected: (value) {
                                            print(value);
                                            if (value == 'share') {
                                              setState(() {
                                                sharePost(context);
                                              });
                                            } else {
                                              BookMarks bookMarks = BookMarks(
                                                  postsId:
                                                      widget.post.id.toString(),
                                                  categoryId:
                                                      widget.post.category);
                                              addBookMarks(bookMarks);
                                            }
                                          },
                                          padding: EdgeInsets.zero,
                                          // initialValue: choices[_selection],
                                          itemBuilder: (_) =>
                                              <PopupMenuItem<String>>[
                                            new PopupMenuItem<String>(
                                                child: new Text('Share'),
                                                value: 'share'),
                                            new PopupMenuItem<String>(
                                                child: new Text('Save'),
                                                value: 'save'),
                                          ],
                                          // itemBuilder: (BuildContext context) {
                                          //   return PostCard.choices.map((String choice) {
                                          //     return PopupMenuItem<String>(
                                          //       value: choice,
                                          //       child: Text(choice),
                                          //     );
                                          //   }).toList();
                                          // },
                                        ))),
                            Positioned(
                              bottom: 0,
                              child: Container(
                                decoration: BoxDecoration(
                                    gradient: LinearGradient(
                                        begin: Alignment.bottomCenter,
                                        end: Alignment.topCenter,
                                        colors: [
                                      secondaryColor,
                                      primaryColor
                                    ])),
                                width: width,
                                // child: Padding(
                                //   padding: const EdgeInsets.only(
                                //       top: 15.0,
                                //       bottom: 5.0,
                                //       left: 5.0,
                                //       right: 5.0),
                                //   child: Column(
                                //     children: <Widget>[
                                //       Padding(
                                //         padding: const EdgeInsets.all(3.0),
                                //         child: Text(
                                //           widget.post.title,
                                //           textAlign: TextAlign.left,
                                //           style: TextStyle(
                                //               color: Colors.white,
                                //               fontWeight: FontWeight.bold,
                                //               fontSize: 18.0),
                                //         ),
                                //       ),
                                //     ],
                                //   ),
                                // ),
                              ),
                            ),
                            Positioned(
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
                                      onSelected: (value) {
                                        print(value);
                                        if (value == 'share') {
                                          setState(() {
                                            sharePost(context);
                                          });
                                        } else {
                                          BookMarks bookMarks = BookMarks(
                                              postsId:
                                                  widget.post.id.toString(),
                                              categoryId: widget.post.category);
                                          addBookMarks(bookMarks);
                                        }
                                      },
                                      padding: EdgeInsets.zero,
                                      // initialValue: choices[_selection],
                                      itemBuilder: (_) =>
                                          <PopupMenuItem<String>>[
                                        new PopupMenuItem<String>(
                                            child: new Text('Share'),
                                            value: 'share'),
                                        new PopupMenuItem<String>(
                                            child: new Text('Save'),
                                            value: 'save'),
                                      ],
                                      // itemBuilder: (BuildContext context) {
                                      //   return PostCard.choices.map((String choice) {
                                      //     return PopupMenuItem<String>(
                                      //       value: choice,
                                      //       child: Text(choice),
                                      //     );
                                      //   }).toList();
                                      // },
                                    ))),
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
