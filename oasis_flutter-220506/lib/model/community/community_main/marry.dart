import 'package:equatable/equatable.dart';

import 'community_main.dart';
import '../community_simple.dart';

class CommunityMarry extends CommunityMain {
  final List<CommunitySimple> marryPreparation;
  final List<CommunitySimple> dowry;
  final List<CommunitySimple> newlywedHouse;
  final List<CommunitySimple> loan;

  CommunityMarry({
    required this.marryPreparation,
    required this.dowry,
    required this.newlywedHouse,
    required this.loan,
  });

  factory CommunityMarry.fromJson(Map<String, dynamic> json) {
    return CommunityMarry(
      marryPreparation: ((json["marry_preparation"] ?? []) as List<dynamic>)
          .map((e) => CommunitySimple.fromJson(e))
          .toList(),
      dowry: ((json["dowry"] ?? []) as List<dynamic>)
          .map((e) => CommunitySimple.fromJson(e))
          .toList(),
      newlywedHouse: ((json["newlywed_house"] ?? []) as List<dynamic>)
          .map((e) => CommunitySimple.fromJson(e))
          .toList(),
      loan: ((json["loan"] ?? []) as List<dynamic>)
          .map((e) => CommunitySimple.fromJson(e))
          .toList(),
    );
  }

  @override
  List<Object?> get props => [
        marryPreparation,
        dowry,
        newlywedHouse,
        loan,
      ];
}
