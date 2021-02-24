import 'package:flutter/material.dart';
import 'package:google_signin_example/model/channel.dart';
import 'package:google_signin_example/model/video.dart';
import 'package:google_signin_example/screens/video_screen.dart';
import 'package:google_signin_example/services/api_services.dart';
import 'package:google_signin_example/services/youtube_service.dart';

class HomeVideos extends StatefulWidget {
  @override
  _HomeVideosState createState() => _HomeVideosState();
}

class _HomeVideosState extends State<HomeVideos> {
  final YoutubeAPIService _youtubeAPIService =
      YoutubeAPIService.youtubeAPIService;
  Channel _channel;
  Channel _channel1;
  Channel _channel2;
  Channel _channel3;
  bool _isLoading = false;
  Color primaryColor = Color(0xff18203d);
  Color secondaryColor = Color(0xff232c51);
  Color logoGreen = Color(0xff25bcbb);
  @override
  void initState() {
    super.initState();
    _initChannel();
    _initChannel1();
    _initChannel2();
    _initChannel3();
  }

  _initChannel() async {
    Channel channel = await APIService.instance
        .fetchChannel(channelId: 'UCgpDrKxkgzFYKPh1wOQuY8Q');

    setState(() {
      _channel = channel;
    });
  }

  _initChannel1() async {
    Channel channel1 = await APIService.instance
        .fetchChannel(channelId: 'UCsu2ICvlMu3NtaTxfEnupXA');

    setState(() {
      _channel1 = channel1;
    });
  }

  _initChannel2() async {
    Channel channel2 = await APIService.instance
        .fetchChannel(channelId: 'UCGuFh3Ul7OxJd3MUDKP2cLw');

    setState(() {
      _channel2 = channel2;
    });
  }

  _initChannel3() async {
    Channel channel3 = await APIService.instance
        .fetchChannel(channelId: 'UCKmwUXQLo6ny-GD2a0dOf8Q');

    setState(() {
      _channel3 = channel3;
    });
  }
  // _buildProfileInfo() {
  //   return Container(
  //     margin: EdgeInsets.all(20.0),
  //     padding: EdgeInsets.all(20.0),
  //     height: 100.0,
  //     decoration: BoxDecoration(
  //       color: Colors.white,
  //       borderRadius: BorderRadius.all(Radius.circular(10)),
  //       boxShadow: [
  //         BoxShadow(
  //           color: Colors.black12,
  //           offset: Offset(0, 1),
  //           blurRadius: 6.0,
  //         ),
  //       ],
  //     ),
  //     child: Row(
  //       children: <Widget>[
  //         CircleAvatar(
  //           backgroundColor: Colors.white,
  //           radius: 35.0,
  //           backgroundImage: NetworkImage(_channel.profilePictureUrl),
  //         ),
  //         SizedBox(width: 12.0),
  //         Expanded(
  //           child: Column(
  //             mainAxisAlignment: MainAxisAlignment.center,
  //             crossAxisAlignment: CrossAxisAlignment.start,
  //             children: <Widget>[
  //               Text(
  //                 _channel.title + _channel.like,
  //                 style: TextStyle(
  //                   color: Colors.black,
  //                   fontSize: 20.0,
  //                   fontWeight: FontWeight.w600,
  //                 ),
  //                 overflow: TextOverflow.ellipsis,
  //               ),
  //               Text(
  //                 '${_channel.subscriberCount} subscribers',
  //                 style: TextStyle(
  //                   color: Colors.grey[600],
  //                   fontSize: 16.0,
  //                   fontWeight: FontWeight.w600,
  //                 ),
  //                 overflow: TextOverflow.ellipsis,
  //               ),
  //             ],
  //           ),
  //         )
  //       ],
  //     ),
  //   );
  // }

  _buildVideo(Video video, Channel channels) {
    return Column(
      children: [
        Column(
          children: [
            GestureDetector(
              onTap: () => Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => VideoScreen(id: video.id),
                ),
              ),
              child: Container(
                width: MediaQuery.of(context).size.width,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.all(Radius.circular(50)),
                  // boxShadow: [
                  //   BoxShadow(
                  //     color: Colors.black12,
                  //     offset: Offset(0, .000.1),
                  //     blurRadius: 6.0,
                  //   ),
                  // ],
                ),
                child: Image(image: NetworkImage(video.thumbnailUrl)),
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
                      backgroundImage: NetworkImage(channels.profilePictureUrl),
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

  _loadMoreVideos() async {
    _isLoading = true;
    List<Video> moreVideos = await APIService.instance
        .fetchVideosFromPlaylist(playlistId: _channel.uploadPlaylistId);
    List<Video> allVideos = _channel.videos..addAll(moreVideos);
    List<Video> moreVideos1 = await APIService.instance
        .fetchVideosFromPlaylist(playlistId: _channel1.uploadPlaylistId);
    List<Video> allVideos1 = _channel1.videos..addAll(moreVideos1);
    List<Video> moreVideos2 = await APIService.instance
        .fetchVideosFromPlaylist(playlistId: _channel2.uploadPlaylistId);
    List<Video> allVideos2 = _channel2.videos..addAll(moreVideos2);
    List<Video> moreVideos3 = await APIService.instance
        .fetchVideosFromPlaylist(playlistId: _channel3.uploadPlaylistId);
    List<Video> allVideos3 = _channel.videos..addAll(moreVideos3);
    setState(() {
      _channel.videos = allVideos;
      _channel1.videos = allVideos1;
      _channel2.videos = allVideos2;
      _channel3.videos = allVideos3;
    });
    _isLoading = false;
  }

  @override
  Widget build(BuildContext context) {
    // int items = _channel.videos.length;
    // int items1 = _channel1.videos.length;
    // int items2 = _channel2.videos.length;
    // // int items3 = _channel3.videos.length;
    // print(items);
    return _channel != null
        ? NotificationListener<ScrollNotification>(
            onNotification: (ScrollNotification scrollDetails) {
              if (!_isLoading &&
                  _channel.videos.length != int.parse(_channel.videoCount) &&
                  // _channel1.videos.length != int.parse(_channel1.videoCount) &&
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
            child: Container(
              // height: 500,
              child: Padding(
                padding: const EdgeInsets.only(top: 8.0),
                child: ListView.builder(
                  itemCount: 1 + _channel.videos.length,
                  itemBuilder: (BuildContext context, int index) {
                    if (index == 0) {
                      return Container();
                    }
                    Video videos = _channel.videos[index - 1];
                    return _buildVideo(videos, _channel);
                  },
                ),
              ),
            ),
          )
        : Center(
            child: CircularProgressIndicator(
              valueColor: AlwaysStoppedAnimation<Color>(
                Theme.of(context).primaryColor, // Red
              ),
            ),
          );
  }
}
