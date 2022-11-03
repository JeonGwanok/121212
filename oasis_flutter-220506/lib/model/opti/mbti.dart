import 'package:equatable/equatable.dart';

class MBTI extends Equatable {
  final List<MBTIQuestion> preMbti;
  final List<MBTIQuestion> mainMbti;

  static const isEmpty = MBTI();

  const MBTI({
    this.preMbti = const [],
    this.mainMbti = const [],
  });

  factory MBTI.fromJson(Map<String, dynamic> json) {
    return MBTI(
      preMbti: ((json["pre_mbti"] ?? []) as List<dynamic>)
          .map((e) => MBTIQuestion.fromJson(e as Map<String, dynamic>))
          .toList(),
      mainMbti: ((json["main_mbti"] ?? []) as List<dynamic>)
          .map((e) => MBTIQuestion.fromJson(e as Map<String, dynamic>))
          .toList(),
    );
  }

  @override
  List<Object?> get props => [
        preMbti,
        mainMbti,
      ];
}

class MBTIQuestion extends Equatable {
  final int? numbering; // "numbering": 0,
  final String? question; // "question": "string",
  final String? exampleType; // "example_type": "string",
  final String? image;
  final List<MBTIExample> example; // "example": []

  static const empty = MBTIQuestion();

  const MBTIQuestion({
    this.numbering,
    this.question,
    this.image,
    this.exampleType,
    this.example = const [],
  });

  factory MBTIQuestion.fromJson(Map<String, dynamic> json) {
    return MBTIQuestion(
      numbering: json["numbering"],
      question: json["question"],
      image: json["image"],
      exampleType: json["example_type"],
      example: ((json["example"] ?? []) as List<dynamic>)
          .map((e) => MBTIExample.fromJson(e as Map<String, dynamic>))
          .toList(),
    );
  }

  @override
  List<Object?> get props => [
        numbering,
        image,
        question,
        exampleType,
        example,
      ];
}

class MBTIExample extends Equatable {
  final int? questionNumber; // ui 에서 저장용도로만 사용
  final int? numbering; // "numbering": 0,
  final String? text; // "text": "string",
  final String? image; // "image": "string"

  MBTIExample({
    this.questionNumber,
    this.numbering,
    this.text,
    this.image,
  });

  factory MBTIExample.fromJson(Map<String, dynamic> json) {
    return MBTIExample(
      numbering: json["numbering"],
      text: json["text"],
      image: json["image"],
    );
  }

  MBTIExample copyWith({
    int? questionNumber,
    int? numbering,
    String? text,
    String? image,
  }) {
    return MBTIExample(
      questionNumber: questionNumber ?? this.questionNumber,
      numbering: numbering ?? this.numbering,
      text: text ?? this.text,
      image: image ?? this.image,
    );
  }

  @override
  List<Object?> get props => [
        questionNumber,
        numbering,
        text,
        image,
      ];
}
