import 'package:flutter/material.dart';
import 'package:google_signin_example/model/channel.dart';
import 'package:google_signin_example/model/channel_models.dart';
import 'package:google_signin_example/model/video.dart';
import 'package:google_signin_example/model/video_model.dart';
import 'package:google_signin_example/screens/video_screen.dart';
import 'package:google_signin_example/services/api_services.dart';

class Video4 extends StatefulWidget {
  @override
  _Video4State createState() => _Video4State();
}

class _Video4State extends State<Video4> {
  Channel _channel;
  bool _isLoading = false;
  Color primaryColor = Color(0xff18203d);
  Color secondaryColor = Color(0xff232c51);
  Color logoGreen = Color(0xff25bcbb);
  @override
  void initState() {
    super.initState();
    _initChannel();
  }

  _initChannel() async {
    Channel channel = await APIService.instance
        .fetchChannel(channelId: 'UCGuFh3Ul7OxJd3MUDKP2cLw');

    setState(() {
      _channel = channel;
    });
  }

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
    // print(items);
    return Scaffold(
      body: _channel != null
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
}
