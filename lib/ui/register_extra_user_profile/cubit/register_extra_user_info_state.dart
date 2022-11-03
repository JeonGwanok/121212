import 'package:equatable/equatable.dart';
import 'package:oasis/enum/screen_status.dart';
import 'package:oasis/model/common/hobby.dart';
import 'package:oasis/model/user/user_profile.dart';

class RegisterExtraUserInfoState extends Equatable {
  final ScreenStatus status;
  final UserProfile user;

  final String? parent;
  final bool? sibling;
  final String? siblingMan;
  final String? siblingWoman;
  final String? siblingRank;

  final List<Hobby> hobbies;
  final List<Hobby> selectedHobbies;

  final String? bloodType;

  final String? drinkType;
  final bool? smoke;

  final String? introduceMySelf;
  final String? introduceMyWork;
  final String? introduceMyFamily;
  final String? myHealing;
  final String? toPartner;

  final DateTime? updateAt;

  bool get disabledMyself =>
      (introduceMySelf ?? "").isNotEmpty &&
      !((introduceMySelf ?? "").length >= 10 &&
          (introduceMySelf ?? "").length <= 200);
  bool get disabledMyWork =>
      (introduceMyWork ?? "").isNotEmpty &&
      !((introduceMyWork ?? "").length >= 10 &&
          (introduceMyWork ?? "").length <= 200);
  bool get disabledFamily =>
      (introduceMyFamily ?? "").isNotEmpty &&
      !((introduceMyFamily ?? "").length >= 10 &&
          (introduceMyFamily ?? "").length <= 200);
  bool get disabledMyHealing =>
      (myHealing ?? "").isNotEmpty &&
      !((myHealing ?? "").length >= 10 && (myHealing ?? "").length <= 200);
  bool get disabledToPartner =>
      (toPartner ?? "").isNotEmpty &&
      !((toPartner ?? "").length >= 10 && (toPartner ?? "").length <= 200);

  // 둘 중에 값이 하나라도 있는데, 비어있는 경우
  bool get disabledSibling =>
      (((siblingMan ?? "").isNotEmpty || (siblingWoman ?? "").isNotEmpty) &&
          (siblingRank ?? "").isEmpty) ||
      (((siblingMan ?? "").isEmpty && (siblingWoman ?? "").isEmpty) &&
          (siblingRank ?? "").isNotEmpty);

  RegisterExtraUserInfoState({
    this.status = ScreenStatus.initial,
    this.user = UserProfile.empty,
    this.parent,
    this.sibling,
    this.siblingMan,
    this.siblingWoman,
    this.siblingRank,
    this.hobbies = const [],
    this.selectedHobbies = const [],
    this.bloodType,
    this.drinkType,
    this.smoke,
    this.introduceMySelf,
    this.introduceMyWork,
    this.introduceMyFamily,
    this.myHealing,
    this.toPartner,
    this.updateAt,
  });

  bool get enableButton =>
      !disabledMyself &&
      !disabledMyWork &&
      !disabledFamily &&
      !disabledMyHealing &&
      !disabledToPartner &&
      !disabledSibling;

  RegisterExtraUserInfoState copyWith({
    ScreenStatus? status,
    UserProfile? user,
    String? parent,
    bool? sibling,
    List<Hobby>? hobbies,
    List<Hobby>? selectedHobbies,
    String? bloodType,
    String? drinkType,
    bool? smoke,
    String? introduceMySelf,
    String? introduceMyWork,
    String? introduceMyFamily,
    String? myHealing,
    String? toPartner,
    String? siblingMan,
    String? siblingWoman,
    String? siblingRank,
    DateTime? updateAt,
  }) {
    return RegisterExtraUserInfoState(
      user: user ?? this.user,
      status: status ?? this.status,
      parent: parent ?? this.parent,
      sibling: sibling ?? this.sibling,
      hobbies: hobbies ?? this.hobbies,
      selectedHobbies: selectedHobbies ?? this.selectedHobbies,
      bloodType: bloodType ?? this.bloodType,
      drinkType: drinkType ?? this.drinkType,
      smoke: smoke ?? this.smoke,
      introduceMySelf: introduceMySelf ?? this.introduceMySelf,
      introduceMyWork: introduceMyWork ?? this.introduceMyWork,
      introduceMyFamily: introduceMyFamily ?? this.introduceMyFamily,
      myHealing: myHealing ?? this.myHealing,
      toPartner: toPartner ?? this.toPartner,
      siblingMan: siblingMan ?? this.siblingMan,
      siblingWoman: siblingWoman ?? this.siblingWoman,
      siblingRank: siblingRank ?? this.siblingRank,
      updateAt: updateAt ?? this.updateAt,
    );
  }

  @override
  List<Object?> get props => [
        status,
        parent,
        user,
        sibling,
        hobbies,
        selectedHobbies,
        bloodType,
        drinkType,
        smoke,
        introduceMySelf,
        introduceMyWork,
        introduceMyFamily,
        myHealing,
        toPartner,
        siblingMan,
        siblingWoman,
        siblingRank,
        updateAt,
      ];
}
