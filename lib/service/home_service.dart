import 'dart:convert';

import 'package:http/http.dart';
import 'package:prabhu_movie_recommendation_system/models/response_model.dart';

import 'common.dart';
import 'constants.dart';

class HomeService {
  static final Client client = Client();

  HomeService._();

  static Future<ResponseModel> getRandomMovies(List<int>? genresId) async {
    String? token = '';
    Map<String, String?> query = {'genresId': genresId?.join(',')};
    await Common.getToken().then((onValue) => token = onValue);
    final response = await client.get(
      Uri.parse(Constants.baseURL + "/movies/random")
          .replace(queryParameters: query),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'bearer $token',
      },
    );
    return ResponseModel(response.statusCode, json.decode(response.body));
  }
}
