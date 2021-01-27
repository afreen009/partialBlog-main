import 'package:flutter/material.dart';
import 'package:google_signin_example/model/post_entity.dart';
import 'package:share/share.dart';

class SharingPost extends StatefulWidget {
  @override
  _SharingPostState createState() => _SharingPostState();
}

class _SharingPostState extends State<SharingPost> {
  String text = '';
  String subject = '';
  sharePost(BuildContext context, PostEntity post) {
    final RenderBox box = context.findRenderObject();
    Share.shareFiles(['${post.link}'],
        text: post.title,
        subject: post.link,
        sharePositionOrigin: box.localToGlobal(Offset.zero) & box.size);
  }

  @override
  Widget build(BuildContext context) {
    return Container();
  }
}
