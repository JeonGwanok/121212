import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:oasis/api_client/api_client.dart';
import 'package:oasis/bloc/app/app_bloc.dart';
import 'package:oasis/bloc/app/app_event.dart';
import 'package:oasis/enum/screen_status.dart';
import 'package:oasis/model/matching/meeting.dart';
import 'package:oasis/model/matching/meeting_story.dart';
import 'package:oasis/repository/matching_repository.dart';
import 'package:oasis/repository/user_repository.dart';

import 'after_metting_state.dart';

class AfterMeetingCubit extends Cubit<AfterMeetingState> {
  final MatchingRepository matchingRepository;
  final AppBloc appBloc;
  final UserRepository userRepository;
  AfterMeetingCubit({
    required this.matchingRepository,
    required this.appBloc,
    required this.userRepository,
  }) : super(AfterMeetingState());

  initialize() async {
    try {
      var user = await userRepository.getUser();
      MeetingResponse? meeting;
      meeting = await matchingRepository.getMeetingInfo(
          customerId: "${user.customer?.id}");

      emit(state.copyWith(
        meetingResponse: meeting,
        status: ScreenStatus.loaded,
      ));
    } catch (err) {
      emit(state.copyWith(status: ScreenStatus.fail));
    }
  }

  changeValue({
    AfterMeetingSelectType? meetingQuestion,
    AfterMeetingSelectType? profileQuestion,
    AfterMeetingSelectType? dateQuestion,
    bool? feelingQuestion,
    String? review,
    String? oasisWant,
  }) {
    emit(state.copyWith(
      meetingQuestion: meetingQuestion,
      profileQuestion: profileQuestion,
      dateQuestion: dateQuestion,
      feelingQuestion: feelingQuestion,
      review: review,
      oasisWant: oasisWant,
    ));
  }

  save() async {
    try {
      emit(state.copyWith(status: ScreenStatus.loading));
      var meetingStory = MeetingStory(
        meetingQuestion: state.meetingQuestion!,
        profileQuestion: state.profileQuestion!,
        dateQuestion: state.dateQuestion!,
        feelingQuestion: state.feelingQuestion!,
        review: state.review,
        oasisWant: state.oasisWant,
      );

      await matchingRepository.uploadMeetingStory(
        meetingId: "${state.meetingResponse?.meeting?.id}",
        meetingStory: meetingStory,
      );
      appBloc.add(AppUpdate());
      emit(state.copyWith(status: ScreenStatus.success));
    } on ApiClientException catch (err) {
      emit(state.copyWith(status: ScreenStatus.fail));
    } catch (err) {
      emit(state.copyWith(status: ScreenStatus.fail));
    }
  }
}
