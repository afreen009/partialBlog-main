import 'dart:async';

// import 'package:admob_flutter/admob_flutter.dart';
import 'package:admob_flutter/admob_flutter.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_signin_example/admob.dart';
import 'package:google_signin_example/database/databasehelep.dart';
import 'package:google_signin_example/database/db_model.dart';
import 'package:google_signin_example/model/channel.dart';
import 'package:google_signin_example/model/post_entity.dart';
import 'package:google_signin_example/model/users.dart';
import 'package:google_signin_example/model/video.dart';
import 'package:google_signin_example/network/wp_api.dart';
import 'package:google_signin_example/screens/video_screen.dart';
import 'package:google_signin_example/services/api_services.dart';
import 'package:google_signin_example/widget/post_list_item.dart';
import 'package:share/share.dart';
import 'package:shimmer/shimmer.dart';

class HomeVideo extends StatefulWidget {
  final List<PostEntity> searchList;
  HomeVideo(this.searchList);
  @override
  _HomeVideoState createState() => _HomeVideoState();
}

class _HomeVideoState extends State<HomeVideo> {
  Channel _channel;
  bool _isLoading = false;
  Color primaryColor = Color(0xff18203d);
  Color secondaryColor = Color(0xff232c51);
  Color logoGreen = Color(0xff25bcbb);
  List<DbModel> db;
  List finalDblist = [];

  // final FirebaseServices firebaseService = FirebaseServices.instance;
  List<PostEntity> posts = List<PostEntity>();
  int page = 0;
  bool isLoading = false;
  GlobalKey<ScaffoldState> scaffoldState = GlobalKey();
  // AdmobBannerSize bannerSize;
  // AdmobInterstitial interstitial;
  AdmobBannerController controller;
  bool _loaded = false;
  @override
  void initState() {
    getStatus();
    getData();
    // bannerSize = AdmobBannerSize.BANNER;
    _initChannel();
    Timer.periodic(Duration(seconds: 5), (timer) {
      getStatus();
    });
    // interstitial = AdmobInterstitial(
    //   adUnitId: AdMobServices.interstitialId,
    //   listener: (AdmobAdEvent event, Map<String, dynamic> args) {
    //     if (event == AdmobAdEvent.closed) interstitial.load();
    //     handleEvent(event, args, 'Interstitial');
    //   },
    // );
    // interstitial.load();
    super.initState();
  }

  // Stream<String> _bids = (() async* {
  //   await PersonDatabaseProvider.db.getAllPersons();
  // })();
  Future<List<DbModel>> getStatus() async {
    db = await PersonDatabaseProvider.db.getAllPersons();
    // print("db:$db");
    // print('inside finaldb');
    finalDblist.clear();
    for (int i = 0; i < db.length; i++) {
      // print(db[i].name);
      if (finalDblist.contains(db[i].name))
        continue;
      else {
        finalDblist.add(db[i].name);
      }
    }
    // print("final$finalDblist");
    return db;
  }

  _initChannel() async {
    Channel channel = await APIService.instance
        .fetchChannel(channelId: 'UCKmwUXQLo6ny-GD2a0dOf8Q');

    if (mounted) {
      setState(() {
        _channel = channel;
      });
    }
  }

  void getData() {
    if (!isLoading) {
      setState(() {
        page++;
        isLoading = true;
      });

      WpApi.getPostsList(
              category: 0, page: page, baseurl: 'http://insuranceofearth.com/')
          .then((_posts) {
        setState(() {
          isLoading = false;
          posts.addAll(_posts);
        });
      }).then((w) {
        //"posts$posts");
      });
    }
  }

