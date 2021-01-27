import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';

import '../model/post_entity.dart';
import '../network/wp_api.dart';
import 'post_list_item.dart';

class PostsList extends StatefulWidget {
  int category = 0;
  String baseurl;

  PostsList({this.category = 0, this.baseurl});

  @override
  _PostsListState createState() => _PostsListState();
}

class _PostsListState extends State<PostsList> {
  List<PostEntity> posts = new List<PostEntity>();

  int page = 0;
  ScrollController _scrollController = new ScrollController();
  bool isLoading = false;

  void getData() {
    if (!isLoading) {
      setState(() {
        page++;
        isLoading = true;
      });

      WpApi.getPostsList(
              category: widget.category, page: page, baseurl: widget.baseurl)
          .then((_posts) {
        setState(() {
          isLoading = false;
          posts.addAll(_posts);
        });
      });
    }
  }

  @override
  void initState() {
    super.initState();
    getData();
    _scrollController.addListener(() {
      if (_scrollController.position.pixels ==
          _scrollController.position.maxScrollExtent) {
        getData();
      }
    });
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemBuilder: postTile,
      itemCount: posts.length + 1,
      scrollDirection: Axis.vertical,
      shrinkWrap: true,
      physics: ClampingScrollPhysics(),
      controller: _scrollController,
    );
  }

  Widget postTile(BuildContext context, int index) {
    if (index == posts.length) {
      return _buildProgressIndicator();
    } else {
      return PostListItem(posts[index]);
    }
  }

  Widget _buildProgressIndicator() {
    return null;
    // return SizedBox(
    //   width: 200.0,
    //   height: 400.0,
    //   child: ListView.builder(
    //       itemCount: 2,
    //       itemBuilder: (BuildContext context, int index) {
    //         return Padding(
    //           padding: const EdgeInsets.all(8.0),
    //           child: Shimmer.fromColors(
    //             baseColor: Colors.grey[300],
    //             highlightColor: Colors.white,
    //             child: Container(
    //               width: 100,
    //               height: 100,
    //               child: Card(
    //                 child: ListTile(
    //                   leading: Container(
    //                     width: 50,
    //                     height: 50,
    //                     child: CircleAvatar(
    //                       child: Container(),
    //                     ),
    //                   ),
    //                 ),
    //               ),
    //             ),
    //           ),
    //         );
    //       }),
    // );
  }
}
