import 'package:flutter/material.dart';
import 'package:dio/dio.dart';
import 'package:google_signin_example/model/post_entity.dart';
import 'package:google_signin_example/network/wp_api.dart';
import 'package:google_signin_example/widget/config.dart';

class SearchPage extends StatefulWidget {
  // SearchPage({ Key key }) : super(key: key);
  @override
  _SearchPageState createState() => new _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {
  List<PostEntity> data = new List<PostEntity>();
  final TextEditingController _filter = new TextEditingController();
  final dio = new Dio();
  String _searchText = "";
  List names = new List();
  List filteredNames = new List();
  Icon _searchIcon = new Icon(Icons.search);
  Widget _appBarTitle = new Text('Search...');

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
  void _getNames() async {
    List tempList = new List();
    print('inside');
    WpApi.getPostsList(
            category: FEATURED_CATEGORY_ID,
            baseurl: 'https://festivalsofearth.com/')
        .then((_posts) {
      setState(() {
        // print('data is here$_posts');
        data.addAll(_posts);
        for (int i = 0; i < 5; i++) {
          // print("title" + data.toString());
          tempList.add(data[i].title);
        }
        setState(() {
          names = tempList;
          names.shuffle();
          filteredNames = names;
        });
      });
    });
    WpApi.getPostsList(
            category: FEATURED_CATEGORY_ID,
            baseurl: 'https://enginejunkies.com/')
        .then((_posts) {
      setState(() {
        // print('data is here$_posts');
        data.addAll(_posts);
        for (int i = 0; i < 5; i++) {
          // print("title" + data.toString());
          tempList.add(data[i].title);
        }
        setState(() {
          names = tempList;
          names.shuffle();
          filteredNames = names;
        });
      });
    });
    WpApi.getPostsList(
            category: FEATURED_CATEGORY_ID,
            baseurl: 'http://insuranceofearth.com/')
        .then((_posts) {
      setState(() {
        // ('data is here$_posts');
        data.addAll(_posts);
        for (int i = 0; i < 5; i++) {
          // print("title" + data.toString());
          tempList.add(data[i].title);
        }
        setState(() {
          names = tempList;
          names.shuffle();
          filteredNames = names;
        });
      });
    });
    WpApi.getPostsList(
            category: FEATURED_CATEGORY_ID, baseurl: 'https://bookworms99.com/')
        .then((_posts) {
      setState(() {
        // print('data is here$_posts');
        data.addAll(_posts);
        for (int i = 0; i < 5; i++) {
          // print("title" + data.toString());
          tempList.add(data[i].title);
        }
        setState(() {
          names = tempList;
          names.shuffle();
          filteredNames = names;
        });
      });
    });
    // print('data is here$data');
  }

  @override
  void initState() {
    this._getNames();
    super.initState();
  }

  Widget build(BuildContext context) {
    return Scaffold(
      appBar: _buildBar(context),
      body: Container(
        child: _buildList(),
      ),
      // resizeToAvoidBottomPadding: false,
    );
  }

  Widget _buildBar(BuildContext context) {
    return new AppBar(
      centerTitle: true,
      title: _appBarTitle,
      leading: IconButton(
        icon: _searchIcon,
        onPressed: _searchPressed,
      ),
    );
  }

  Widget _buildList() {
    if (_searchText.isNotEmpty) {
      List tempList = new List();
      for (int i = 0; i < filteredNames.length; i++) {
        if (filteredNames[i]
            .toLowerCase()
            .contains(_searchText.toLowerCase())) {
          // print('filtered nameas');
          print(filteredNames[i]);
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
          onTap: () => print(
            filteredNames[index],
          ),
        );
      },
    );
  }

  void _searchPressed() {
    setState(() {
      print(filteredNames);
      if (this._searchIcon.icon == Icons.search) {
        this._searchIcon = new Icon(Icons.close);
        this._appBarTitle = new TextField(
          controller: _filter,
          decoration: new InputDecoration(
              prefixIcon: new Icon(Icons.search), hintText: 'Search the posts'),
        );
      } else {
        this._searchIcon = new Icon(Icons.search);
        this._appBarTitle = new Text('Search...');
        filteredNames = names;
        _filter.clear();
      }
    });
  }
}
