class Post {
  Post({
    required this.id,
    required this.doctorId,
    required this.title,
    required this.content,
    required this.tags,
    required this.imageUrl,
    required this.postAnonymously,
    required this.shares,
    required this.likes,
    required this.comments,
    required this.isSavedPosts,
    required this.reportPost,
    required this.createdAt,
    required this.updatedAt,
    required this.v,
    required this.caregiverId,
  });

  final String? id;
  final DoctorId? doctorId;
  final String? title;
  final String? content;
  final List<Tag> tags;
  final List<String> imageUrl;
  final bool? postAnonymously;
  final List<dynamic> shares;
  final List<Like> likes;
  final List<CommentElement> comments;
  final bool? isSavedPosts;
  final List<dynamic> reportPost;
  final DateTime? createdAt;
  final DateTime? updatedAt;
  final int? v;
  final CaregiverId? caregiverId;

  factory Post.fromJson(Map<String, dynamic> json) {
    return Post(
      id: json["_id"],
      doctorId: json["doctorId"] == null ? null : DoctorId.fromJson(json["doctorId"]),
      title: json["title"],
      content: json["content"],
      tags: json["tags"] == null
          ? []
          : List<Tag>.from(json["tags"]!.map((x) => Tag.fromJson(x))),
      imageUrl: json["imageUrl"] == null
          ? []
          : List<String>.from(json["imageUrl"]!.map((x) => x)),
      postAnonymously: json["postAnonymously"],
      shares:
          json["shares"] == null ? [] : List<dynamic>.from(json["shares"]!.map((x) => x)),
      likes: json["likes"] == null
          ? []
          : List<Like>.from(json["likes"]!.map((x) => Like.fromJson(x))),
      comments: json["comments"] == null
          ? []
          : List<CommentElement>.from(
              json["comments"]!.map((x) => CommentElement.fromJson(x))),
      isSavedPosts: json["is_SavedPosts"],
      reportPost: json["reportPost"] == null
          ? []
          : List<dynamic>.from(json["reportPost"]!.map((x) => x)),
      createdAt: json["createdAt"] == null ? null : DateTime.parse(json["createdAt"]),
      updatedAt: json["updatedAt"] == null ? null : DateTime.parse(json["updatedAt"]),
      v: json["__v"],
      caregiverId:
          json["caregiverId"] == null ? null : CaregiverId.fromJson(json["caregiverId"]),
    );
  }

  Map<String, dynamic> toJson() => {
        "_id": id,
        "doctorId": doctorId?.toJson(),
        "title": title,
        "content": content,
        "tags": tags.map((x) => x.toJson()).toList(),
        "imageUrl": List<String>.from(imageUrl.map((x) => x)),
        "postAnonymously": postAnonymously,
        "shares": List<dynamic>.from(shares.map((x) => x)),
        "likes": List<Like>.from(likes.map((x) => x.toJson())),
        "comments": List<CommentElement>.from(comments.map((x) => x.toJson())),
        "is_SavedPosts": isSavedPosts,
        "reportPost": List<dynamic>.from(reportPost.map((x) => x)),
        "createdAt": createdAt?.toIso8601String(),
        "updatedAt": updatedAt?.toIso8601String(),
        "__v": v,
        "caregiverId": caregiverId?.toJson(),
      };
}

class CaregiverId {
  CaregiverId({
    required this.id,
    required this.fullName,
    required this.rolesDescription,
    required this.imageUrl,
  });

  final String? id;
  final String? fullName;
  final String? rolesDescription;
  final String? imageUrl;

  factory CaregiverId.fromJson(Map<String, dynamic> json) {
    return CaregiverId(
      id: json["_id"],
      fullName: json["fullName"],
      rolesDescription: json["rolesDescription"],
      imageUrl: json["imageUrl"],
    );
  }

  Map<String, dynamic> toJson() => {
        "_id": id,
        "fullName": fullName,
        "rolesDescription": rolesDescription,
        "imageUrl": imageUrl,
      };
}

class CommentElement {
  CommentElement({
    required this.id,
    required this.likes,
    required this.replies,
    required this.postId,
    required this.comments,
    required this.doctorId,
    required this.fullName,
    required this.role,
    required this.comment,
    required this.caregiverId,
    required this.rolesDescription,
    required this.timeMoment,
    required this.userType,
  });

  final String? id;
  final List<Like> likes;
  final List<ReplyElement> replies;
  final String? postId;
  final String? comments;
  final String? doctorId;
  final String? fullName;
  final String? role;
  final CommentComment? comment;
  final String? caregiverId;
  final String? rolesDescription;
  final String? timeMoment;
  final String? userType;

  factory CommentElement.fromJson(Map<String, dynamic> json) {
    return CommentElement(
      id: json["_id"],
      likes: json["likes"] == null
          ? []
          : List<Like>.from(json["likes"]!.map((x) => Like.fromJson(x))),
      replies: json["replies"] == null
          ? []
          : List<ReplyElement>.from(
              json["replies"]!.map((x) => ReplyElement.fromJson(x))),
      postId: json["postId"],
      comments: json["comments"],
      doctorId: json["doctorId"],
      fullName: json["fullName"],
      role: json["role"],
      comment: json["comment"] == null ? null : CommentComment.fromJson(json["comment"]),
      caregiverId: json["caregiverId"],
      rolesDescription: json["rolesDescription"],
      timeMoment: json["timeMoment"],
      userType: json["userType"],
    );
  }

