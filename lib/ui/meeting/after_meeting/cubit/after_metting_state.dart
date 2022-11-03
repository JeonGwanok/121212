import 'package:equatable/equatable.dart';
import 'package:oasis/enum/screen_status.dart';
import 'package:oasis/model/matching/meeting.dart';

enum AfterMeetingSelectType { tooBad, bad, normal, good, veryGood }

extension AfterMeetingSelectTypeExtension on AfterMeetingSelectType {
  String get title {
    switch (this) {
      case AfterMeetingSelectType.tooBad:
        return "매우\n좋지 않음";
      case AfterMeetingSelectType.bad:
        return "좋지 않음";
      case AfterMeetingSelectType.normal:
        return "그저\n그랬음";
      case AfterMeetingSelectType.good:
        return "좋았음";
      case AfterMeetingSelectType.veryGood:
        return "매우\n좋았음";
    }
  }

  String get title2 {
    switch (this) {
      case AfterMeetingSelectType.tooBad:
        return "매우\n맞지 않음";
      case AfterMeetingSelectType.bad:
        return "맞지 않음";
      case AfterMeetingSelectType.normal:
        return "일부\n맞지 않음";
      case AfterMeetingSelectType.good:
        return "좋았음";
      case AfterMeetingSelectType.veryGood:
        return "매우\n좋았음";
    }
  }
}

class AfterMeetingState extends Equatable {
  final ScreenStatus status;
  final MeetingResponse? meetingResponse;

  final AfterMeetingSelectType? meetingQuestion;
  final AfterMeetingSelectType? profileQuestion;
  final AfterMeetingSelectType? dateQuestion;
  final bool? feelingQuestion;
  final String review;
  final String oasisWant;

  AfterMeetingState({
    this.status = ScreenStatus.initial,
    this.meetingResponse,
    this.meetingQuestion,
    this.profileQuestion,
    this.dateQuestion,
    this.feelingQuestion,
    this.review = "",
    this.oasisWant = "",
  });

  AfterMeetingState copyWith({
    ScreenStatus? status,
    MeetingResponse? meetingResponse,
    AfterMeetingSelectType? meetingQuestion,
    AfterMeetingSelectType? profileQuestion,
    AfterMeetingSelectType? dateQuestion,
    bool? feelingQuestion,
    String? review,
    String? oasisWant,
  }) {
    return AfterMeetingState(
      status: status ?? this.status,
      meetingResponse: meetingResponse ?? this.meetingResponse,
      meetingQuestion: meetingQuestion ?? this.meetingQuestion,
      profileQuestion: profileQuestion ?? this.profileQuestion,
      dateQuestion: dateQuestion ?? this.dateQuestion,
      feelingQuestion: feelingQuestion ?? this.feelingQuestion,
      review: review ?? this.review,
      oasisWant: oasisWant ?? this.oasisWant,
    );
  }

  String get partner => meetingResponse?.loverInfo?.customer?.nickName ?? "---";

  bool get enableButton =>
      meetingQuestion != null &&
      profileQuestion != null &&
      dateQuestion != null &&
      feelingQuestion != null &&
      review.length>=10 &&
      oasisWant.length>=10;

  @override
  List<Object?> get props => [
        status,
        meetingResponse,
        meetingQuestion,
        profileQuestion,
        dateQuestion,
        feelingQuestion,
        review,
        oasisWant,
      ];
}
