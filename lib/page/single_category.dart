import 'package:flutter/material.dart';
import 'package:google_signin_example/widget/posts_list.dart';

import '../model/post_entity.dart';

class SingleCategory extends StatelessWidget {
  final PostCategory category;

  SingleCategory(this.category);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(category.name),
      ),
      body: PostsList(category: category.id),
    );
  }
}
