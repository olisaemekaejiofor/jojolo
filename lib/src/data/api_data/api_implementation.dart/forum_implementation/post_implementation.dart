// ignore_for_file: avoid_print, unused_local_variable, iterable_contains_unrelated_type

import 'dart:convert';
import 'dart:io';

// import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';
import 'package:jojolo_mobile/src/data/models/tag_post_models.dart' as tag;
import 'package:path_provider/path_provider.dart';

import '/src/data/storage_data/storage_data.dart';
import '/src/di/service_locator.dart';
import '/src/utils/api_routes.dart';
import '/src/data/api_data/api_data.dart';
import '/src/data/models/post_models.dart';

class PostImpl implements PostFeed {
  Storage store = serviceLocator<Storage>();
  @override
  Future<List<Post>> getPosts() async {
    String? token = await store.getToken();
    String? id = await store.getId();
    String? userType = await store.getUserType();

    var url = (userType == 'caregiver')
        ? Uri.parse(AppUrl.getFeeds)
        : Uri.parse(AppUrl.getDFeeds);

    var headers = {
      'Authorization': 'Bearer $token',
      'Content-Type': 'application/json',
    };

    var res = await http.get(url, headers: headers);
    // print(res.body);
    if (res.statusCode == 200) {
      Map<String, dynamic> json = jsonDecode(res.body);

      List<dynamic> posts = json['data']['posts'];

      List<Post> postList = posts.map((dynamic item) => Post.fromJson(item)).toList();
      return postList;
    } else {
      return [];
    }
  }

  @override
  Future<bool> isliked(String postId) async {
    String? token = await store.getToken();
    String? userId = await store.getId();
    String? userType = await store.getUserType();
    bool normal = false;
    var data = '?_id=$postId';

    var url = (userType == 'caregiver')
        ? Uri.parse(AppUrl.getPost + data)
        : Uri.parse(AppUrl.getDFeeds + data);
    var headers = {'Authorization': 'Bearer $token', 'Content-Type': 'application/json'};

    var res = await http.get(url, headers: headers);
    if (res.statusCode == 200) {
      var bodyData = jsonDecode(res.body);
      List<dynamic> post = bodyData['data']['posts'];
      List<Post> postList = post.map((dynamic item) => Post.fromJson(item)).toList();

      for (var i in postList[0].likes) {
        var b = i.id == userId;
        normal = b;
      }
      return normal;
    } else {
      return false;
    }
  }

  @override
  Future<bool> likeUnlike(String postId) async {
    String? token = await store.getToken();
    String? userType = await store.getUserType();
    // print('token: ' + token!);

    String? userId = await store.getId();
    // print('userId: ' + userId!);
    var data = (userType == 'caregiver')
        ? {"caregiverId": userId, "postId": postId}
        : {"doctorId": userId, "postId": postId};

    var url = (userType == 'caregiver')
        ? Uri.parse(AppUrl.caregiverLike)
        : Uri.parse(AppUrl.doctorLike);

    var headers = {'Authorization': 'Bearer $token', 'Content-Type': 'application/json'};

    var res = await http.post(
      url,
      body: jsonEncode(data),
      headers: headers,
    );
    // print(res.body);
    if (res.statusCode == 200) {
      return true;
    } else {
      return false;
    }
  }

  @override
  Future<List<Post>> getMyPosts() async {
    String? token = await store.getToken();
    String? id = await store.getId();
    String? userType = await store.getUserType();

    var headers = {
      'Authorization': 'Bearer $token',
      'Content-Type': 'application/json',
    };

    var url = (userType == 'caregiver')
        ? Uri.parse(AppUrl.getMyPosts + '$id')
        : Uri.parse(AppUrl.getDoctorPost + '$id');

    var res = await http.get(url, headers: headers);
    if (res.statusCode == 200) {
      Map<String, dynamic> json = jsonDecode(res.body);
      // print(json['data']['posts']);
      List<dynamic> posts = json['data']['posts'];
      List<Post> postList = posts.map((dynamic item) => Post.fromJson(item)).toList();
      postList.sort((a, b) {
        DateFormat formatter = DateFormat("yyyy-MM-ddTHH:mm:ssZ");
        DateTime aTime = a.createdAt!;
        DateTime bTime = b.createdAt!;

        return aTime.compareTo(bTime);
      });
      return postList;
    } else {
      return [];
    }
  }

