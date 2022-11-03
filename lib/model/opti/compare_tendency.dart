import 'package:equatable/equatable.dart';
import 'package:oasis/model/opti/tendencies.dart';

class CompareTendency extends Equatable {
  final TendencyCompare? tendencyCompare;
  final List<Tendency> tendencyAnswer;

  const CompareTendency({
    this.tendencyCompare,
    this.tendencyAnswer = const [],
  });

  static const empty = CompareTendency();

  factory CompareTendency.fromJson(Map<String, dynamic> json) {
    return CompareTendency(
      tendencyCompare: json["tendency_compare"] != null
          ? TendencyCompare.fromJson(json["tendency_compare"])
          : null,
      tendencyAnswer: ((json["tendency_answer"] ?? []) as List<dynamic>)
          .map((e) => Tendency.fromJson(e))
          .toList(),
    );
  }

  @override
  List<Object?> get props => [
        tendencyCompare,
        tendencyAnswer,
      ];
}

class TendencyCompare extends Equatable {
  final String? myMbti;
  final String? loverMbti;
  final String? compatibility;
  final String? explain;

  const TendencyCompare({
    this.myMbti,
    this.loverMbti,
    this.compatibility,
    this.explain,
  });

  static const empty = TendencyCompare();

  factory TendencyCompare.fromJson(Map<String, dynamic> json) {
    return TendencyCompare(
      myMbti: json["my_mbti"],
      loverMbti: json["lover_mbti"],
      compatibility: json["compatibility"],
      explain: json["explain"],
    );
  }

  @override
  List<Object?> get props => [
        myMbti,
        loverMbti,
        compatibility,
        explain,
      ];
}
