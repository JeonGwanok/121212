import 'package:equatable/equatable.dart';

/// 이상형 찾는중 화면에서 보여줄 정보
class AiMatching extends Equatable {
  final String? mbti;// "mbti": "string",
  final String? temper;// "temper": "string",
  final String? myMarriage;// "my_marriage": "string",
  final int? matchingRate;// "matching_rate": 0

  const AiMatching({
    this.mbti,
    this.temper,
    this.myMarriage,
    this.matchingRate,
  });

  static const empty = AiMatching();

  factory AiMatching.fromJson(Map<String, dynamic> json) {
    return AiMatching(
      mbti: json["mbti"],
      temper: json["temper"],
      myMarriage: json["my_marriage"],
      matchingRate: json["matching_rate"],
    );
  }

  AiMatching copyWith({
     String? mbti,
     String? temper,
     String? myMarriage,
     int? matchingRate,
  }) {
    return AiMatching(
      mbti: mbti ?? this.mbti,
      temper: temper ?? this.temper,
      myMarriage: myMarriage ?? this.myMarriage,
      matchingRate: matchingRate ?? this.matchingRate,
    );
  }

  @override
  List<Object?> get props => [
    mbti,
    temper,
    myMarriage,
    matchingRate,
  ];
}