  @override
  Future<List<Post>> getSavedPosts() async {
    String? token = await store.getToken();
    String? id = await store.getId();
    String? userType = await store.getUserType();

    var url = (userType == 'caregiver')
        ? Uri.parse(AppUrl.getSavedPosts + '$id?sort=desc')
        : Uri.parse(AppUrl.getDSavedPosts + '$id?sort=desc');

    var headers = {
      'Authorization': 'Bearer $token',
      'Content-Type': 'application/json',
    };
    var res = await http.get(url, headers: headers);
    if (res.statusCode == 200) {
      Map<String, dynamic> json = jsonDecode(res.body);

      List<dynamic> posts = json['data']['posts'];
      List<Post> postList = posts.map((dynamic item) => Post.fromJson(item)).toList();
      postList.sort((a, b) {
        DateFormat formatter = DateFormat("yyyy-MM-ddTHH:mm:ssZ");
        DateTime aTime = a.updatedAt!;
        DateTime bTime = b.updatedAt!;

        return aTime.compareTo(bTime);
      });
      return postList;
    } else {
      return [];
    }
  }

  @override
  Future<List<Tag>> getTags() async {
    String? token = await store.getToken();
    String? id = await store.getId();
    var headers = {
      'Authorization': 'Bearer $token',
      'Content-Type': 'application/json',
    };

    var res = await http.get(Uri.parse(AppUrl.getTags), headers: headers);
    // print(res.body);
    if (res.statusCode == 200) {
      var body = jsonDecode(res.body);
      List<dynamic> tags = body['data']['tags'];
      List<Tag> list = tags.map((dynamic item) => Tag.fromJson(item)).toList();
      return list;
    } else {
      return [];
    }
  }

  @override
  Future<bool> savePost(String postId) async {
    String? token = await store.getToken();
    String? id = await store.getId();
    String? userType = await store.getUserType();
    var headers = {
      'Authorization': 'Bearer $token',
      'Content-Type': 'application/json',
    };
    var body = (userType == 'caregiver')
        ? {'caregiverId': id, "is_SavedPosts": true}
        : {'doctorId': id, "is_SavedPosts": true};

    var url = (userType == 'caregiver')
        ? Uri.parse(AppUrl.savePost + postId)
        : Uri.parse(AppUrl.saveDPost + postId);
    var res = await http.put(
      url,
      headers: headers,
      body: jsonEncode(body),
    );
    if (res.statusCode == 200) {
      return true;
    } else {
      return false;
    }
  }

  @override
  Future<String> createPost(String title, String content, String? tags,
      List<String?> postImage, bool postAnon) async {
    String? token = await store.getToken();
    String? id = await store.getId();
    String? userType = await store.getUserType();

    var headers = {
      'Authorization': 'Bearer $token',
      'Content-Type': 'application/json',
    };

    var url = (userType == 'caregiver')
        ? Uri.parse(AppUrl.createPost)
        : Uri.parse(AppUrl.dPost);

    var req = http.MultipartRequest('POST', url);
    (tags != null)
        ? req.fields.addAll({
            'title': title,
            'content': content,
            'tags': tags,
            'postAnonymously': postAnon.toString(),
            (userType == 'caregiver') ? 'caregiverId' : 'doctorId': '$id',
          })
        : req.fields.addAll({
            'title': title,
            'content': content,
            'postAnonymously': postAnon.toString(),
            (userType == 'caregiver') ? 'caregiverId' : 'doctorId': '$id',
          });

    for (var i in postImage) {
      req.files.add(await http.MultipartFile.fromPath('postImage', i.toString()));
    }

    req.headers.addAll(headers);

    var res = await req.send();
    var bodyData = jsonDecode(await res.stream.bytesToString());
    if (res.statusCode == 200) {
      return 'done';
    } else {
      return bodyData['data'];
    }
  }

