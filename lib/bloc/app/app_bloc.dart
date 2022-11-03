import 'dart:io';

import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:oasis/repository/user_repository.dart';
import 'bloc.dart';

class AppBloc extends Bloc<AppEvent, AppState> {
  final UserRepository userRepository;
  AppBloc({required this.userRepository}) : super(AppLoading());

  @override
  Stream<AppState> mapEventToState(event) async* {
    if (event is AppInitialize) {
      yield* mapAppInitializeToState(event);
    } else if (event is AppUpdate) {
      yield* mapAppUpdateToState(event);
    }
  }

  Stream<AppState> mapAppUpdateToState(AppUpdate event) async* {
    try {
      var user = event.user ?? await userRepository.getUser();
      yield AppLoaded(
        user: user,
        updateAt: DateTime.now(),
      );
    } catch (_) {}
  }

  Stream<AppState> mapAppInitializeToState(AppInitialize event) async* {
    var user = event.user ?? await userRepository.getUser();
    var mbti =
        await userRepository.getUserMBTIMain(customerId: user.customer?.id);
    var mbtiDetail =
        await userRepository.getUserMBTIDetail(customerId: user.customer?.id);

    if ((user.profile?.myReligion ?? "").isEmpty) {
      // (1) 내 정보가 없으면
      yield AppUnInitialized.unCompleteMYInfo();
    } else if (!(user.customer?.essentialStatus ?? false)) {
      // (2) 추가정보를 입력 안 했으면
      yield AppUnInitialized.unCompleteCompleteExtraInfo();
    } else if ((user.profile?.loverAcademic ?? "").isEmpty) {
      // (3) 이상형 정보가 없으면
      yield AppUnInitialized.unCompletePartnerInfo();
    } else if (!(mbti?.eValue != null &&
        (mbtiDetail?.tendencyAnswer ?? []).isNotEmpty)) {
      // (4) mbti 안 했으면
      yield AppUnInitialized.unCompleteMBTI();
    } else if (!(user.customer?.certificateStatus ?? false)) {
      // (5) 서류인증 안했으면
      yield AppUnInitialized.unCompleteCertificate();
    } else if (!(user.customer?.joinStatus ?? false)) {
      // (6) signUp 안눌렀으면
      yield AppUnInitialized.unCompleteSignUp();
    } else {
      // signUp 버튼까지 무사히 완료 했으면
      try {
        String? deviceToken;
        String? os;
        os = Platform.isAndroid ? "ANDROID" : "IOS";

        // 푸시 퍼미션 확인
        await FirebaseMessaging.instance.requestPermission(
          alert: true,
          announcement: true,
          badge: true,
          carPlay: true,
          criticalAlert: true,
          provisional: true,
          sound: true,
        );

        await FirebaseMessaging.instance.getNotificationSettings();
        if (os == "ANDROID") {
          deviceToken = await FirebaseMessaging.instance.getToken() ?? "";
        } else {
          deviceToken = await FirebaseMessaging.instance.getToken() ?? "";
        }
        await userRepository.updateDeviceInfo(
          customerId: "${user.customer?.id}",
          deviceToken: deviceToken,
          deviceOS: os,
        );
      } catch (_) {}

      yield AppLoaded(user: user);
    }
  }
}
