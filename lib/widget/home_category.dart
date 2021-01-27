import 'package:flutter/material.dart';
import 'package:google_signin_example/widget/post_card.dart';
import 'package:shimmer/shimmer.dart';

import '../model/post_entity.dart';
import '../network/wp_api.dart';
import 'config.dart';
import 'home_post.dart';

class HomeCategory extends StatefulWidget {
  String url;
  HomeCategory(this.url);
  @override
  _HomeCategoryState createState() => _HomeCategoryState();
}

class _HomeCategoryState extends State<HomeCategory>
    with AutomaticKeepAliveClientMixin {
  List<PostEntity> posts = new List<PostEntity>();
  bool isLoading = true;

  @override
  void initState() {
    // print('here' + widget.url);
    super.initState();
    // print(FEATURED_CATEGORY_ID);
    WpApi.getPostsList(category: FEATURED_CATEGORY_ID, baseurl: widget.url)
        .then((_posts) {
      setState(() {
        isLoading = false;
        posts.addAll(_posts);
      });
    }).then((value) => print(posts));
  }

  @override
  Widget build(BuildContext context) {
    List<PostEntity> items = posts.reversed.toList();
    // print(items);
    super.build(context);
    return isLoading
        ? SizedBox(
            width: MediaQuery.of(context).size.width,
            height: 300.0,
            child: Shimmer.fromColors(
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Card(
                  color: Colors.grey,
                ),
              ),
              baseColor: Colors.white70,
              highlightColor: Colors.grey[700],
              direction: ShimmerDirection.ltr,
            ))
        : ListView.builder(
            itemCount: items?.length ?? 0,
            scrollDirection: Axis.horizontal,
            shrinkWrap: true,
//            physics: ClampingScrollPhysics(),
            itemBuilder: (context, index) {
              return HomePost(items[index], isFeaturedList: true);
            },
          );
  }

  @override
  bool get wantKeepAlive => true;
}
