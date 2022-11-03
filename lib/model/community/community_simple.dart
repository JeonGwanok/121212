import 'package:equatable/equatable.dart';

class CommunitySimple extends Equatable {
  final int? communityId; //community_id
  final String? image;

  CommunitySimple({
    required this.communityId,
    required this.image,
  });

  factory CommunitySimple.fromJson(Map<String, dynamic> json) {
    return CommunitySimple(
      communityId: json["community_id"],
      image: json["image"],
    );
  }

  @override
  List<Object?> get props => [
        communityId,
        image,
      ];
}
