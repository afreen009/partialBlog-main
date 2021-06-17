// import 'package:admob_flutter/admob_flutter.dart';
import 'package:admob_flutter/admob_flutter.dart';
import 'package:flutter/material.dart';
import 'package:google_signin_example/admob.dart';
import 'package:google_signin_example/model/channel.dart';
import 'package:google_signin_example/model/channel_models.dart';
import 'package:google_signin_example/model/video.dart';
import 'package:google_signin_example/model/video_model.dart';
import 'package:google_signin_example/screens/video_screen.dart';
import 'package:google_signin_example/services/api_services.dart';

class VideoPlayerApp extends StatefulWidget {
  @override
  _VideoPlayerAppState createState() => _VideoPlayerAppState();
}

class _VideoPlayerAppState extends State<VideoPlayerApp> {
  Channel _channel;
  // AdmobInterstitial interstitialAd;`
  // AdmobReward reward;
  bool _isLoading = false;
  Color primaryColor = Color(0xff18203d);
  Color secondaryColor = Color(0xff232c51);
  Color logoGreen = Color(0xff25bcbb);
  GlobalKey<ScaffoldState> scaffoldState = GlobalKey();
  @override
  void initState() {
    super.initState();
    _initChannel();
    // interstitialAd = AdmobInterstitial(
    //   adUnitId: AdMobServices.interstitialId,
    //   listener: (AdmobAdEvent event, Map<String, dynamic> args) {
    //     if (event == AdmobAdEvent.closed) interstitialAd.load();
    //     handleEvent(event, args, 'Interstitial');
    //   },
    // );
    // interstitialAd.load();
    // reward = AdmobReward(
    //     adUnitId: AdMobServices.rewardId,
    //     listener: (event, args) {
    //       if (event == AdmobAdEvent.rewarded) {
    //         print("User rewarded.......");
    //       }
    //     });
    // reward.load();
  }

  _initChannel() async {
    Channel channel = await APIService.instance
        .fetchChannel(channelId: 'UCgpDrKxkgzFYKPh1wOQuY8Q');

    if (mounted) {
      setState(() {
        _channel = channel;
      });
    }
  }

  _buildVideo(Video video) {
    return Column(
      children: [
        Column(
          children: [
            GestureDetector(
              onTap: () async {
                // if (await interstitialAd.isLoaded) {
                //   interstitialAd.show();
                // }
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => VideoScreen(id: video.id),
                  ),
                );
              },
              child: Container(
                height: 200,
                width: MediaQuery.of(context).size.width,
                decoration: BoxDecoration(
                  color: Colors.grey[300],
                  borderRadius: BorderRadius.all(Radius.circular(15)),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black12,
                      offset: Offset(0, 1),
                      blurRadius: 6.0,
                    ),
                  ],
                ),
                child: Image(
                  image: NetworkImage(
                    video.thumbnailUrl,
                  ),
                  fit: BoxFit.cover,
                ),
              ),
            ),
            Container(
              height: 45,
              width: double.infinity,
              // decoration: BoxDecoration(
              //     borderRadius: BorderRadius.only(
              //         bottomRight: Radius.circular(10),
              //         bottomLeft: Radius.circular(10)),
              //     color: Colors.grey),
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
        ),
      ],
    );
  }

  void handleEvent(
      AdmobAdEvent event, Map<String, dynamic> args, String adType) {
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
        showDialog(
          context: scaffoldState.currentContext,
          builder: (BuildContext context) {
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
    // int items = _channel.videos.length;
    // int items1 = _channel1.videos.length;
    // int items2 = _channel2.videos.length;
    // // int items3 = _channel3.videos.length;
    // //items);
    return Scaffold(
      body: _channel != null
          ? NotificationListener<ScrollNotification>(
              onNotification: (ScrollNotification scrollDetails) {
                if (!_isLoading &&
                    _channel.videos.length != int.parse(_channel.videoCount) &&
                    // _channel2.videos.length !=
                    //     int.parse(_channel2.videoCount) &&
                    // _channel3.videos.length !=
                    //     int.parse(_channel3.videoCount) &&
                    scrollDetails.metrics.pixels ==
                        scrollDetails.metrics.maxScrollExtent) {
                  _loadMoreVideos();
                }
                return false;
              },
              child: Padding(
                padding: const EdgeInsets.only(top: 8.0),
                child: ListView.builder(
                  itemCount: _channel.videos.length,
                  itemBuilder: (BuildContext context, int index) {
                    // if (index % 3 == 0 && index != 0) {
                    //   return AdmobBanner(
                    //       adUnitId: AdMobServices.bannerId,
                    //       adSize: AdmobBannerSize.LARGE_BANNER);
                    // }
                    if (index == 0) {
                      return Container();
                    }
                    Video videos = _channel.videos[index - 1];
                    return _buildVideo(videos);
                  },
                ),
              ),
            )
          : Center(
              child: CircularProgressIndicator(
                valueColor: AlwaysStoppedAnimation<Color>(
                  Theme.of(context).primaryColor, // Red
                ),
              ),
            ),
    );
  }

  @override
  void dispose() {
    // interstitialAd?.dispose();
    // reward?.dispose();
    super.dispose();
  }
}
