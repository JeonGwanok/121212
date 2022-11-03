import 'package:equatable/equatable.dart';

class Comment extends Equatable {
  final int? id; //"id": 0,
  final int? customerId; //customer_id
  final String? comment;
  final DateTime? createdAt; //"create_dt": "2022-01-05",
  final String? nickName; //"nick_name": "string"

 const Comment({
    this.id,
    this.customerId,
    this.createdAt,
    this.comment,
    this.nickName,
  });

 static const empty = Comment();

  factory Comment.fromJson(Map<String, dynamic> json) {
    return Comment(
      id: json["id"],
      createdAt: json["create_dt"] != null
          ? DateTime.parse(json["create_dt"] as String).toLocal()
          : null,
      nickName: json["nick_name"],
      customerId: json["customer_id"],
      comment: json["comment"],
    );
  }

  @override
  List<Object?> get props => [id, createdAt, comment, nickName, customerId];
}

class WriteComment extends Equatable {
  final int? postId;
  final String? comment;

  WriteComment({
    this.postId,
    this.comment,
  });

  Map<String, dynamic> toMyStoryJson() {
    return {
      "mystory_id": postId,
      "comment": comment,
    };
  }

  Map<String, dynamic> toCommunityJson() {
    return {
      "community_id": postId,
      "comment": comment,
    };
  }

  @override
  List<Object?> get props => [
        postId,
        comment,
      ];
}
