// ignore_for_file: avoid_print

import 'dart:async';

import 'package:flutter/material.dart';
import 'package:jojolo_mobile/src/data/api_data/api_data.dart';
import 'package:jojolo_mobile/src/di/service_locator.dart';

import '../../data/models/post_models.dart';

class SearchController extends ChangeNotifier {
  final TextEditingController controller = TextEditingController();
  final Search search = serviceLocator<Search>();
  String query = '';
  String result = '';
  List<Post> list = [];
  Timer? debouncer;

  void debounce(
    VoidCallback callback, {
    Duration duration = const Duration(milliseconds: 1000),
  }) {
    if (debouncer != null) {
      debouncer!.cancel();
    }

    debouncer = Timer(duration, callback);
  }

  Future searchPosts(String query) async => debounce(
        () async {
          result = query;
          notifyListeners();
          var posts = await search.searchPosts(query);
          list = posts;
          notifyListeners();
        },
      );
}