  @override
  Future<Post> getPost(String postId) async {
    String? token = await store.getToken();
    String? userId = await store.getId();
    String? userType = await store.getUserType();
    var data = '?_id=$postId';

    var url = (userType == 'caregiver')
        ? Uri.parse(AppUrl.getPost + data)
        : Uri.parse(AppUrl.getDFeeds + data);
    var headers = {'Authorization': 'Bearer $token', 'Content-Type': 'application/json'};

    var res = await http.get(url, headers: headers);
    // print(res.body);
    if (res.statusCode == 200) {
      var bodyData = jsonDecode(res.body);
      List<dynamic> post = bodyData['data']['posts'];
      Post tPost = Post.fromJson(post[0]);
      return tPost;
    } else {
      throw Error();
    }
  }

  @override
  Future<bool> delPost(String postId) async {
    String? token = await store.getToken();
    String? userId = await store.getId();
    String? userType = await store.getUserType();

    var url = (userType == 'caregiver')
        ? Uri.parse(AppUrl.deletePost + '$userId/$postId')
        : Uri.parse(AppUrl.deleteDPost + '$userId/$postId');
    var headers = {'Authorization': 'Bearer $token', 'Content-Type': 'application/json'};
    var res = await http.delete(url, headers: headers);
    // print(res.body);
    if (res.statusCode == 200) {
      return true;
    } else {
      return false;
    }
  }

  @override
  Future<List<Post>> latestPosts() async {
    String? token = await store.getToken();
    String? id = await store.getId();
    String? userType = await store.getUserType();

    String fileName = 'post';

    var dir = await getTemporaryDirectory();
    File file = File(dir.path + '/' + fileName);

    var url = (userType == 'caregiver')
        ? Uri.parse(AppUrl.getFeeds + '?sort=desc')
        : Uri.parse(AppUrl.getDFeeds + '?sort=desc');

    var headers = {
      'Authorization': 'Bearer $token',
      'Content-Type': 'application/json',
    };
    var res = await http.get(url, headers: headers);
    if (file.existsSync() && file.readAsStringSync() == res.body) {
      var jsonData = jsonDecode(file.readAsStringSync());
      List<dynamic> jposts = jsonData['data']['posts'];
      List<Post> jpostList = jposts.map((dynamic item) => Post.fromJson(item)).toList();
      return jpostList;
    } else {
      if (res.statusCode == 200) {
        file.writeAsStringSync(res.body, flush: true, mode: FileMode.write);
        Map<String, dynamic> json = jsonDecode(res.body);

        List<dynamic> posts = json['data']['posts'];
        List<Post> postList = posts.map((dynamic item) => Post.fromJson(item)).toList();
        return postList;
      } else {
        return [];
      }
    }
  }

  @override
  Future<List<Post>> popularPosts() async {
    String? token = await store.getToken();
    String? id = await store.getId();
    String? userType = await store.getUserType();

    var url = (userType == 'caregiver')
        ? Uri.parse(AppUrl.filterPopular)
        : Uri.parse(AppUrl.filterPopularD);

    var headers = {
      'Authorization': 'Bearer $token',
      'Content-Type': 'application/json',
    };
    var res = await http.get(url, headers: headers);
    if (res.statusCode == 200) {
      Map<String, dynamic> json = jsonDecode(res.body);

      List<dynamic> posts = json['data']['posts'];
      List<Post> postList = posts.map((dynamic item) => Post.fromJson(item)).toList();
      return postList;
    } else {
      return [];
    }
  }

  @override
  Future<bool> unSavePost(String postId) async {
    String? token = await store.getToken();
    String? id = await store.getId();
    String? userType = await store.getUserType();
    var headers = {
      'Authorization': 'Bearer $token',
      'Content-Type': 'application/json',
    };
    var body = (userType == 'caregiver')
        ? {'caregiverId': id, "is_SavedPosts": false}
        : {'doctorId': id, "is_SavedPosts": false};

    var url = (userType == 'caregiver')
        ? Uri.parse(AppUrl.savePost + postId)
        : Uri.parse(AppUrl.saveDPost + postId);
    var res = await http.put(
      url,
      headers: headers,
      body: jsonEncode(body),
    );

    if (res.statusCode == 200) {
      return true;
    } else {
      return false;
    }
  }

