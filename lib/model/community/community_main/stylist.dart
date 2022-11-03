
import 'community_main.dart';
import '../community_simple.dart';

class CommunityStylist extends CommunityMain {
  final List<CommunitySimple> manStyle;
  final List<CommunitySimple> womanStyle;
  final List<CommunitySimple> seasonStyle;

  CommunityStylist({
    required this.manStyle,
    required this.womanStyle,
    required this.seasonStyle,
  });

  factory CommunityStylist.fromJson(Map<String, dynamic> json) {
    return CommunityStylist(
      manStyle: ((json["man_style"] ?? []) as List<dynamic>)
          .map((e) => CommunitySimple.fromJson(e))
          .toList(),
      womanStyle: ((json["woman_style"] ?? []) as List<dynamic>)
          .map((e) => CommunitySimple.fromJson(e))
          .toList(),
      seasonStyle: ((json["season_style"] ?? []) as List<dynamic>)
          .map((e) => CommunitySimple.fromJson(e))
          .toList(),
    );
  }

  @override
  List<Object?> get props => [
        manStyle,
        womanStyle,
        seasonStyle,
      ];
}
