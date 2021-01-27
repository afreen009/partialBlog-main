import 'dart:convert';

import 'package:google_signin_example/widget/config.dart';
import 'package:http/http.dart' as http;
import '../model/post_entity.dart';

class WpApi {
  static const String BASE_URL = URL + REST_URL_PREFIX + '/wp/v2/';
  
  static Future<List<PostEntity>> getPostsList({int category = 0, int page = 1, String baseurl}) async {
    
    List<PostEntity> posts = List();
    try {
      String extra = category != 0 ? '&categories=' + '$category' : '';
      print(baseurl + REST_URL_PREFIX + '/wp/v2/posts?_embed&page=$page' + extra);
      dynamic response = await http.get(baseurl + REST_URL_PREFIX + '/wp/v2/posts?_embed&page=$page');
      dynamic json = jsonDecode(response.body);

      (json as List).forEach((v) {
        posts.add(PostEntity.fromJson(v));
      });
    } catch (e) {
      //TODO Handle No Internet Response
    }
    return posts;
  }

  static Future<List<PostCategory>> getCategoriesList({int page = 1,String baseurl}) async {
    List<PostCategory> categories = List();
    try {
      dynamic response = await http.get(baseurl +REST_URL_PREFIX + '/wp/v2/categories?orderby=count&order=desc&per_page=15&page=$page');
      print(baseurl +REST_URL_PREFIX + '/wp/v2/categories?orderby=count&order=desc&per_page=15&page=$page');
      dynamic json = jsonDecode(response.body);

      (json as List).forEach((v) {
        categories.add(PostCategory.fromJson(v));
      });
    } catch (e) {
      //TODO Handle No Internet Response
    }
    return categories;
  }
}
