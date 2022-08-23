import 'dart:convert';

import 'package:http/http.dart';
import 'package:prabhu_movie_recommendation_system/models/response_model.dart';

import 'common.dart';
import 'constants.dart';

class MovieService {
  static final Client client = Client();

  MovieService._();

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

  static Future<ResponseModel> postLike(String movieId) async {
    String? token = '';
    Map<String, dynamic> body = {
      'movieId': movieId,
    };
    await Common.getToken().then((onValue) => token = onValue);
    final response = await client.post(
      Uri.parse(Constants.baseURL + "/movies/like"),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'bearer $token',
      },
      body: json.encode(body),
    );

    return ResponseModel(response.statusCode, json.decode(response.body));
  }

  static Future<ResponseModel> postUnLike(String movieId) async {
    String? token = '';
    Map<String, dynamic> body = {
      'movieId': movieId,
    };
    await Common.getToken().then((onValue) => token = onValue);
    final response = await client.post(
      Uri.parse(Constants.baseURL + "/movies/unlike"),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'bearer $token',
      },
      body: json.encode(body),
    );

    return ResponseModel(response.statusCode, json.decode(response.body));
  }

  static Future<ResponseModel> postDisLike(String movieId) async {
    String? token = '';
    Map<String, dynamic> body = {
      'movieId': movieId,
    };
    await Common.getToken().then((onValue) => token = onValue);
    final response = await client.post(
      Uri.parse(Constants.baseURL + "/movies/dislike"),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'bearer $token',
      },
      body: json.encode(body),
    );

    return ResponseModel(response.statusCode, json.decode(response.body));
  }

  static Future<ResponseModel> postUnDisLike(String movieId) async {
    String? token = '';
    Map<String, dynamic> body = {
      'movieId': movieId,
    };
    await Common.getToken().then((onValue) => token = onValue);
    final response = await client.post(
      Uri.parse(Constants.baseURL + "/movies/undislike"),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'bearer $token',
      },
      body: json.encode(body),
    );

    return ResponseModel(response.statusCode, json.decode(response.body));
  }

  static Future<ResponseModel> getRecommendation({int count = 10}) async {
    String? token = '';
    await Common.getToken().then((onValue) => token = onValue);
    final response = await client.get(
      Uri.parse(Constants.baseURL + "/movies/recommend?numberOfRecs=$count}"),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'bearer $token',
      },
    );

    return ResponseModel(response.statusCode, json.decode(response.body));
  }
}
