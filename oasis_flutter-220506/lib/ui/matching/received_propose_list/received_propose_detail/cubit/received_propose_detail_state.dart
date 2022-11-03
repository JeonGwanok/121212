import 'package:equatable/equatable.dart';
import 'package:oasis/enum/screen_status.dart';
import 'package:oasis/model/matching/propose.dart';

/// 프로포즈 accept 보내고 난 뒤 상태
enum ReceivedProposeStatus {
  initial,
  notEnoughMeeting,
  notFoundUser,
  unableUser,
  success,
  reject,
  fail, // fail 은 로드 fail 일때만. 다시 시도해주세요 등의 메세지 필요
}

class ReceivedProposeDetailState extends Equatable {
  final ScreenStatus status; // 기본적으로 status 는 페이지 스테이터스
  final Propose propose;
  final ReceivedProposeStatus proposeStatus;

  ReceivedProposeDetailState({
    this.status = ScreenStatus.initial,
    this.proposeStatus = ReceivedProposeStatus.initial,
    this.propose = Propose.empty,
  });

  ReceivedProposeDetailState copyWith({
    ScreenStatus? status,
    ReceivedProposeStatus? proposeStatus,
    Propose? propose,
  }) {
    return ReceivedProposeDetailState(
      status: status ?? this.status,
      proposeStatus: proposeStatus ?? this.proposeStatus,
      propose: propose ?? this.propose,
    );
  }

  @override
  List<Object?> get props => [
        status,
        proposeStatus,
    propose,
      ];
}
