import 'package:flutter/material.dart';
import 'package:getwidget/getwidget.dart';
import 'package:prabhu_movie_recommendation_system/screens/pages/tabs/recommendation.dart';
import 'package:prabhu_movie_recommendation_system/screens/widgets/group_list.dart';
import 'package:provider/provider.dart';

import '../../service/auths_service.dart';
import '../../service/common.dart';
import '../../style/style.dart';
import '../../view_model/app_model.dart';
import '../auth/login.dart';
import '../widgets/common_widgets.dart';
import 'tabs/home.dart';

class Home extends StatefulWidget {
  final int currentIndex;

  const Home({Key? key, this.currentIndex = 0}) : super(key: key);

  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> with TickerProviderStateMixin {
  late TabController tabController;
  bool isCheckTokenLoading = false;

  @override
  void initState() {
    checkTokenValidOrNot();
    currentIndex = widget.currentIndex;
    super.initState();
    tabController =
        TabController(length: 2, vsync: this, initialIndex: currentIndex);
    tabController.addListener(_handleTabSelection);
  }

  void _handleTabSelection() {
    setState(() {});
  }

  @override
  void dispose() {
    tabController.dispose();
    super.dispose();
  }

  checkTokenValidOrNot() {
    if (mounted) {
      setState(() {
        isCheckTokenLoading = true;
      });
    }
    AuthService.checkToken().then((response) {
      if (mounted) {
        setState(() {
          isCheckTokenLoading = false;
          if (response.data['token'] == null) {
            Common.removeToken();
            Navigator.pushAndRemoveUntil(
                context,
                MaterialPageRoute(
                  builder: (BuildContext context) => const LogInPage(),
                ),
                (Route<dynamic> route) => false);
          }
        });
      }
    }).catchError((onError) {
      if (mounted) {
        setState(() {
          isCheckTokenLoading = false;
        });
      }
    });
  }

  int currentIndex = 0;

  @override
  Widget build(BuildContext context) {
    Provider.of<AppModel>(context, listen: true).checkConnectivity();
    return SafeArea(
      bottom: true,
      top: false,
      child: Scaffold(
        floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
        body: isCheckTokenLoading
            ? customLoader()
            : GFTabBarView(
                physics: const NeverScrollableScrollPhysics(),
                controller: tabController,
                children: <Widget>[
                  Container(
                    color: Colors.white,
                    child: const HomePage(),
                  ),
                  Container(
                    color: Colors.white,
                    child: const MovieRecommendationListPage(),
                  ),
                  // Container(
                  //   color: Colors.white,
                  //   child: const Account(),
                  // ),
                ],
              ),
        floatingActionButton: isCheckTokenLoading
            ? Container(height: 1)
            : FloatingActionButton(
                shape: const StadiumBorder(),
                onPressed: () => Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const GroupList()),
                ),
                backgroundColor: Colors.transparent,
                foregroundColor: Colors.transparent,
                focusColor: Colors.transparent,
                splashColor: Colors.transparent,
                hoverColor: Colors.transparent,
                elevation: 0.0,
                hoverElevation: 0.0,
                highlightElevation: 0.0,
                child: Column(
                  children: [
                    Container(
                      height: 40,
                      width: 40,
                      decoration: BoxDecoration(
                        boxShadow: const [
                          BoxShadow(color: Colors.black45, blurRadius: 6)
                        ],
                        borderRadius: BorderRadius.circular(50),
                        gradient: const LinearGradient(
                            colors: <Color>[
                              primary,
                              secondary,
                            ],
                            begin: Alignment.topCenter,
                            end: Alignment.bottomCenter),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Image.asset(
                          'lib/assets/icons/plus.png',
                          color: Colors.white,
                          width: 10,
                          height: 12,
                        ),
                      ),
                    ),
                    Text(
                      'Group',
                      style: textpoppinsRegularxs(),
                    )
                  ],
                ),
              ),
        bottomNavigationBar: isCheckTokenLoading
            ? Container(height: 1)
            : Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Container(
                    height: 60,
                    decoration: BoxDecoration(boxShadow: const [
                      BoxShadow(
                          color: Colors.black,
                          blurRadius: 1.0,
                          offset: Offset(0.0, 1.0))
                    ], borderRadius: BorderRadius.circular(0)),
                    child: BottomAppBar(
                      shape: const CircularNotchedRectangle(),
                      child: GFTabBar(
                        length: 2,
                        controller: tabController,
                        tabs: [
                          Tab(
                            child: Column(
                              children: [
                                const SizedBox(height: 5),
                                Image.asset('lib/assets/icons/home.png',
                                    width: 20,
                                    height: 22,
                                    color: tabController.index == 0
                                        ? primary
                                        : const Color(0xFF8E8E93)),
                                Text(
                                  'Home',
                                  style: tabController.index == 0
                                      ? textpoppinsRegularxsprimary()
                                      : textpoppinsRegularxs(),
                                )
                              ],
                            ),
                          ),
                          Tab(
                            child: Column(
                              children: [
                                const SizedBox(height: 5),
                                Image.asset(
                                    'lib/assets/icons/recommendation.png',
                                    width: 20,
                                    height: 22,
                                    color: tabController.index == 1
                                        ? primary
                                        : const Color(0xFF8E8E93)),
                                Text(
                                  'Recommendation',
                                  style: tabController.index == 1
                                      ? textpoppinsRegularxsprimary()
                                      : textpoppinsRegularxs(),
                                )
                              ],
                            ),
                          ),
                          // Tab(
                          //   child: Column(
                          //     children: [
                          //       const SizedBox(height: 5),
                          //       Image.asset('lib/assets/icons/account.png',
                          //           width: 20,
                          //           height: 22,
                          //           color: tabController.index == 2
                          //               ? primary
                          //               : const Color(0xFF8E8E93)),
                          //       Text(
                          //         'Account',
                          //         style: tabController.index == 2
                          //             ? textpoppinsRegularxsprimary()
                          //             : textpoppinsRegularxs(),
                          //       )
                          //     ],
                          //   ),
                          // ),
                          //
                        ],
                        indicatorColor: Colors.transparent,
                        // labelColor: primary,
                        labelPadding: const EdgeInsets.all(0),
                        tabBarColor: Colors.white,
                        // unselectedLabelColor: Colors.white,
                        labelStyle: const TextStyle(color: Colors.red),

                        unselectedLabelStyle: const TextStyle(color: primary),
                      ),
                    ),
                  ),
                ],
              ),
      ),
    );
  }
}
