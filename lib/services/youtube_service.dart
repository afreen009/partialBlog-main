import 'dart:convert';
import 'dart:io';
import 'package:flutter/cupertino.dart';
import 'package:google_signin_example/model/channel.dart';
import 'package:google_signin_example/model/video.dart';
import 'package:http/http.dart' as http;

class YoutubeAPIService {
  List<Channel> _channelList = [];
  static const String _apiBaseUrl = 'www.googleapis.com';
  YoutubeAPIService._instantiate();

  static final YoutubeAPIService _youtubeAPIService =
      YoutubeAPIService._instantiate();

  static get youtubeAPIService => _youtubeAPIService;

  String _nextPageToken = '';

  Future<Channel> fetchChannel({String channelId}) async {
    Map<String, String> parameters = {
      'part': 'snippet, contentDetails, statistics',
      'id': channelId,
      'key': 'AIzaSyDu29zC203WDgefAI4IGBaqvMhy3eHLMMQ',
    };
    Uri uri = Uri.https(
      _apiBaseUrl,
      '/youtube/v3/channels',
      parameters,
    );
    Map<String, String> headers = {
      HttpHeaders.contentTypeHeader: 'application/json',
    };

    // Get Channel
    var response = await http.get(uri, headers: headers);
    if (response.statusCode == 200) {
      print(channelId);
      Map<String, dynamic> data = json.decode(response.body)['items'][0];
      Channel channel = Channel.fromMap(data);

      // Fetch first batch of videos from uploads playlist
      channel.videos = await fetchVideosFromPlaylist(
        playlistId: channel.uploadPlaylistId,
      );
      print('Hee');
      return channel;
    } else {
      throw json.decode(response.body)['error']['message'];
    }
  }

  //Search video from a given channel
  Future<List<Video>> fetchVideosFromPlaylist({String playlistId}) async {
    Map<String, String> parameters = {
      'part': 'snippet',
      'playlistId': playlistId,
      'maxResults': '8',
      'pageToken': _nextPageToken,
      'key': 'AIzaSyDu29zC203WDgefAI4IGBaqvMhy3eHLMMQ',
    };
    Uri uri = Uri.https(
      _apiBaseUrl,
      '/youtube/v3/playlistItems',
      parameters,
    );
    Map<String, String> headers = {
      HttpHeaders.contentTypeHeader: 'application/json',
    };

    // Get Playlist Videos
    var response = await http.get(uri, headers: headers);
    if (response.statusCode == 200) {
      var data = json.decode(response.body);

      _nextPageToken = data['nextPageToken'] ?? '';
      List<dynamic> videosJson = data['items'];

      // Fetch first eight videos from uploads playlist
      List<Video> videos = [];
      videosJson.forEach(
        (json) => videos.add(
          Video.fromMap(json['snippet']),
        ),
      );
      return videos;
    } else {
      throw json.decode(response.body)['error']['message'];
    }
  }

  //Fetch List of CHannels
  Stream<List<Channel>> getListOfChannels(
      {@required List<String> channelListID}) async* {
    assert(channelListID != null);
    for (var i = 0; i < channelListID.length; i++) {
      Channel _channel = await this.fetchChannel(channelId: channelListID[i]);
      _channelList.add(_channel);
      yield _channelList;
    }
  }
}
