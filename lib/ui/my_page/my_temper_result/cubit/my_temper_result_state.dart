import 'package:equatable/equatable.dart';
import 'package:oasis/enum/screen_status.dart';
import 'package:oasis/model/opti/tendencies.dart';
import 'package:oasis/model/user/opti/user_mbti_detail.dart';
import 'package:oasis/model/user/opti/user_mbti_main.dart';
import 'package:oasis/model/user/user_profile.dart';

class TemperResultState extends Equatable {
  final ScreenStatus status;
  final UserProfile user;
  final UserMBTIDetail mbtiDetail;
  final UserMBTIMain mbtiMain;
  final Map<int, Tendency> tendencies;
  final String myMBTI;

  TemperResultState({
    this.status = ScreenStatus.initial,
    this.user = UserProfile.empty,
    this.mbtiDetail = UserMBTIDetail.empty,
    this.mbtiMain = UserMBTIMain.empty,
    this.tendencies = const {},
    this.myMBTI = "",
  });

  TemperResultState copyWith({
    ScreenStatus? status,
    UserProfile? user,
    UserMBTIDetail? mbtiDetail,
    UserMBTIMain? mbtiMain,
    Map<int, Tendency>? tendencies,
    String? myMBTI,
  }) {
    return TemperResultState(
      status: status ?? this.status,
      user: user ?? this.user,
      mbtiDetail: mbtiDetail ?? this.mbtiDetail,
      mbtiMain: mbtiMain ?? this.mbtiMain,
      tendencies: tendencies ?? this.tendencies,
      myMBTI: myMBTI ?? this.myMBTI,
    );
  }

  @override
  List<Object?> get props => [
        tendencies,
        status,
        user,
        mbtiDetail,
        mbtiMain,
        myMBTI,
      ];
}
