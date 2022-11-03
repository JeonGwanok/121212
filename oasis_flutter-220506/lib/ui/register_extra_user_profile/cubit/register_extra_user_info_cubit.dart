import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:oasis/enum/screen_status.dart';
import 'package:oasis/model/common/hobby.dart';
import 'package:oasis/repository/common_repository.dart';
import 'package:oasis/repository/user_repository.dart';

import 'register_extra_user_info_state.dart';

class RegisterExtraUserInfoCubit extends Cubit<RegisterExtraUserInfoState> {
  final UserRepository userRepository;
  final CommonRepository commonRepository;

  RegisterExtraUserInfoCubit({
    required this.userRepository,
    required this.commonRepository,
  }) : super(RegisterExtraUserInfoState());

  initialize() async {
    var user = await userRepository.getUser();
    try {
      var hobbies = await commonRepository.getHobby();
      List<Hobby>? selectedHobbies;
      if ((user.profile?.myHobby ?? "").isNotEmpty) {
        List<String> selectedHobbiesIds =
            user.profile!.myHobby!.split(",").toList();
        var _hobbies = hobbies.where((element) {
          if (selectedHobbiesIds.contains("${element.id}")) {
            return true;
          } else {
            return false;
          }
        }).toList();
        if (_hobbies.isNotEmpty) {
          selectedHobbies = _hobbies;
        }
      }

      emit(state.copyWith(
          user: user,
          parent: user.profile?.myParents,
          sibling: user.profile?.mySiblings,
          selectedHobbies: selectedHobbies,
          bloodType: user.profile?.myBloodType,
          drinkType: user.profile?.myDrink,
          smoke: user.profile?.mySmoke,
          introduceMySelf: user.profile?.myIntroduce,
          introduceMyWork: user.profile?.myWorkIntro,
          introduceMyFamily: user.profile?.myFamilyIntro,
          myHealing: user.profile?.myHealing,
          toPartner: user.profile?.myVoiceToLover,
          siblingMan: user.profile?.myBrotherNumber != null
              ? "${user.profile!.myBrotherNumber}"
              : null,
          siblingWoman: user.profile?.mySisterNumber != null
              ? "${user.profile!.mySisterNumber}"
              : null,
          siblingRank: user.profile?.mySiblingRank != null
              ? "${user.profile!.mySiblingRank}"
              : null,
          status: ScreenStatus.loaded,
          hobbies: hobbies));
    } catch (err) {}
  }

  changeScreenStatus() {
    emit(state.copyWith(status: ScreenStatus.loaded));
  }

  enterValue({
    String? parent,
    bool? sibling,
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
  }) {
    emit(state.copyWith(
      parent: parent,
      sibling: sibling,
      selectedHobbies: selectedHobbies,
      bloodType: bloodType,
      drinkType: drinkType,
      smoke: smoke,
      introduceMySelf: introduceMySelf,
      introduceMyWork: introduceMyWork,
      introduceMyFamily: introduceMyFamily,
      myHealing: myHealing,
      toPartner: toPartner,
      siblingMan: siblingMan,
      siblingWoman: siblingWoman,
      siblingRank: siblingRank,
    ));
  }

  update() async {

    String? hobby;

    if (state.selectedHobbies.isNotEmpty) {
      for (var item in state.selectedHobbies) {
        hobby = "${item.id}${hobby == null ? "" : ",$hobby"}";
      }
    }

    try {
      var user = state.user.copyWith(
          profile: state.user.profile!.copyWith(
              myParents: state.parent,
              mySiblings: state.sibling,
              myBloodType: state.bloodType,
              myDrink: state.drinkType,
              mySmoke: state.smoke,
              myIntroduce: state.introduceMySelf,
              myWorkIntro: state.introduceMyWork,
              myFamilyIntro: state.introduceMyFamily,
              myHealing: state.myHealing,
              mySisterNumber: (state.siblingWoman ?? "").isNotEmpty
                  ? int.parse(state.siblingWoman!)
                  : null,
              myBrotherNumber: (state.siblingMan ?? "").isNotEmpty
                  ? int.parse(state.siblingMan!)
                  : null,
              mySiblingRank: (state.siblingRank ?? "").isNotEmpty
                  ? int.parse(state.siblingRank!)
                  : null,
              myHobby: hobby,

              ));
      await userRepository.editProfile(user.profile!);
      await userRepository.editCustomer(state.user.customer!.copyWith(essentialStatus: true));
      emit(state.copyWith(
          status: ScreenStatus.success, user: user, updateAt: DateTime.now()));
    } catch (err) {
      emit(state.copyWith(status: ScreenStatus.fail));
    }
  }
}
