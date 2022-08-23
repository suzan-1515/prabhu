import 'package:flutter/material.dart';
import 'package:prabhu_movie_recommendation_system/screens/auth/login.dart';
import 'package:prabhu_movie_recommendation_system/screens/pages/layout.dart';
import 'package:provider/provider.dart';

import 'service/common.dart';
import 'service/constants.dart';
import 'view_model/app_model.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(MultiProvider(
    providers: [
      ChangeNotifierProvider(create: (context) => AppModel()),
    ],
    child: MaterialApp(
      title: Constants.appName,
      home: await checkIsLogin() ? const Home() : const LogInPage(),
      debugShowCheckedModeBanner: false,
    ),
  ));
}

checkIsLogin() => Common.getToken().then((value) {
      return value != null ? true : false;
    });
