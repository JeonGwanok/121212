import 'package:equatable/equatable.dart';

import 'community_main.dart';
import '../community_simple.dart';

class CommunityLove extends CommunityMain {
  final List<CommunitySimple> loveTip;
  final List<CommunitySimple> lovePsychology;
  final List<CommunitySimple> loveRelationship;

  CommunityLove({
    required this.loveTip,
    required this.lovePsychology,
    required this.loveRelationship,
  });

  factory CommunityLove.fromJson(Map<String, dynamic> json) {
    return CommunityLove(
      loveTip: ((json["love_tip"] ?? []) as List<dynamic>)
          .map((e) => CommunitySimple.fromJson(e))
          .toList(),
      lovePsychology: ((json["love_psychology"] ?? []) as List<dynamic>)
          .map((e) => CommunitySimple.fromJson(e))
          .toList(),
      loveRelationship: ((json["love_relationship"] ?? []) as List<dynamic>)
          .map((e) => CommunitySimple.fromJson(e))
          .toList(),
    );
  }

  @override
  List<Object?> get props => [
        loveTip,
        lovePsychology,
        loveRelationship,
      ];
}
