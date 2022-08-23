import 'dart:convert';

import 'package:http/http.dart' show Client;
import 'package:http/http.dart' as http;
import 'package:path/path.dart' as path;

import '../models/response_model.dart';
import 'common.dart';
import 'constants.dart';

class AuthService {
  static final Client client = Client();

  AuthService._();

  static Future<ResponseModel> signUp(body) async {
    final response = await client.post(
        Uri.parse(Constants.baseURL + "/auth/register"),
        body: json.encode(body),
        headers: {
          'Content-Type': 'application/json',
        });
    return ResponseModel(response.statusCode, json.decode(response.body));
  }

  // user login
  static Future<ResponseModel> signIn(body) async {
    final response = await client.post(
        Uri.parse(Constants.baseURL + "/auth/login"),
        body: json.encode(body),
        headers: {
          'Content-Type': 'application/json',
        });

    return ResponseModel(response.statusCode, json.decode(response.body));
  }

  // change password
  static Future<ResponseModel> changePassword(body) async {
    String? token = '';

    await Common.getToken().then((code) {
      token = code;
    });

    final response = await client.put(
        Uri.parse(Constants.baseURL + "/users/password"),
        body: json.encode(body),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'bearer $token',
        });
    return ResponseModel(response.statusCode, json.decode(response.body));
  }

  static Future<ResponseModel> getUserInfo() async {
    String? token = '';
    await Common.getToken().then((code) {
      token = code;
    });
    final response = await client
        .get(Uri.parse(Constants.baseURL + "/users/profile"), headers: {
      'Content-Type': 'application/json',
      'Authorization': 'bearer $token',
    });
    return ResponseModel(response.statusCode, json.decode(response.body));
  }

  static Future<ResponseModel> updateUserProfile(body) async {
    String? token = '';

    await Common.getToken().then((code) {
      token = code;
    });
    final response =
        await client.put(Uri.parse(Constants.baseURL + "/users/profile"),
            headers: {
              'Content-Type': 'application/json',
              'Authorization': 'bearer $token',
            },
            body: json.encode(body));
    return ResponseModel(response.statusCode, json.decode(response.body));
  }

  static Future<ResponseModel> uploadAvatar(stream, length, imagePath) async {
    String? token = '';

    await Common.getToken().then((code) {
      token = code;
    });

    String uri = Constants.baseURL + '/users/avatar';

    dynamic request = http.MultipartRequest("POST", Uri.parse(uri));

    dynamic multipartFile = http.MultipartFile('image', stream, length,
        filename: path.basename(imagePath));

    await request.files.add(multipartFile);

    request.headers['Authorization'] = 'bearer $token';

    final streamedResponse = await request.send();
    final response = await http.Response.fromStream(streamedResponse);

    return ResponseModel(response.statusCode, json.decode(response.body));
  }

  static Future<ResponseModel> checkToken() async {
    String? token = '';

    await Common.getToken().then((code) {
      token = code;
    });
    final response = await client.post(
      Uri.parse(Constants.baseURL + "/auth/verify-token"),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'bearer $token',
      },
    );
    return ResponseModel(response.statusCode, json.decode(response.body));
  }
}
