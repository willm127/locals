import 'dart:convert';
import 'package:http/http.dart' as http;

import '../models/post.dart';

class Network {
  final baseURL = 'https://app-test.rr-qa.seasteaddigital.com';

  final email = 'testlocals0@gmail.com';
  final pass = 'jahubhsgvd23';
  final deviceID = '7789e3ef-c87f-49c5-a2d3-5165927298f0';
  String token = '';
  var lpid = 0;
  var prevOrder = '';

  Future<void> _authenticate() async {
    try {
      final url = Uri.parse(baseURL + '/app_api/auth.php');
      final response = await http.post(
        url,
        body: {
          'email': email,
          'password': pass,
          'device_id': deviceID,
        },
      );
      final json = jsonDecode(response.body);
      token = json['result']['ss_auth_token'];
    } catch (e) {
      throw Error();
    }
  }

  Future<List<Post>> fetchPosts(String order) async {
    if (prevOrder != order) {
      // If it's not the same order, we have to start over
      lpid = 0;
      prevOrder = order;
    }

    try {
      if (token.isEmpty) {
        await _authenticate();
      }

      final url = Uri.parse(baseURL + '/api/v1/posts/feed/global.json');

      Map<String, dynamic> body = {
        "page_size": 10,
        "order": order.toLowerCase(),
        "lpid": lpid
      };

      final response = await http.post(
        url,
        headers: {'X-APP-AUTH-TOKEN': token, 'X-DEVICE-ID': deviceID},
        body: jsonEncode({'data': body}),
      );

      final data = await jsonDecode(response.body);

      final List<Post> posts = [];

      data['data'].forEach((p) {
        posts.add(Post(
          p['id'],
          DateTime.fromMillisecondsSinceEpoch(p['timestamp'] * 1000),
          p['author_name'],
          p['author_avatar_url'],
          p['title'],
          p['text'],
        ));
      });

      lpid = posts.last.id;

      return posts;
    } catch (e) {
      print(e);
      return [];
    }
  }
}
