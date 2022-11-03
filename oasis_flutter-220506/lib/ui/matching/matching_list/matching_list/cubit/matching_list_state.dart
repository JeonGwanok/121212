import 'package:equatable/equatable.dart';
import 'package:oasis/enum/screen_status.dart';
import 'package:oasis/model/matching/matchings.dart';
import 'package:oasis/model/user/user_profile.dart';

enum MatchingListStatus {
  initial,
  notEnoughMeeting,
  notFoundUser,
  unableUser,
  success,
  reject,
  fail, // fail 은 로드 fail 일때만. 다시 시도해주세요 등의 메세지 필요
}

class MatchingListState extends Equatable {
  final ScreenStatus status;
  final MatchingListStatus matchingListStatus;
  final UserProfile userProfile;
  final List<Matching> matchings;
  final Matching current;

  MatchingListState({
    this.status = ScreenStatus.initial,
    this.matchingListStatus = MatchingListStatus.initial,
    this.userProfile = UserProfile.empty,
    this.matchings = const [],
    this.current = Matching.empty,
  });

  MatchingListState copyWith({
    ScreenStatus? status,
    MatchingListStatus? matchingListStatus,
    List<Matching>? matchings,
    UserProfile? userProfile,
    Matching? current,
  }) {
    return MatchingListState(
      status: status ?? this.status,
      matchingListStatus: matchingListStatus ?? this.matchingListStatus,
      matchings: matchings ?? this.matchings,
      userProfile: userProfile ?? this.userProfile,
      current: current ?? this.current,
    );
  }

  @override
  List<Object?> get props => [
        status,
        matchingListStatus,
        matchings,
        userProfile,
        current,
      ];
}
