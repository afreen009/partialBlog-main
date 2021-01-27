// import 'dart:convert';

// import 'package:http/http.dart' as http;

// const String TITLE = "Jenius";

// /// last slash ' / ' is mandatory
// const String BaseUrl = "http://festivalsofearth.com/wp-json/wp/v2/posts?_embed";
// const int FEATURED_CATEGORY_ID = 20;
// const String FEATURED_CATEGORY_TITLE = 'Featured';



// Future<List> fetchData(url) async {
//    var response = await http.get(url + 'wp-json/wp/v2/posts?_embed', headers: {"Accept": "aplication/json"});
//    var convertDataToJson = jsonDecode(response.body);
//   //  print(convertDataToJson);
//    return convertDataToJson;
// }

const String TITLE = "Jenius";

/// last slash ' / ' is mandatory
const String URL = "https://festivalsofearth.com/";

const int FEATURED_CATEGORY_ID = 20;
const String FEATURED_CATEGORY_TITLE = 'Featured';

const String REST_URL_PREFIX = 'wp-json';