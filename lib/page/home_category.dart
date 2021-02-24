import 'package:flutter/material.dart';
import 'package:google_signin_example/model/video.dart';
import 'package:google_signin_example/network/youtube_channel.dart';
import 'package:google_signin_example/widget/config.dart';
import 'package:shimmer/shimmer.dart';

import '../model/post_entity.dart';
import '../network/wp_api.dart';
import 'home_post.dart';

class HomeCategory extends StatefulWidget {
  final String option;
  final List<PostEntity> data;
  HomeCategory({this.data, this.option});
  @override
  _HomeCategoryState createState() => _HomeCategoryState();
}

class _HomeCategoryState extends State<HomeCategory>
    with AutomaticKeepAliveClientMixin {
  // List<PostEntity> posts = new List<PostEntity>();
  bool isLoading = true;
  YoutubeResponse youtubeResponse = new YoutubeResponse();
  List videoList;
  @override
  void initState() {
    // print('here' + widget.url);
    super.initState();
    getVideo();
  }

  void getVideo() async {
    // for (int i = 0; i < widget.url.length; i++) {
    //   WpApi.getPostsList(category: FEATURED_CATEGORY_ID, baseurl: widget.url[i])
    //       .then((_posts) {
    //     posts.addAll(_posts);
    //   }).then((value) => isLoading = false);
    // }
    videoList = await youtubeResponse.initChannel();
  }

  @override
  Widget build(BuildContext context) {
    // items.forEach((element) => videoList.add(element));
    // var newList = items + videoList;
    // newList.shuffle();
    print(videoList);
    super.build(context);
    return isLoading
        ? SizedBox(
            width: MediaQuery.of(context).size.width / 2,
            height: 300.0,
            child: ListView.builder(
              itemCount: 10,
              scrollDirection: Axis.horizontal,
              itemBuilder: (context, index) {
                return Shimmer.fromColors(
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Card(
                      color: Colors.grey,
                    ),
                  ),
                  baseColor: Colors.white70,
                  highlightColor: Colors.grey[700],
                  direction: ShimmerDirection.ltr,
                );
              },
            ))
        : ListView.builder(
            primary: false,
            itemCount: 5,
            scrollDirection: Axis.horizontal,
            shrinkWrap: true,
            physics: ClampingScrollPhysics(),
            itemBuilder: (context, index) {
              return widget.data.isNotEmpty
                  ? HomePost(
                      widget.data[index],
                      isFeaturedList: true,
                      option: widget.option,
                      videoList:
                          videoList[index] != null ? videoList[index] : [],
                    )
                  : Container();
            },
          );
  }

  @override
  bool get wantKeepAlive => true;
}
