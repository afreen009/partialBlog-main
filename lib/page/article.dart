import 'dart:io';
import 'package:admob_flutter/admob_flutter.dart';
import 'package:flutter/material.dart';
import 'package:google_signin_example/model/channel.dart';
import 'package:google_signin_example/model/post_entity.dart';
import 'package:google_signin_example/model/video.dart';
import 'package:google_signin_example/page/home_category.dart';
import 'package:google_signin_example/page/video_Page.dart';
import 'package:google_signin_example/services/api_services.dart';
import 'package:google_signin_example/tabs/homevideo.dart';
// import 'package:admob_flutter/admob_flutter.dart';

class Articles extends StatefulWidget {
  final List<PostEntity> searchList;
  Articles(this.searchList);
  @override
  _ArticlesState createState() => _ArticlesState();
}

class _ArticlesState extends State<Articles>
    with SingleTickerProviderStateMixin {
  Channel _channel;
  bool _isLoading = false;
  VideoPlayerApp3 list = new VideoPlayerApp3();
  Color primaryColor = Color(0xff18203d);
  Color secondaryColor = Color(0xff232c51);
  Color logoGreen = Color(0xff25bcbb);
  // AdmobInterstitial interstitial;
  // AdmobReward reward;
  AdmobBannerSize bannerSize;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    print(widget.searchList);
    // _initChannel();

    // You should execute `Admob.requestTrackingAuthorization()` here before showing any ad.

    bannerSize = AdmobBannerSize.BANNER;
    // interstitial = AdmobInterstitial(adUnitId: AdMobServices.interstitialId);
    // interstitial.load();
    // reward = AdmobReward(
    //   adUnitId: AdMobServices.rewardId,
    //   // listener: (AdmobAdEvent event, Map<String, dynamic>? args) {
    //   //   if (event == AdmobAdEvent.closed) interstitial.load();
    //   //   // handleEvent(event, args, 'Interstitial');
    //   // },
    //   listener: (event, args) {
    //     if (event == AdmobAdEvent.rewarded) {
    //       print("User rewarded.......");
    //     }
    //   },
    // );
    // reward.load();
    // //a min let me
  }

  // _initChannel() async {
  // List list = await widget.searchList;
  // Channel channel4 = await APIService.instance
  //     .fetchChannel(channelId: 'UCgpDrKxkgzFYKPh1wOQuY8Q');
  // setState(() {
  //   _channel = channel4;
  // });
  // }

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

