import 'package:equatable/equatable.dart';
import 'package:oasis/enum/screen_status.dart';
import 'package:oasis/model/matching/matchings.dart';
import 'package:oasis/model/matching/meeting.dart';
import 'package:oasis/model/matching/propose.dart';
import 'package:oasis/model/user/opti/user_mbti_main.dart';
import 'package:oasis/model/user/user_profile.dart';

class HomeState extends Equatable {
  final ScreenStatus status;
  final List<Propose> proposes;
  final List<Matching> matchings;
  final bool? completeCertificate;
  final MeetingResponse? meeting;

  final Propose? myPropose; // propose 상태에서 내가 보낸 프로포즈
  final UserProfile user;
  final UserMBTIMain mbtiMain;

  final String? loverCities;
  final String? loverWorkerCities;

  HomeState({
    this.status = ScreenStatus.initial,
    this.user = UserProfile.empty,
    this.proposes = const [],
    this.matchings = const [],
    this.completeCertificate = false,
    this.meeting,
    this.myPropose = Propose.empty,
    this.loverCities,
    this.loverWorkerCities,
    this.mbtiMain = UserMBTIMain.empty,
  });

  HomeState copyWith({
    ScreenStatus? status,
    UserProfile? user,
    List<Propose>? proposes,
    List<Matching>? matchings,
    MeetingResponse? meeting,
    Propose? myPropose,
    String? loverCities,
    String? loverWorkerCities,
    bool? completeCertificate,
    UserMBTIMain? mbtiMain,
  }) {
    return HomeState(
      status: status ?? this.status,
      user: user ?? this.user,
      proposes: proposes ?? this.proposes,
      matchings: matchings ?? this.matchings,
      meeting: meeting ?? this.meeting,
      myPropose: myPropose ?? this.myPropose,
      loverCities: loverCities ?? this.loverCities,
      loverWorkerCities: loverWorkerCities ?? this.loverWorkerCities,
      completeCertificate: completeCertificate ?? this.completeCertificate,
        mbtiMain: mbtiMain?? this.mbtiMain,
    );
  }

  @override
  List<Object?> get props => [
        status,mbtiMain,
        user,
        myPropose,
        proposes,
        matchings,
        meeting,
        loverCities,
        loverWorkerCities,
        completeCertificate,
      ];
}
