import 'package:equatable/equatable.dart';

class MyStoryWrite extends Equatable {
  final String? title;
  final String? content;
  final bool publicStatus;
  final List<String>? hashTags;

  MyStoryWrite({
    this.title,
    this.content,
    this.publicStatus = true,
    this.hashTags,
  });

  String toLovePayload() {
    return '{"title": "$title", "content": "$content", "hash_tag": ${(hashTags ?? []).map((e) => '"$e"').toList()}}';
  }

  String toDailyPayload() {
    return '{"title": "$title", "content": "${content != null ? content!.replaceAll("\n", "\\n") : content}", "public_status": $publicStatus,"hash_tag": ${(hashTags ?? []).map((e) => '"$e"').toList()}}';
  }

  @override
  List<Object?> get props => [
    title,
    content,
    publicStatus,
    hashTags,
  ];
}