//can u tell me where u want to create this object, ill show u that, cause i have not used the userdata object
//Okay np prblem, just show me where you fetch userdata when you fetch u
////i fetch in 2 place first place is hete
  // _buildVideo(Video video) {
  //   return Flex(
  //     direction: Axis.vertical,
  //     children: [
  //       GestureDetector(
  //         onTap: () => Navigator.push(
  //           context,
  //           MaterialPageRoute(
  //             builder: (_) => VideoScreen(id: video.id),
  //           ),
  //         ),
  //         child: Container(
  //           decoration: BoxDecoration(
  //             color: Colors.white,
  //             borderRadius: BorderRadius.all(Radius.circular(15)),
  //             boxShadow: [
  //               BoxShadow(
  //                 color: Colors.black12,
  //                 offset: Offset(0, 1),
  //                 blurRadius: 6.0,
  //               ),
  //             ],
  //           ),
  //           child: Image(image: NetworkImage(video.thumbnailUrl)),
  //         ),
  //       ),
  //       Container(
  //         height: 45,
  //         width: double.infinity,
  //         child: Padding(
  //           padding: EdgeInsets.all(8.0),
  //           child: Row(
  //             children: [
  //               CircleAvatar(
  //                 backgroundColor: Colors.white,
  //                 radius: 20.0,
  //                 backgroundImage: NetworkImage(_channel.profilePictureUrl),
  //               ),
  //               Expanded(child: Text('  ' + video.title)),
  //             ],
  //           ),
  //         ),
  //       ),
  //       SizedBox(
  //         height: 15,
  //       )
  //     ],
  //   );
  // }
  var scrollController = ScrollController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: NestedScrollView(
        controller: scrollController,
        physics: ScrollPhysics(parent: PageScrollPhysics()),
        body: bottomList(),
        // body: Flexible(fit: FlexFit.loose, child: bottomList()),
        headerSliverBuilder: (BuildContext context, bool innerBoxIsScrolled) {
          return <Widget>[
            SliverAppBar(
                iconTheme: IconThemeData(color: Colors.white),
                floating: true,
                expandedHeight: 210.0,
                flexibleSpace: FlexibleSpaceBar(
                  background: topScroll(),
                ))
          ];
        },
      ),
    );
  }

  Widget bottomList() {
    Size size = MediaQuery.of(context).size;
    return Container(
      height: size.height,
      child: Column(
        children: <Widget>[
          SizedBox(
            height: 15,
          ),
          Row(
            children: [
              SizedBox(
                width: 10,
              ),
              Text(
                "Latest",
                style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 18,
                    shadows: [
                      BoxShadow(
                        color: Color.fromRGBO(0, 0, 0, 0.15),
                        offset: Offset(0, 5),
                        blurRadius: 10.0,
                      )
                    ]),
              ),
            ],
          ),
          SizedBox(
            height: 10,
          ),
          Expanded(flex: 1, child: HomeVideo(widget.searchList))
        ],
      ),
    );
  }

  Widget topScroll() {
    return Column(
      children: [
        SizedBox(
          height: 20,
        ),
        Row(
          children: [
            SizedBox(
              width: 10,
            ),
            Text(
              "Trending",
              style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 18,
                  shadows: [
                    BoxShadow(
                      color: Color.fromRGBO(0, 0, 0, 0.15),
                      offset: Offset(0, 5),
                      blurRadius: 10.0,
                    )
                  ]),
            ),
            // GestureDetector(
            //   onTap: () {
            //     // myInterstitialAd
            //     //   ..load()
            //     //   ..show(
            //     //     anchorType: AnchorType.bottom,
            //     //     anchorOffset: 0.0,
            //     //     horizontalCenterOffset: 0.0,
            //     //   );
            //     Navigator.push(
            //         context,
            //         MaterialPageRoute(
            //             builder: (context) => ExplorePage(
            //                   baseurl: [
            //                     'https://enginejunkies.com/',
            //                     'http://festivalsofearth.com/',
            //                     'http://insuranceofearth.com/',
            //                     'https://bookworms99.com/'
            //                   ],
            //                   option: 'view',
            //                 )));
            //   },
            // child: Container(
            //   padding: EdgeInsets.symmetric(horizontal: 20, vertical: 5),
            //   decoration: BoxDecoration(
            //     borderRadius: BorderRadius.circular(50),
            //     color: Theme.of(context).primaryColor,
            //   ),
            //   child: Text(
            //     "view all",
            //     style: TextStyle(
            //       color: Colors.white,
            //       fontWeight: FontWeight.bold,
            //       fontSize: 13,
            //     ),
            //   ),
            // ),
            // ),
          ],
        ),
        SizedBox(height: 19),
        Container(
          height: 140.0,
          // color: Colors.blueGrey[100],
          child: HomeCategory(
            url: [
              'http://gamesandapps.in/',
              'http://managemywealth.in/',
              'https://yourcryptocurrency.in/'
            ],
            option: 'top',
          ),
        ),
      ],
    );
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

  String getBannerAdUnitId() {
    if (Platform.isIOS) {
      return 'ca-app-pub-3940256099942544/2934735716';
    } else if (Platform.isAndroid) {
      return 'ca-app-pub-3940256099942544/6300978111';
    }
    return null;
  }

  @override
  void dispose() {
    // AdmobBannerController controller;
    // controller.dispose();
    // interstitial?.dispose();
    // reward?.dispose();
    super.dispose();
  }
}
