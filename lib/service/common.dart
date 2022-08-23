import 'package:shared_preferences/shared_preferences.dart';

class Common {
  Common._();

  // save token on storage
  static Future<bool> setToken(String token) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.setString('token', token);
  }

  // save genres on storage
  static Future<bool> setGenres(List<int> genres) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.setString('genres', genres.join(','));
  }

  static Future<bool> removeToken() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.remove('token');
  }

  // retrieve token from storage
  static Future<String?> getToken() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return Future(() => prefs.getString('token'));
  }

  // retrieve genres from storage
  static Future<List<int>?> getGenres() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return Future(() {
      final genres = prefs.getString('genres');
      if (genres == null) return List<int>.empty();
      return genres.split(',').map((e) => int.parse(e)).toList();
    });
  }
}
