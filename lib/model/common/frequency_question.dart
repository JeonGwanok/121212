import 'package:equatable/equatable.dart';

class FrequentlyQuestion extends Equatable {
  final int? id; // "id": 0,
  final DateTime? createdAt; // "create_dt": "2022-01-18T22:34:53.558Z",
  final DateTime? updatedAt; // "update_dt": "2022-01-18T22:34:53.558Z",
  final bool? publicStatus; // "public_status": true,
  final String? qestion; // "qestion": "string",
  final String? answer; // "answer": "string",
  final int? writer; // "writer": 0
  bool uiShowAnswer;

  FrequentlyQuestion({
    this.id,
    this.createdAt,
    this.updatedAt,
    this.publicStatus,
    this.qestion,
    this.answer,
    this.writer,
    this.uiShowAnswer = false,
  });

  factory FrequentlyQuestion.fromJson(Map<String, dynamic> json) {
    return FrequentlyQuestion(
      id: json["id"],
      createdAt: json["create_dt"] != null
          ? DateTime.parse(json['create_dt'] as String).toLocal()
          : null,
      updatedAt: json["update_dt"] != null
          ? DateTime.parse(json['update_dt'] as String).toLocal()
          : null,
      publicStatus: json["public_status"],
      qestion: json["question"],
      answer: json["answer"],
      writer: json["writer"],
    );
  }

  @override
  List<Object?> get props => [
        id,
        createdAt,
        updatedAt,
        publicStatus,
        qestion,
        answer,
        writer,
        uiShowAnswer,
      ];
}
