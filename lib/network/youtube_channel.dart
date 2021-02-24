import 'package:google_signin_example/model/channel.dart';
import 'package:google_signin_example/model/channel_models.dart';
import 'package:google_signin_example/model/video.dart';
import 'package:google_signin_example/model/video_model.dart';
import 'package:google_signin_example/services/api_services.dart';

class YoutubeResponse {
  Channel _channel1;
  Channel _channel2;
  // Channel _channel3;
  // Channel _channel4;
  List videoList = new List();
  Future<List> initChannel() async {
    Channel channel1 = await APIService.instance
        .fetchChannel(channelId: 'UCgpDrKxkgzFYKPh1wOQuY8Q');
    Channel channel2 = await APIService.instance
        .fetchChannel(channelId: 'UCsu2ICvlMu3NtaTxfEnupXA');
    // Channel channel3 = await APIService.instance
    //     .fetchChannel(channelId: 'UCKmwUXQLo6ny-GD2a0dOf8Q');
    // Channel channel4 = await APIService.instance
    //     .fetchChannel(channelId: 'UCGuFh3Ul7OxJd3MUDKP2cLw');
    _channel1 = channel1;
    _channel2 = channel2;
    // _channel3 = channel3;
    // _channel4 = channel4;
    for (int i = 0; i < _channel1.videos.length; i++) {
      videoList.add([
        _channel1.videos[i].id,
        _channel1.videos[i].channelTitle,
        _channel1.videos[i].title,
        _channel1.videos[i].thumbnailUrl,
        _channel1.profilePictureUrl
      ]);
    }
    for (int i = 0; i < _channel2.videos.length; i++) {
      videoList.add([
        _channel2.videos[i].id,
        _channel2.videos[i].channelTitle,
        _channel2.videos[i].title,
        _channel2.videos[i].thumbnailUrl,
        _channel2.profilePictureUrl
      ]);
    }
    // for (int i = 0; i < _channel3.videos.length; i++) {
    //   videoList.add([
    //     _channel3.videos[i].id,
    //     _channel3.videos[i].channelTitle,
    //     _channel3.videos[i].title,
    //     _channel3.videos[i].thumbnailUrl,
    //     _channel3.profilePictureUrl
    //   ]);
    // }
    // for (int i = 0; i < _channel4.videos.length; i++) {
    //   videoList.add([
    //     _channel4.videos[i].id,
    //     _channel4.videos[i].channelTitle,
    //     _channel4.videos[i].title,
    //     _channel4.videos[i].thumbnailUrl,
    //     _channel4.profilePictureUrl
    //   ]);
    // }
    loadMoreVideos();
    videoList.shuffle();
    return videoList;
  }

  loadMoreVideos() async {
    List<Video> moreVideos = await APIService.instance
        .fetchVideosFromPlaylist(playlistId: _channel1.uploadPlaylistId);
    List<Video> allVideos = _channel1.videos..addAll(moreVideos);
    List<Video> moreVideos1 = await APIService.instance
        .fetchVideosFromPlaylist(playlistId: _channel2.uploadPlaylistId);
    List<Video> allVideos1 = _channel2.videos..addAll(moreVideos1);

    // List<Video> moreVideos2 = await APIService.instance
    //     .fetchVideosFromPlaylist(playlistId: _channel3.uploadPlaylistId);
    // List<Video> allVideos2 = _channel3.videos..addAll(moreVideos2);

    // List<Video> moreVideos3 = await APIService.instance
    //     .fetchVideosFromPlaylist(playlistId: _channel4.uploadPlaylistId);
    // List<Video> allVideos3 = _channel4.videos..addAll(moreVideos3);
    _channel1.videos = allVideos;
    _channel2.videos = allVideos1;
    // _channel3.videos = allVideos2;
    // _channel4.videos = allVideos3;
  }
}
