import 'package:equatable/equatable.dart';
import 'package:oasis/model/common/hobby.dart';
import 'package:oasis/model/user/certificate.dart';
import 'package:oasis/model/user/user_profile.dart';

enum MyInfoDetailStateStatus {
  initial,
  loading,
  fail,
  success,
  sending,
  editSuccess,
}

class MyInfoDetailState extends Equatable {
  final MyInfoDetailStateStatus status;
  final UserProfile userProfile;
  final Certificate certificate;

  final List<Hobby> hobbies;
  final String? region;
  final String? workCity;

  final List<Hobby> selectedHobbies;
  final String myDrink;
  final bool mySmoke;
  final String myIntroduce;
  final String myWorkIntro;
  final String myFamilyIntro;
  final String myHealing;
  final String myVoiceToLover;

  bool get disabledMyself =>
      myIntroduce.isNotEmpty &&
      !(myIntroduce.length >= 10 && myIntroduce.length <= 200);
  bool get disabledMyWork =>
      myWorkIntro.isNotEmpty &&
      !(myWorkIntro.length >= 10 && myWorkIntro.length <= 200);
  bool get disabledFamily =>
      myFamilyIntro.isNotEmpty &&
      !(myFamilyIntro.length >= 10 && myFamilyIntro.length <= 200);
  bool get disabledMyHealing =>
      myHealing.isNotEmpty &&
      !(myHealing.length >= 10 && myHealing.length <= 200);
  bool get disabledToPartner =>
      myVoiceToLover.isNotEmpty &&
      !(myVoiceToLover.length >= 10 && myVoiceToLover.length <= 200);

  bool get enabledButton =>  !disabledMyself && !disabledMyWork && !disabledFamily && !disabledMyHealing && !disabledToPartner;

  MyInfoDetailState({
    this.status = MyInfoDetailStateStatus.initial,
    this.userProfile = UserProfile.empty,
    this.certificate = Certificate.empty,
    this.region = "",
    this.workCity = "",
    this.selectedHobbies = const [],
    this.hobbies = const [],
    this.myDrink = "",
    this.mySmoke = false,
    this.myIntroduce = "",
    this.myWorkIntro = "",
    this.myFamilyIntro = "",
    this.myHealing = "",
    this.myVoiceToLover = "",
  });

  MyInfoDetailState copyWith({
    MyInfoDetailStateStatus? status,
    UserProfile? userProfile,
    Certificate? certificate,
    List<Hobby>? selectedHobbies,
    List<Hobby>? hobbies,
    String? region,
    String? workCity,
    String? myDrink,
    bool? mySmoke,
    String? myIntroduce,
    String? myWorkIntro,
    String? myFamilyIntro,
    String? myHealing,
    String? myVoiceToLover,
  }) {
    return MyInfoDetailState(
      status: status ?? this.status,
      userProfile: userProfile ?? this.userProfile,
      certificate: certificate ?? this.certificate,
      selectedHobbies: selectedHobbies ?? this.selectedHobbies,
      region: region ?? this.region,
      workCity: workCity ?? this.workCity,
      hobbies: hobbies ?? this.hobbies,
      myDrink: myDrink ?? this.myDrink,
      mySmoke: mySmoke ?? this.mySmoke,
      myIntroduce: myIntroduce ?? this.myIntroduce,
      myWorkIntro: myWorkIntro ?? this.myWorkIntro,
      myFamilyIntro: myFamilyIntro ?? this.myFamilyIntro,
      myHealing: myHealing ?? this.myHealing,
      myVoiceToLover: myVoiceToLover ?? this.myVoiceToLover,
    );
  }

  @override
  List<Object?> get props => [
        status,
        userProfile,
        workCity,
        region,
        certificate,
        selectedHobbies,
        hobbies,
        myDrink,
        mySmoke,
        myIntroduce,
        myWorkIntro,
        myFamilyIntro,
        myHealing,
        myVoiceToLover,
      ];
}
