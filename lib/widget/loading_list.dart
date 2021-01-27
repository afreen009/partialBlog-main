import 'dart:async';

import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';

class LoadingList extends StatefulWidget {
  @override
  _LoadingListState createState() => _LoadingListState();
}

class _LoadingListState extends State<LoadingList> {
  double containerWidth = 200;
  double containerHeight = 30;
  bool loading = true;
  @override
  Widget build(BuildContext context) {
    Timer timer = Timer(Duration(seconds: 3), () {
      setState(() {
        loading = false;
      });
    });
    return ListView.builder(itemBuilder: (context, index) {
      return Padding(
        padding: EdgeInsets.symmetric(horizontal: 20),
        child: Shimmer.fromColors(
            child: Container(
              margin: EdgeInsets.symmetric(vertical: 5.0),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Container(
                    height: 80,
                    width: 100,
                    color: Colors.grey,
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        height: containerHeight,
                        width: containerWidth,
                        color: Colors.grey,
                      ),
                      SizedBox(
                        height: 5.0,
                      ),
                      Container(
                        height: containerHeight,
                        width: containerWidth,
                        color: Colors.grey,
                      ),
                      SizedBox(
                        height: 5.0,
                      ),
                    ],
                  )
                ],
              ),
            ),
            period: Duration(milliseconds: 1500),
            baseColor: Colors.grey[300],
            highlightColor: Colors.white),
      );
    });
  }
}

// class ShimmerLayout extends StatelessWidget {
//   @override
//   Widget build(BuildContext context) {
//     double containerWidth = 200;
//     double containerHeight = 30;
//     return Container(
//       margin: EdgeInsets.symmetric(vertical: 5.0),
//       child: Row(
//         crossAxisAlignment: CrossAxisAlignment.start,
//         mainAxisAlignment: MainAxisAlignment.spaceBetween,
//         children: [
//           Container(
//             height: 80,
//             width: 100,
//             color: Colors.grey,
//           ),
//           Column(
//             crossAxisAlignment: CrossAxisAlignment.start,
//             children: [
//               Container(
//                 height: containerHeight,
//                 width: containerWidth,
//                 color: Colors.grey,
//               ),
//               SizedBox(
//                 height: 5.0,
//               ),
//               Container(
//                 height: containerHeight,
//                 width: containerWidth,
//                 color: Colors.grey,
//               ),
//               SizedBox(
//                 height: 5.0,
//               ),
//             ],
//           )
//         ],
//       ),
//     );
//   }
// }
