import 'dart:async';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:google_signin_example/widget/config.dart';
import 'package:google_signin_example/widget/post_list_item.dart';
import 'package:shimmer/shimmer.dart';
import '../model/post_entity.dart';
import '../network/wp_api.dart';
import 'package:in_app_purchase/in_app_purchase.dart';
import 'package:in_app_purchase/store_kit_wrappers.dart';

class ViewAll extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      child: Center(
        child: Text('View All'),
      ),
    );
  }
}

// import 'consumable.dart';

// const bool kAutoConsume = true;

// const String _kConsumableId = '';
// const String _kSubscriptionId = '';
// const List<String> _kProductIds = <String>[
//   _kConsumableId,
//   'noadforfifteendays',
//   _kSubscriptionId
// ];

// // TODO: Please Add your android product ID here
// const List<String> _kAndroidProductIds = <String>[''];
// //Example
// //const List<String> _kAndroidProductIds = <String>[
// //  'ADD_YOUR_ANDROID_PRODUCT_ID_1',
// //  'ADD_YOUR_ANDROID_PRODUCT_ID_2',
// //  'ADD_YOUR_ANDROID_PRODUCT_ID_3'
// //];

// // TODO: Please Add your iOS product ID here
// const List<String> _kiOSProductIds = <String>[''];

// class ViewAll extends StatefulWidget {
//   int category = 0;
//   List<String> baseurl;
//   String option;
//   ViewAll({this.category = 0, this.baseurl, this.option});

//   @override
//   _ViewAllState createState() => _ViewAllState();
// }

// class _ViewAllState extends State<ViewAll> {
//   final InAppPurchaseConnection _connection = InAppPurchaseConnection.instance;
//   StreamSubscription<List<PurchaseDetails>> _subscription;
//   List<String> _notFoundIds = [];
//   List<ProductDetails> _products = [];
//   List<PurchaseDetails> _purchases = [];
//   List<String> _consumables = [];
//   bool _isAvailable = false;
//   bool _purchasePending = false;
//   bool _loading = true;
//   String _queryProductError;

//   @override
//   void initState() {
//     DateTime currentDate = DateTime.now();
//     DateTime noADDate;

//     var fiftyDaysFromNow = currentDate.add(new Duration(days: 50));
//     print(
//         '${fiftyDaysFromNow.month} - ${fiftyDaysFromNow.day} - ${fiftyDaysFromNow.year} ${fiftyDaysFromNow.hour}:${fiftyDaysFromNow.minute}');

//     Stream purchaseUpdated =
//         InAppPurchaseConnection.instance.purchaseUpdatedStream;
//     _subscription = purchaseUpdated.listen((purchaseDetailsList) {
//       _listenToPurchaseUpdated(purchaseDetailsList);
//     }, onDone: () {
//       _subscription.cancel();
//     }, onError: (error) {
//       // handle error here.
//     });
//     initStoreInfo();
//     super.initState();
//   }

//   Future<void> initStoreInfo() async {
//     final bool isAvailable = await _connection.isAvailable();

//     if (!isAvailable) {
//       setState(() {
//         _isAvailable = isAvailable;
//         _products = [];
//         _purchases = [];
//         _notFoundIds = [];
//         _consumables = [];
//         _purchasePending = false;
//         _loading = false;
//       });
//       return;
//     }

//     ProductDetailsResponse productDetailResponse =
//         await _connection.queryProductDetails(Platform.isIOS
//             ? _kiOSProductIds.toSet()
//             : _kAndroidProductIds.toSet()); //_kProductIds.toSet());
//     if (productDetailResponse.error != null) {
//       setState(() {
//         _queryProductError = productDetailResponse.error.message;
//         _isAvailable = isAvailable;
//         _products = productDetailResponse.productDetails;
//         _purchases = [];
//         _notFoundIds = productDetailResponse.notFoundIDs;
//         _consumables = [];
//         _purchasePending = false;
//         _loading = false;
//       });
//       return;
//     }

//     if (productDetailResponse.productDetails.isEmpty) {
//       setState(() {
//         _queryProductError = null;
//         _isAvailable = isAvailable;
//         _products = productDetailResponse.productDetails;
//         _purchases = [];
//         _notFoundIds = productDetailResponse.notFoundIDs;
//         _consumables = [];
//         _purchasePending = false;
//         _loading = false;
//       });
//       return;
//     }

