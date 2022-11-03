import 'package:equatable/equatable.dart';
import 'package:oasis/enum/screen_status.dart';
import 'package:oasis/model/matching/propose.dart';
import 'package:oasis/model/opti/compare_tendency.dart';
import 'package:oasis/model/user/user_profile.dart';
import 'package:oasis/ui/matching/received_propose_list/received_propose_detail/cubit/received_propose_detail_state.dart';

class ReceivedProposeListState extends Equatable {
  final ScreenStatus status; // 기본적으로 status 는 페이지 스테이터스
  final ReceivedProposeStatus proposeStatus;
  final UserProfile userProfile;
  final List<Propose> proposes;
  final Propose current;
  final CompareTendency compareTendency;

  ReceivedProposeListState({
    this.status = ScreenStatus.success,
    this.userProfile = UserProfile.empty,
    this.proposeStatus = ReceivedProposeStatus.initial,
    this.proposes = const [],
    this.current = Propose.empty,
    this.compareTendency = CompareTendency.empty,
  });

  ReceivedProposeListState copyWith({
    ScreenStatus? status,
    UserProfile? userProfile,
    ReceivedProposeStatus? proposeStatus,
    List<Propose>? proposes,
    Propose? current,
    CompareTendency? compareTendency,
  }) {
    return ReceivedProposeListState(
      status: status ?? this.status,
      userProfile: userProfile ?? this.userProfile,
      proposeStatus: proposeStatus ?? this.proposeStatus,
      proposes: proposes ?? this.proposes,
      current: current ?? this.current,
      compareTendency: compareTendency ?? this.compareTendency,
    );
  }

  @override
  List<Object?> get props => [
        status,
        userProfile,
        proposeStatus,
        proposes,
        current,
        compareTendency,
      ];
}
