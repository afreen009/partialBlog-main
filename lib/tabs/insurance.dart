import 'package:flutter/material.dart';
import 'package:google_signin_example/widget/config.dart';
import 'package:google_signin_example/widget/featured_category_list.dart';
import 'package:google_signin_example/widget/posts_list.dart';
// import '../admob.dart';
import 'listHeading.dart';

class Insurance extends StatefulWidget {
  @override
  _InsuranceState createState() => _InsuranceState();
}

class _InsuranceState extends State<Insurance> {
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
              child: FeaturedCategoryList('https://insuranceofearth.com/'),
            ),
            ListHeading('Latest', 0),
            Flexible(
              fit: FlexFit.loose,
              child: PostsList(
                baseurl: 'https://insuranceofearth.com/',
              ),
            ),
          ],
        ),
      ),
    );
  }
}
