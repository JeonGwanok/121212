import 'package:equatable/equatable.dart';
import 'package:oasis/enum/screen_status.dart';
import 'package:oasis/model/matching/meeting.dart';
import 'package:oasis/model/user/user_profile.dart';

class ConfirmMeetingState extends Equatable {
  final ScreenStatus status;
  final UserProfile user;
  final UserProfile lover;
  final int myStoryCount;
  final int partnerStoryCount;
  final MeetingResponse? meeting;

  ConfirmMeetingState({
    this.status = ScreenStatus.initial,
    this.user = UserProfile.empty,
    this.lover = UserProfile.empty,
    this.myStoryCount = 0,
    this.partnerStoryCount = 0,
    this.meeting,
  });

  ConfirmMeetingState copyWith({
    ScreenStatus? status,
    UserProfile? user,
    UserProfile? lover,
    MeetingResponse? meeting,
    int? myStoryCount,
    int? partnerStoryCount,
  }) {
    return ConfirmMeetingState(
      status: status ?? this.status,
      user: user ?? this.user,
      lover: lover ?? this.lover,
      meeting: meeting ?? this.meeting,
      myStoryCount: myStoryCount ?? this.myStoryCount,
      partnerStoryCount: partnerStoryCount ?? this.partnerStoryCount,
    );
  }

  @override
  List<Object?> get props => [
        status,
        lover,
        user,
        meeting,
        myStoryCount,
        partnerStoryCount,
      ];
}
