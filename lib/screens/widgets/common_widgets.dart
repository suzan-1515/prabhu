import 'package:flutter/material.dart';
import 'package:getwidget/getwidget.dart';
import 'package:prabhu_movie_recommendation_system/service/constants.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../style/style.dart';
import '../../view_model/app_model.dart';

customLoader() => const GFLoader(
      androidLoaderColor: AlwaysStoppedAnimation<Color>(primary),
    );

customLoaderW() => const GFLoader(
      androidLoaderColor: AlwaysStoppedAnimation<Color>(white),
    );

class NoData extends StatelessWidget {
  final String? text;

  const NoData({
    Key? key,
    this.text,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    AppModel appModel = Provider.of<AppModel>(context, listen: true);
    return Center(
      child: Text(appModel.isOnline
          ? text ?? 'No Data Found'
          : Constants.internetConnectionUnavailable),
    );
  }
}

launchURL(String url) async {
  if (!url.contains('http')) url = 'https://$url';
  var uri = Uri.tryParse(url);
  if (uri != null && await canLaunchUrl(uri)) {
    await launchURL(url);
  } else {
    throw 'Could not launch $url';
  }
}

class NoInternet extends StatelessWidget {
  const NoInternet({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) => Container(
        height: 20,
        width: double.infinity,
        color: Colors.red,
        child: Center(
          child: Text(Constants.internetConnectionUnavailable,
              style: textBarLowRegularWhiteBold2()),
        ),
      );
}
