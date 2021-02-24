import 'package:dio/dio.dart';
import 'package:firebase_admob/firebase_admob.dart';
import 'package:flutter/material.dart';
import 'package:google_signin_example/admob.dart';
import 'package:google_signin_example/model/channel.dart';
import 'package:google_signin_example/model/channel_models.dart';
import 'package:google_signin_example/model/post_entity.dart';
import 'package:google_signin_example/model/video.dart';
import 'package:google_signin_example/model/video_model.dart';
import 'package:google_signin_example/network/wp_api.dart';
import 'package:google_signin_example/page/home_category.dart';
import 'package:google_signin_example/page/video_Page.dart';
import 'package:google_signin_example/page/view_all.dart';
import 'package:google_signin_example/screens/video_screen.dart';
import 'package:google_signin_example/services/api_services.dart';
import 'package:google_signin_example/tabs/video2.dart';
import 'package:google_signin_example/tabs/videosPage.dart';
import 'package:google_signin_example/widget/config.dart';

import 'explore_page.dart';

class Articles extends StatefulWidget {
  List<PostEntity> data;
  Articles({this.data});
  @override
  _ArticlesState createState() => _ArticlesState();
}

class _ArticlesState extends State<Articles> {
  Channel _channel;
  bool _isLoading = false;
  VideoPlayerApp3 list = new VideoPlayerApp3();
  @override
  void initState() {
    List tempList = new List();
    // TODO: implement initState
    super.initState();

    _initChannel();
    FirebaseAdMob.instance.initialize(appId: BannerAd.testAdUnitId);
    // _bannerAd = myBanner
    //   ..load()
    //   ..show(
    //     anchorType: AnchorType.top,
    //     anchorOffset: kToolbarHeight + 50,
    //   );
  }