  @override
  Future<bool> comment(
    String postId,
    String comments,
  ) async {
    String? token = await store.getToken();
    String? id = await store.getId();
    String? userType = await store.getUserType();
    String? role = await store.getRole();
    String? fullname = await store.getName();
    var headers = {
      'Authorization': 'Bearer $token',
      'Content-Type': 'application/json',
    };
    var url = (userType == 'caregiver')
        ? Uri.parse(AppUrl.commentPost)
        : Uri.parse(AppUrl.dCommentPost);

    var body = (userType == 'caregiver')
        ? {
            "postId": postId,
            "comments": comments,
            "caregiverId": id,
            "fullName": fullname,
            "rolesDescription": role,
            "timeMoment": DateTime.now().add(const Duration(hours: 1)).toUtc().toString(),
          }
        : {
            "postId": postId,
            "comments": comments,
            "doctorId": id,
            "fullName": fullname,
            "role": role,
            "timeMoment": DateTime.now().add(const Duration(hours: 1)).toUtc().toString(),
          };
    var res = await http.post(url, headers: headers, body: jsonEncode(body));
    if (res.statusCode == 200) {
      return true;
    } else {
      return false;
    }
  }

  @override
  Future<bool> reply(
    String postId,
    String reply,
    String commentId,
  ) async {
    String? token = await store.getToken();
    String? id = await store.getId();
    String? userType = await store.getUserType();
    String? role = await store.getRole();
    String? fullname = await store.getName();
    var headers = {
      'Authorization': 'Bearer $token',
      'Content-Type': 'application/json',
    };

    var url = (userType == 'caregiver')
        ? Uri.parse(AppUrl.commentReply)
        : Uri.parse(AppUrl.dCommentReply);
    var body = (userType == 'caregiver')
        ? {
            "postId": postId,
            "commentId": commentId,
            "caregiverId": id,
            "fullName": fullname,
            "rolesDescription": role,
            "reply": reply,
            "timeMoment": DateTime.now().add(const Duration(hours: 1)).toUtc().toString(),
          }
        : {
            "postId": postId,
            "commentId": commentId,
            "doctorId": id,
            "fullName": fullname,
            "role": role,
            "reply": reply,
            "timeMoment": DateTime.now().add(const Duration(hours: 1)).toUtc().toString(),
          };

    var res = await http.post(url, headers: headers, body: jsonEncode(body));

    if (res.statusCode == 200) {
      return true;
    } else {
      return false;
    }
  }

  @override
  Future<bool> reportPost(String postId) async {
    String? token = await store.getToken();
    String? id = await store.getId();
    String? userType = await store.getUserType();
    String? role = await store.getRole();
    String? fullname = await store.getName();

    var headers = {
      'Content-Type': 'application/json',
      'Authorization': 'Bearer $token',
    };

    var url = (userType == 'caregiver')
        ? Uri.parse(AppUrl.reportPost)
        : Uri.parse(AppUrl.reportDPost);

    var data = (userType == 'caregiver')
        ? {
            "postId": postId,
            "reportPost": "false message speech",
            "caregiverId": "$id",
          }
        : {
            "postId": postId,
            "reportPost": "false message speech",
            "doctorId": "$id",
          };

    var res = await http.post(url, headers: headers, body: jsonEncode(data));

    var jsonData = jsonDecode(res.body);

    if (res.statusCode == 200) {
      return true;
    } else {
      return false;
    }
  }

  @override
  Future<List<tag.TagPost>> getTagName(String tagName) async {
    String? token = await store.getToken();
    String? id = await store.getId();
    String? userType = await store.getUserType();

    var url = (userType == 'caregiver')
        ? Uri.parse(AppUrl.getTags + '/$id?tagName=$tagName')
        : Uri.parse(AppUrl.getDTags + '/$id?tagName=$tagName');

    var headers = {
      'Authorization': 'Bearer $token',
      'Content-Type': 'application/json',
    };
    var res = await http.get(url, headers: headers);
    if (res.statusCode == 200) {
      Map<String, dynamic> json = jsonDecode(res.body);

      List<dynamic> posts = json['data']['posts'];
      List<tag.TagPost> postList =
          posts.map((dynamic item) => tag.TagPost.fromJson(item)).toList();
      return postList;
    } else {
      return [];
    }
  }