//     final QueryPurchaseDetailsResponse purchaseResponse =
//         await _connection.queryPastPurchases();
//     if (purchaseResponse.error != null) {
//       // handle query past purchase error..
//     }
//     final List<PurchaseDetails> verifiedPurchases = [];
//     for (PurchaseDetails purchase in purchaseResponse.pastPurchases) {
//       if (await _verifyPurchase(purchase)) {
//         verifiedPurchases.add(purchase);
//       }
//     }
//     List<String> consumables = await ConsumableStore.load();
//     setState(() {
//       _isAvailable = isAvailable;
//       _products = productDetailResponse.productDetails;
//       _purchases = verifiedPurchases;
//       _notFoundIds = productDetailResponse.notFoundIDs;
//       _consumables = consumables;
//       _purchasePending = false;
//       _loading = false;
//     });
//   }

//   @override
//   void dispose() {
//     _subscription.cancel();
//     super.dispose();
//   }

//   @override
//   Widget build(BuildContext context) {
//     List<Widget> stack = [];
//     if (_queryProductError == null) {
//       stack.add(
//         ListView(
//           children: [
//             _buildConnectionCheckTile(),
//             _buildProductList(),
//             _buildConsumableBox(),
//           ],
//         ),
//       );
//     } else {
//       stack.add(Center(
//         child: Text(_queryProductError),
//       ));
//     }
//     if (_purchasePending) {
//       stack.add(
//         Stack(
//           children: [
//             Opacity(
//               opacity: 0.3,
//               child: const ModalBarrier(dismissible: false, color: Colors.grey),
//             ),
//             Center(
//               child: CircularProgressIndicator(),
//             ),
//           ],
//         ),
//       );
//     }

//     return MaterialApp(
//       home: Scaffold(
//         appBar: AppBar(
//           title: const Text('IAP Example'),
//         ),
//         body: Stack(
//           children: stack,
//         ),
//       ),
//     );
//   }

//   Card _buildConnectionCheckTile() {
//     if (_loading) {
//       return Card(child: ListTile(title: const Text('Trying to connect...')));
//     }
//     final Widget storeHeader = ListTile(
//       leading: Icon(_isAvailable ? Icons.check : Icons.block,
//           color: _isAvailable ? Colors.green : ThemeData.light().errorColor),
//       title: Text(
//           'The store is ' + (_isAvailable ? 'available' : 'unavailable') + '.'),
//     );
//     final List<Widget> children = <Widget>[storeHeader];

//     if (!_isAvailable) {
//       children.addAll([
//         Divider(),
//         ListTile(
//           title: Text('Not connected',
//               style: TextStyle(color: ThemeData.light().errorColor)),
//           subtitle: const Text(
//               'Unable to connect to the payments processor. Has this app been configured correctly? See the example README for instructions.'),
//         ),
//       ]);
//     }
//     return Card(child: Column(children: children));
//   }

//   Card _buildProductList() {
//     if (_loading) {
//       return Card(
//           child: (ListTile(
//               leading: CircularProgressIndicator(),
//               title: Text('Fetching products...'))));
//     }
//     if (!_isAvailable) {
//       return Card();
//     }
//     final ListTile productHeader = ListTile(title: Text('Products for Sale'));
//     List<ListTile> productList = <ListTile>[];
//     if (_notFoundIds.isNotEmpty) {
//       productList.add(ListTile(
//           title: Text('[${_notFoundIds.join(", ")}] not found',
//               style: TextStyle(color: ThemeData.light().errorColor)),
//           subtitle: Text(
//               'This app needs special configuration to run. Please see example/README.md for instructions.')));
//     }

//     // This loading previous purchases code is just a demo. Please do not use this as it is.
//     // In your app you should always verify the purchase data using the `verificationData` inside the [PurchaseDetails] object before trusting it.
//     // We recommend that you use your own server to verity the purchase data.
//     Map<String, PurchaseDetails> purchases =
//         Map.fromEntries(_purchases.map((PurchaseDetails purchase) {
//       if (purchase.pendingCompletePurchase) {
//         InAppPurchaseConnection.instance.completePurchase(purchase);
//       }
//       return MapEntry<String, PurchaseDetails>(purchase.productID, purchase);
//     }));
//     productList.addAll(_products.map(
//       (ProductDetails productDetails) {
//         PurchaseDetails previousPurchase = purchases[productDetails.id];
//         return ListTile(
//             title: Text(
//               productDetails.title,
//             ),
//             subtitle: Text(
//               productDetails.description,
//             ),
//             trailing: previousPurchase != null
//                 ? Icon(Icons.check)
//                 : FlatButton(
//                     child: Text(productDetails.price),
//                     color: Colors.green[800],
//                     textColor: Colors.white,
//                     onPressed: () {
//                       PurchaseParam purchaseParam = PurchaseParam(
//                           productDetails: productDetails,
//                           applicationUserName: null,
//                           sandboxTesting: false);
//                       if (productDetails.id == _kConsumableId) {
//                         _connection.buyConsumable(
//                             purchaseParam: purchaseParam,
//                             autoConsume: kAutoConsume || Platform.isIOS);
//                       } else {
//                         _connection.buyNonConsumable(
//                             purchaseParam: purchaseParam);
//                       }
//                     },
//                   ));
//       },
//     ));

