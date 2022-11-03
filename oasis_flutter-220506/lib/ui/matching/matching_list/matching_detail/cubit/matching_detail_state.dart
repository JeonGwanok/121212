import 'package:equatable/equatable.dart';
import 'package:oasis/enum/screen_status.dart';
import 'package:oasis/model/matching/propose.dart';
import 'package:oasis/model/opti/compare_tendency.dart';

/// matching accept 보내고 난 뒤 상태
enum MatchingStatus {
  initial,
  notEnoughMeeting,
  notFoundUser,
  unableUser,
  success,
  reject,
  fail, // fail 은 로드 fail 일때만. 다시 시도해주세요 등의 메세지 필요
}

class MatchingDetailState extends Equatable {
  final ScreenStatus status; // 기본적으로 status 는 페이지 스테이터스
  final Propose propose;
  final CompareTendency compareTendency;
  final MatchingStatus matchingStatus;

  MatchingDetailState({
    this.status = ScreenStatus.initial,
    this.compareTendency = CompareTendency.empty,
    this.matchingStatus = MatchingStatus.initial,
    this.propose = Propose.empty,
  });

  MatchingDetailState copyWith({
    ScreenStatus? status,
    MatchingStatus? matchingStatus,
    CompareTendency? compareTendency,
    Propose? propose,
  }) {
    return MatchingDetailState(
      status: status ?? this.status,
      compareTendency: compareTendency ?? this.compareTendency,
      matchingStatus: matchingStatus ?? this.matchingStatus,
      propose: propose ?? this.propose,
    );
  }

  @override
  List<Object?> get props => [
        status,
        compareTendency,
        matchingStatus,
        propose,
      ];
}
