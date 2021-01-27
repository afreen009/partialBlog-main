import 'package:flutter/material.dart';
import 'package:google_signin_example/page/post_details.dart';
import 'package:google_signin_example/page/sharing_post.dart';
import 'package:share/share.dart';

import '../model/post_entity.dart';
import 'helpers.dart';

class PostCard extends StatefulWidget {
  PostEntity post;
  bool isFeaturedList;
  static const List<String> choices = <String>[
    "share to...",
  ];
  PostCard(this.post, {this.isFeaturedList = false});

  @override
  _PostCardState createState() => _PostCardState();
}

class _PostCardState extends State<PostCard> {
  SharingPost share;

  String _selectedChoices;

  final shareData = SharingPost();

  void _select(String choice) {
    setState(() {
      _selectedChoices = choice;
    });
    // showSnackBar(choice);
  }

  sharePost(
    BuildContext context,
  ) {
    print(widget.post.link);
    final RenderBox box = context.findRenderObject();
    Share.share(widget.post.title + '\n' + widget.post.link,
        subject: widget.post.link,
        sharePositionOrigin: box.localToGlobal(Offset.zero) & box.size);
  }

  void showSnackBar(String selection) {
    final snackBarContent = SnackBar(
      content: Text('Selected: $selection'),
      action: SnackBarAction(
        label: 'Undo',
        onPressed: () {
          // Some code to undo the change.
        },
      ),
    );
    // _scaffoldkey.currentState.showSnackBar(snackBarContent);
  }

  @override
  Widget build(BuildContext context) {
    Color primaryColor = Color(0xff18203d);
    Color secondaryColor = Color(0xff232c51);
    // print(post);
    Size size = MediaQuery.of(context).size;
    double width = widget.isFeaturedList ? size.width * 0.8 : size.width;
    return GestureDetector(
      onTap: () {
        if (widget.isFeaturedList)
          Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) => PostDetails(widget.post)));
      },
      child: Padding(
        padding: EdgeInsets.all(widget.isFeaturedList ? 10.0 : 5.0),
        child: ClipRRect(
          borderRadius:
              BorderRadius.circular(widget.isFeaturedList ? 14.0 : 0.0),
          child: Material(
            elevation: 14.0,
            borderRadius: BorderRadius.circular(10.0),
            shadowColor: Theme.of(context).primaryColor.withOpacity(.5),
            child: SizedBox(
              height: 150.0,
              width: width,
              child: Stack(
                children: <Widget>[
                  Hero(
                    tag: widget.post.image,
                    child: widget.post.image.isNotEmpty
                        ? CachedImage(
                            widget.post.image,
                            width: width,
                            height: size.height,
                          )
                        : Center(
                            child: Text('no image'),
                          ),
                  ),
                  Positioned(
                      left: 0,
                      top: 10,
                      child: PopupMenuButton(
                        onSelected: (_select) => sharePost(context),
                        padding: EdgeInsets.zero,
                        // initialValue: choices[_selection],
                        itemBuilder: (BuildContext context) {
                          return PostCard.choices.map((String choice) {
                            return PopupMenuItem<String>(
                              value: choice,
                              child: Text(choice),
                            );
                          }).toList();
                        },
                      )),
                  Positioned(
                    right: 0,
                    child: CategoryPill(post: widget.post),
                  ),
                  Positioned(
                      right: 0,
                      bottom: 10,
                      child: PopupMenuButton(
                        onSelected: (_select) => sharePost(context),
                        padding: EdgeInsets.zero,
                        // initialValue: choices[_selection],
                        itemBuilder: (BuildContext context) {
                          return PostCard.choices.map((String choice) {
                            return PopupMenuItem<String>(
                              value: choice,
                              child: Text(choice),
                            );
                          }).toList();
                        },
                      )),
                  Positioned(
                    bottom: 0,
                    child: Container(
                      decoration: BoxDecoration(
                          gradient: LinearGradient(
                              begin: Alignment.bottomCenter,
                              end: Alignment.topCenter,
                              colors: [secondaryColor, primaryColor])),
                      width: width,
                      child: Padding(
                        padding: const EdgeInsets.only(
                            top: 15.0, bottom: 5.0, left: 5.0, right: 5.0),
                        child: Column(
                          children: <Widget>[
                            Padding(
                              padding: const EdgeInsets.all(3.0),
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
                        ),
                      ),
                    ),
                  ),
                  // Positioned(
                  //   child: Hero(tag: '${post.id}_author', child: Author(post: post)),
                  // )
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class CategoryPill extends StatelessWidget {
  const CategoryPill({
    Key key,
    @required this.post,
  }) : super(key: key);

  final PostEntity post;

  @override
  Widget build(BuildContext context) {
    Color primaryColor = Color(0xff18203d);
    return Padding(
      padding: const EdgeInsets.only(right: 5.0),
      child: Opacity(
        opacity: 0.8,
        child: MaterialButton(
          height: 26.0,
          onPressed: () {},
          color: primaryColor,
          child: Text(post.category.toUpperCase(),
              style: TextStyle(
                color: Colors.white,
                fontSize: 12.0,
              )),
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(20.0)),
        ),
      ),
    );
  }
}

class Author extends StatelessWidget {
  const Author({
    Key key,
    @required this.post,
  }) : super(key: key);

  final PostEntity post;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Row(
        children: <Widget>[
          ClipRRect(
            borderRadius: BorderRadius.circular(6.0),
            child: Image.network(
              post.extra.author[0].avatar,
              height: 26.0,
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(left: 8.0),
            child: Text(
              post.extra.author[0].name,
              style: TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
                fontSize: 14.0,
                shadows: <Shadow>[
                  Shadow(
                    offset: Offset(1.0, 1.0),
                    blurRadius: 5.0,
                    color: Colors.black,
                  ),
                  Shadow(
                    offset: Offset(1.0, 1.0),
                    blurRadius: 8.0,
                    color: Colors.black,
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
