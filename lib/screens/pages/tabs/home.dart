import 'package:flare_flutter/flare_actor.dart';
import 'package:flare_flutter/flare_controls.dart';
import 'package:flutter/material.dart';
import 'package:prabhu_movie_recommendation_system/screens/pages/tabs/account.dart';
import 'package:prabhu_movie_recommendation_system/screens/widgets/swipe_card.dart';
import 'package:prabhu_movie_recommendation_system/utils/view_utils.dart';
import 'package:swipeable_card_stack/swipe_controller.dart';
import 'package:swipeable_card_stack/swipeable_card_stack.dart';

import '../../../service/common.dart';
import '../../../service/movie_service.dart';
import '../../../style/style.dart';
import '../../widgets/common_widgets.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage>
    with AutomaticKeepAliveClientMixin<HomePage> {
  bool isLoading = false;
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  final SwipeableCardSectionController _cardController =
      SwipeableCardSectionController();

  List<dynamic> moviesList = List<dynamic>.empty(growable: true);

  final flareControls = FlareControls();

  @override
  void initState() {
    getRandomMovies();
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return Scaffold(
      key: _scaffoldKey,
      backgroundColor: bg,
      appBar: PreferredSize(
        child: Container(
          padding: EdgeInsets.only(top: MediaQuery.of(context).padding.top),
          child: Stack(
            alignment: Alignment.center,
            children: [
              FittedBox(
                fit: BoxFit.contain,
                child: Image.asset(
                  'lib/assets/icons/logo.png',
                  height: 82,
                  width: 82,
                  fit: BoxFit.cover,
                ),
              ),
              Align(
                alignment: Alignment.centerRight,
                child: IconButton(
                  onPressed: () => Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => const Account()),
                  ),
                  icon: Image.asset('lib/assets/icons/account.png',
                      width: 20, height: 22, color: Colors.white),
                ),
              )
            ],
          ),
          decoration: BoxDecoration(
              gradient: const LinearGradient(colors: <Color>[
                primary,
                secondary,
              ], begin: Alignment.topCenter, end: Alignment.bottomCenter),
              boxShadow: [
                BoxShadow(
                  color: Colors.grey[500]!,
                  blurRadius: 20.0,
                  spreadRadius: 1.0,
                )
              ]),
        ),
        preferredSize: Size(MediaQuery.of(context).size.width, 90.0),
      ),
      body: isLoading ? customLoader() : buildBody(context),
    );
  }

  void getRandomMovies() async {
    if (mounted) {
      setState(() {
        isLoading = true;
      });
    }
    final genresId = await Common.getGenres();
    MovieService.getRandomMovies(genresId).then((value) {
      if (mounted) {
        setState(() {
          isLoading = false;
          if (value.data['results'] != null) {
            moviesList.clear();
            moviesList.addAll((value.data['results']));
          } else {
            ViewUtils.showSnackBar("Movies Not Found.", _scaffoldKey);
          }
        });
      }
    }).catchError((onError) {
      if (mounted) {
        setState(() {
          isLoading = false;
        });
        ViewUtils.showSnackBar("Movies Not Found.", _scaffoldKey);
      }
    });
  }

  Widget buildBody(BuildContext context) {
    return Stack(
      fit: StackFit.expand,
      children: [
        SwipeableCardsSection(
          cardController: _cardController,
          context: context,
          //add the first 3 cards (widgets)
          items: moviesList
              .take(3)
              .map<Widget>((e) => SwipeCard(
                    movie: e,
                  ))
              .toList(),
          //Get card swipe event callbacks
          onCardSwiped: (dir, index, widget) {
            if (moviesList.length > (index + 3)) {
              _cardController.addItem(
                SwipeCard(
                  movie: moviesList[index + 3],
                ),
              );
            } else {
              getRandomMovies();
            }

            if (dir == Direction.left) {
              MovieService.postDisLike(moviesList[index]['id'].toString())
                  .then((value) {})
                  .catchError((onError) {});
            } else if (dir == Direction.right) {
              flareControls.play('like');
              MovieService.postLike(moviesList[index]['id'].toString())
                  .then((value) {})
                  .catchError((onError) {});
            } else {}
          },
          //
          enableSwipeUp: false,
          enableSwipeDown: false,
        ),
        Align(
          alignment: Alignment.center,
          child: ConstrainedBox(
            constraints: BoxConstraints.loose(const Size(150, 150)),
            child: FlareActor(
              "lib/assets/like.flr",
              animation: "idle",
              controller: flareControls,
              color: Colors.red,
            ),
          ),
        ),
      ],
    );
  }

  @override
  bool get wantKeepAlive => true;
}
