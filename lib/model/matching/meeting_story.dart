import 'package:equatable/equatable.dart';
import 'package:oasis/ui/meeting/after_meeting/cubit/after_metting_state.dart';

class MeetingStory extends Equatable {
  final AfterMeetingSelectType meetingQuestion; //"meeting_question": "string",
  final AfterMeetingSelectType profileQuestion; // "profile_question": "string",
  final AfterMeetingSelectType dateQuestion; // "date_question": "string",
  final bool feelingQuestion; // "feeling_question": false,
  final String review; // "review": "string",
  final String oasisWant; // "oasis_want": "string"

  MeetingStory({
    this.meetingQuestion = AfterMeetingSelectType.good,
    this.profileQuestion = AfterMeetingSelectType.good,
    this.dateQuestion = AfterMeetingSelectType.good,
    this.feelingQuestion = false,
    this.review = "",
    this.oasisWant = "",
  });

  Map<String, dynamic> toJson() {
    return {
      "meeting_question": "${meetingQuestion.index}",
      "profile_question": "${profileQuestion.index}",
      "date_question": "${dateQuestion.index}",
      "feeling_question": feelingQuestion,
      "review": review,
      "oasis_want": oasisWant,
    };
  }

  @override
  List<Object?> get props => [
        meetingQuestion,
        profileQuestion,
        dateQuestion,
        feelingQuestion,
        review,
        oasisWant,
      ];
}
