import 'package:flutter/material.dart';

class ListHeading extends StatelessWidget {
  final String title;
  final int categoryId;

  ListHeading(this.title, this.categoryId);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 2.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          Text(
            title,
            style: TextStyle(
              // color: Colors.white,
              fontSize: 30,
              fontWeight: FontWeight.bold,
            ),
          ),
          // GestureDetector(
          //   onTap: () {
          //     PostCategory category = PostCategory(name: title, id: categoryId);
          //     Navigator.push(context, MaterialPageRoute(builder: (context) => SingleCategory(category)));
          //   },
          //   child: Container(
          //     decoration: BoxDecoration(borderRadius: BorderRadius.circular(8.0), color: Colors.green.shade300),
          //     padding: EdgeInsets.symmetric(horizontal: 10.0, vertical: 6.0),
          //     child: Text('Show All', style: TextStyle(color:Colors.black),),
          //   ),
          // )
        ],
      ),
    );
  }
}
