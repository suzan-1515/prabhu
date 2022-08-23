import 'dart:convert';

import 'package:http/http.dart' show Client;

import 'common.dart';
import 'constants.dart';

class FavouriteService {
  static final Client client = Client();

  FavouriteService._();

  // get fav
  static Future<Map<String, dynamic>> getFavList() async {
    String? token = '';
    await Common.getToken().then((onValue) => token = onValue);
    final response = await client
        .get(Uri.parse(Constants.baseURL + "/favourites"), headers: {
      'Content-Type': 'application/json',
      'Authorization': 'bearer $token',
    });
    return json.decode(response.body);
  }
}
