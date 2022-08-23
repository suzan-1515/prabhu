import 'package:prabhu_movie_recommendation_system/service/constants.dart';

class ImageUtils {
  ImageUtils._();

  static String getTMDBImagePath(final String path) =>
      '${Constants.tmdbImageBasePath}$path';

  static String getAvatarPath(final String firstname, String lastName) =>
      'https://ui-avatars.com/api/?name=$firstname+$lastName';

  static String getAvatarPathOfApi(String path) => '${Constants.baseURL}$path';
}
