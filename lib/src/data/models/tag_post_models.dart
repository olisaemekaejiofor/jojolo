class TagPost {
  TagPost({
    required this.id,
    required this.caregiverId,
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
    required this.doctorId,
  });

  final String? id;
  final List<CaregiverId> caregiverId;
  final String? title;
  final String? content;
  final TagP? tags;
  final List<dynamic> imageUrl;
  final bool? postAnonymously;
  final List<dynamic> shares;
  final List<Like> likes;
  final List<CommentElement> comments;
  final bool? isSavedPosts;
  final List<ReportPost> reportPost;
  final DateTime? createdAt;
  final DateTime? updatedAt;
  final int? v;
  final List<DoctorId> doctorId;

  factory TagPost.fromJson(Map<String, dynamic> json) {
    return TagPost(
      id: json["_id"],
      caregiverId: json["caregiverId"] == null
          ? []
          : List<CaregiverId>.from(
              json["caregiverId"]!.map((x) => CaregiverId.fromJson(x))),
      title: json["title"],
      content: json["content"],
      tags: json["tags"] == null ? null : TagP.fromJson(json["tags"]),
      imageUrl: json["imageUrl"] == null
          ? []
          : List<dynamic>.from(json["imageUrl"]!.map((x) => x)),
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
          : List<ReportPost>.from(json["reportPost"]!.map((x) => ReportPost.fromJson(x))),
      createdAt: json["createdAt"] == null ? null : DateTime.parse(json["createdAt"]),
      updatedAt: json["updatedAt"] == null ? null : DateTime.parse(json["updatedAt"]),
      v: json["__v"],
      doctorId: json["doctorId"] == null
          ? []
          : List<DoctorId>.from(json["doctorId"]!.map((x) => DoctorId.fromJson(x))),
    );
  }

  Map<String, dynamic> toJson() => {
        "_id": id,
        "caregiverId": List<CaregiverId>.from(caregiverId.map((x) => x.toJson())),
        "title": title,
        "content": content,
        "tags": tags?.toJson(),
        "imageUrl": List<dynamic>.from(imageUrl.map((x) => x)),
        "postAnonymously": postAnonymously,
        "shares": List<dynamic>.from(shares.map((x) => x)),
        "likes": List<Like>.from(likes.map((x) => x.toJson())),
        "comments": List<CommentElement>.from(comments.map((x) => x.toJson())),
        "is_SavedPosts": isSavedPosts,
        "reportPost": List<ReportPost>.from(reportPost.map((x) => x.toJson())),
        "createdAt": createdAt?.toIso8601String(),
        "updatedAt": updatedAt?.toIso8601String(),
        "__v": v,
        "doctorId": List<DoctorId>.from(doctorId.map((x) => x.toJson())),
      };
}

class CaregiverId {
  CaregiverId({
    required this.fullName,
    required this.rolesDescription,
    required this.imageUrl,
  });

  final String? fullName;
  final String? rolesDescription;
  final String? imageUrl;

  factory CaregiverId.fromJson(Map<String, dynamic> json) {
    return CaregiverId(
      fullName: json["fullName"],
      rolesDescription: json["rolesDescription"],
      imageUrl: json["imageUrl"],
    );
  }

  Map<String, dynamic> toJson() => {
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
    required this.caregiverId,
    required this.fullName,
    required this.rolesDescription,
    required this.comments,
    required this.timeMoment,
    required this.userType,
    required this.doctorId,
    required this.role,
    required this.comment,
  });

  final String? id;
  final List<Like> likes;
  final List<ReplyElement> replies;
  final String? postId;
  final String? caregiverId;
  final String? fullName;
  final String? rolesDescription;
  final String? comments;
  final String? timeMoment;
  final String? userType;
  final String? doctorId;
  final String? role;
  final CommentComment? comment;

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
      caregiverId: json["caregiverId"],
      fullName: json["fullName"],
      rolesDescription: json["rolesDescription"],
      comments: json["comments"],
      timeMoment: json["timeMoment"],
      userType: json["userType"],
      doctorId: json["doctorId"],
      role: json["role"],
      comment: json["comment"] == null ? null : CommentComment.fromJson(json["comment"]),
    );
  }

  Map<String, dynamic> toJson() => {
        "_id": id,
        "likes": List<Like>.from(likes.map((x) => x.toJson())),
        "replies": List<ReplyElement>.from(replies.map((x) => x.toJson())),
        "postId": postId,
        "caregiverId": caregiverId,
        "fullName": fullName,
        "rolesDescription": rolesDescription,
        "comments": comments,
        "timeMoment": timeMoment,
        "userType": userType,
        "doctorId": doctorId,
        "role": role,
        "comment": comment?.toJson(),
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
    required this.reply,
    required this.fullName,
    required this.rolesDescription,
    required this.caregiverId,
    required this.timeMoment,
    required this.userType,
    required this.replyId,
    required this.doctorId,
    required this.role,
  });

  final String? postId;
  final String? commentId;
  final String? reply;
  final String? fullName;
  final String? rolesDescription;
  final String? caregiverId;
  final String? timeMoment;
  final String? userType;
  final String? replyId;
  final String? doctorId;
  final String? role;

  factory ReplyReply.fromJson(Map<String, dynamic> json) {
    return ReplyReply(
      postId: json["postId"],
      commentId: json["commentId"],
      reply: json["reply"],
      fullName: json["fullName"],
      rolesDescription: json["rolesDescription"],
      caregiverId: json["caregiverId"],
      timeMoment: json["timeMoment"],
      userType: json["userType"],
      replyId: json["replyId"],
      doctorId: json["doctorId"],
      role: json["role"],
    );
  }

  Map<String, dynamic> toJson() => {
        "postId": postId,
        "commentId": commentId,
        "reply": reply,
        "fullName": fullName,
        "rolesDescription": rolesDescription,
        "caregiverId": caregiverId,
        "timeMoment": timeMoment,
        "userType": userType,
        "replyId": replyId,
        "doctorId": doctorId,
        "role": role,
      };
}

class DoctorId {
  DoctorId({
    required this.fullName,
    required this.role,
  });

  final String? fullName;
  final String? role;

  factory DoctorId.fromJson(Map<String, dynamic> json) {
    return DoctorId(
      fullName: json["fullName"],
      role: json["role"],
    );
  }

  Map<String, dynamic> toJson() => {
        "fullName": fullName,
        "role": role,
      };
}

class ReportPost {
  ReportPost({
    required this.id,
    required this.account,
    required this.reportpost,
  });

  final String? id;
  final String? account;
  final String? reportpost;

  factory ReportPost.fromJson(Map<String, dynamic> json) {
    return ReportPost(
      id: json["_id"],
      account: json["account"],
      reportpost: json["reportpost"],
    );
  }

  Map<String, dynamic> toJson() => {
        "_id": id,
        "account": account,
        "reportpost": reportpost,
      };
}

class TagP {
  TagP({
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
  final int? v;

  factory TagP.fromJson(Map<String, dynamic> json) {
    return TagP(
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
