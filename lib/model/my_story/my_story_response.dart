import 'package:equatable/equatable.dart';
import 'package:oasis/model/my_story/my_story.dart';

class MyStoryResponse extends Equatable {
  final int? count;
  final List<MyStory> results;
  final List<MyStoryPopular> loveList; //love_list
  final List<MyStoryPopular> marryList; //marry_list

  MyStoryResponse({
    this.count,
    this.results = const [],
    this.loveList = const [],
    this.marryList = const [],
  });

  factory MyStoryResponse.fromJson(Map<String, dynamic> json) {
    return MyStoryResponse(
      count: json["count"],
      results: ((json["results"] ?? []) as List<dynamic>)
          .map((e) => MyStory.fromJson(e))
          .toList(),
      loveList: ((json["love_list"] ?? []) as List<dynamic>)
          .map((e) => MyStoryPopular.fromJson(e))
          .toList(),
      marryList: ((json["marry_list"] ?? []) as List<dynamic>)
          .map((e) => MyStoryPopular.fromJson(e))
          .toList(),
    );
  }

  @override
  List<Object?> get props => [
        count,
        results,
        loveList,
        marryList,
      ];
}

class MyStoryPopular extends Equatable {
  final int? id; // "id": 0,
  final int? number; // "number": 0,
  final String? content; // "content": "string",
  final int? commentCount; // "comment_count": 0,
  final List<String> hashTag; // hash_tag

  MyStoryPopular({
    this.id,
    this.number,
    this.content,
    this.commentCount,
    this.hashTag = const [],
  });

  factory MyStoryPopular.fromJson(Map<String, dynamic> json) {
    return MyStoryPopular(
      id: json["id"],
      number: json["number"],
      content: json["content"],
      commentCount: json["comment_count"],
      hashTag: ((json["hash_tag"] ?? []) as List<dynamic>)
          .map((e) => e as String)
          .toList(),
    );
  }

  @override
  List<Object?> get props => [
        id,
        number,
        content,
        commentCount,
        hashTag,
      ];
}