//     return Card(
//         child:
//             Column(children: <Widget>[productHeader, Divider()] + productList));
//   }

//   Card _buildConsumableBox() {
//     if (_loading) {
//       return Card(
//           child: (ListTile(
//               leading: CircularProgressIndicator(),
//               title: Text('Fetching consumables...'))));
//     }
//     if (!_isAvailable || _notFoundIds.contains(_kConsumableId)) {
//       return Card();
//     }
//     final ListTile consumableHeader =
//         ListTile(title: Text('Purchased consumables'));
//     final List<Widget> tokens = _consumables.map((String id) {
//       return GridTile(
//         child: IconButton(
//           icon: Icon(
//             Icons.stars,
//             size: 42.0,
//             color: Colors.orange,
//           ),
//           splashColor: Colors.yellowAccent,
//           onPressed: () => consume(id),
//         ),
//       );
//     }).toList();
//     return Card(
//         child: Column(children: <Widget>[
//       consumableHeader,
//       Divider(),
//       GridView.count(
//         crossAxisCount: 5,
//         children: tokens,
//         shrinkWrap: true,
//         padding: EdgeInsets.all(16.0),
//       )
//     ]));
//   }

//   Future<void> consume(String id) async {
//     print('consume id is $id');
//     await ConsumableStore.consume(id);
//     final List<String> consumables = await ConsumableStore.load();
//     setState(() {
//       _consumables = consumables;
//     });
//   }

//   void showPendingUI() {
//     setState(() {
//       _purchasePending = true;
//     });
//   }

//   void deliverProduct(PurchaseDetails purchaseDetails) async {
//     print('deliverProduct'); // Last
//     // IMPORTANT!! Always verify a purchase purchase details before delivering the product.
//     if (purchaseDetails.productID == _kConsumableId) {
//       await ConsumableStore.save(purchaseDetails.purchaseID);
//       List<String> consumables = await ConsumableStore.load();
//       setState(() {
//         _purchasePending = false;
//         _consumables = consumables;
//       });
//     } else {
//       setState(() {
//         _purchases.add(purchaseDetails);
//         _purchasePending = false;
//       });
//     }
//   }

//   void handleError(IAPError error) {
//     setState(() {
//       _purchasePending = false;
//     });
//   }

//   Future<bool> _verifyPurchase(PurchaseDetails purchaseDetails) {
//     // IMPORTANT!! Always verify a purchase before delivering the product.
//     // For the purpose of an example, we directly return true.
//     print('_verifyPurchase');
//     return Future<bool>.value(true);
//   }

//   void _handleInvalidPurchase(PurchaseDetails purchaseDetails) {
//     // handle invalid purchase here if  _verifyPurchase` failed.
//     print('_handleInvalidPurchase');
//   }

//   void _listenToPurchaseUpdated(List<PurchaseDetails> purchaseDetailsList) {
//     print('_listenToPurchaseUpdated');
//     purchaseDetailsList.forEach((PurchaseDetails purchaseDetails) async {
//       if (purchaseDetails.status == PurchaseStatus.pending) {
//         showPendingUI();
//       } else {
//         if (purchaseDetails.status == PurchaseStatus.error) {
//           handleError(purchaseDetails.error);
//         } else if (purchaseDetails.status == PurchaseStatus.purchased) {
//           bool valid = await _verifyPurchase(purchaseDetails);
//           if (valid) {
//             deliverProduct(purchaseDetails);
//           } else {
//             _handleInvalidPurchase(purchaseDetails);
//             return;
//           }
//         }
//         if (Platform.isAndroid) {
//           if (!kAutoConsume && purchaseDetails.productID == _kConsumableId) {
//             await InAppPurchaseConnection.instance
//                 .consumePurchase(purchaseDetails);
//           }
//         }
//         if (purchaseDetails.pendingCompletePurchase) {
//           await InAppPurchaseConnection.instance
//               .completePurchase(purchaseDetails);
//         }
//       }
//     });
//   }

//   // List<PostEntity> posts = new List<PostEntity>();
//   // // List<String> urls = [
//   // //   'https://enginejunkies.com/',
//   // //   'http://festivalsofearth.com/',
//   // //   'http://insuranceofearth.com/',
//   // //   'https://bookworms99.com/'
//   // // ];
//   // int page = 0;
//   // ScrollController _scrollController = new ScrollController();
//   // bool isLoading = true;
//   // Color primaryColor = Color(0xff18203d);
//   // Color secondaryColor = Color(0xff232c51);
//   // Color logoGreen = Color(0xff25bcbb);
//   // void getData() {
//   //   if (!isLoading) {
//   //     setState(() {
//   //       page++;
//   //       isLoading = true;
//   //     });

