import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_signin_example/model/channel.dart';
import 'package:google_signin_example/model/video.dart';
import 'package:google_signin_example/screens/video_screen.dart';
import 'package:google_signin_example/services/api_services.dart';
import 'package:google_signin_example/widget/helpers.dart';

class VideoPlayerApp3 extends StatefulWidget {
  final String option;
  VideoPlayerApp3({this.option});
  @override
  _VideoPlayerApp3State createState() => _VideoPlayerApp3State();
}

class _VideoPlayerApp3State extends State<VideoPlayerApp3>
    with SingleTickerProviderStateMixin {
  Channel _channel1;
  Channel _channel2;
  Channel _channel3;
  Channel _channel4;
  bool _isLoading = false;
  Color primaryColor = Color(0xff18203d);
  Color secondaryColor = Color(0xff232c51);
  Color logoGreen = Color(0xff25bcbb);
  List videoList = new List();

  @override
  void initState() {
    super.initState();
    _initChannel();
  }

  _initChannel() async {
    Channel channel3 = await APIService.instance
        .fetchChannel(channelId: 'UCKmwUXQLo6ny-GD2a0dOf8Q');
    Channel channel4 = await APIService.instance
        .fetchChannel(channelId: 'UCGuFh3Ul7OxJd3MUDKP2cLw');
    setState(() {
      _channel3 = channel3;
      _channel4 = channel4;
      for (int k = 0; k < _channel3.videos.length; k++) {
        videoList.add([
          _channel3.videos[k].id,
          _channel3.videos[k].channelTitle,
          _channel3.videos[k].title,
          _channel3.videos[k].thumbnailUrl,
          _channel3.profilePictureUrl
        ]);
      }
      for (int l = 0; l < _channel4.videos.length; l++) {
        videoList.add([
          _channel4.videos[l].id,
          _channel4.videos[l].channelTitle,
          _channel4.videos[l].title,
          _channel4.videos[l].thumbnailUrl,
          _channel4.profilePictureUrl
        ]);
      }
    });
    videoList.shuffle();
  }

  sendVideos() {
    return videoList;
  }

  _buildVideo(videos, size) {
    for (int i = 0; i < videos.length; i++) {
      print('video id' + videos.toString());
      return Column(
        children: [
          GestureDetector(
            // onTap: () {
            //   print(videoList.toString());
            // },
            onTap: () => Navigator.push(
              context,
              MaterialPageRoute(
                builder: (_) => VideoScreen(id: videos[i]),
              ),
            ),
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
              child: Image(
                image: NetworkImage(videos[3]),
                fit: BoxFit.cover,
              ),
            ),
          ),
          // ClipRRect(
          //   borderRadius: BorderRadius.circular(8.0),
          //   child: Image.network(videos[4]),
          // ),
          // Expanded(
          //   child: Text(
          //     ' ' + videos[2],
          //     style: TextStyle(
          //         letterSpacing: 0.5, fontWeight: FontWeight.bold),
          //   ),
          // ),
          Container(
            width: double.infinity,
            child: Padding(
              padding: EdgeInsets.all(2.0),
              child: Row(
                children: [
                  CircleAvatar(
                    backgroundColor: Colors.white,
                    radius: 20.0,
                    backgroundImage: NetworkImage(videos[4]),
                  ),
                  Expanded(
                    child: Text(
                      ' ' + videos[2],
                      style: TextStyle(
                          letterSpacing: 0.5, fontWeight: FontWeight.bold),
                    ),
                  ),
                  // Spacer(),
                  makeShareButton(),
                  Icon(
                    FontAwesomeIcons.bookmark,
                    size: 18,
                    color: Colors.grey[700],
                  ),
                  // SizedBox(
                  //   width: 10,
                  // ),
                  // Icon(
                  //   FontAwesomeIcons.share,
                  //   size: 18,
                  // )
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
  }

  loadMoreVideos() async {
    _isLoading = true;
    List<Video> moreVideos = await APIService.instance
        .fetchVideosFromPlaylist(playlistId: _channel1.uploadPlaylistId);
    List<Video> allVideos = _channel1.videos..addAll(moreVideos);
    List<Video> moreVideos1 = await APIService.instance
        .fetchVideosFromPlaylist(playlistId: _channel2.uploadPlaylistId);
    List<Video> allVideos1 = _channel2.videos..addAll(moreVideos1);

    List<Video> moreVideos2 = await APIService.instance
        .fetchVideosFromPlaylist(playlistId: _channel3.uploadPlaylistId);
    List<Video> allVideos2 = _channel3.videos..addAll(moreVideos2);

    List<Video> moreVideos3 = await APIService.instance
        .fetchVideosFromPlaylist(playlistId: _channel4.uploadPlaylistId);
    List<Video> allVideos3 = _channel4.videos..addAll(moreVideos3);
    setState(() {
      _channel1.videos = allVideos;
      _channel2.videos = allVideos1;
      _channel3.videos = allVideos2;
      _channel4.videos = allVideos3;
    });
    _isLoading = false;
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      body: _channel3 != null
          ? NotificationListener<ScrollNotification>(
              onNotification: (ScrollNotification scrollDetails) {
                if (!_isLoading &&
                    _channel3.videos.length !=
                        int.parse(_channel3.videoCount) &&
                    scrollDetails.metrics.pixels ==
                        scrollDetails.metrics.maxScrollExtent) {
                  loadMoreVideos();
                }
                return false;
              },
              child: ListView.builder(
                scrollDirection: Axis.horizontal,
                shrinkWrap: true, // <- added
                primary: false,
                itemCount: videoList.length,
                itemBuilder: (BuildContext context, int index) {
                  print(videoList.length);
                  if (index == 0) {
                    return Container();
                  }
                  return _buildVideo(videoList[index], size);
                },
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

  Widget makeShareButton() {
    return Container(
      height: 40,
      width: 150,
      padding: EdgeInsets.symmetric(horizontal: 10, vertical: 5),
      decoration: BoxDecoration(
        border: Border.all(color: Colors.grey[200]),
        borderRadius: BorderRadius.circular(50),
      ),
      child: Center(
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Icon(Icons.share, color: Colors.grey[700], size: 18),
            SizedBox(
              width: 5,
            ),
            Text(
              "Share",
              style: TextStyle(color: Colors.grey[700]),
            )
          ],
        ),
      ),
    );
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
  }
}
