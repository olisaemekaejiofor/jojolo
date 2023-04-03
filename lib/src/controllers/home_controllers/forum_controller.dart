// ignore_for_file: avoid_print

import 'dart:convert';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';

import 'package:flutter_custom_tab_bar/library.dart';
import 'package:flutter_share/flutter_share.dart';
import 'package:jojolo_mobile/src/controllers/home_controllers/notification_controller.dart';
import 'package:jojolo_mobile/src/data/models/tag_post_models.dart';

import '../../utils/notification_service.dart';
import '../../utils/notifiers.dart';
import '/src/ui/screens/home_screens/forum/forum_screen.dart';
import '/src/ui/widgets/app_widgets/app_flush.dart';
import '/src/utils/colors.dart';
import '../../data/api_data/api_data.dart';
import '../../data/storage_data/storage_data.dart';
import '../../ui/widgets/app_widgets/bottom_sheet.dart';
import '/src/di/service_locator.dart';
import '../../data/models/post_models.dart';

class ForumController extends ChangeNotifier {
  final PostFeed _post = serviceLocator<PostFeed>();
  final Storage storage = serviceLocator<Storage>();
  final PageController controller = PageController(initialPage: 0);
  final CustomTabBarController tabBarController = CustomTabBarController();
  TextEditingController title = TextEditingController();
  TextEditingController comment = TextEditingController();
  TextEditingController tag = TextEditingController();
  RadioNotifier radio = RadioNotifier();
  List<String> list = ['Feed', 'My Posts', 'Saved Posts', 'Tags'];
  List<Notifications> notifications = [];
  int value = 0;
  late bool stuff;
  bool loading = true;
  bool postsLoad = true;
  bool myPostsLoad = true;
  bool savePostLoad = true;
  bool tagsLoad = true;
  bool comLoad = true;
  bool buttonLoad = false;
  bool checkLike = false;

  List<Post> posts = [];
  List<Post> myPosts = [];
  List<Post> savedPosts = [];
  List<Tag> tags = [];
  List<TagPost> tagsPost = [];
  List<String> tagName = [];
  List<dynamic> tagP = [];

  List<String?> postImage = [];
  String filter = 'latest';

  Post? post;

  String? type = '';
  String? id = '';
  int unread = 0;

  void listenToSocket() {
    SocketService().socket.on('notification-message', (data) {
      var u = jsonDecode(data);
      notifications.add(Notifications(notification: u['message'], title: u['title']));
      NotificationService().showNotifications(u['title'], u['message']);
      unread++;
      notifyListeners();
    });
    notifyListeners();
  }

//load posts for post feed
  void loadPost() async {
    type = await storage.getUserType();
    id = await storage.getId();
    List<Post>? data = await _post.latestPosts();
    //
    posts = data;
    postsLoad = false;
    notifyListeners();
  }

//refresh posts for feed
  Future refreshPosts() async {
    List<Post>? data = await _post.latestPosts();
    posts = data;
    notifyListeners();
  }

//load myposts
  void loadMyPosts() async {
    List<Post>? data = await _post.getMyPosts();
    myPosts = data;
    myPostsLoad = false;
    notifyListeners();
  }

//refresh myPosts
  Future refreshMyPosts() async {
    List<Post>? data = await _post.getMyPosts();
    myPosts = data;
    notifyListeners();
  }

//load savedPosts
  void loadSaved() async {
    List<Post>? data = await _post.getSavedPosts();
    savedPosts = data;
    savePostLoad = false;
    notifyListeners();
  }

//refresh savedPosts
  Future refreshSaved() async {
    List<Post>? mySaved = await _post.getSavedPosts();
    savedPosts = mySaved;
    notifyListeners();
  }

//load tags
  void load() async {
    var u = await _post.getNotificationHistory();
    var x = u.where((e) => e.isRead == false).toList();

    unread = x.length;
    notifyListeners();
    List<Tag> dataTag = await _post.getTags();
    var t = await _post.getTagNumber();

    tags = dataTag;
    for (var i in tags) {
      tagP.add({"tag": i.tagName, "postN": t['${i.tagName}'].toString()});
      notifyListeners();
    }
    loading = false;
    notifyListeners();
  }

//refrsh tags
  Future refreshTags() async {
    List<Tag> tag = await _post.getTags();
    tags = tag;
    notifyListeners();
  }

  void loadTags(String name) async {
    tagsPost = await _post.getTagName(name);
    tagsLoad = false;
    notifyListeners();
  }

//get single post
  Future getPost(String id) async {
    post = await _post.getPost(id);
    comLoad = false;
    notifyListeners();
  }

//like a post
  Future<bool> onlike(bool isLiked) async {
    /// send your request here
    // final bool success= await sendRequest();

    /// if failed, you can do nothing
    // return success? !isLiked:isLiked;

    return !isLiked;
  }

  Future<bool> like(String id, BuildContext ctx) async {
    bool like = await _post.likeUnlike(id);
    return like;
  }

  Future<bool> likeComment(String id, String cid, BuildContext ctx) async {
    bool like = await _post.likeUnlikeComment(id, cid);
    return like;
  }

  //check for like
  Future<bool> checkLiked(String id) async {
    bool liked = await _post.isliked(id);
    return liked;
  }

