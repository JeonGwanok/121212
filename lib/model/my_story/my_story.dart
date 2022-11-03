import 'package:equatable/equatable.dart';
import 'package:oasis/model/my_story/comment.dart';

import '../image_model.dart';

class MyStory extends Equatable {
  final DateTime? createdAt; // "create_dt": "2022-01-03T01:05:39.475Z",
  final bool? publicStatus; //public_status
  final int? id; // "id": 0,
  final String? title; // "title": "string",
  final String? content; // "content": "string",
  final String? nickName; //nick_name
  final int? hits;
  final int? like; // "like": 0,
  final bool? likeStatus; //likeStatus // 해당 계정이 이 게시물에 좋아요를 눌렀는지 여부
  final int? dislike; // "like": 0,
  final bool? dislikeStatus; //likeStatus // 해당 계정이 이 게시물에 좋아요를 눌렀는지 여부
  final List<String> hashTag; // "hash_tag": [ "string" ],
  final List<PostingImageList> imageList;
  final List<String> imageUrlList; // "image": [ "string" ]
  final List<Comment>? comment; // "comment": [ ]
  final int? commentCount;
  final int? customerId;

  const MyStory({
    this.createdAt,
    this.publicStatus,
    this.id,
    this.title,
    this.content,
    this.nickName,
    this.hits,
    this.dislike,
    this.dislikeStatus,
    this.likeStatus,
    this.like,
    this.imageUrlList = const [],
    this.hashTag = const [],
    this.imageList = const [],
    this.comment,
    this.customerId,
    this.commentCount,
  });

  static const empty = MyStory();

  factory MyStory.fromJson(Map<String, dynamic> json) {
    return MyStory(
      createdAt: json["create_dt"] != null
          ? DateTime.parse(json['create_dt'] as String).toLocal()
          : null,
      id: json["id"],
      publicStatus: json["public_status"],
      title: json["title"],
      content: json["content"],
      nickName: json["nick_name"],
      hits: json["hits"],
      likeStatus: json["like_status"],
      like: json["like"],
      dislikeStatus: json["dislike_status"],
      dislike: json["dislike"],
      hashTag: ((json["hash_tag"] ?? []) as List<dynamic>)
          .map((e) => e as String)
          .toList(),
      imageList: ((json["image_list"] ?? []) as List<dynamic>)
          .map((e) => PostingImageList.fromJson(e as Map<String, dynamic>))
          .toList(),
      imageUrlList: ((json["image"] ?? []) as List<dynamic>)
          .map((e) => e as String)
          .toList(),
      comment: ((json["comment"] ?? []) as List<dynamic>)
          .map((e) => Comment.fromJson(e))
          .toList(),
      customerId: json["customer_id"],
      commentCount: json["comment_count"],
    );
  }

  MyStory copyWith({
    DateTime? createdAt,
    bool? publicStatus,
    int? id,
    String? title,
    String? content,
    String? nickName,
    int? hits,
    int? like,
    bool? likeStatus,
    int? dislike,
    bool? dislikeStatus,
    List<String>? hashTag,
    List<PostingImageList>? image,
    List<String>? imageUrlList,
    List<Comment>? comment,
    int? customer_id,
    int? commentCount,
  }) {
    return MyStory(
      createdAt: createdAt ?? this.createdAt,
      id: id ?? this.id,
      title: title ?? this.title,
      content: content ?? this.content,
      nickName: nickName ?? this.nickName,
      publicStatus: publicStatus ?? this.publicStatus,
      hits: hits ?? this.hits,
      likeStatus: likeStatus ?? this.likeStatus,
      like: like ?? this.like,
      dislike: dislike ?? this.dislike,
      dislikeStatus: dislikeStatus ?? this.dislikeStatus,
      hashTag: hashTag ?? this.hashTag,
      imageList: image ?? this.imageList,
      imageUrlList: imageUrlList ?? this.imageUrlList,
      comment: comment ?? this.comment,
      customerId: customer_id ?? this.customerId,
      commentCount: commentCount ?? this.commentCount,
    );
  }

  @override
  List<Object?> get props => [
        createdAt,
        id,
        title,
        content,
        nickName,
        publicStatus,
        hits,
        likeStatus,
        like,
        dislike,
        dislikeStatus,
        hashTag,
        imageList,
        comment,
        imageUrlList,
        customerId,
        commentCount,
      ];
}
