import 'package:flutter/material.dart';
import 'package:getwidget/getwidget.dart';
import 'package:prabhu_movie_recommendation_system/screens/widgets/disliked_history.dart';
import 'package:prabhu_movie_recommendation_system/screens/widgets/liked_history.dart';
import 'package:prabhu_movie_recommendation_system/style/style.dart';

class HistoryPage extends StatefulWidget {
  const HistoryPage({Key? key}) : super(key: key);

  @override
  _HistoryPageState createState() => _HistoryPageState();
}

class _HistoryPageState extends State<HistoryPage>
    with SingleTickerProviderStateMixin {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  late TabController tabController;

  @override
  void initState() {
    super.initState();
    tabController = TabController(length: 2, vsync: this);
  }

  @override
  void dispose() {
    tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      backgroundColor: white,
      appBar: AppBar(
        backgroundColor: primary,
        title: Text(
          'History',
          textAlign: TextAlign.start,
          overflow: TextOverflow.ellipsis,
          style: textpoppinssemiboldlgwhite(),
        ),
        bottom: PreferredSize(
          child: GFTabBar(
            tabBarColor: primary,
            tabBarHeight: 40,
            indicatorColor: white,
            length: 2,
            controller: tabController,
            tabs: const <Widget>[
              Tab(
                icon: Icon(Icons.thumb_up),
              ),
              Tab(
                icon: Icon(Icons.thumb_down),
              ),
            ],
          ),
          preferredSize: Size(MediaQuery.of(context).size.width, 40.0),
        ),
      ),
      body: GFTabBarView(
        controller: tabController,
        children: const <Widget>[
          LikedHistoryView(),
          DisLikedHistoryView(),
        ],
      ),
    );
  }
}
