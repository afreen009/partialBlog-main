import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:google_signin_example/database.dart';
import 'package:google_signin_example/widget/helpers.dart';
import 'package:google_signin_example/widget/post_card.dart';
import 'package:url_launcher/url_launcher.dart';

import '../model/post_entity.dart';

class PostDetails extends StatelessWidget {
  final PostEntity post;
  PostDetails(
    this.post,
  );
  FirebasesData fData = FirebasesData.instance;
  void _showToast(BuildContext context) {
    final scaffold = Scaffold.of(context);
    scaffold.showSnackBar(
      SnackBar(
        content: const Text('+10 points added'),
        // action: SnackBarAction(
        //     label: 'UNDO', onPressed: scaffold.hideCurrentSnackBar),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    // print(post);
    // //post);
    // post.isDetailCard = true;
    return Scaffold(
      // resizeToAvoidBottomPadding: false,
      body: NestedScrollView(
        headerSliverBuilder: (BuildContext context, bool innerBoxIsScrolled) {
          Size size = MediaQuery.of(context).size;
          return <Widget>[
            SliverAppBar(
              iconTheme: IconThemeData(color: Colors.white),
              floating: true,
              expandedHeight: 100.0,
              flexibleSpace: FlexibleSpaceBar(
                background: Stack(
                  children: <Widget>[
                    post.image.isNotEmpty
                        ? CachedImage(
                            post.image,
                            width: size.width,
                            height: size.height,
                          )
                        : Container(
                            color: Colors.white,
                            child: Center(child: Text('no image'))),
                    // Positioned(
                    //   child: Container(
                    //     height: 200,
                    //     decoration: BoxDecoration(
                    //       gradient: LinearGradient(
                    //           begin: Alignment.bottomCenter,
                    //           end: Alignment.topCenter,
                    //           colors: [Colors.amber, Colors.green]),
                    //     ),
                    //   ),
                    // ),
                    Positioned(
                      bottom: 0,
                      child: Author(post: post),
                    ),
                    Positioned(
                      bottom: 35.0,
                      child: Container(
                          width: size.width,
                          child: Column(
                            children: <Widget>[
                              Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Text(
                                  post.title,
                                  textAlign: TextAlign.left,
                                  style: TextStyle(
                                      shadows: [
                                        BoxShadow(
                                          color: Colors.black,
                                          offset: Offset(0, 5),
                                          blurRadius: 10.0,
                                        )
                                      ],
                                      color: Colors.white,
                                      fontWeight: FontWeight.bold,
                                      fontSize: 18.0),
                                ),
                              ),
                            ],
                          )),
                    ),
                    Positioned(
                      bottom: 0,
                      right: 0,
                      child: CategoryPill(post: post),
                    ),
                  ],
                ),
              ),
            )
          ];
        },
        body: Scaffold(
          body: SingleChildScrollView(
            child: Column(
              children: [
                Html(
                  data: post.content,
                  onLinkTap: (url) async {
                    if (await canLaunch(url)) {
                      await launch(url);
                    } else {
                      throw 'Could not launch $url';
                    }
                  },
                  padding: EdgeInsets.all(8.0),
                  linkStyle: const TextStyle(
                    color: Colors.blueAccent,
                    decorationColor: Colors.blueAccent,
                    decoration: TextDecoration.underline,
                  ),
                ),
                // FlatButton(
                //   color: Color(0xFF0d1117),
                //   child: Text(
                //     'click to redeem points',
                //     style: TextStyle(color: Colors.white),
                //   ),
                //   onPressed: () {
                //     print('redeem');
                //     int points = this.points + 50;
                //     Map<String, dynamic> data = {
                //       'points': points,
                //     };
                //     fData.userCollection
                //         .doc(fData.usersname.uid)
                //         .set(data, SetOptions(merge: true))
                //         .then((e) {
                //       print('redeemed');
                //       _showToast(context);
                //     });
                //   },
                // )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
