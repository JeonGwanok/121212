import 'dart:async';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:oasis/bloc/app/app_bloc.dart';
import 'package:oasis/bloc/app/app_state.dart';
import 'package:oasis/enum/screen_status.dart';
import 'package:oasis/model/common/citys.dart';
import 'package:oasis/model/matching/matchings.dart';
import 'package:oasis/model/matching/meeting.dart';
import 'package:oasis/model/matching/propose.dart';
import 'package:oasis/model/user/certificate.dart';
import 'package:oasis/repository/common_repository.dart';
import 'package:oasis/repository/matching_repository.dart';
import 'package:oasis/repository/user_repository.dart';

import 'home_state.dart';

class HomeCubit extends Cubit<HomeState> {
  final AppBloc appBloc;
  final UserRepository userRepository;
  final MatchingRepository matchingRepository;
  final CommonRepository commonRepository;

  StreamSubscription? _subscription;

  HomeCubit({
    required this.appBloc,
    required this.userRepository,
    required this.commonRepository,
    required this.matchingRepository,
  }) : super(HomeState()) {
    _subscription = appBloc.stream.listen(_update);
    _update(appBloc.state);
  }

  void _update(AppState appState) {
    AppState _appState = appBloc.state;
    if (_appState is AppLoaded) {
      initialize();
    }
  }

  initialize({bool onRefresh = false}) async {
    emit(state.copyWith(
        status: onRefresh ? ScreenStatus.refresh : ScreenStatus.loading));
    var user = await userRepository.getUser();
    var mbti = await userRepository.getUserMBTIMain(customerId: user.customer?.id);
    var cities = await commonRepository.getCitys();

    if (onRefresh) {
      await Future.delayed(Duration(milliseconds: 500));
    }

    List<City>? selectedCity;
    if (user.profile?.loverResidenceCity1Id != null ||
        user.profile?.loverResidenceCity2Id != null) {
      var _citys = cities
          .where((element) =>
              element.id == user.profile?.loverResidenceCity1Id ||
              element.id == user.profile?.loverResidenceCity2Id)
          .toList();
      if (_citys.isNotEmpty) {
        selectedCity = _citys;
      }
    }

    List<City>? selectedWorkerCity;
    if (user.profile?.loverWorkCity1Id != null ||
        user.profile?.loverWorkCity2Id != null) {
      var _citys = cities
          .where((element) =>
              element.id == user.profile?.loverWorkCity1Id ||
              element.id == user.profile?.loverWorkCity2Id)
          .toList();
      if (_citys.isNotEmpty) {
        selectedWorkerCity = _citys;
      }
    }

    var userId = "${user.customer?.id}";

    var certificate = await userRepository.getCertificate(userId);
    List<Propose>? proposes;
    Propose? myPropose;
    List<Matching>? matchings;
    MeetingResponse? meeting;

    if (user.customer!.nowStatus == "WAIT") {
      proposes = await matchingRepository.getProposes(customerId: userId);

      matchings = await matchingRepository.getMatchings(customerId: userId);

      matchings = (matchings ?? []).where((e) => !(e.proposeStatus ?? false)).toList();

    } else if (user.customer!.nowStatus == "PROPOSE") {
      List<Propose> myProposes =
          await matchingRepository.getSentProposes(customerId: userId);
      myProposes = myProposes
          .where((element) => element.meetingStatus != false)
          .toList();
      if (myProposes.isNotEmpty) {
        myProposes.sort((a, b) => a.createdAt!.compareTo(b.createdAt!));
        myPropose = myProposes.last;
      }
    } else if (user.customer!.nowStatus == "MEETING") {
      meeting = await matchingRepository.getMeetingInfo(customerId: userId);
    } else if (user.customer!.nowStatus == "LOVE") {
      meeting = await matchingRepository.getMeetingInfo(customerId: userId);
    }

    emit(
      state.copyWith(
        status: ScreenStatus.success,
        mbtiMain: mbti,
        user: user,
        meeting: meeting,
        myPropose: myPropose,
        proposes: proposes,
        matchings: matchings,
        loverCities: (selectedCity ?? []).map((e) => e.name).toString(),
        loverWorkerCities:
            (selectedWorkerCity ?? []).map((e) => e.name).toString(),
        completeCertificate:
            certificate.marriageStatus == CertificateStatusType.complete &&
                certificate.marriageStatus == CertificateStatusType.complete &&
                certificate.jobStatus == CertificateStatusType.complete,
      ),
    );
  }

  @override
  Future<void> close() {
    _subscription?.cancel();
    return super.close();
  }
}
