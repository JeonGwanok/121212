part of 'opti_test_cubit.dart';

class OPTITestState extends Equatable {
  final ScreenStatus status;
  final UserProfile user;
  final UserMBTIMain mbtiMain;
  final UserMBTIDetail mbtiDetail;

  OPTITestState({
    this.status = ScreenStatus.initial,
    this.user = UserProfile.empty,
    this.mbtiMain = UserMBTIMain.empty,
    this.mbtiDetail = UserMBTIDetail.empty,
  });

  OPTITestState copyWith({
    ScreenStatus? status,
    UserProfile? user,
    UserMBTIMain? mbtiMain,
    UserMBTIDetail? mbtiDetail,
  }) {
    return OPTITestState(
      status: status ?? this.status,
      user: user ?? this.user,
      mbtiMain: mbtiMain ?? this.mbtiMain,
      mbtiDetail: mbtiDetail ?? this.mbtiDetail,
    );
  }

  @override
  List<Object?> get props => [
        status,
        user,
        mbtiMain,
        mbtiDetail,
      ];
}
