import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:oasis/model/common/citys.dart';
import 'package:oasis/model/common/hobby.dart';
import 'package:oasis/model/user/image/user_image.dart';
import 'package:oasis/repository/common_repository.dart';
import 'package:oasis/repository/user_repository.dart';

import 'my_info_detail_state.dart';

class MyInfoDetailCubit extends Cubit<MyInfoDetailState> {
  final UserRepository userRepository;
  final CommonRepository commonRepository;

  MyInfoDetailCubit({
    required this.userRepository,
    required this.commonRepository,
  }) : super(MyInfoDetailState());

  initialize() async {
    try {
      emit(state.copyWith(status: MyInfoDetailStateStatus.loading));
      var user = await userRepository.getUser();
      var certificate =
          await userRepository.getCertificate("${user.customer!.id}");

      var cityId = user.profile?.myCityId;
      var cities = await commonRepository.getCitys();
      City? selectedCity;
      if (cityId != null) {
        var _city = cities.where((element) => element.id == cityId).toList();
        if (_city.isNotEmpty) {
          selectedCity = _city.first;
        }
      }

      List<Country> countries = [];
      Country? selectedCountry;
      var countryId = user.profile?.myCountryId;
      if (selectedCity != null && countryId != null) {
        try {
          countries = await commonRepository.getCountry("$cityId");
          if (countries.isNotEmpty) {
            var _country =
                countries.where((element) => countryId == element.id).toList();
            if (_country.isNotEmpty) {
              selectedCountry = _country.first;
            }
          }
        } catch (err) {}
      }

      var hobbies = await commonRepository.getHobby();
      List<Hobby>? selectedHobbies;

      var myHobbies = user.profile?.myHobby;
      if ((myHobbies ?? "").isNotEmpty) {
        List<String> selectedHobbiesIds = myHobbies!.split(",").toList();
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

      var copyUser = user.copyWith();

      emit(state.copyWith(
        userProfile: user,
        certificate: certificate,
        region: "${selectedCity?.name ?? ""} ${selectedCountry?.name ?? ""}",
        hobbies: hobbies,
        selectedHobbies: selectedHobbies,
        myDrink: copyUser.profile?.myDrink,
        mySmoke: copyUser.profile?.mySmoke,
        myIntroduce: copyUser.profile?.myIntroduce,
        myWorkIntro: copyUser.profile?.myWorkIntro,
        myFamilyIntro: copyUser.profile?.myFamilyIntro,
        myHealing: copyUser.profile?.myHealing,
        myVoiceToLover: copyUser.profile?.myVoiceToLover,
        status: MyInfoDetailStateStatus.success,
      ));
    } catch (err) {
      emit(state.copyWith(status: MyInfoDetailStateStatus.fail));
    }
  }

  updateImage({UserImage? image}) {
    if (image != null) {
      emit(
        state.copyWith(
          userProfile: state.userProfile.copyWith(image: image),
        ),
      );
    }
  }

  changeHobby(List<Hobby> hobbies) {
    emit(state.copyWith(selectedHobbies: hobbies));
  }

  changeDrink(String myDrink) {
    emit(state.copyWith(myDrink: myDrink));
  }

  changeSmoke(bool mySmoke) {
    emit(state.copyWith(mySmoke: mySmoke));
  }

  changeMyIntroduce(String myIntroduce) {
    emit(state.copyWith(myIntroduce: myIntroduce));
  }

  changeMyWorkIntro(String myWorkIntro) {
    emit(state.copyWith(myWorkIntro: myWorkIntro));
  }

  changeMyFamilyIntro(String myFamilyIntro) {
    emit(state.copyWith(myFamilyIntro: myFamilyIntro));
  }

  changeMyHealing(String myHealing) {
    emit(state.copyWith(myHealing: myHealing));
  }

  changeMyVoiceToLover(String myVoiceToLover) {
    emit(state.copyWith(myVoiceToLover: myVoiceToLover));
  }

  updateProfile() async {
    try {
      emit(state.copyWith(status: MyInfoDetailStateStatus.loading));

      String hobby = "";
      if (state.selectedHobbies.isNotEmpty) {
        for (var item in state.selectedHobbies) {
          hobby = "${item.id}${hobby == null ? "" : ",$hobby"}";
        }
      }

      await userRepository.editProfile(state.userProfile.profile!.copyWith(
        myDrink: state.myDrink,
        mySmoke: state.mySmoke,
        myHobby: hobby,
        myIntroduce: state.myIntroduce,
        myWorkIntro: state.myWorkIntro,
        myFamilyIntro: state.myFamilyIntro,
        myHealing: state.myHealing,
        myVoiceToLover: state.myVoiceToLover,
      ));

      emit(state.copyWith(status: MyInfoDetailStateStatus.editSuccess));
      initialize();
    } catch (err) {}
  }
  // requestManager() async {
  //   try {
  //     emit(state.copyWith(status: MyInfoDetailStateStatus.sending));
  //     await userRepository
  //         .profileEditRequestToManager("${state.userProfile.customer?.id}");
  //     emit(state.copyWith(status: MyInfoDetailStateStatus.editSuccess));
  //   } catch (err) {}
  // }
}
