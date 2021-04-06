import 'package:flutter/material.dart';
import 'package:google_signin_example/theme.dart';
import 'bookworms.dart';
import 'enginejunkies.dart';
import 'first.dart';
import 'insurance.dart';

class ArticleTab extends StatefulWidget {
  @override
  _ArticleTabState createState() => _ArticleTabState();
}

class _ArticleTabState extends State<ArticleTab>
    with SingleTickerProviderStateMixin {
  TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(
      length: 4,
      vsync: this,
    );
  }

  @override
  Widget build(BuildContext context) {
    Color color = Style.get(false).buttonColor;
    return Container(
      child: DefaultTabController(
        length: 4,
        child: Center(
          child: Column(
            children: [
              Container(
                color: Colors.black,
                child: TabBar(
                  // labelColor: Colors.white,
                  // indicatorColor: Colors.white,s
                  // controller: _tabController,
                  tabs: <Widget>[
                    Tab(
                      child: Text(
                        'Engine Junkies',
                        // style: TextStyle(
                        //     fontSize: 12,
                        //     color: color,
                        //     fontWeight: FontWeight.bold,
                        //     shadows: [
                        //       BoxShadow(
                        //         color: Color.fromRGBO(0, 0, 0, 0.15),
                        //         offset: Offset(0, 5),
                        //         blurRadius: 10.0,
                        //       )
                        //     ]),
                      ),
                    ),
                    Tab(
                      child: Text(
                        'Insurance',
                        // style: TextStyle(
                        //     fontSize: 12,
                        //     color: color,
                        //     fontWeight: FontWeight.bold,
                        //     shadows: [
                        //       BoxShadow(
                        //         color: Color.fromRGBO(0, 0, 0, 0.15),
                        //         offset: Offset(0, 5),
                        //         blurRadius: 10.0,
                        //       )
                        //     ]),
                      ),
                    ),
                    Tab(
                      child: Text(
                        'Books',
                        // style: TextStyle(
                        //     fontSize: 12,
                        //     color: color,
                        //     fontWeight: FontWeight.bold,
                        //     shadows: [
                        //       BoxShadow(
                        //         color: Color.fromRGBO(0, 0, 0, 0.15),
                        //         offset: Offset(0, 5),
                        //         blurRadius: 10.0,
                        //       )
                        //     ]),
                      ),
                    ),
                    Tab(
                      child: Text(
                        'Festivals',
                        // style: TextStyle(
                        //     fontSize: 12,
                        //     color: color,
                        //     fontWeight: FontWeight.bold,
                        //     shadows: [
                        //       BoxShadow(
                        //         color: Color.fromRGBO(0, 0, 0, 0.15),
                        //         offset: Offset(0, 5),
                        //         blurRadius: 10.0,
                        //       )
                        //     ]),
                      ),
                    ),
                  ],
                ),
              ),
              Expanded(
                child: Container(
                  // color: Colors.white,
                  child: TabBarView(
                    children: [
                      EngineJunkies(),
                      First(),
                      Insurance(),
                      BookWorms(),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
