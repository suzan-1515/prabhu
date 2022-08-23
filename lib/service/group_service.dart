import 'dart:convert';

import 'package:http/http.dart';
import 'package:prabhu_movie_recommendation_system/models/response_model.dart';

import 'common.dart';
import 'constants.dart';

class GroupService {
  static final Client client = Client();

  GroupService._();

  static Future<ResponseModel> getGroup() async {
    String? token = '';
    await Common.getToken().then((onValue) => token = onValue);
    final response = await client.get(
      Uri.parse(Constants.baseURL + "/groups/"),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'bearer $token',
      },
    );
    var body = json.decode(response.body);
    late Map<String, dynamic> data;
    if (body is List) {
      data = {'groups': body};
    } else {
      data = body;
    }
    return ResponseModel(response.statusCode, data);
  }

  static Future<ResponseModel> createGroup(final String name) async {
    String? token = '';
    final body = {'name': name};
    await Common.getToken().then((onValue) => token = onValue);
    final response = await client.post(
      Uri.parse(Constants.baseURL + "/groups/"),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'bearer $token',
      },
      body: json.encode(body),
    );
    return ResponseModel(response.statusCode, json.decode(response.body));
  }

  static Future<ResponseModel> removeMember(
    int groupId,
    List<int> membersId,
  ) async {
    String? token = '';
    final body = {'groupId': groupId, 'membersId': membersId};
    await Common.getToken().then((onValue) => token = onValue);
    final response = await client.delete(
      Uri.parse(Constants.baseURL + "/groups/remove-member/"),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'bearer $token',
      },
      body: json.encode(body),
    );
    return ResponseModel(response.statusCode, json.decode(response.body));
  }

  static Future<ResponseModel> addMember(
    int groupId,
    List<String> membersId,
  ) async {
    String? token = '';
    final body = {'groupId': groupId, 'membersId': membersId};
    await Common.getToken().then((onValue) => token = onValue);
    final response = await client.put(
      Uri.parse(Constants.baseURL + "/groups/add-member/"),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'bearer $token',
      },
      body: json.encode(body),
    );
    return ResponseModel(response.statusCode, json.decode(response.body));
  }

  static Future<ResponseModel> deleteGroup(
    int groupId,
  ) async {
    String? token = '';
    await Common.getToken().then((onValue) => token = onValue);
    final response = await client.delete(
      Uri.parse(Constants.baseURL + "/groups/$groupId"),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'bearer $token',
      },
    );
    return ResponseModel(response.statusCode, json.decode(response.body));
  }
}
