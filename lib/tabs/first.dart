import 'package:flutter/material.dart';
import 'package:google_signin_example/widget/config.dart';
import 'package:google_signin_example/widget/featured_category_list.dart';
import 'package:google_signin_example/widget/posts_list.dart';
import '../admob.dart';
import 'listHeading.dart';

class First extends StatefulWidget {
  @override
  _FirstState createState() => _FirstState();
}

class _FirstState extends State<First> {
  @override
  Widget build(BuildContext context) {
    return Container(
      child: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            ListHeading(FEATURED_CATEGORY_TITLE, FEATURED_CATEGORY_ID),
            Container(
              height: 200.0,
              child: FeaturedCategoryList(
                'http://festivalsofearth.com/',
              ),
            ),
            ListHeading('Latest', 0),
            Flexible(
              fit: FlexFit.loose,
              child: PostsList(
                baseurl: 'http://festivalsofearth.com/',
              ),
            ),
          ],
        ),
      ),
    );
  }
}
