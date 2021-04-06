import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_signin_example/database/databasehelep.dart';
import 'package:google_signin_example/database/db_model.dart';
// import 'package:fstore/customised_pages/database_sqlite.dart';
// import 'package:fstore/customised_pages/databasehelep.dart';
// import 'package:fstore/frameworks/vendor/store_detail/qr_event.dart';
import 'package:shimmer/shimmer.dart';

class MyPoints extends StatefulWidget {
  @override
  _MyPointsState createState() => _MyPointsState();
}

class _MyPointsState extends State<MyPoints> {
  @override
  void didUpdateWidget(MyPoints oldWidget) {
    // TODO: implement didUpdateWidget
    super.didUpdateWidget(oldWidget);
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("My Points"),
      ),
      body: SingleChildScrollView(
        child: FutureBuilder<List<DbModel>>(
          future: PersonDatabaseProvider.db.getAllPersons(),
          builder:
              (BuildContext context, AsyncSnapshot<List<DbModel>> snapshot) {
            if (snapshot.hasData) {
              List<DbModel> list = snapshot.data;
              return Column(
                children: [
                  const SizedBox(
                    height: 20,
                  ),
                  Container(
                    height: 150,
                    child: CircleAvatar(
                      radius: 100,
                      backgroundColor: Theme.of(context).primaryColor,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(list.length.toString(),
                              style: const TextStyle(
                                  color: Colors.white,
                                  fontSize: 40,
                                  fontWeight: FontWeight.bold)),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              const Text(
                                'Points',
                                style: TextStyle(
                                    color: Colors.black,
                                    fontWeight: FontWeight.bold),
                              ),
                              const SizedBox(
                                width: 10,
                              ),
                              Shimmer.fromColors(
                                baseColor: Colors.amber,
                                highlightColor: Colors.white,
                                direction: ShimmerDirection.ltr,
                                child: const Icon(
                                  FontAwesomeIcons.coins,
                                  color: Colors.amber,
                                ),
                              )
                            ],
                          )
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  Container(
                    height: MediaQuery.of(context).size.height / 1.5,
                    child: ListView.builder(
                      physics: const BouncingScrollPhysics(),
                      itemCount: snapshot.data.length,
                      itemBuilder: (BuildContext context, int index) {
                        DbModel item = snapshot.data[index];
                        return Dismissible(
                            key: UniqueKey(),
                            background: Container(color: Colors.red),
                            // onDismissed: (direction) {
                            //   PersonDatabaseProvider.db.deletePersonWithId(item.id);
                            // },
                            child: Card(
                              child: Row(
                                children: <Widget>[
                                  Padding(
                                    padding: const EdgeInsets.only(right: 14.0),
                                    child: ClipRRect(
                                      borderRadius: BorderRadius.circular(10),
                                      child: Container(
                                          width: 100,
                                          height: 85,
                                          child: const Center(
                                              child: Text(
                                            'no image',
                                            style:
                                                TextStyle(color: Colors.black),
                                          ))),
                                    ),
                                  ),
                                  Flexible(
                                    child: SizedBox(
                                      height: 85.0,
                                      child: Column(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: <Widget>[
                                          Text(
                                            item.name,
                                            textAlign: TextAlign.left,
                                            maxLines: 3,
                                            overflow: TextOverflow.ellipsis,
                                            style: const TextStyle(
                                                color: Colors
                                                    .black), //TextStyle(color: Colors.black, fontWeight: FontWeight.bold, fontSize: 18.0, fontFamily: 'Roboto'),
                                          ),
                                          Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceBetween,
                                            children: <Widget>[
                                              Text(
                                                item.date,
                                                style: TextStyle(
                                                    color: Colors.grey[600]),
                                              ),
                                            ],
                                          ),
                                        ],
                                      ),
                                    ),
                                  )
                                ],
                              ),
                            )
                            // child: ListTile(
                            //   title: Text(item.name),
                            //   subtitle: Text(item.date),
                            //   leading: CircleAvatar(child: Image.network(item.image)),
                            //   onTap: () {
                            //     // Navigator.of(context).push(MaterialPageRoute(
                            //     //     builder: (context) => EditPerson(
                            //     //           true,
                            //     //           person: item,
                            //     //         )));
                            //   },
                            // ),
                            );
                      },
                    ),
                  ),
                ],
              );
            } else {
              return Container(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const SizedBox(
                      height: 20,
                    ),
                    const Text('You have no points yet',
                        style: TextStyle(fontWeight: FontWeight.bold))
                  ],
                ),
              );
            }
          },
        ),
      ),
    );
  }
}

// import 'package:flutter/material.dart';
// import 'package:font_awesome_flutter/font_awesome_flutter.dart';
// import 'package:shared_preferences/shared_preferences.dart';

// class MyPoints extends StatefulWidget {
//   @override
//   _MyPointsState createState() => _MyPointsState();
// }

// class _MyPointsState extends State<MyPoints> {
//   String pointMessage;
//   List list;
//   @override
//   void initState() {
//     // TODO: implement initState
//     super.initState();
//     getStringList();
//   }

//   // void getPrefs() async {
//   //   SharedPreferences prefs = await SharedPreferences.getInstance();
//   //   setState(() {
//   //     pointMessage = prefs.getString('mypoints');
//   //   });
//   // }

//   getStringList() async {
//     SharedPreferences prefs = await SharedPreferences.getInstance();
//     setState(() {
//       pointMessage = prefs.getString('qrcode');
//       list = prefs.getStringList('qrList');
//     });
//     //"list: $list");
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//         appBar: AppBar(
//           title: const Text('My Points'),
//         ),
//         body: pointMessage != null
//             ? Column(
//                 children: [
//                   Container(
//                     height: 150,
//                     width: MediaQuery.of(context).size.width,
//                     child: Card(
//                       color: Colors.blueGrey[50],
//                       child: Stack(
//                         children: [
//                           Positioned(
//                             bottom: 20,
//                             left: 120,
//                             child: Text(list[3]),
//                           ),
//                           Positioned(
//                             top: 20,
//                             left: 10,
//                             child: Container(
//                               height: 100,
//                               width: 100,
//                               decoration: BoxDecoration(
//                                   borderRadius: BorderRadius.circular(10)),
//                               child: Image.network(
//                                 list[1],
//                                 fit: BoxFit.cover,
//                               ),
//                             ),
//                           ),
//                           Positioned(
//                             top: 20,
//                             left: 120,
//                             child: Text(
//                               list[2],
//                               style: const TextStyle(
//                                   fontSize: 16,
//                                   fontWeight: FontWeight.bold,
//                                   color: Colors.black),
//                             ),
//                           ),
//                           Positioned(
//                             top: 40,
//                             left: 120,
//                             child: Text(
//                               pointMessage.toString(),
//                               style: const TextStyle(
//                                   fontSize: 17,
//                                   fontWeight: FontWeight.bold,
//                                   color: Colors.black),
//                             ),
//                           )
//                         ],
//                       ),
//                     ),
//                   ),
//                 ],
//               )
//             : Column(
//                 mainAxisAlignment: MainAxisAlignment.center,
//                 children: [
//                   Image.asset(
//                     'assets/images/points.png',
//                     fit: BoxFit.cover,
//                   ),
//                   const SizedBox(
//                     height: 20,
//                   ),
//                   const Text('You have no points yet',
//                       style: TextStyle(fontWeight: FontWeight.bold))
//                 ],
//               ));
//   }
// }
