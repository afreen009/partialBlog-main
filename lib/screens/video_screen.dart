import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:google_signin_example/database.dart';
import 'package:google_signin_example/providers/user_provder.dart';
import 'package:provider/provider.dart';
import 'package:youtube_player_flutter/youtube_player_flutter.dart';

class VideoScreen extends StatefulWidget {
  final String id;
  final String title;
  VideoScreen({this.id, this.title});

  @override
  _VideoScreenState createState() => _VideoScreenState();
}

class _VideoScreenState extends State<VideoScreen> {
  YoutubePlayerController _controller;
  bool _isPlayerReady;
  FirebasesData fData = FirebasesData.instance;

  void initState() {
    Future.delayed(Duration(seconds: 30), () => reward(context));
    super.initState();
    _isPlayerReady = false;
    _controller = YoutubePlayerController(
      initialVideoId: widget.id,
      flags: YoutubePlayerFlags(
        mute: false,
        autoPlay: true,
      ),
    )..addListener(_listener);
  }

  void _listener() {
    if (_isPlayerReady && mounted && !_controller.value.isFullScreen) {
      //
    }
  }

  reward(BuildContext context) async {
    UserProvider _userProvider =
        Provider.of<UserProvider>(context, listen: false);
    print('inside video reward');
    _userProvider.updatePoint(25);
    // await FirebasesData().updateUserPresence(points: widget.points + 25);
  }

  @override
  void deactivate() {
    _controller.pause();
    super.deactivate();
  }

  @override
  Widget build(BuildContext context) {
    print(widget.title);
    return Scaffold(
      // appBar: AppBar(),
      body: Container(
        child: Center(
          child: Container(
            child: YoutubePlayer(
              controller: _controller,
              showVideoProgressIndicator: true,
              onReady: () {
                print('Player is ready.');
                _isPlayerReady = true;
              },
            ),
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }
}
