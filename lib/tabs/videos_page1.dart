import 'package:flutter/material.dart';
import 'package:google_signin_example/model/channel_models.dart';
import 'package:google_signin_example/model/video_model.dart';
import 'package:google_signin_example/screens/video_screen.dart';
import 'package:google_signin_example/services/api_services.dart';

class VideoPlayerApp extends StatefulWidget {
  @override
  _VideoPlayerAppState createState() => _VideoPlayerAppState();
}

class _VideoPlayerAppState extends State<VideoPlayerApp> {
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
  }

  _initChannel() async {
    Channel channel = await APIService.instance
        .fetchChannel(channelId: 'UCgpDrKxkgzFYKPh1wOQuY8Q');
    Channel channel1 = await APIService.instance
        .fetchChannel(channelId: 'UCsu2ICvlMu3NtaTxfEnupXA');
    // Channel channel2 = await APIService.instance
    //     .fetchChannel(channelId: 'UCGuFh3Ul7OxJd3MUDKP2cLw');
    // Channel channel3 = await APIService.instance
    //     .fetchChannel(channelId: 'UCKmwUXQLo6ny-GD2a0dOf8Q');
    setState(() {
      _channel = channel;
      _channel1 = channel1;
      // _channel2 = channel2;
      // _channel3 = channel3;
    });
  }

  _buildVideo(Video video) {
    print(video.thumbnailUrl.toString());
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
              // color: Colors.amber.withOpacity(0.7),
              borderRadius: BorderRadius.all(Radius.circular(15)),
              boxShadow: [
                BoxShadow(
                  color: Colors.black12,
                  offset: Offset(0, 1),
                  blurRadius: 6.0,
                ),
              ],
            ),
            child: Stack(
              // mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Center(
                  child: Icon(
                    Icons.play_circle_fill,
                    color: Colors.amber,
                    size: 125,
                  ),
                ),
                Image(image: NetworkImage(video.thumbnailUrl)),
              ],
            ),
          ),
        ),
        // Container(
        //   height: 45,
        //   width: double.infinity,
        //   // decoration: BoxDecoration(
        //   //     borderRadius: BorderRadius.only(
        //   //         bottomRight: Radius.circular(10),
        //   //         bottomLeft: Radius.circular(10)),
        //   //     color: Colors.grey),
        //   child: Padding(
        //     padding: EdgeInsets.all(8.0),
        //     child: Row(
        //       children: [
        //         CircleAvatar(
        //           backgroundColor: Colors.white,
        //           radius: 20.0,
        //           backgroundImage: NetworkImage(_channel.profilePictureUrl),
        //         ),
        //         Expanded(child: Text('  ' + video.title)),
        //       ],
        //     ),
        //   ),
        // ),
        SizedBox(
          height: 15,
        )
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

    // List<Video> moreVideos2 = await APIService.instance
    //     .fetchVideosFromPlaylist(playlistId: _channel2.uploadPlaylistId);
    // List<Video> allVideos2 = _channel2.videos..addAll(moreVideos2);

    // List<Video> moreVideos3 = await APIService.instance
    //     .fetchVideosFromPlaylist(playlistId: _channel3.uploadPlaylistId);
    // List<Video> allVideos3 = _channel3.videos..addAll(moreVideos3);
    setState(() {
      _channel.videos = allVideos;
      _channel1.videos = allVideos1;
      // _channel2.videos = allVideos2;
      // _channel3.videos = allVideos3;
    });
    _isLoading = false;
  }

  @override
  Widget build(BuildContext context) {
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
                  itemCount: 8,
                  itemBuilder: (BuildContext context, int index) {
                    if (index == 0) {
                      return Container();
                    }

                    Video video = _channel.videos[index - 1];
                    Video video1 = _channel1.videos[index - 1];
                    // Video video2 = _channel2.videos[index - 1];
                    // Video video3 = _channel3.videos[index - 1];
                    print(" video1  $video");
                    print('video2  $video1');
                    return Column(
                      children: [
                        video != null ? _buildVideo(video) : Container(),
                        video1 != null ? _buildVideo(video1) : Container(),
                        // video2 != null ? _buildVideo(video2) : Container(),
                        // video3 != null ? _buildVideo(video3) : Container(),
                      ],
                    );
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