  void handleEvent(
      AdmobAdEvent event, Map<String, dynamic> args, String adType) {
    print("inside");
    switch (event) {
      case AdmobAdEvent.loaded:
        showSnackBar('New Admob $adType Ad loaded!');
        break;
      case AdmobAdEvent.opened:
        showSnackBar('Admob $adType Ad opened!');
        break;
      case AdmobAdEvent.closed:
        showSnackBar('Admob $adType Ad closed!');
        break;
      case AdmobAdEvent.failedToLoad:
        showSnackBar('Admob $adType failed to load. :(');
        break;
      case AdmobAdEvent.rewarded:
        print("rewarded with so many points");
        showDialog(
          context: scaffoldState.currentContext,
          builder: (BuildContext context) {
            print("rewarded so many");
            return WillPopScope(
              child: AlertDialog(
                content: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: <Widget>[
                    Text('Reward callback fired. Thanks Andrew!'),
                    Text('Type: ${args['type']}'),
                    Text('Amount: ${args['amount']}'),
                  ],
                ),
              ),
              onWillPop: () async {
                scaffoldState.currentState.hideCurrentSnackBar();
                return true;
              },
            );
          },
        );
        break;
      default:
    }
  }

  void showSnackBar(String content) {
    scaffoldState.currentState.showSnackBar(
      SnackBar(
        content: Text(content),
        duration: Duration(milliseconds: 1500),
      ),
    );
  }

  sharePost(BuildContext context, title, id) {
    final RenderBox box = context.findRenderObject();
    Share.share(title + '\n' + 'https://www.youtube.com/watch?v=$id',
        subject: 'https://www.youtube.com/watch?v=$id',
        sharePositionOrigin: box.localToGlobal(Offset.zero) & box.size);
  }

  addBookMarks(BookMarks data) async {
    //'inside add method');
    // await firebaseService.saveDataBookMark(data);
    Fluttertoast.showToast(
      msg: "Saved",
      toastLength: Toast.LENGTH_SHORT,
      gravity: ToastGravity.CENTER,
    );
  }

  Widget _buildVideo(Video video, Channel channels) {
    // print("finaldb$finalDblist");
    return Padding(
      padding: const EdgeInsets.symmetric(
        horizontal: 5.0,
      ),
      child: GestureDetector(
        onTap: () async {
          setState(() => _loaded = false);
          // if (await interstitial.isLoaded) {
          //   interstitial.show();
          // }
          print("tapped");
          await PersonDatabaseProvider.db.addPersonToDatabase(DbModel(
            name: video.title,
          ));
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (_) => VideoScreen(
                id: video.id,
                title: video.title,
              ),
            ),
          );
        },
        child: Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(5),
            // color: Colors.blueGrey[100],
          ),
          padding: EdgeInsets.all(5),
          child: Row(
            children: <Widget>[
              Container(
                width: 140,
                height: 85,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(5),
                  // color: Colors.white,
                  image: new DecorationImage(
                    image: new NetworkImage(video.thumbnailUrl),
                    fit: BoxFit.cover,
                  ),
                ),
                alignment: Alignment.center,
                child: Center(
                  child: Icon(
                    FontAwesomeIcons.play,
                    // color: Colors.white,
                  ),
                ),
              ),
              Flexible(
                child: SizedBox(
                  height: 85.0,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Row(
                        children: [
                          SizedBox(
                            width: 15,
                          ),
                          Expanded(
                            child: Text(
                              video.title,
                              textAlign: TextAlign.left,
                              maxLines: 2,
                              overflow: TextOverflow.ellipsis,
                              style: TextStyle(
                                  // color: Colors.white,
                                  fontSize: 17,
                                  shadows: [
                                    BoxShadow(
                                      color: Colors.blueGrey,
                                      offset: Offset(0, 5),
                                      blurRadius: 10.0,
                                    )
                                  ],
                                  fontWeight: FontWeight
                                      .bold), //TextStyle(color: Colors.black, fontWeight: FontWeight.bold, fontSize: 18.0, fontFamily: 'Roboto'),
                            ),
                          ),
                          // StreamBuilder(
                          //     stream: _bids,
                          //     builder: (context, snapshot) {
                          //       List<DbModel> dbData = snapshot.data;
                          //       if (snapshot.hasData && dbData.contains(video.title)) {
                          //         return Text('read');
                          //       }
                          //       return Text("");
                          //     })
                          finalDblist.contains(video.title)
                              ? Text('Read',
                                  style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 14,
                                      shadows: [
                                        BoxShadow(
                                          color: Colors.black87,
                                          offset: Offset(0, 5),
                                          blurRadius: 10.0,
                                        )
                                      ],
                                      fontWeight: FontWeight.bold))
                              : Text('')
                          // db.contains(video.title) ? Text("Read") : Text(''),
                          // Spacer(),
                          // Container(
                          //   height: 25,
                          //   width: 25,
                          //   decoration: BoxDecoration(
                          //       borderRadius: BorderRadius.circular(8),
                          //       color: Colors.grey[300]),
                          //   child: PopupMenuButton(
                          //     color: Colors.white,
                          //     onSelected: (value) {
                          //       //value);
                          //       if (value == 'share') {
                          //         setState(() {
                          //           sharePost(context, video.title, video.id);
                          //         });
                          //       } else {
                          //         BookMarks bookMarks = BookMarks(
                          //             postsId: video.id.toString(),
                          //             categoryId: video.title);
                          //         addBookMarks(bookMarks);
                          //       }
                          //     },
                          //     padding: EdgeInsets.zero,
                          //     // initialValue: choices[_selection],
                          //     itemBuilder: (_) => <PopupMenuItem<String>>[
                          //       new PopupMenuItem<String>(
                          //           child: new Text('Share'), value: 'share'),
                          //       new PopupMenuItem<String>(
                          //           child: new Text('Save'), value: 'save'),
                          //     ],
                          //     // itemBuilder: (BuildContext context) {
                          //     //   return PostCard.choices.map((String choice) {
                          //     //     return PopupMenuItem<String>(
                          //     //       value: choice,
                          //     //       child: Text(choice),
                          //     //     );
                          //     //   }).toList();
                          //     // },
                          //   ),
                          // )
                        ],
                      ),
                      Row(
                        children: [
                          SizedBox(
                            width: 15,
                          ),
                          Text(video.channelTitle,
                              textAlign: TextAlign.end,
                              overflow: TextOverflow.fade,
                              style: TextStyle(
                                  color: Colors.grey,
                                  shadows: [
                                    BoxShadow(
                                      color: Colors.black26,
                                      offset: Offset(0, 5),
                                      blurRadius: 10.0,
                                    )
                                  ],
                                  fontSize: 12,
                                  fontWeight: FontWeight.bold)),
                          Spacer(),
                          GestureDetector(
                            onTap: () async {
                              setState(() {
                                sharePost(context, video.title, video.id);
                              });
                              // notifyListeners();
                            },
                            child: CircleAvatar(
                              radius: 12,
                              backgroundColor: Colors.white,
                              child: Icon(
                                Icons.share_outlined,
                                color: primaryColor,
                                size: 16,
                              ),
                            ),
                          ),
                          // GestureDetector(
                          //   onTap: () {
                          //     BookMarks bookMarks = BookMarks(
                          //         postsId: video.id.toString(),
                          //         categoryId: video.title);
                          //     addBookMarks(bookMarks);
                          //   },
                          //   child: Icon(
                          //     Icons.bookmark_border_outlined,
                          //     size: 20,
                          //   ),
                          // ),
                        ],
                      ),
                      // SizedBox(
                      //   height: 2,
                      // ),
                    ],
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }

  _loadMoreVideos() async {
    _isLoading = true;
    List<Video> moreVideos = await APIService.instance
        .fetchVideosFromPlaylist(playlistId: _channel.uploadPlaylistId);
    List<Video> allVideos = _channel.videos..addAll(moreVideos);

    setState(() {
      _channel.videos = allVideos;
    });
    _isLoading = false;
  }

  @override
  Widget build(BuildContext context) {
    print(widget.searchList.length.toString());
    return _channel != null
        ? NotificationListener<ScrollNotification>(
            onNotification: (ScrollNotification scrollDetails) {
              if (!_isLoading &&
                  _channel.videos.length != int.parse(_channel.videoCount) &&
                  scrollDetails.metrics.pixels ==
                      scrollDetails.metrics.maxScrollExtent) {
                _loadMoreVideos();
              }
              return false;
            },
            child: ListView.builder(
              itemCount: widget.searchList.length,
              itemBuilder: (BuildContext context, int index) {
                // if (index % 3 == 0 && index != 0) {
                //   print('video length:{$_channel.videos.length}');
                //   return AdmobBanner(
                //       adUnitId: AdMobServices.bannerId,
                //       adSize: AdmobBannerSize.BANNER);
                // }
                // if (index != 0 && index % 3 == 0) {
                //   return Container(
                //     margin: EdgeInsets.only(bottom: 10.0),
                //     child: AdmobBanner(
                //       adUnitId: AdMobServices.bannerId,
                //       adSize: AdmobBannerSize.BANNER,
                //       listener:
                //           (AdmobAdEvent event, Map<String, dynamic> args) {
                //         handleEvent(event, args, 'Banner');
                //       },
                //       // onBannerCreated: (AdmobBannerController controller) {
                //       //   // Dispose is called automatically for you when Flutter removes the banner from the widget tree.
                //       //   // Normally you don't need to worry about disposing this yourself, it's handled.
                //       //   // If you need direct access to dispose, this is your guy!
                //       //   // controller.dispose();
                //       // },
                //     ),
                //   );
                // }
                if (index == 0) {
                  return Container();
                }
                // Video videos = index <= 7 ? _channel.videos[index - 1] : null;
                // print("videos:" + _channel.videos.length.toString());
                return Column(
                  children: [
                    // index <= 7 ? _buildVideo(videos, _channel) : Container(),
                    widget.searchList.isEmpty
                        ? Container()
                        : finalDblist.contains(widget.searchList[index].title)
                            ? PostListItem(widget.searchList[index], read: true)
                            : PostListItem(widget.searchList[index],
                                read: false)
                  ],
                );
              },
            ),
          )
        : Container(
            width: MediaQuery.of(context).size.width,
            child: ListView.builder(
              itemCount: 7,
              scrollDirection: Axis.vertical,
              primary: false,
              itemBuilder: (context, index) {
                return SizedBox(
                    width: MediaQuery.of(context).size.width,
                    height: 120.0,
                    child: Shimmer.fromColors(
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Card(
                          color: Color(0xFF44534a),
                        ),
                      ),
                      baseColor: Colors.white,
                      highlightColor: Colors.blueGrey[300],
                      direction: ShimmerDirection.ltr,
                    ));
              },
            ),
          );
  }

  @override
  void dispose() {
    // reward?.dispose();
    super.dispose();
  }
}
