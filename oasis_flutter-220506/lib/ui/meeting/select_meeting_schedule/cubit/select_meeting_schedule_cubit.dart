import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:oasis/api_client/api_client.dart';
import 'package:oasis/bloc/app/app_bloc.dart';
import 'package:oasis/bloc/app/app_event.dart';
import 'package:oasis/enum/screen_status.dart';
import 'package:oasis/model/matching/meeting.dart';
import 'package:oasis/repository/common_repository.dart';
import 'package:oasis/repository/matching_repository.dart';
import 'package:oasis/repository/user_repository.dart';
import 'package:oasis/ui/meeting/select_meeting_schedule/cubit/select_meeting_schedule_state.dart';
import 'package:oasis/ui/meeting/select_meeting_schedule/select_meeting_schedule_screen.dart';

class SelectMeetingScheduleCubit extends Cubit<SelectMeetingScheduleState> {
  final UserRepository userRepository;
  final CommonRepository commonRepository;
  final AppBloc appBloc;
  final MatchingRepository matchingRepository;
  SelectMeetingScheduleCubit({
    required this.userRepository,
    required this.commonRepository,
    required this.appBloc,
    required this.matchingRepository,
  }) : super(SelectMeetingScheduleState());

  initialize() async {
    emit(state.copyWith(status: ScreenStatus.loading));
    var user = await userRepository.getUser();
    var hollyDays = await commonRepository.getHolyDay(DateTime.now().year);
    var meeting = await matchingRepository.getMeetingInfo(
        customerId: "${user.customer?.id}");
    emit(
      state.copyWith(
        user: user,
        meeting: meeting,
        status: ScreenStatus.loaded,
        hollyDays: hollyDays,
      ),
    );
  }

  changeSelectDate(DateTime date) {
    if (state.timeType != null) {
      var result = DateTime(
        date.year,
        date.month,
        date.day,
        (state.timeType as MeetingScheduleType).time.hour,
        (state.timeType as MeetingScheduleType).time.minute,
      );
      emit(state.initialized(result));
    } else {
      emit(state.copyWith(selectedDateTime: date));
    }
  }

  changeSelectTime(MeetingScheduleType time) {
    if (state.selectedDateTime != null) {
      var result = DateTime(
        state.selectedDateTime!.year,
        state.selectedDateTime!.month,
        state.selectedDateTime!.day,
        time.time.hour,
        time.time.minute,
      );
      emit(state.initialized(result));
    } else {
      emit(state.copyWith(timeType: time));
    }
  }

  deleteDate(DateTime date) {
    if (state.selectedDate.contains(date)) {
      var items = [...state.selectedDate];
      items.remove(date);
      emit(state.copyWith(selectedDate: items));
    }
  }

  confirm() async {
    emit(state.copyWith(status: ScreenStatus.loading));
    List<Schedule> result = [];
    try {
      result = state.selectedDate
          .map((e) => Schedule(date: e, time: DateFormat("HH:mm:00").format(e)))
          .toList();
      await matchingRepository.updateSchedule(
          meetingId: "${state.meeting?.meeting?.id}", schedules: result);
      emit(state.copyWith(status: ScreenStatus.success));
      appBloc.add(AppUpdate());
    } on ApiClientException catch (err) {
      emit(state.copyWith(status: ScreenStatus.fail));
    } catch (err) {
      emit(state.copyWith(status: ScreenStatus.fail));
    }
  }
}