  Future<String?> getTagId(String? tag) async {
    String? token = await store.getToken();
    String? id = await store.getId();
    String? userType = await store.getUserType();

    var url = (userType == 'caregiver')
        ? Uri.parse(AppUrl.getTags + '/$id?tagName=$tag')
        : Uri.parse(AppUrl.getDTags + '/$id?tagName=$tag');

    var headers = {
      'Authorization': 'Bearer $token',
      'Content-Type': 'application/json',
    };
    var res = await http.get(url, headers: headers);
    if (res.statusCode == 200) {
      Map<String, dynamic> json = jsonDecode(res.body);
      return json['data']['posts'][0]['tags']['_id'];
    }
    return null;
  }

  @override
  Future<dynamic> getTagNumber() async {
    String? token = await store.getToken();
    String? id = await store.getId();
    String? userType = await store.getUserType();

    var url = (userType == 'caregiver')
        ? Uri.parse(AppUrl.caregiver + '/analytics/$id')
        : Uri.parse(AppUrl.doctor + '/analytics/$id');

    var headers = {
      'Authorization': 'Bearer $token',
      'Content-Type': 'application/json',
    };

    var res = await http.get(url, headers: headers);

    var bodyData = jsonDecode(res.body);

    var analytics = bodyData['data']['analytics'];
    return analytics;
  }

  @override
  Future<bool> likeUnlikeComment(String postId, String commentId) async {
    String? token = await store.getToken();
    String? userType = await store.getUserType();

    String? userId = await store.getId();
    var data = (userType == 'caregiver')
        ? {
            "caregiverId": userId,
            "postId": postId,
            "commentId": commentId,
          }
        : {
            "doctorId": userId,
            "postId": postId,
            "commentId": commentId,
          };

    var url = (userType == 'caregiver')
        ? Uri.parse(AppUrl.caregiver + '/comment-like')
        : Uri.parse(AppUrl.doctor + '/comment-like');

    var headers = {'Authorization': 'Bearer $token', 'Content-Type': 'application/json'};

    var res = await http.post(
      url,
      body: jsonEncode(data),
      headers: headers,
    );
    // print(res.body);
    if (res.statusCode == 200) {
      return true;
    } else {
      return false;
    }
  }

  @override
  Future<bool> isCommentliked(String postId, String commentId) async {
    String? token = await store.getToken();
    String? userId = await store.getId();
    String? userType = await store.getUserType();
    bool normal = false;
    var data = '?_id=$postId';

    var url = (userType == 'caregiver')
        ? Uri.parse(AppUrl.getPost + data)
        : Uri.parse(AppUrl.getDFeeds + data);
    var headers = {'Authorization': 'Bearer $token', 'Content-Type': 'application/json'};

    var res = await http.get(url, headers: headers);
    if (res.statusCode == 200) {
      var bodyData = jsonDecode(res.body);
      List<dynamic> post = bodyData['data']['posts'][0]['comments'];
      List<CommentElement> postList =
          post.map((dynamic item) => CommentElement.fromJson(item)).toList();

      for (var i in postList) {
        if (i.id == commentId) {
          for (var j in i.likes) {
            var b = j.id == userId;
            normal = b;
          }
        }
      }
      return normal;
    } else {
      return false;
    }
  }

  @override
  Future<List<Notices>> getNotificationHistory() async {
    String? token = await store.getToken();
    String? userId = await store.getId();
    String? userType = await store.getUserType();

    var url = (userType == 'caregiver')
        ? Uri.parse(AppUrl.caregiver + '/notification-history?acceptor=$userId&sort=desc')
        : Uri.parse(AppUrl.doctor + '/notification-history?acceptor=$userId&sort=desc');
    var headers = {'Authorization': 'Bearer $token'};
    var res = await http.get(url, headers: headers);
    if (res.statusCode == 200) {
      var bodyData = jsonDecode(res.body);
      List<dynamic> list = bodyData['data']['notifications'];
      return list.map((dynamic item) => Notices.fromJson(item)).toList();
    } else {
      return [];
    }
  }

  @override
  Future<void> setNotification(String sid) async {
    String? id = await store.getId();
    String? token = await store.getToken();
    String? type = await store.getUserType();

    var url = (type == 'caregiver')
        ? Uri.parse(AppUrl.caregiver + '/notification-is-read/$sid')
        : Uri.parse(AppUrl.doctor + '/notification-is-read/$sid');

    var headers = {'Authorization': 'Bearer $token', 'Content-Type': 'application/json'};
    var body = jsonEncode({'isRead': true});
    var res = await http.put(url, body: body, headers: headers);
  }
}
