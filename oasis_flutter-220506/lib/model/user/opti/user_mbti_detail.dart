import 'package:equatable/equatable.dart';
import 'package:oasis/model/opti/tendencies.dart';

class UserMBTIDetail extends Equatable {
  final String? emotion; // "emotion": "string",
  final String? mbtiResult; // "mbti_result": "string",
  final String? loveType; // "love_type": "string",
  final String? beforeMbtiResult; // "before_mbti_result": "string",
  final String? loveTypeExplain; // "love_type_explain": "string",
  final MBTIChange? mbtiChange; // "mbti_change": {
  final String? mbtiType;
  final String? mbtiExplain;
  final List<Tendency>? tendencyAnswer;
  final String? loveElement;

  const UserMBTIDetail({
    this.emotion,
    this.mbtiResult,
    this.loveType,
    this.beforeMbtiResult,
    this.loveTypeExplain,
    this.mbtiChange,
    this.tendencyAnswer,
    this.mbtiType,
    this.mbtiExplain,
    this.loveElement,
  });

  static const empty = UserMBTIDetail();

  factory UserMBTIDetail.fromJson(Map<String, dynamic> json) {
    return UserMBTIDetail(
      emotion: json["emotion"],
      mbtiResult: json["mbti_result"],
      loveType: json["love_type"],
      loveElement: json["love_element"],
      beforeMbtiResult: json["before_mbti_result"],
      loveTypeExplain: json["love_type_explain"],
      mbtiType: json["mbti_type"],
      mbtiExplain: json["mbti_explain"],
      mbtiChange: json["mbti_change"] != null
          ? MBTIChange.fromJson(json["mbti_change"])
          : null,
      tendencyAnswer: ((json["tendency_answer"] ?? []) as List<dynamic>)
          .map((e) => Tendency.fromJson(e))
          .toList(),
    );
  }

  @override
  List<Object?> get props => [
        emotion,
        loveElement,
        mbtiResult,
        loveType,
        beforeMbtiResult,
        loveTypeExplain,
        mbtiType,
        mbtiExplain,
        mbtiChange,
        tendencyAnswer,
      ];
}

class MBTIChange extends Equatable {
  final String? before_mbti;
  final String? after_mbti;
  final String? context;

  const MBTIChange({
    this.before_mbti,
    this.after_mbti,
    this.context,
  });

  static const empty = UserMBTIDetail();

  factory MBTIChange.fromJson(Map<String, dynamic> json) {
    return MBTIChange(
      before_mbti: json["before_mbti"],
      after_mbti: json["after_mbti"],
      context: json["context"],
    );
  }

  @override
  List<Object?> get props => [
        before_mbti,
        after_mbti,
        context,
      ];
}
