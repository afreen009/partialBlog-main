// import 'package:flutter/material.dart';
// import 'package:google_signin_example/helpers/constants.dart';
// import 'package:google_signin_example/model/channel_models.dart';
// import 'package:google_signin_example/model/video_model.dart';
// import 'package:google_signin_example/screens/video_screen.dart';
// import 'package:google_signin_example/services/api_services.dart';

// class VideoPlayerApp extends StatefulWidget {
//   @override
//   _VideoPlayerAppState createState() => _VideoPlayerAppState();
// }

// class _VideoPlayerAppState extends State<VideoPlayerApp> {
//   Channel _channel;
//   bool _isLoading = false;
//   Color primaryColor = Color(0xff18203d);
//   Color secondaryColor = Color(0xff232c51);
//   Color logoGreen = Color(0xff25bcbb);
//   @override
//   void initState() {
//     super.initState();
//     _initChannel();
//   }

//   _initChannel() async {
//     Channel channel = await APIService.instance
//         .fetchChannel(channelId: 'UCgpDrKxkgzFYKPh1wOQuY8Q');

//     setState(() {
//       _channel = channel;
//     });
//   }

// //Where is the playlist code I pushed ?I jusr want to code py and that code i dint push oI unders

//   // _buildProfileInfo() {
//   //   return Container(
//   //     margin: EdgeInsets.all(20.0),
//   //     padding: EdgeInsets.all(20.0),
//   //     height: 100.0,
//   //     decoration: BoxDecoration(
//   //       color: Colors.white,
//   //       borderRadius: BorderRadius.all(Radius.circular(10)),
//   //       boxShadow: [
//   //         BoxShadow(
//   //           color: Colors.black12,
//   //           offset: Offset(0, 1),
//   //           blurRadius: 6.0,
//   //         ),
//   //       ],
//   //     ),
//   //     child: Row(
//   //       children: <Widget>[
//   //         CircleAvatar(
//   //           backgroundColor: Colors.white,
//   //           radius: 35.0,
//   //           backgroundImage: NetworkImage(_channel.profilePictureUrl),
//   //         ),
//   //         SizedBox(width: 12.0),
//   //         Expanded(
//   //           child: Column(
//   //             mainAxisAlignment: MainAxisAlignment.center,
//   //             crossAxisAlignment: CrossAxisAlignment.start,
//   //             children: <Widget>[
//   //               Text(
//   //                 _channel.title + _channel.like,
//   //                 style: TextStyle(
//   //                   color: Colors.black,
//   //                   fontSize: 20.0,
//   //                   fontWeight: FontWeight.w600,
//   //                 ),
//   //                 overflow: TextOverflow.ellipsis,
//   //               ),
//   //               Text(
//   //                 '${_channel.subscriberCount} subscribers',
//   //                 style: TextStyle(
//   //                   color: Colors.grey[600],
//   //                   fontSize: 16.0,
//   //                   fontWeight: FontWeight.w600,
//   //                 ),
//   //                 overflow: TextOverflow.ellipsis,
//   //               ),
//   //             ],
//   //           ),
//   //         )
//   //       ],
//   //     ),
//   //   );
//   // }

//   _buildVideo(Video video) {
//     return Column(
//       children: [
//         GestureDetector(
//           onTap: () => Navigator.push(
//             context,
//             MaterialPageRoute(
//               builder: (_) => VideoScreen(id: video.id),
//             ),
//           ),
//           child: Container(
//             width: MediaQuery.of(context).size.width,
//             decoration: BoxDecoration(
//               color: Colors.white,
//               borderRadius: BorderRadius.all(Radius.circular(15)),
//               boxShadow: [
//                 BoxShadow(
//                   color: Colors.black12,
//                   offset: Offset(0, 1),
//                   blurRadius: 6.0,
//                 ),
//               ],
//             ),
//             child: Image(image: NetworkImage(video.thumbnailUrl)),
//           ),
//         ),
//         Container(
//           height: 45,
//           width: double.infinity,
//           // decoration: BoxDecoration(
//           //     borderRadius: BorderRadius.only(
//           //         bottomRight: Radius.circular(10),
//           //         bottomLeft: Radius.circular(10)),
//           //     color: Colors.grey),
//           child: Padding(
//             padding: EdgeInsets.all(8.0),
//             child: Row(
//               children: [
//                 CircleAvatar(
//                   backgroundColor: Colors.white,
//                   radius: 20.0,
//                   backgroundImage: NetworkImage(_channel.profilePictureUrl),
//                 ),
//                 Expanded(child: Text('  ' + video.title)),
//               ],
//             ),
//           ),
//         ),
//         SizedBox(
//           height: 15,
//         )
//       ],
//     );
//   }

