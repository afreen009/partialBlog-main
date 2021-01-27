import 'dart:convert';
import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:google_signin_example/model/channel_models.dart';
import 'package:google_signin_example/model/video_model.dart';
import 'package:http/http.dart' as http;

class APIService {
  APIService._instantiate();

  static final APIService instance = APIService._instantiate();

  final String _baseUrl = 'www.googleapis.com';
  String _nextPageToken = '';

  Future<Channel> fetchChannel({String channelId}) async {
    Map<String, String> parameters = {
      'part': 'snippet, contentDetails, statistics',
      'id': channelId,
      'key': 'AIzaSyDu29zC203WDgefAI4IGBaqvMhy3eHLMMQ',
    };
    Uri uri = Uri.https(
      _baseUrl,
      '/youtube/v3/channels',
      parameters,
    );
    Map<String, String> headers = {
      HttpHeaders.contentTypeHeader: 'application/json',
    };

    // Get Channel
    var response = await http.get(uri, headers: headers);
    if (response.statusCode == 200) {
      Map<String, dynamic> data = json.decode(response.body)['items'][0];
      Channel channel = Channel.fromMap(data);

      // Fetch first batch of videos from uploads playlist
      channel.videos = await fetchVideosFromPlaylist(
        playlistId: channel.uploadPlaylistId,
      );
      return channel;
    } else {
      throw json.decode(response.body)['error']['message'];
    }
  }

  Future<List<Video>> fetchVideosFromPlaylist({String playlistId}) async {
    Map<String, String> parameters = {
      'part': 'snippet',
      'playlistId': playlistId,
      'maxResults': '8',
      'pageToken': _nextPageToken,
      'key': 'AIzaSyDu29zC203WDgefAI4IGBaqvMhy3eHLMMQ',
    };
    Uri uri = Uri.https(
      _baseUrl,
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

//can u see whats the error
  //Fetch List of CHannels
  Stream<List<Channel>> getListOfChannels(
      {@required List<String> channelListID}) async* {
    assert(channelListID != null);
    List<Channel> _channelList = [];

    for (var i = 0; i < channelListID.length; i++) {
      Channel _channel = await this.fetchChannel(channelId: channelListID[i]);
      _channelList.add(_channel);
      yield _channelList;
    }
  }
}

// import 'dart:convert';
// import 'dart:io';
// import 'package:flutter/foundation.dart';
// import 'package:google_signin_example/model/channel_models.dart';
// import 'package:google_signin_example/model/video_model.dart';
// import 'package:http/http.dart' as http;

// class APIService {
//   APIService._instantiate();

//   static final APIService instance = APIService._instantiate();

//   final String _baseUrl = 'www.googleapis.com';
//   String _nextPageToken = '';

//   Future<Channel> fetchChannel({String channelId}) async {
//     Map<String, String> parameters = {
//       'part': 'snippet, contentDetails, statistics',
//       'id': channelId,
//       'key': 'AIzaSyDu29zC203WDgefAI4IGBaqvMhy3eHLMMQ',
//     };
//     Uri uri = Uri.https(
//       _baseUrl,
//       '/youtube/v3/channels',
//       parameters,
//     );
//     Map<String, String> headers = {
//       HttpHeaders.contentTypeHeader: 'application/json',
//     };

//     // Get Channel
//     var response = await http.get(uri, headers: headers);
//     if (response.statusCode == 200) {
//       Map<String, dynamic> data = json.decode(response.body)['items'][0];
//       Channel channel = Channel.fromMap(data);

//       // Fetch first batch of videos from uploads playlist
//       //so whats the error, let see I don't know much for now, okyes
//       //should i run it again?hello o o o o o hello yeah oo sorry . Re run the app again yeah, run it in debug mode
//       //a min till it runs ok? I'm not getting you. ill brb in a min, u can see the screen here ok? just a min ok?ok? I can see ok continue plz :) Yeah  not problem
//       channel.videos = await fetchVideosFromPlaylist(
//         playlistId: channel.uploadPlaylistId,
//       );
//       return channel;
//     } else {
//       throw json.decode(response.body)['error']['message'];
//     }
//   }

//   Future<List<Video>> fetchVideosFromPlaylist({String playlistId}) async {
//     Map<String, String> parameters = {
//       'part': 'snippet',
//       'playlistId': playlistId,
//       'maxResults':
//           '8', // FOr each video fetch it will just fetch for8 video of tha chennel, then in totlal you 've 32 video at the first load normally
//       //i see, so now uwill come in after for other loadmore option right?eah eactly ok npthen I'll be disconnec
//       'pageToken': _nextPageToken,
//       'key': 'AIzaSyDu29zC203WDgefAI4IGBaqvMhy3eHLMMQ',
//     };
//     Uri uri = Uri.https(
//       _baseUrl,
//       '/youtube/v3/playlistItems',
//       parameters,
//     );
//     Map<String, String> headers = {
//       HttpHeaders.contentTypeHeader: 'application/json',
//     };

//     // Get Playlist Videos
//     var response = await http.get(uri, headers: headers);
//     if (response.statusCode == 200) {
//       var data = json.decode(response.body);

//       _nextPageToken = data['nextPageToken'] ?? '';
//       List<dynamic> videosJson = data['items'];

//       // Fetch first eight videos from uploads playlist
//       List<Video> videos = [];
//       videosJson.forEach(
//         (json) => videos.add(
//           Video.fromMap(json['snippet']),
//         ),
//       );
//       return videos;
//     } else {
//       throw json.decode(response.body)['error']['message'];
//     }
//   }

//   //this is the error i got u there?
//   //Fetch List of CHannels
//   Stream<List<Channel>> getListOfChannels(
//       {@required List<String> channelListID}) async* {
//     assert(channelListID != null);
//     List<Channel> _channelList = [];

//     for (var i = 0; i < channelListID.length; i++) {
//       Channel _channel = await this.fetchChannel(channelId: channelListID[i]);
//       _channelList.add(_channel);
//       yield _channelList;
//       //?? Thinking ,haha sure :) let see yours till that my code?yes I worked I think but there is index error, shall i change? to mine?yes , but tell me if your worked already
//       //yeYes  i  had put all 4 ids and was able to fetch let me show ok?Yes
//     }
//   }
//   //one min is this ur code , i mean ur ui o there?
//   //This is the code I wrote for the fetch list channel ok but the ui? np u continue. continue o .sorry to disturb o no problem
//   //That red point is just a breakpoint but that way the app (or the runtime) will be stop at that place (when that part will be reach )yea great
//   //did u test ur app?Yeah I tested you mean the extension I guess yea the extension eah tested but an issue on my side then we'll to do it asap
//   //ok let me show u the screen
//   //o y is it taking this much time, is my internet slow?Hm may be but also it fetch from different channel then It takes a bit more time thy I used stream
//   //ohk
// }