  Future<bool> checkComment(String id, String cid) async {
    bool liked = await _post.isCommentliked(id, cid);
    return liked;
  }

//save post
  void savePost(String id, BuildContext ctx) async {
    bool isAuthenticated = await storage.isAuthenticated();
    if (isAuthenticated == true) {
      bool saved = await _post.savePost(id);
      // print(saved);
      if (saved == true) {
        Navigator.pop(ctx);
        showFlush(
          ctx,
          message: 'Post Saved Successfully',
          image: 'assets/Active2.svg',
          color: greenColor,
        );

        notifyListeners();
      } else {
        Navigator.pop(ctx);
        showFlush(
          ctx,
          message: 'Unable to Save Post',
          image: 'assets/Active.svg',
          color: errorColor,
        );

        notifyListeners();
      }
    } else {
      bottom(ctx);
    }
  }

//unsave post
  void unSavePost(String id, int index, BuildContext ctx) async {
    bool isAuthenticated = await storage.isAuthenticated();
    if (isAuthenticated == true) {
      bool saved = await _post.unSavePost(id);

      if (saved == true) {
        Navigator.pop(ctx);
        savedPosts.removeAt(index);
        notifyListeners();
        showFlush(
          ctx,
          message: 'Post Unsaved Successfully',
          image: 'assets/Active2.svg',
          color: greenColor,
        );

        notifyListeners();
      } else {
        Navigator.pop(ctx);
        showFlush(
          ctx,
          message: 'Unable to Unsave Post',
          image: 'assets/Active.svg',
          color: errorColor,
        );

        notifyListeners();
      }
    } else {
      bottom(ctx);
    }
  }

//fetching tags
  Future<List<String>> getList() async {
    List<String> list = [];
    List<Tag> dataTag = await _post.getTags();
    for (var i in dataTag) {
      list.add(i.tagName.toString());
      notifyListeners();
    }

    return list;
  }

  Future<String> getTagId(String tagName) async {
    List<Tag> dataTag = await _post.getTags();
    var l = dataTag.where((e) => e.tagName == tagName).toList();
    return l[0].id!;
  }

//creating a post
  void createPost(BuildContext ctx) async {
    bool anon;
    (value == 0) ? anon = false : anon = true;
    notifyListeners();
    buttonLoad = true;
    notifyListeners();
    var tagId = (tag.text != '') ? await getTagId(tag.text) : null;
    String data =
        await _post.createPost(title.text, comment.text, tagId, postImage, anon);
    //
    if (data != 'done') {
      buttonLoad = false;
      showFlush(
        ctx,
        message: data,
        image: 'assets/Active.svg',
        color: errorColor,
      );
      notifyListeners();
    } else {
      showFlush(
        ctx,
        message: 'Post Created Succesfully',
        image: 'assets/Active2.svg',
        color: greenColor,
      );
      Future.delayed(const Duration(seconds: 1), () {
        Navigator.pushNamed(ctx, Forum.routeName);
      });
      notifyListeners();
    }
    notifyListeners();
  }

  //selecting and clearing image for post
  void selectImage() async {
    var doc = await FilePicker.platform.pickFiles(
        type: FileType.custom,
        allowedExtensions: ["png", "jpg", "jpeg"],
        allowCompression: false);

    var path = doc!.paths.first;
    postImage.add(path);
    notifyListeners();
  }

  void clear(int index) {
    postImage.removeAt(index);
    notifyListeners();
  }

  //

  //comment on post
  Future<String> commentPost(String postId) async {
    buttonLoad = true;
    notifyListeners();
    bool done = await _post.comment(postId, comment.text);

    if (done == true) {
      return 'done';
    } else {
      return 'failed';
    }
  }

//reply to comment
  Future<String> replyPost(String postId, String text, String commentId) async {
    buttonLoad = true;
    notifyListeners();
    bool done = await _post.reply(postId, text, commentId);

    if (done == false) {
      return 'failed';
    } else {
      return 'done';
    }
  }

//filter post by latest or popular
  Future filterPost(String type) async {
    if (type == 'popular') {
      postsLoad = true;
      notifyListeners();
      posts = await _post.getPosts();
      postsLoad = false;
      notifyListeners();
    } else if (type == 'latest') {
      loading = true;
      notifyListeners();
      posts = await _post.latestPosts();
      loading = false;
      notifyListeners();
    }
  }

//delete a post youve created
  Future deletePost(String postId, int index, BuildContext ctx) async {
    bool check = await _post.delPost(postId);
    if (check == true) {
      myPosts.removeAt(index);
      Navigator.pop(ctx);
      showFlush(
        ctx,
        message: 'Post Deleted Successfully',
        image: 'assets/Active2.svg',
        color: greenColor,
      );
      notifyListeners();
    } else {
      showFlush(
        ctx,
        message: 'Unable to Delete Post',
        image: 'assets/Active.svg',
        color: errorColor,
      );
      notifyListeners();
    }
  }

//share a post
  Future<dynamic> share(String id, BuildContext ctx) async {
    bool isAuthenticated = await storage.isAuthenticated();
    if (isAuthenticated == true) {
      await FlutterShare.share(
        title: 'Check out my post on Jojolo',
        text: 'Check out a post on Jojolo.\nClick on this link to view the post\n',
        linkUrl: 'https://jojolo.netlify.app/forum/post/' + id,
      );
    } else {
      bottom(ctx);
    }
  }

  Future<bool> reportPost(String postId) async {
    var check = await _post.reportPost(postId);
    return check;
  }
}
