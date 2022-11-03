import 'package:equatable/equatable.dart';
import 'package:oasis/enum/community/community.dart';

class CommunityWrite extends Equatable {
  final CommunitySubType? topic;
  final String? info;
  final String? title;
  final String? content;
  final String? url;
  final List<String>? hashTags;

  CommunityWrite({
    this.topic,
    this.url,
    this.info,
    this.title,
    this.content,
    this.hashTags,
  });

  String infoToPayload() {
    return '{"topic": "${topic?.topic ?? ""}", "info": "$info","url": "$url", "hash_tag": ${(hashTags ?? []).map((e) => '"$e"').toList()}}';
  }

  String contentToPayload() {
    return '{"topic": "${topic?.topic ?? ""}","url": "$url", "title": "$title", "content": "${content != null ? content!.replaceAll("\n", "\\n") : content}", "hash_tag": ${(hashTags ?? []).map((e) => '"$e"').toList()}}';
  }

  @override
  List<Object?> get props => [
        topic,
        info,
    url,
        title,
        content,
        hashTags,
      ];
}
