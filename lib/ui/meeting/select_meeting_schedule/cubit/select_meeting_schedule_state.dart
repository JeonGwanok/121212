import 'package:equatable/equatable.dart';
import 'package:oasis/enum/screen_status.dart';
import 'package:oasis/model/matching/meeting.dart';
import 'package:oasis/model/user/user_profile.dart';
import 'package:oasis/ui/meeting/select_meeting_schedule/select_meeting_schedule_screen.dart';

class SelectMeetingScheduleState extends Equatable {
  final ScreenStatus status;
  final List<DateTime> hollyDays;
  final UserProfile user;

  final MeetingResponse? meeting;

  final List<DateTime> selectedDate;

  final DateTime? selectedDateTime;
  final MeetingScheduleType? timeType;

  SelectMeetingScheduleState({
    this.status = ScreenStatus.initial,
    this.hollyDays = const [],
    this.meeting,
    this.user = UserProfile.empty,
    this.selectedDate = const [],
    this.selectedDateTime,
    this.timeType,
  });

  SelectMeetingScheduleState initialized(DateTime result) {
    List<DateTime> _result = [result, ...this.selectedDate];
    _result.sort((a, b) => b.compareTo(a));

    return SelectMeetingScheduleState(
      meeting: this.meeting,
      status: this.status,
      user: this.user,
      hollyDays: this.hollyDays,
      selectedDate: [result, ...this.selectedDate],
    );
  }

  SelectMeetingScheduleState copyWith({
    ScreenStatus? status,
    MeetingResponse? meeting,
    UserProfile? user,
    List<DateTime>? selectedDate,
    DateTime? selectedDateTime,
    List<DateTime>? hollyDays,
    MeetingScheduleType? timeType,
  }) {
    return SelectMeetingScheduleState(
      status: status ?? this.status,
      meeting: meeting ?? this.meeting,
      user: user ?? this.user,
      selectedDate: selectedDate ?? this.selectedDate,
      selectedDateTime: selectedDateTime ?? this.selectedDateTime,
      timeType: timeType ?? this.timeType,
      hollyDays: hollyDays ?? this.hollyDays,
    );
  }

  @override
  List<Object?> get props => [
        status,
        user,
        meeting,
        selectedDate,
        selectedDateTime,
        hollyDays,
        timeType,
      ];
}
