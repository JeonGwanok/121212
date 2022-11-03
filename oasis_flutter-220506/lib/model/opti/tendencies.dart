import 'package:equatable/equatable.dart';

class Tendency extends Equatable {
  final int? numbering; // "numbering": 0,
  final String? question; // "question": "string",
  final bool? answer;

  Tendency({
    this.numbering,
    this.question,
    this.answer,
  });

  factory Tendency.fromJson(Map<String, dynamic> json) {
    return Tendency(
      numbering: json["numbering"],
      answer: json["answer"],
      question: json["question"],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      "numbering": numbering,
      "answer": answer,
    };
  }

  Tendency copyWith({
    int? numbering,
    String? question,
    bool? answer,
  }) {
    return Tendency(
      numbering: numbering ?? this.numbering,
      question: question ?? this.question,
      answer: answer ?? this.answer,
    );
  }

  @override
  List<Object?> get props => [
        numbering,
        question,
        answer,
      ];
}
