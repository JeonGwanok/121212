import 'package:equatable/equatable.dart';
import 'package:oasis/model/image_model.dart';
import 'package:oasis/model/my_story/comment.dart';

class CommunityResponse extends Equatable {
  final int? count;
  final List<CommunityResponseItem> results;

  CommunityResponse({
    this.count,
    this.results = const [],
  });

  factory CommunityResponse.fromJson(Map<String, dynamic> json) {
    return CommunityResponse(
      count: json["count"],
      results: ((json["results"] ?? []) as List<dynamic>)
          .map((e) => CommunityResponseItem.fromJson(e))
          .toList(),
    );
  }

  @override
  List<Object?> get props => [
        count,
        results,
      ];
}

// 페이지네이션 결과물로 나올 객체
class CommunityResponseItem extends Equatable {
  final String? image;
  final int? like;
  final int? dislike;
  final CommunityDetail? community;

  const CommunityResponseItem({
    this.image,
    this.like,
    this.dislike,
    this.community,
  });

  static const empty = CommunityResponseItem();

  factory CommunityResponseItem.fromJson(Map<String, dynamic> json) {
    return CommunityResponseItem(
      image: json["image"],
      like: json["like"],
      dislike: json["dislike"],
      community: json["community"] != null
          ? CommunityDetail.fromJson(json["community"])
          : null,
    );
  }

  @override
  List<Object?> get props => [
        image,
        like,
        dislike,
        community,
      ];
}

// 커뮤니티 상세
class CommunityDetail extends Equatable {
  final DateTime? createdAt; // "create_dt": "2022-01-16T08:19:23.716Z",
  final int? id; // "id": 0,
  final String? info; //"info": "string",
  final String? title; // "title": "string",
  final String? content; // "content": "string",
  final String? nickName; // "nick_name": "string",
  final int? hits; // "hits": 0,
  final int? like; // "like": 0,
  final int? dislike; // "dislike": 0,
  final bool? likeStatus; // "like_status": true,
  final bool? dislikeStatus; // "dislike_status": true,
  final List<String>? hashTag; // "hash_tag": [ "string"],
  final List<PostingImageList>? image; //
  final String? myNickName; // "my_nick_name": "string"
  final List<Comment>? comment; // "comment": [
  final int? customerId;
  final String? url;

  const CommunityDetail({
    this.createdAt,
    this.url,
    this.id,
    this.info,
    this.title,
    this.content,
    this.nickName,
    this.hits,
    this.like,
    this.dislike,
    this.likeStatus,
    this.dislikeStatus,
    this.hashTag,
    this.image,
    this.myNickName,
    this.comment,
    this.customerId,
  });

  static const empty = CommunityDetail();

  factory CommunityDetail.fromJson(Map<String, dynamic> json) {
    return CommunityDetail(
      createdAt: json["create_dt"] != null
          ? DateTime.parse(json['create_dt'] as String).toLocal()
          : null,
      id: json["id"],
      url: json["url"],
      info: json["info"],
      title: json["title"],
      content: json["content"],
      nickName: json["nick_name"],
      hits: json["hits"],
      like: json["like"],
      dislike: json["dislike"],
      likeStatus: json["like_status"],
      dislikeStatus: json["dislike_status"],
      hashTag: ((json["hash_tag"] ?? []) as List<dynamic>)
          .map((e) => e as String)
          .toList(),
      image: ((json["image_list"] ?? []) as List<dynamic>)
          .map((e) => PostingImageList.fromJson(e as Map<String, dynamic>))
          .toList(),
      myNickName: json["my_nick_name"],
      comment: ((json["comment"] ?? []) as List<dynamic>)
          .map((e) => Comment.fromJson(e))
          .toList(),
      customerId: json["customer_id"],
    );
  }

  @override
  List<Object?> get props => [
        createdAt,
        id,
    url,
        info,
        title,
        content,
        nickName,
        hits,
        like,
        dislike,
        likeStatus,
        dislikeStatus,
        hashTag,
        image,
        myNickName,
        comment,
        customerId,
      ];
}
