import 'package:equatable/equatable.dart';
import 'package:oasis/enum/screen_status.dart';
import 'package:oasis/model/matching/meeting.dart';
import 'package:oasis/model/user/user_profile.dart';

class MyStatusState extends Equatable {
  final ScreenStatus status;
  final UserProfile user;

  final MeetingResponse? meeting;
  final int uncheckedMatchingCount;

  MyStatusState({
    this.status = ScreenStatus.initial,
    this.user = UserProfile.empty,
    this.meeting,
    this.uncheckedMatchingCount = 0,
  });

  MyStatusState copyWith({
    ScreenStatus? status,
    UserProfile? user,
    MeetingResponse? meeting,
    int? uncheckedMatchingCount,
  }) {
    return MyStatusState(
      status: status ?? this.status,
      user: user ?? this.user,
      meeting: meeting ?? this.meeting,
      uncheckedMatchingCount:
          uncheckedMatchingCount ?? this.uncheckedMatchingCount,
    );
  }

  @override
  List<Object?> get props => [
        status,
        user,
        meeting,
        uncheckedMatchingCount,
      ];
}
