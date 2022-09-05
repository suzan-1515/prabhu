import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:getwidget/colors/gf_color.dart';
import 'package:getwidget/components/avatar/gf_avatar.dart';
import 'package:getwidget/components/badge/gf_badge.dart';
import 'package:getwidget/components/button/gf_button_bar.dart';
import 'package:getwidget/components/card/gf_card.dart';
import 'package:getwidget/components/list_tile/gf_list_tile.dart';
import 'package:getwidget/position/gf_position.dart';
import 'package:getwidget/size/gf_size.dart';
import 'package:prabhu_movie_recommendation_system/screens/widgets/common_widgets.dart';
import 'package:prabhu_movie_recommendation_system/utils/imageUtils.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../../service/movie_service.dart';
import '../../../style/style.dart';
import '../../../utils/view_utils.dart';

class LikedHistoryView extends StatefulWidget {
  const LikedHistoryView({Key? key}) : super(key: key);

  @override
  _LikedHistoryViewState createState() => _LikedHistoryViewState();
}

class _LikedHistoryViewState extends State<LikedHistoryView> {
  bool isLoading = false;

  List moviesList = List.empty(growable: true);

  @override
  void initState() {
    getLikedMoviesList();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return _buildBody(context);
  }

  void getLikedMoviesList() {
    if (mounted) {
      setState(() {
        isLoading = true;
      });
    }
    MovieService.getLikedMovies().then((value) {
      if (mounted) {
        setState(() {
          isLoading = false;
          if (value.statusCode == 200) {
            if (value.data['results'] != null) {
              moviesList.addAll(value.data['results'].reversed);
            } else {
              ViewUtils.showSnackBarWithContext("Data Not Found.", context);
            }
          } else {
            ViewUtils.showSnackBarWithContext(value.data['message'], context);
          }
        });
      }
    }).catchError((onError) {
      if (mounted) {
        setState(() {
          isLoading = false;
        });
        ViewUtils.showSnackBarWithContext("Data Not Found.", context);
      }
    });
  }

  Widget _buildBody(BuildContext context) {
    return isLoading
        ? customLoader()
        : (moviesList.isNotEmpty)
            ? buildMovieListView()
            : const NoData(text: "No Data.");
  }

  buildMovieListView() => ListView.builder(
        itemCount: moviesList.length,
        scrollDirection: Axis.vertical,
        itemBuilder: (context, index) {
          final movie = moviesList[index];

          return GFCard(
            boxFit: BoxFit.cover,
            titlePosition: GFPosition.start,
            image: Image.network(
              ImageUtils.getTMDBImagePath(movie['poster_path']),
              height: MediaQuery.of(context).size.height * 0.2,
              width: MediaQuery.of(context).size.width,
              fit: BoxFit.cover,
            ),
            showImage: true,
            title: GFListTile(
              titleText: movie['original_title'],
              subTitle: GFBadge(
                size: GFSize.SMALL,
                textStyle: textpoppinsRegularxs(),
                text: '${movie['release_date'].split('-')[0]}',
                color: Colors.grey,
              ),
              avatar: GFAvatar(
                backgroundImage: NetworkImage(
                    ImageUtils.getTMDBImagePath(movie['poster_path'])),
                child: GFBadge(
                  size: GFSize.MEDIUM,
                  textStyle: textpoppinsRegular(),
                  text:
                      '${num.parse(movie['vote_average'].toStringAsFixed(1))}',
                  color: Colors.lightGreen,
                ),
              ),
            ),
            buttonBar: GFButtonBar(
              children: <Widget>[
                InkWell(
                  child: const GFAvatar(
                    backgroundColor: GFColors.PRIMARY,
                    backgroundImage: AssetImage('lib/assets/icons/imdb.png'),
                  ),
                  onTap: () {
                    launch('https://www.themoviedb.org/movie/${movie['id']}');
                  },
                ),
              ],
            ),
          );

          return ListTile(
            title: Text(
              movie['original_title'],
              style: textpoppinssemibold(),
              maxLines: 2,
            ),
            subtitle: Text(
              movie['overview'],
              style: textpoppinsRegularsm(),
              maxLines: 4,
            ),
            leading: CircleAvatar(
              backgroundImage: CachedNetworkImageProvider(
                ImageUtils.getTMDBImagePath(movie['poster_path']),
              ),
            ),
          );
        },
      );
}
