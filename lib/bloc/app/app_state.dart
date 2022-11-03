import 'package:equatable/equatable.dart';
import 'package:oasis/model/user/user_profile.dart';

class AppState extends Equatable {
  @override
  List<Object?> get props => [];
}

class AppUnAuth extends AppState {}

class AppLoading extends AppState {}

class AppUnInitialized extends AppState {
  final bool completeMyInfo;
  final bool completePartnerInfo;
  final bool completeExtraInfo;
  final bool completeMBTI;
  final bool completeCertificate;
  final bool completeSignUp;

  AppUnInitialized({
    this.completeMyInfo = false,
    this.completePartnerInfo = false,
    this.completeExtraInfo = false,
    this.completeMBTI = false,
    this.completeCertificate = false,
    this.completeSignUp = false,
  });

  static AppUnInitialized unCompleteMYInfo() => AppUnInitialized(
        completeMyInfo: false,
      );


  static AppUnInitialized unCompleteCompleteExtraInfo() => AppUnInitialized(
        completeMyInfo: true,
        completePartnerInfo: false,
      );

  static AppUnInitialized unCompletePartnerInfo() => AppUnInitialized(
    completeMyInfo: true,
    completeExtraInfo: true,
    completePartnerInfo: false,
  );

  static AppUnInitialized unCompleteMBTI() => AppUnInitialized(
        completeMyInfo: true,
        completePartnerInfo: true,
        completeExtraInfo: true,
        completeMBTI: false,
      );

  static AppUnInitialized unCompleteCertificate() => AppUnInitialized(
        completeMyInfo: true,
        completePartnerInfo: true,
        completeExtraInfo: true,
        completeMBTI: true,
        completeCertificate: false,
      );

  static AppUnInitialized unCompleteSignUp() => AppUnInitialized(
        completeMyInfo: true,
        completePartnerInfo: true,
        completeExtraInfo: true,
        completeMBTI: true,
        completeCertificate: true,
        completeSignUp: false,
      );

  @override
  List<Object?> get props => [
        completeMyInfo,
        completePartnerInfo,
        completeExtraInfo,
        completeMBTI,
        completeCertificate,
        completeSignUp,
      ];
}

class AppLoaded extends AppState {
  final UserProfile user;
  final DateTime? updateAt;
  AppLoaded({
    this.user = UserProfile.empty,
    this.updateAt,
  });

  @override
  List<Object?> get props => [
        user,
        updateAt,
      ];
}
