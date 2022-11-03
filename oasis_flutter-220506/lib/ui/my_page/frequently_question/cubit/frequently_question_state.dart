import 'package:contacts_service/contacts_service.dart';
import 'package:equatable/equatable.dart';
import 'package:oasis/enum/screen_status.dart';
import 'package:oasis/model/common/frequency_question.dart';
import 'package:oasis/model/user/cut_phone.dart';

class FrequentlyQuestionState extends Equatable {
  final ScreenStatus status;
  final List<FrequentlyQuestion> questions;
  final DateTime? updateAt;
  FrequentlyQuestionState({
    this.status = ScreenStatus.initial,
    this.questions = const [],
    this.updateAt,
  });

  FrequentlyQuestionState copyWith({
    List<FrequentlyQuestion>? questions,
    ScreenStatus? status,
    DateTime? updateAt,
  }) {
    return FrequentlyQuestionState(
      status: status ?? this.status,
      questions: questions ?? this.questions,
      updateAt: updateAt ?? this.updateAt,
    );
  }

  @override
  List<Object?> get props => [
        questions,
        status,
        updateAt,
      ];
}
