import 'package:flutter/material.dart';
import 'package:google_signin_example/widget/post_card.dart';
import 'package:shimmer/shimmer.dart';

import '../model/post_entity.dart';
import '../network/wp_api.dart';
import 'config.dart';

class FeaturedCategoryList extends StatefulWidget {
  String url;
  FeaturedCategoryList(this.url);
  @override
  _FeaturedCategoryListState createState() => _FeaturedCategoryListState();
}

class _FeaturedCategoryListState extends State<FeaturedCategoryList>
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
              return PostCard(items[index], isFeaturedList: true);
            },
          );
  }

  @override
  bool get wantKeepAlive => true;
}

// import 'package:flutter/material.dart';
// import 'package:wordpress_flutter/widgets/post_card.dart';

// import '../config.dart';
// import '../model/post_entity.dart';

// class FeaturedCategoryList extends StatefulWidget {
//   String url;
//   FeaturedCategoryList({this.url});
//   @override
//   _FeaturedCategoryListState createState() => _FeaturedCategoryListState();
// }

// class _FeaturedCategoryListState extends State<FeaturedCategoryList> with AutomaticKeepAliveClientMixin {
//   List<PostEntity> posts = new List<PostEntity>();
//   bool isLoading = true;
//   var data ;
//   @override
//   void initState() {
//     super.initState();
//     // data = fetchData();
//     // WpApi.getPostsList(category: FEATURED_CATEGORY_ID).then((_posts) {
//     //   setState(() {
//     //     isLoading = false;
//     //     posts.addAll(_posts);
//     //   });
//     // });

//   }

//   @override
//   Widget build(BuildContext context) {
//     return SafeArea(
//       child: FutureBuilder<List>(
//         future: fetchData(widget.url),
//         builder: (context, snapshot) {
//           if (snapshot.hasError)
//             return Scaffold(
//               body: Center(
//                 child: Text("Error"),
//               ),
//             );
//           if (snapshot.hasData) {

//             return Scaffold(
//               // appBar: AppBar(
//               //   elevation: 0,
//               //   title: Text(
//               //     "Cybdom Blog",
//               //     style: Theme.of(context)
//               //         .textTheme
//               //         .headline6
//               //         .copyWith(color: Colors.black),
//               //   ),
//               //   // actions: <Widget>[
//               //   //   Padding(
//               //   //     padding: const EdgeInsets.all(9.0),
//               //   //     child: ClipRRect(
//               //   //       borderRadius: BorderRadius.circular(9),
//               //   //       child: Image.network(
//               //   //         "${snapshot.data[0].avatarURL}",
//               //   //         fit: BoxFit.cover,
//               //   //       ),
//               //   //     ),
//               //   //   )
//               //   // ],
//               // ),
//               body: ListView.builder(
//             itemCount: snapshot.data?.length ?? 0,
//             scrollDirection: Axis.horizontal,
//             shrinkWrap: true,
// //            physics: ClampingScrollPhysics(),
//             itemBuilder: (context, index) {
//               Map wpPost = snapshot.data[index];
//               var media = wpPost['excerpt']["rendered"];
//               var imageUrl = wpPost['_embedded']["wp:featuredmedia"] != null ? wpPost['_embedded']["wp:featuredmedia"][0]['source_url'] : '0';
//               List image = [];
//               image.add(imageUrl);
//               return PostCard(wpPost,imageUrl, isFeaturedList: true);
//             },)
//           );
//           } else {
//             return Scaffold(
//               body: Center(
//                 child: CircularProgressIndicator(),
//               ),
//             );
//           }
//         },
//       ),
//     );
//   }
// //   @override
// //   Widget build(BuildContext context) {
// //     super.build(context);
// //     return isLoading
// //         ? Center(
// //             child: CircularProgressIndicator(),
// //           )
// //         : ListView.builder(
// //             itemCount: posts?.length ?? 0,
// //             scrollDirection: Axis.horizontal,
// //             shrinkWrap: true,
// // //            physics: ClampingScrollPhysics(),
// //             itemBuilder: (context, index) {
// //               return PostCard(posts[index], isFeaturedList: true);
// //             },
// //           );
// //   }

//   @override
//   bool get wantKeepAlive => true;
// }
