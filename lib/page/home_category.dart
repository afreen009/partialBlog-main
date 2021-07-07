import 'package:admob_flutter/admob_flutter.dart';
import 'package:flutter/material.dart';
import 'package:flutter_swiper/flutter_swiper.dart';
import 'package:google_signin_example/database/databasehelep.dart';
import 'package:google_signin_example/database/db_model.dart';
import 'package:google_signin_example/network/youtube_channel.dart';
import 'package:google_signin_example/page/post_details.dart';
import 'package:google_signin_example/widget/config.dart';
import 'package:intl/intl.dart';
import 'package:shimmer/shimmer.dart';

import '../model/post_entity.dart';
import '../network/wp_api.dart';

class HomeCategory extends StatefulWidget {
  final String option;
  final List<String> url;
  // final List<PostEntity> data;
  HomeCategory({this.url, this.option});
  @override
  _HomeCategoryState createState() => _HomeCategoryState();
}

class _HomeCategoryState extends State<HomeCategory>
    with AutomaticKeepAliveClientMixin {
  List<PostEntity> posts = new List<PostEntity>();
  bool isLoading = true;
  YoutubeResponse youtubeResponse = new YoutubeResponse();
  List videoList;
  GlobalKey<ScaffoldState> scaffoldState = GlobalKey();
  Color primaryColor = Color(0xff18203d);
  AdmobReward reward;
  @override
  void initState() {
    // //'here' + widget.url);
    super.initState();

    getVideo();
  }

  void getVideo() async {
    for (int i = 0; i < widget.url.length; i++) {
      WpApi.getPostsList(
              category: FEATURED_CATEGORY_ID, baseurl: widget.url[i], page: 2)
          .then((_posts) {
        setState(() {
          isLoading = false;
          posts.addAll(_posts);
        });
      });
    }
    // videoList = await youtubeResponse.initChannel();
  }

  @override
  Widget build(BuildContext context) {
    // items.forEach((element) => videoList.add(element));
    // var newList = items + videoList;
    // posts.shuffle();
    //videoList);
    super.build(context);
    return isLoading || posts.isEmpty
        ? Scaffold(
            key: scaffoldState,
            body: Container(
              width: MediaQuery.of(context).size.width,
              child: ListView.builder(
                itemCount: 7,
                scrollDirection: Axis.horizontal,
                primary: false,
                itemBuilder: (context, index) {
                  return SizedBox(
                      width: 150,
                      height: 150.0,
                      child: Shimmer.fromColors(
                        child: Swiper(
                          itemBuilder: (BuildContext context, int index) {
                            return Card(
                              color: Colors.white,
                            );
                          },
                          // pagination: new SwiperPagination(),
                          // control: new SwiperControl(),

                          itemCount: posts.length,
                          viewportFraction: 0.9,
                          scale: 0.8,
                        ),
                        baseColor: Colors.white,
                        highlightColor: Colors.grey,
                        direction: ShimmerDirection.ltr,
                      ));
                },
              ),
            ),
          )
        : Swiper(
            itemBuilder: (BuildContext context, int index) {
              return Stack(
                children: [
                  GestureDetector(
                    onTap: () async {
                      print("tapped");

                      DateTime date = DateTime.now();
                      var newDt = DateFormat.yMMMEd().format(date);

                      //storing data locally - SQFLITE
                      await PersonDatabaseProvider.db
                          .addPersonToDatabase(DbModel(
                        name: posts[index].image,
                        date: posts[index].date,
                      ));

                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => PostDetails(posts[index])));
                    },
                    child: Container(
                      height: 140,
                      decoration: BoxDecoration(
                          color: Colors.white10,
                          // border: Border(
                          //     bottom: BorderSide(
                          //       color: Colors.grey[300],
                          //       width: 0.5,
                          //     ),
                          //   ),
                          borderRadius: BorderRadius.circular(10)),
                      child: Center(
                        child: posts[index].image.isNotEmpty
                            ? ClipRRect(
                                borderRadius: BorderRadius.circular(10.0),
                                child: Image.network(
                                  posts[index].image,
                                  fit: BoxFit.fill,
                                ))
                            : Center(
                                child: Image.asset(
                                  "assets/no-image.png",
                                  fit: BoxFit.cover,
                                ),
                              ),
                      ),
                    ),
                  ),
                  Positioned(
                    bottom: 0,
                    top: 100,
                    left: 0,
                    right: 0,
                    child: Container(
                        decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.only(
                                bottomLeft: Radius.circular(10),
                                bottomRight: Radius.circular(10))),
                        child: Padding(
                          padding: const EdgeInsets.only(
                              left: 8.0, right: 8.0, top: 8.0),
                          child: Text(
                            posts[index].title,
                            textAlign: TextAlign.left,
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                            style: TextStyle(
                                color: const Color(0xFF212121),
                                fontSize: 14,
                                fontWeight: FontWeight.bold),
                          ),
                        )),
                  )
                ],
              );
            },
            // pagination: new SwiperPagination(),
            control: new SwiperControl(),

            itemCount: posts.length,
            viewportFraction: 0.7,
            scale: 0.8,
          );
    // : ListView.builder(
    //     primary: false,
    //     itemCount: 5,
    //     scrollDirection: Axis.horizontal,
    //     shrinkWrap: true,
    //     physics: ClampingScrollPhysics(),
    //     itemBuilder: (context, index) {
    //       return HomePost(
    //         posts[index],
    //         isFeaturedList: true,
    //         option: widget.option,
    //       );
    //     },
    //   );
  }

  @override
  bool get wantKeepAlive => true;
}