//   _loadMoreVideos() async {
//     _isLoading = true;
//     List<Video> moreVideos = await APIService.instance
//         .fetchVideosFromPlaylist(playlistId: _channel.uploadPlaylistId);
//     List<Video> allVideos = _channel.videos..addAll(moreVideos);
//     setState(() {
//       _channel.videos = allVideos;
//     });
//     _isLoading = false;
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       body: (1 != 2)
//           ?
// //It alradey one
//           Padding(
//               padding: const EdgeInsets.only(top: 8.0),
//               child: StreamBuilder<List<Channel>>(
//                 stream: APIService.instance
//                     .getListOfChannels(channelListID: CHANNEL_ID_LIST),
//                 builder: (context, snapshot) {
//                   print(snapshot.data);
//                   if (snapshot.hasData) {
//                     List<Video> _totalVideo = [];
//                     snapshot.data.forEach((channel) {
//                       channel.videos.forEach((video) => _totalVideo.add(video));
//                     });
//                     return ListView.builder(
//                         itemCount: _totalVideo.length,
//                         itemBuilder: (context, index) =>
//                             _buildVideo(_totalVideo[index]));
//                   } else if (snapshot.connectionState ==
//                           ConnectionState.active ||
//                       snapshot.connectionState == ConnectionState.waiting) {
//                     return Center(
//                       child: CircularProgressIndicator(),
//                     );
//                   }
//                   //ALl is done I think , just the time do not allow me to do the load more thingf for nor, nut I'll do when I'll got time afternoon if I find you online ,
// // Areyou there ?yea yea  so what is remaining, the remaining is to add loadMoreVideo feature, because the video must be load from different channel at the same time
//                   //so if i run now what is the screen i see, what will it have all videos?yeah It will have all the video as you know
//                   return Center(
//                     child: Column(
//                       mainAxisAlignment: MainAxisAlignment.center,
//                       children: [
//                         Text('Be sure your internet is fine and retry'),
//                         FlatButton(
//                           color: Colors.grey[400],
//                           child: Text(
//                             'Retry again',
//                           ),
//                           onPressed: () => this.setState(() {}),
//                         )
//                       ],
//                     ),
//                   );
//                 },
//               ),
//             )
//           : _channel != null
//               ? NotificationListener<ScrollNotification>(
//                   onNotification: (ScrollNotification scrollDetails) {
//                     if (!_isLoading &&
//                         _channel.videos.length !=
//                             int.parse(_channel.videoCount) &&
//                         scrollDetails.metrics.pixels ==
//                             scrollDetails.metrics.maxScrollExtent) {
//                       _loadMoreVideos();
//                     }
//                     return false;
//                   },
//                   child: Padding(
//                     padding: const EdgeInsets.only(top: 8.0),
//                     child: ListView.builder(
//                       itemCount: 1 + _channel.videos.length,
//                       itemBuilder: (BuildContext context, int index) {
//                         if (index == 0) {
//                           return Container();
//                         }
//                         Video video = _channel.videos[index - 1];
//                         return _buildVideo(video);
//                       },
//                     ),
//                   ),
//                 )
//               : Center(
//                   child: CircularProgressIndicator(
//                     valueColor: AlwaysStoppedAnimation<Color>(
//                       Theme.of(context).primaryColor, // Red
//                     ),
//                   ),
//                 ),
//     );
//   }
// }