//   //     // WpApi.getPostsList(
//   //     //         category: widget.category, page: page, baseurl: widget.baseurl)
//   //     //     .then((_posts) {
//   //     //   setState(() {
//   //     //     isLoading = false;
//   //     //     posts.addAll(_posts);
//   //     //   });
//   //     // });
//   //   }
//   // }

//   // @override
//   // void initState() {
//   //   super.initState();
//   //   for (int i = 0; i < widget.baseurl.length; i++) {
//   //     WpApi.getPostsList(
//   //             category: FEATURED_CATEGORY_ID, baseurl: widget.baseurl[i])
//   //         .then((_posts) {
//   //       setState(() {
//   //         isLoading = false;
//   //         posts.addAll(_posts);
//   //       });
//   //     }).then((value) => print(posts));
//   //   }
//   // }

//   // @override
//   // void dispose() {
//   //   _scrollController.dispose();
//   //   super.dispose();
//   // }

//   // @override
//   // Widget build(BuildContext context) {
//   //   return Scaffold(
//   //     appBar: widget.option == 'view'
//   //         ? AppBar(
//   //             iconTheme: IconThemeData(
//   //               color: Colors.white, //change your color here
//   //             ),
//   //             backgroundColor: primaryColor,
//   //             automaticallyImplyLeading: true,
//   //             title: Text(
//   //               'All Posts',
//   //               style: TextStyle(color: Colors.white),
//   //             ),
//   //           )
//   //         : null,
//   //     body: SingleChildScrollView(
//   //       child: Container(
//   //         child: Column(
//   //           children: [
//   //             Container(
//   //               margin: EdgeInsets.all(16),
//   //               height: 180,
//   //               decoration: BoxDecoration(
//   //                 borderRadius: BorderRadius.circular(8.0),
//   //                 color: Colors.brown[600],
//   //               ),
//   //               width: MediaQuery.of(context).size.width,
//   //               child: Center(
//   //                 child: Container(
//   //                   height: 140,
//   //                   width: 140,
//   //                   decoration: BoxDecoration(
//   //                       borderRadius: BorderRadius.circular(120),
//   //                       color: secondaryColor),
//   //                   child: Shimmer.fromColors(
//   //                     period: Duration(milliseconds: 1500),
//   //                     baseColor: logoGreen,
//   //                     highlightColor: Colors.grey[300],
//   //                     child: Image.asset(
//   //                       'assets/genius.png',
//   //                       height: 250,
//   //                       width: 250,
//   //                     ),
//   //                   ),
//   //                 ),
//   //               ),
//   //             ),
//   //             // !isLoading
//   //             //     ? ListView.builder(
//   //             //         itemBuilder: postTile,
//   //             //         itemCount: posts.length + 1,
//   //             //         scrollDirection: Axis.vertical,
//   //             //         shrinkWrap: true,
//   //             //         physics: ClampingScrollPhysics(),
//   //             //         controller: _scrollController,
//   //             //       )
//   //             //     : Center(child: CircularProgressIndicator()),
//   //           ],
//   //         ),
//   //       ),
//   //     ),
//   //   );
//   // }

//   // Widget postTile(BuildContext context, int index) {
//   //   if (index == posts.length) {
//   //     return _buildProgressIndicator();
//   //   } else {
//   //     return PostListItem(posts[index]);
//   //   }
//   // }

//   // Widget _buildProgressIndicator() {
//   //   return null;
//   //   // return SizedBox(
//   //   //   width: 200.0,
//   //   //   height: 400.0,
//   //   //   child: ListView.builder(
//   //   //       itemCount: 2,
//   //   //       itemBuilder: (BuildContext context, int index) {
//   //   //         return Padding(
//   //   //           padding: const EdgeInsets.all(8.0),
//   //   //           child: Shimmer.fromColors(
//   //   //             baseColor: Colors.grey[300],
//   //   //             highlightColor: Colors.white,
//   //   //             child: Container(
//   //   //               width: 100,
//   //   //               height: 100,
//   //   //               child: Card(
//   //   //                 child: ListTile(
//   //   //                   leading: Container(
//   //   //                     width: 50,
//   //   //                     height: 50,
//   //   //                     child: CircleAvatar(
//   //   //                       child: Container(),
//   //   //                     ),
//   //   //                   ),
//   //   //                 ),
//   //   //               ),
//   //   //             ),
//   //   //           ),
//   //   //         );
//   //   //       }),
//   //   // );
//   // }
// }
