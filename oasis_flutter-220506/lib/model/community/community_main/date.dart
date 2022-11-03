import 'package:equatable/equatable.dart';

import 'community_main.dart';
import '../community_simple.dart';

class CommunityDate extends CommunityMain {
  final List<CommunitySimple> famousRestaurant;
  final List<CommunitySimple> drive;
  final List<CommunitySimple> hotPlace;
  final List<CommunitySimple> gift;

  CommunityDate({
    required this.famousRestaurant,
    required this.drive,
    required this.hotPlace,
    required this.gift,
  });

  factory CommunityDate.fromJson(Map<String, dynamic> json) {
    return CommunityDate(
      famousRestaurant: ((json["famous_restaurant"] ?? []) as List<dynamic>)
          .map((e) => CommunitySimple.fromJson(e))
          .toList(),
      drive: ((json["drive"] ?? []) as List<dynamic>)
          .map((e) => CommunitySimple.fromJson(e))
          .toList(),
      hotPlace: ((json["hot_place"] ?? []) as List<dynamic>)
          .map((e) => CommunitySimple.fromJson(e))
          .toList(),
      gift: ((json["gift"] ?? []) as List<dynamic>)
          .map((e) => CommunitySimple.fromJson(e))
          .toList(),
    );
  }

  @override
  List<Object?> get props => [
        famousRestaurant,
        drive,
        hotPlace,
        gift,
      ];
}
