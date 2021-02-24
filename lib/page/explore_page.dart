import 'package:flutter/material.dart';
import 'package:google_signin_example/widget/config.dart';
import 'package:google_signin_example/widget/post_list_item.dart';
import '../model/post_entity.dart';
import '../network/wp_api.dart';

class ExplorePage extends StatefulWidget {
  int category = 0;
  List<String> baseurl;
  String option;
  ExplorePage({this.category = 0, this.baseurl, this.option});

  @override
  _ExplorePageState createState() => _ExplorePageState();
}

class _ExplorePageState extends State<ExplorePage> {
  List<PostEntity> posts = new List<PostEntity>();
  // List<String> urls = [
  //   'https://enginejunkies.com/',
  //   'http://festivalsofearth.com/',
  //   'http://insuranceofearth.com/',
  //   'https://bookworms99.com/'
  // ];
  int page = 0;
  ScrollController _scrollController = new ScrollController();
  bool isLoading = true;
  Color primaryColor = Color(0xff18203d);
  Color secondaryColor = Color(0xff232c51);
  Color logoGreen = Color(0xff25bcbb);
  void getData() {
    if (!isLoading) {
      setState(() {
        page++;
        isLoading = true;
      });

      // WpApi.getPostsList(
      //         category: widget.category, page: page, baseurl: widget.baseurl)
      //     .then((_posts) {
      //   setState(() {
      //     isLoading = false;
      //     posts.addAll(_posts);
      //   });
      // });
    }
  }

  @override
  void initState() {
    super.initState();
    for (int i = 0; i < widget.baseurl.length; i++) {
      WpApi.getPostsList(
              category: FEATURED_CATEGORY_ID, baseurl: widget.baseurl[i])
          .then((_posts) {
        setState(() {
          isLoading = false;
          posts.addAll(_posts);
        });
      }).then((value) => print(posts));
    }
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: widget.option == 'view'
          ? AppBar(
              iconTheme: IconThemeData(
                color: Colors.white, //change your color here
              ),
              backgroundColor: primaryColor,
              automaticallyImplyLeading: true,
              title: Text(
                'All Posts',
                style: TextStyle(color: Colors.white),
              ),
            )
          : null,
      body: SingleChildScrollView(
        child: Container(
          child: Column(
            children: [
              ListView.builder(
                itemBuilder: postTile,
                itemCount: posts.length + 1,
                scrollDirection: Axis.vertical,
                shrinkWrap: true,
                physics: ClampingScrollPhysics(),
                controller: _scrollController,
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget postTile(BuildContext context, int index) {
    if (index == posts.length) {
      return _buildProgressIndicator();
    } else {
      return PostListItem(posts[index]);
      // return posts[index].image.isNotEmpty
      //     ? Card(
      //         child: Container(child: Image.network(posts[index].image)),
      //       )
      //     : Container(
      //         child: Center(
      //           child: Text('no image'),
      //         ),
      //       );
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
