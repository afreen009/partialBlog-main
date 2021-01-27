import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:google_signin_example/widget/helpers.dart';
import 'package:google_signin_example/widget/post_card.dart';
import 'package:flutter_web_browser/flutter_web_browser.dart';
import '../model/post_entity.dart';

class PostDetails extends StatefulWidget {
  final PostEntity post;

  PostDetails(this.post);

  @override
  _PostDetailsState createState() => _PostDetailsState();
}

class _PostDetailsState extends State<PostDetails> {
  openBrowserTab(url) async {
    await FlutterWebBrowser.openWebPage(
        url: url.toString(),
        customTabsOptions: CustomTabsOptions(
          colorScheme: CustomTabsColorScheme.dark,
          toolbarColor: Colors.deepPurple,
          secondaryToolbarColor: Colors.green,
          navigationBarColor: Colors.amber,
          addDefaultShareMenuItem: true,
          instantAppsEnabled: true,
          showTitle: true,
          urlBarHidingEnabled: true,
        )
        // androidToolbarColor: Colors.deepPurple,
        );
  }

  @override
  Widget build(BuildContext context) {
    // print(post);
    widget.post.isDetailCard = true;
    return Scaffold(
      resizeToAvoidBottomPadding: false,
      body: NestedScrollView(
        headerSliverBuilder: (BuildContext context, bool innerBoxIsScrolled) {
          Size size = MediaQuery.of(context).size;
          return <Widget>[
            SliverAppBar(
              iconTheme: IconThemeData(color: Colors.white),
              floating: true,
              expandedHeight: 300.0,
              flexibleSpace: FlexibleSpaceBar(
                background: Stack(
                  children: <Widget>[
                    widget.post.image.isNotEmpty
                        ? Hero(
                            tag: widget.post.image,
                            child: CachedImage(
                              widget.post.image,
                              width: size.width,
                              height: size.height,
                            ),
                          )
                        : Text('no image'),
                    Positioned(
                      child: Container(
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                              begin: Alignment.bottomCenter,
                              end: Alignment.topCenter,
                              colors: [Colors.amber, Colors.green]),
                        ),
                      ),
                    ),
                    Positioned(
                      bottom: 0,
                      child: Author(post: widget.post),
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
                                  widget.post.title,
                                  textAlign: TextAlign.left,
                                  style: TextStyle(
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
                      child: CategoryPill(post: widget.post),
                    ),
                  ],
                ),
              ),
            )
          ];
        },
        body: SingleChildScrollView(
          child: Html(
            data: widget.post.content,
            onLinkTap: (url) async {
              print("Opening $url...");
              await openBrowserTab(url);
            },
            padding: EdgeInsets.all(8.0),
            linkStyle: const TextStyle(
              color: Colors.blueAccent,
              decorationColor: Colors.blueAccent,
              decoration: TextDecoration.underline,
            ),
          ),
        ),
      ),
    );
  }
}
