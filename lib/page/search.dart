import 'dart:math';

import 'package:flappy_search_bar/flappy_search_bar.dart';
import 'package:flappy_search_bar/scaled_tile.dart';
import 'package:flutter/material.dart';
import 'package:google_signin_example/model/post_entity.dart';
import 'package:google_signin_example/network/wp_api.dart';
import 'package:dio/dio.dart';

class SearchPage extends StatefulWidget {
  // SearchPage({ Key key }) : super(key: key);
  @override
  _SearchPageState createState() => new _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {
  // final formKey = new GlobalKey<FormState>();
  // final key = new GlobalKey<ScaffoldState>();
  final TextEditingController _filter = new TextEditingController();
  final dio = new Dio();
  String _searchText = "";
  List names = new List();
  List filteredNames = new List();
  Icon _searchIcon = new Icon(Icons.search);
  Widget _appBarTitle = new Text('Search Example');

  _SearchPageState() {
    _filter.addListener(() {
      if (_filter.text.isEmpty) {
        setState(() {
          _searchText = "";
          filteredNames = names;
        });
      } else {
        setState(() {
          _searchText = _filter.text;
        });
      }
    });
  }

  @override
  void initState() {
    _getNames();
    this._getNames();
    super.initState();
  }

  Widget build(BuildContext context) {
    return Scaffold(
      appBar: _buildBar(context),
      body: Container(
        child: _buildList(),
      ),
      resizeToAvoidBottomPadding: false,
    );
  }

  Widget _buildBar(BuildContext context) {
    return new AppBar(
      centerTitle: true,
      title: _appBarTitle,
      leading: new IconButton(
        icon: _searchIcon,
        onPressed: _searchPressed,
      ),
    );
  }

  Widget _buildList() {
    if (!(_searchText.isEmpty)) {
      List tempList = new List();
      for (int i = 0; i < filteredNames.length; i++) {
        if (filteredNames[i]
            .toLowerCase()
            .contains(_searchText.toLowerCase())) {
          tempList.add(filteredNames[i]);
        }
      }
      filteredNames = tempList;
    }
    return ListView.builder(
      itemCount: names == null ? 0 : filteredNames.length,
      itemBuilder: (BuildContext context, int index) {
        return new ListTile(
          title: Text(filteredNames[index]),
          onTap: () => print(filteredNames[index]),
        );
      },
    );
  }

  void _searchPressed() {
    setState(() {
      if (this._searchIcon.icon == Icons.search) {
        this._searchIcon = new Icon(Icons.close);
        this._appBarTitle = new TextField(
          controller: _filter,
          decoration: new InputDecoration(
              prefixIcon: new Icon(Icons.search), hintText: 'Search...'),
        );
      } else {
        this._searchIcon = new Icon(Icons.search);
        this._appBarTitle = new Text('Search Example');
        filteredNames = names;
        _filter.clear();
      }
    });
  }

  void _getNames() async {
    final response = await dio.get('https://api.github.com/users/zellwk/repos');
    List tempList = new List();
    //u can continue okay
    for (int i = 0; i < response.data.length; i++) {
      print('response of api ' + response.data[i].toString());
      tempList.add(response.data[i]['name']);
    }
    setState(() {
      names = tempList;
      names.shuffle();
      filteredNames = names;
      print('filtered name are here $filteredNames');
    });
  }
  //Show me the video
}
// class Post {
//   final String title;
//   final String body;
//   final PostEntity data;
//   Post(this.title, this.body, this.data);
// }

// class SearchPage extends StatefulWidget {
//   @override
//   _SearchPageState createState() => _SearchPageState();
// }

// class _SearchPageState extends State<SearchPage> {
//   final SearchBarController<Post> _searchBarController = SearchBarController();
//   bool isReplay = false;
//   List<PostEntity> posts = new List<PostEntity>();

//   int page = 0;
//   bool isLoading = false;

//   void getData() {
//     if (!isLoading) {
//       setState(() {
//         page++;
//         isLoading = true;
//       });

//       WpApi.getPostsList(
//               category: 0, page: page, baseurl: 'https://enginejunkies.com/')
//           .then((_posts) {
//         setState(() {
//           isLoading = false;
//           posts.addAll(_posts);
//         });
//       });
//       WpApi.getPostsList(
//               category: 0, page: page, baseurl: 'http://festivalsofearth.com/')
//           .then((_posts) {
//         setState(() {
//           isLoading = false;
//           posts.addAll(_posts);
//         });
//       });
//       WpApi.getPostsList(
//               category: 0, page: page, baseurl: 'https://bookworms99.com/')
//           .then((_posts) {
//         setState(() {
//           isLoading = false;
//           posts.addAll(_posts);
//         });
//       });
//       WpApi.getPostsList(
//               category: 0, page: page, baseurl: 'http://insuranceofearth.com/')
//           .then((_posts) {
//         setState(() {
//           isLoading = false;
//           posts.addAll(_posts);
//         });
//       });
//     }
//   }

//   @override
//   void initState() {
//     super.initState();
//     getData();
//   }

//   Future<List<Post>> _getALlPosts(String text) async {
//     await Future.delayed(Duration(seconds: text.length == 4 ? 4 : 1));
//     // if (isReplay) return [Post("Replaying !", "Replaying body")];
//     // if (text.length == 5) throw Error();
//     // if (text.length == 6) return [];
//     List<Post> post = [];

//     for (int i = 0; i < posts.length; i++) {
//       post.add(Post("$text $i", "title : ${posts[i].title}", posts[i]));
//     }
//     return post;
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       body: SafeArea(
//         child: SearchBar<Post>(
//           searchBarPadding: EdgeInsets.symmetric(horizontal: 10),
//           headerPadding: EdgeInsets.symmetric(horizontal: 10),
//           listPadding: EdgeInsets.symmetric(horizontal: 10),
//           onSearch: _getALlPosts,
//           searchBarController: _searchBarController,
//           placeHolder: Center(child: Text("search ")),
//           cancellationWidget: Text("Cancel"),
//           emptyWidget: Text("empty"),
//           indexedScaledTileBuilder: (int index) =>
//               ScaledTile.count(1, index.isEven ? 2 : 1),
//           header: Row(
//             children: <Widget>[
//               RaisedButton(
//                 child: Text("sort"),
//                 onPressed: () {
//                   _searchBarController.sortList((Post a, Post b) {
//                     return a.body.compareTo(b.body);
//                   });
//                 },
//               ),
//               RaisedButton(
//                 child: Text("Desort"),
//                 onPressed: () {
//                   _searchBarController.removeSort();
//                 },
//               ),
//               RaisedButton(
//                 child: Text("Replay"),
//                 onPressed: () {
//                   isReplay = !isReplay;
//                   _searchBarController.replayLastSearch();
//                 },
//               ),
//             ],
//           ),
//           onCancelled: () {
//             print("Cancelled triggered");
//           },
//           mainAxisSpacing: 10,
//           crossAxisSpacing: 10,
//           crossAxisCount: 2,
//           onItemFound: (Post post, int index) {
//             return Container(
//               height: 70,
//               color: Colors.white,
//               child: ListTile(
//                 leading: Container(
//                   height: 50,
//                   width: 50,
//                   child: post.data.image.isNotEmpty
//                       ? Image.network(
//                           post.data.image,
//                           fit: BoxFit.contain,
//                         )
//                       : Text('no image'),
//                 ),
//                 title: Text(post.data.title),
//                 // isThreeLine: true,
//                 // subtitle: Text(post.body),
//                 onTap: () {
//                   Navigator.of(context).push(MaterialPageRoute(
//                       builder: (context) => Detail(post.data)));
//                 },
//               ),
//             );
//           },
//         ),
//       ),
//     );
//   }
// }

// class Detail extends StatelessWidget {
//   PostEntity data;
//   Detail(this.data);
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       body: SafeArea(
//         child: Column(
//           children: <Widget>[
//             IconButton(
//               icon: Icon(Icons.arrow_back),
//               onPressed: () => Navigator.of(context).pop(),
//             ),
//             Text(data.title),
//           ],
//         ),
//       ),
//     );
//   }
// }
