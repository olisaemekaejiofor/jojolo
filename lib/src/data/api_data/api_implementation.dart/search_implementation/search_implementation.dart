// ignore_for_file: avoid_print

import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:jojolo_mobile/src/data/models/post_models.dart';
import 'package:jojolo_mobile/src/utils/api_routes.dart';

import '../../../../di/service_locator.dart';
import '../../../storage_data/storage_data.dart';
import '/src/data/api_data/api_data.dart';

class SearchImpl implements Search {
  Storage store = serviceLocator<Storage>();
  @override
  Future<List<Post>> searchPosts(String query) async {
    String? token = await store.getToken();
    String? id = await store.getId();
    String? userType = await store.getUserType();

    var url = (userType == 'caregiver')
        ? Uri.parse(AppUrl.search + '$id?search=$query')
        : Uri.parse(AppUrl.dSearch + '$id?search=$query');
    var headers = {
      'Authorization': 'Bearer $token',
      'Content-Type': 'application/json',
    };

    var res = await http.get(url, headers: headers);

    if (res.statusCode == 200) {
      var body = jsonDecode(res.body);
      List list = body['data']['posts'];
      return list.map((e) => Post.fromJson(e)).toList();
    } else {
      return [];
    }
  }
}