  Map<String, dynamic> toJson() => {
        "_id": id,
        "likes": List<Like>.from(likes.map((x) => x.toJson())),
        "replies": List<ReplyElement>.from(replies.map((x) => x.toJson())),
        "postId": postId,
        "comments": comments,
        "doctorId": doctorId,
        "fullName": fullName,
        "role": role,
        "comment": comment?.toJson(),
        "caregiverId": caregiverId,
        "rolesDescription": rolesDescription,
        "timeMoment": timeMoment,
        "userType": userType,
      };
}

class CommentComment {
  CommentComment({
    required this.postId,
    required this.caregiverId,
    required this.fullName,
    required this.rolesDescription,
    required this.comments,
    required this.timeMoment,
    required this.userType,
  });

  final String? postId;
  final String? caregiverId;
  final String? fullName;
  final String? rolesDescription;
  final String? comments;
  final String? timeMoment;
  final String? userType;

  factory CommentComment.fromJson(Map<String, dynamic> json) {
    return CommentComment(
      postId: json["postId"],
      caregiverId: json["caregiverId"],
      fullName: json["fullName"],
      rolesDescription: json["rolesDescription"],
      comments: json["comments"],
      timeMoment: json["timeMoment"],
      userType: json["userType"],
    );
  }

  Map<String, dynamic> toJson() => {
        "postId": postId,
        "caregiverId": caregiverId,
        "fullName": fullName,
        "rolesDescription": rolesDescription,
        "comments": comments,
        "timeMoment": timeMoment,
        "userType": userType,
      };
}

class Like {
  Like({
    required this.id,
  });

  final String? id;

  factory Like.fromJson(Map<String, dynamic> json) {
    return Like(
      id: json["_id"],
    );
  }

  Map<String, dynamic> toJson() => {
        "_id": id,
      };
}

class ReplyElement {
  ReplyElement({
    required this.id,
    required this.likes,
    required this.reply,
  });

  final String? id;
  final List<Like> likes;
  final ReplyReply? reply;

  factory ReplyElement.fromJson(Map<String, dynamic> json) {
    return ReplyElement(
      id: json["_id"],
      likes: json["likes"] == null
          ? []
          : List<Like>.from(json["likes"]!.map((x) => Like.fromJson(x))),
      reply: json["reply"] == null ? null : ReplyReply.fromJson(json["reply"]),
    );
  }

  Map<String, dynamic> toJson() => {
        "_id": id,
        "likes": List<Like>.from(likes.map((x) => x.toJson())),
        "reply": reply?.toJson(),
      };
}

class ReplyReply {
  ReplyReply({
    required this.postId,
    required this.commentId,
    required this.doctorId,
    required this.reply,
    required this.fullName,
    required this.role,
    required this.userType,
    required this.rolesDescription,
    required this.caregiverId,
    required this.timeMoment,
    required this.replyId,
  });

  final String? postId;
  final String? commentId;
  final String? doctorId;
  final String? reply;
  final String? fullName;
  final String? role;
  final String? userType;
  final String? rolesDescription;
  final String? caregiverId;
  final String? timeMoment;
  final String? replyId;

  factory ReplyReply.fromJson(Map<String, dynamic> json) {
    return ReplyReply(
      postId: json["postId"],
      commentId: json["commentId"],
      doctorId: json["doctorId"],
      reply: json["reply"],
      fullName: json["fullName"],
      role: json["role"],
      userType: json["userType"],
      rolesDescription: json["rolesDescription"],
      caregiverId: json["caregiverId"],
      timeMoment: json["timeMoment"],
      replyId: json["replyId"],
    );
  }

  Map<String, dynamic> toJson() => {
        "postId": postId,
        "commentId": commentId,
        "doctorId": doctorId,
        "reply": reply,
        "fullName": fullName,
        "role": role,
        "userType": userType,
        "rolesDescription": rolesDescription,
        "caregiverId": caregiverId,
        "timeMoment": timeMoment,
        "replyId": replyId,
      };
}

class DoctorId {
  DoctorId({
    required this.id,
    required this.fullName,
    required this.role,
  });

  final String? id;
  final String? fullName;
  final String? role;

  factory DoctorId.fromJson(Map<String, dynamic> json) {
    return DoctorId(
      id: json["_id"],
      fullName: json["fullName"],
      role: json["role"],
    );
  }

  Map<String, dynamic> toJson() => {
        "_id": id,
        "fullName": fullName,
        "role": role,
      };
}

class Tag {
  Tag({
    required this.id,
    required this.tagName,
    required this.createdAt,
    required this.updatedAt,
    required this.v,
  });

  final String? id;
  final String? tagName;
  final DateTime? createdAt;
  final DateTime? updatedAt;
  final num? v;

  factory Tag.fromJson(Map<String, dynamic> json) {
    return Tag(
      id: json["_id"],
      tagName: json["tagName"],
      createdAt: json["createdAt"] == null ? null : DateTime.parse(json["createdAt"]),
      updatedAt: json["updatedAt"] == null ? null : DateTime.parse(json["updatedAt"]),
      v: json["__v"],
    );
  }

  Map<String, dynamic> toJson() => {
        "_id": id,
        "tagName": tagName,
        "createdAt": createdAt?.toIso8601String(),
        "updatedAt": updatedAt?.toIso8601String(),
        "__v": v,
      };
}
