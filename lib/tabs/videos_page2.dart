import 'package:flutter/material.dart';
import 'package:google_signin_example/model/channel_models.dart';
import 'package:google_signin_example/model/video_model.dart';
import 'package:google_signin_example/screens/video_screen.dart';
import 'package:google_signin_example/services/api_services.dart';

class VideoPlayerApp1 extends StatefulWidget {
  @override
  _VideoPlayerApp1State createState() => _VideoPlayerApp1State();
}

class _VideoPlayerApp1State extends State<VideoPlayerApp1> {
  Channel _channel1;
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
    Channel channel2 = await APIService.instance
        .fetchChannel(channelId: 'UCsu2ICvlMu3NtaTxfEnupXA');

    setState(() {
      _channel1 = channel2;
    });
  }

  _buildVideo(Video video) {
    return Column(
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
                  backgroundImage: NetworkImage(_channel1.profilePictureUrl),
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

  _loadMoreVideos() async {
    _isLoading = true;
    List<Video> moreVideos = await APIService.instance
        .fetchVideosFromPlaylist(playlistId: _channel1.uploadPlaylistId);
    List<Video> allVideos = _channel1.videos..addAll(moreVideos);
    setState(() {
      _channel1.videos = allVideos;
    });
    _isLoading = false;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _channel1 != null
          ? NotificationListener<ScrollNotification>(
              onNotification: (ScrollNotification scrollDetails) {
                if (!_isLoading &&
                    _channel1.videos.length !=
                        int.parse(_channel1.videoCount) &&
                    scrollDetails.metrics.pixels ==
                        scrollDetails.metrics.maxScrollExtent) {
                  _loadMoreVideos();
                }
                return false;
              },
              child: Padding(
                padding: const EdgeInsets.only(top: 8.0),
                child: ListView.builder(
                  itemCount: 1 + _channel1.videos.length,
                  itemBuilder: (BuildContext context, int index) {
                    if (index == 0) {
                      return Container();
                    }
                    Video video = _channel1.videos[index - 1];
                    return _buildVideo(video);
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
    // TODO: implement dispose
    super.dispose();
  }
}