  _initChannel() async {
    Channel channel4 = await APIService.instance
        .fetchChannel(channelId: 'UCgpDrKxkgzFYKPh1wOQuY8Q');
    setState(() {
      _channel = channel4;
    });
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

  static const MobileAdTargetingInfo targetingInfo = MobileAdTargetingInfo(
    keywords: <String>['flutterio', 'beautiful apps'],
    contentUrl: 'https://flutter.io',
    childDirected: false,
    testDevices: <String>[], // Android emulators are considered test devices
  );

  BannerAd myBanner = BannerAd(
    adUnitId: BannerAd.testAdUnitId,
    size: AdSize.banner,
    targetingInfo: targetingInfo,
    listener: (MobileAdEvent event) {
      print("BannerAd event is $event");
    },
  );

  InterstitialAd myInterstitialAd = InterstitialAd(
    adUnitId: InterstitialAd.testAdUnitId,
    targetingInfo: targetingInfo,
    listener: (MobileAdEvent event) {
      print("InterstitialAd event is $event");
    },
  );

  BannerAd _bannerAd;
  _buildVideo(Video video) {
    return Flex(
      direction: Axis.vertical,
      children: [
        GestureDetector(
          onTap: () => Navigator.push(
            context,
            MaterialPageRoute(
              builder: (_) => VideoScreen(id: video.id),
            ),
          ),
          child: Container(
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.all(Radius.circular(15)),
              boxShadow: [
                BoxShadow(
                  color: Colors.black12,
                  offset: Offset(0, 1),
                  blurRadius: 6.0,
                ),
              ],
            ),
            child: Image(image: NetworkImage(video.thumbnailUrl)),
          ),
        ),
        Container(
          height: 45,
          width: double.infinity,
          child: Padding(
            padding: EdgeInsets.all(8.0),
            child: Row(
              children: [
                CircleAvatar(
                  backgroundColor: Colors.white,
                  radius: 20.0,
                  backgroundImage: NetworkImage(_channel.profilePictureUrl),
                ),
                Expanded(child: Text('  ' + video.title)),
              ],
            ),
          ),
        ),
        SizedBox(
          height: 15,
        )
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: SingleChildScrollView(
      child: Container(
        child: Column(
          children: [
            SizedBox(
              height: 80,
            ),
            Row(
              children: [
                SizedBox(
                  width: 10,
                ),
                Text(
                  "Top Posts",
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 18,
                  ),
                ),
                Spacer(),
                GestureDetector(
                  onTap: () {
                    myInterstitialAd
                      ..load()
                      ..show(
                        anchorType: AnchorType.bottom,
                        anchorOffset: 0.0,
                        horizontalCenterOffset: 0.0,
                      );
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => ExplorePage(
                                  baseurl: [
                                    'https://enginejunkies.com/',
                                    'http://festivalsofearth.com/',
                                    'http://insuranceofearth.com/',
                                    'https://bookworms99.com/'
                                  ],
                                  option: 'view',
                                )));
                  },
                  child: Container(
                    padding: EdgeInsets.symmetric(horizontal: 20, vertical: 5),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(50),
                      color: Color(0xff25bcbb),
                    ),
                    child: Text(
                      "view all",
                      style: TextStyle(
                        color: Colors.grey[900],
                        fontWeight: FontWeight.bold,
                        fontSize: 12,
                      ),
                    ),
                  ),
                ),
                SizedBox(
                  width: 5,
                ),
              ],
            ),
            Container(
              height: MediaQuery.of(context).size.height / 8,
              width: MediaQuery.of(context).size.width,
              decoration: BoxDecoration(// BoxShape.circle or BoxShape.retangle
                  //color: const Color(0xFF66BB6A),
                  boxShadow: [
                BoxShadow(
                  color: Colors.grey[300],
                  offset: new Offset(5.0, 5.0),
                  blurRadius: 5.0,
                ),
              ]),
              child: ListView(
                scrollDirection: Axis.horizontal,
                children: <Widget>[
                  HomeCategory(
                    data: widget.data,
                    option: 'top',
                  )
                ],
              ),
            ),
            SizedBox(
              height: 10,
            ),

            // Row(
            //   children: <Widget>[
            //     RaisedButton(
            //       onPressed: () async {
            //         if (await interstitial.isLoaded) {
            //           interstitial.show();
            //         }
            //       },
            //       child: Text("Interstitial Ad"),
            //     ),
            //     SizedBox(
            //       width: 10.0,
            //     ),
            //     RaisedButton(
            //       onPressed: () async {
            //         if (await reward.isLoaded) {
            //           reward.show();
            //         }
            //       },
            //       child: Text("Reward Ad"),
            //     )
            //   ],
            // ),
            // Expanded(
            //   child: ListView.builder(
            //       itemCount: 50,
            //       itemBuilder: (context, index) {
            //         if (index % 12 == 0 && index != 0) {
            //           return AdmobBanner(
            //               adUnitId: AdMobService.bannerId,
            //               adSize: AdmobBannerSize.LARGE_BANNER);
            //         }
            //         return ListTile(
            //           title: Text('Item $index'),
            //         );
            //       }),
            // ),
            Row(
              children: [
                SizedBox(
                  width: 10,
                ),
                Text(
                  "Featured Posts",
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 18,
                  ),
                ),
                SizedBox(
                  width: 10,
                ),
              ],
            ),
            Container(
              height: MediaQuery.of(context).size.height / 6.5,
              width: MediaQuery.of(context).size.width,
              decoration: BoxDecoration(// BoxShape.circle or BoxShape.retangle
                  //color: const Color(0xFF66BB6A),
                  boxShadow: [
                BoxShadow(
                  color: Colors.grey[300],
                  offset: new Offset(5.0, 5.0),
                  blurRadius: 5.0,
                ),
              ]),
              child: ListView(
                scrollDirection: Axis.horizontal,
                children: <Widget>[
                  HomeCategory(
                    data: widget.data,
                    option: 'featured',
                  )
                ],
              ),
            ),
            SizedBox(
              height: 10,
            ),
            SizedBox(
              height: 10,
            ),
            Row(
              children: [
                SizedBox(
                  width: 10,
                ),
                Text(
                  'Videos',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 18,
                  ),
                ),
              ],
            ),
            SizedBox(
              height: 10,
            ),
            _channel != null
                ? NotificationListener<ScrollNotification>(
                    onNotification: (ScrollNotification scrollDetails) {
                      if (!_isLoading &&
                          _channel.videos.length !=
                              int.parse(_channel.videoCount) &&
                          scrollDetails.metrics.pixels ==
                              scrollDetails.metrics.maxScrollExtent) {
                        _loadMoreVideos();
                      }
                      return false;
                    },
                    child: Container(
                      padding: EdgeInsets.only(left: 6.0, right: 6.0),
                      height: MediaQuery.of(context).size.height / 1.5,
                      width: MediaQuery.of(context).size.width,
                      child: Container(
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.all(Radius.circular(15)),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black12,
                                offset: Offset(0, 1),
                                blurRadius: 6.0,
                              ),
                            ],
                          ),
                          child: Video2()),
                    ),
                  )
                : Center(
                    child: CircularProgressIndicator(
                      valueColor: AlwaysStoppedAnimation<Color>(
                        Theme.of(context).primaryColor, // Red
                      ),
                    ),
                  ),
          ],
        ),
      ),
    ));
  }

  @override
  void dispose() {
    // _bannerAd.dispose();
    // myInterstitialAd.dispose();
    // TODO: implement dispose
    super.dispose();
  }

  Widget makeStory({storyImage, userImage, userName}) {
    return AspectRatio(
      aspectRatio: 1.6 / 2,
      child: Container(
        margin: EdgeInsets.only(right: 10),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(15),
          // image:
          //     DecorationImage(image: AssetImage(storyImage), fit: BoxFit.cover),
        ),
        child: Container(
          padding: EdgeInsets.all(10),
          decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(15),
              gradient: LinearGradient(begin: Alignment.bottomRight, colors: [
                Colors.black.withOpacity(.9),
                Colors.black.withOpacity(.1),
              ])),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              Container(
                width: 40,
                height: 40,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  border: Border.all(color: Colors.white, width: 2),
                  // image: DecorationImage(
                  //     image: AssetImage(userImage), fit: BoxFit.cover),
                ),
              ),
              Text(
                userName,
                style: TextStyle(color: Colors.white),
              )
            ],
          ),
        ),
      ),
    );
  }

  Widget makeFeed({userName, feedTime, feedText, feedImage}) {
    return Container(
      margin: EdgeInsets.only(bottom: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              Row(
                children: <Widget>[
                  Container(
                    width: 50,
                    height: 50,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      // image: DecorationImage(
                      //     image: AssetImage(userImage), fit: BoxFit.cover),
                    ),
                  ),
                  SizedBox(
                    width: 10,
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Text(
                        userName,
                        style: TextStyle(
                            color: Colors.grey[900],
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            letterSpacing: 1),
                      ),
                      SizedBox(
                        height: 3,
                      ),
                      Text(
                        feedTime,
                        style: TextStyle(fontSize: 15, color: Colors.grey),
                      ),
                    ],
                  )
                ],
              ),
              IconButton(
                icon: Icon(
                  Icons.more_horiz,
                  size: 30,
                  color: Colors.grey[600],
                ),
                onPressed: () {},
              )
            ],
          ),
          SizedBox(
            height: 20,
          ),
          Text(
            feedText,
            style: TextStyle(
                fontSize: 15,
                color: Colors.grey[800],
                height: 1.5,
                letterSpacing: .7),
          ),
          SizedBox(
            height: 20,
          ),
          feedImage != ''
              ? Container(
                  height: 200,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                    // image: DecorationImage(
                    //     image: AssetImage(feedImage), fit: BoxFit.cover),
                  ),
                )
              : Container(),
          SizedBox(
            height: 20,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              Row(
                children: <Widget>[
                  makeLike(),
                  Transform.translate(offset: Offset(-5, 0), child: makeLove()),
                  SizedBox(
                    width: 5,
                  ),
                  Text(
                    "2.5K",
                    style: TextStyle(fontSize: 15, color: Colors.grey[800]),
                  )
                ],
              ),
              Text(
                "400 Comments",
                style: TextStyle(fontSize: 13, color: Colors.grey[800]),
              )
            ],
          ),
          SizedBox(
            height: 20,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              makeLikeButton(isActive: true),
              makeCommentButton(),
              makeShareButton(),
            ],
          )
        ],
      ),
    );
  }

  Widget makeLike() {
    return Container(
      width: 25,
      height: 25,
      decoration: BoxDecoration(
          color: Colors.blue,
          shape: BoxShape.circle,
          border: Border.all(color: Colors.white)),
      child: Center(
        child: Icon(Icons.thumb_up, size: 12, color: Colors.white),
      ),
    );
  }

  Widget makeLove() {
    return Container(
      width: 25,
      height: 25,
      decoration: BoxDecoration(
          color: Colors.red,
          shape: BoxShape.circle,
          border: Border.all(color: Colors.white)),
      child: Center(
        child: Icon(Icons.favorite, size: 12, color: Colors.white),
      ),
    );
  }

  Widget makeLikeButton({isActive}) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 20, vertical: 5),
      decoration: BoxDecoration(
        border: Border.all(color: Colors.grey[200]),
        borderRadius: BorderRadius.circular(50),
      ),
      child: Center(
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Icon(
              Icons.thumb_up,
              color: isActive ? Colors.blue : Colors.grey,
              size: 18,
            ),
            SizedBox(
              width: 5,
            ),
            Text(
              "Like",
              style: TextStyle(color: isActive ? Colors.blue : Colors.grey),
            )
          ],
        ),
      ),
    );
  }

  Widget makeCommentButton() {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 20, vertical: 5),
      decoration: BoxDecoration(
        border: Border.all(color: Colors.grey[200]),
        borderRadius: BorderRadius.circular(50),
      ),
      child: Center(
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Icon(Icons.chat, color: Colors.grey, size: 18),
            SizedBox(
              width: 5,
            ),
            Text(
              "Comment",
              style: TextStyle(color: Colors.grey),
            )
          ],
        ),
      ),
    );
  }

  Widget makeShareButton() {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 20, vertical: 5),
      decoration: BoxDecoration(
        border: Border.all(color: Colors.grey[200]),
        borderRadius: BorderRadius.circular(50),
      ),
      child: Center(
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Icon(Icons.share, color: Colors.grey, size: 18),
            SizedBox(
              width: 5,
            ),
            Text(
              "Share",
              style: TextStyle(color: Colors.grey),
            )
          ],
        ),
      ),
    );
  }
}
