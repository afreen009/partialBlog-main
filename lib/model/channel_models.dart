// import 'package:google_signin_example/model/video.dart';
// import 'package:google_signin_example/model/video_model.dart';

// class Channel {
//   final String id;
//   final String like;
//   final String favorites;
//   final String title;
//   final String profilePictureUrl;
//   final String subscriberCount;
//   final String videoCount;
//   final String uploadPlaylistId;
//   List<Video> videos;

//   Channel({
//     this.id,
//     this.like,
//     this.favorites,
//     this.title,
//     this.profilePictureUrl,
//     this.subscriberCount,
//     this.videoCount,
//     this.uploadPlaylistId,
//     this.videos,
//   });

//   factory Channel.fromMap(Map<String, dynamic> map) {
//     return Channel(
//       id: map['id'],
//       like: map['contentDetails']['relatedPlaylists']['likes'],
//       favorites: map['contentDetails']['relatedPlaylists']['favorites'],
//       title: map['snippet']['title'],
//       profilePictureUrl: map['snippet']['thumbnails']['default']['url'],
//       subscriberCount: map['statistics']['subscriberCount'],
//       videoCount: map['statistics']['videoCount'],
//       uploadPlaylistId: map['contentDetails']['relatedPlaylists']['uploads'],
//     );
//   }
// }
