import 'dart:math';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:oasis/enum/profile/academic_type.dart';
import 'package:oasis/enum/profile/job_type.dart';
import 'package:oasis/enum/profile/marriage_type.dart';
import 'package:oasis/enum/screen_status.dart';
import 'package:oasis/model/common/citys.dart';
import 'package:oasis/model/user/image/user_image.dart';
import 'package:oasis/repository/common_repository.dart';
import 'package:oasis/repository/user_repository.dart';
import 'package:oasis/ui/register_user_info/common/base_info/gender_select.dart';
import 'package:oasis/ui/sign/util/field_status.dart';
import 'package:oasis/ui/sign/util/validator.dart';

import 'register_user_info_state.dart';

class RegisterUserInfoCubit extends Cubit<RegisterUserInfoState> {
  final int initialPage;
  final UserRepository userRepository;
  final CommonRepository commonRepository;

  RegisterUserInfoCubit({
    required this.initialPage,
    required this.userRepository,
    required this.commonRepository,
  }) : super(RegisterUserInfoState());

  initialize() async {
    var user = await userRepository.getUser();
    var cities = await commonRepository.getCitys();
    var terms = await commonRepository.getTerms();


    HeightFieldStatus heightStatus = HeightFieldStatus.initial;

    if (user.profile?.myHeight != null) {
      if (user.profile!.myHeight! >= 120 && user.profile!.myHeight! <= 300) {
        heightStatus = HeightFieldStatus.success;
      } else {
        heightStatus = HeightFieldStatus.invalid;
      }
    }

    NickNameFieldStatus nameStatus =
        Validator.nameNameValidator(user.customer?.name ?? "");

    SchoolFieldStatus schoolStatus =
        Validator.schoolValidator(user.profile?.mySchoolName ?? "");

    City? selectedCity;
    City? selectedWorkCity;
    if (user.profile?.myCityId != null) {
      var _city = cities
          .where((element) => element.id == user.profile?.myCityId!)
          .toList();
      var _workCity = cities
          .where((element) => element.id == user.profile?.myWorkCityId)
          .toList();
      if (_city.isNotEmpty) {
        selectedCity = _city.first;
      }
      if (_workCity.isNotEmpty) {
        selectedWorkCity = _workCity.first;
      }
    }

    List<Country> countries = [];
    Country? selectedCountry;
    if (selectedCity != null && user.profile?.myCountryId != null) {
      try {
        countries = await commonRepository.getCountry("${selectedCity.id}");
        if (countries.isNotEmpty) {
          var _country = countries
              .where((element) => user.profile?.myCountryId == element.id)
              .toList();
          if (_country.isNotEmpty) {
            selectedCountry = _country.first;
          }
        }
      } catch (err) {}
    }

    List<Country> workCountries = [];
    Country? selectedWorkCountry;
    if (selectedWorkCity != null && user.profile?.myWorkCountryId != null) {
      try {
        workCountries =
            await commonRepository.getCountry("${selectedWorkCity.id}");
        if (workCountries.isNotEmpty) {
          var _country = workCountries
              .where((element) => user.profile?.myWorkCountryId == element.id)
              .toList();
          if (_country.isNotEmpty) {
            selectedWorkCountry = _country.first;
          }
        }
      } catch (err) {}
    }

    emit(state.copyWith(
      page:initialPage,
      user: user,
      terms: terms,
      images: user.image,
      cities: cities,
      countries: countries,
      gender: user.customer?.gender,
      name: user.customer?.name,
      birth: user.customer?.birth,
      height:
          user.profile?.myHeight != null ? "${user.profile?.myHeight}" : null,
      heightStatus:heightStatus,
      city: selectedCity,
      country: selectedCountry,
      workCity: selectedWorkCity,
      workCountries: workCountries,
      workCounty: selectedWorkCountry,
      childrenMan: user.profile?.myChildrenMan != null
          ? "${user.profile?.myChildrenMan}"
          : null,
      childrenWomen: user.profile?.myChildrenWoman != null
          ? "${user.profile?.myChildrenWoman}"
          : null,
      academic: user.profile?.myAcademic,
      schoolName: user.profile?.mySchoolName,
      job: user.profile?.myJob,
      marriage: user.profile?.myMarriage,
      hasChildren: user.profile?.myChildren,
      religion: user.profile?.myReligion,
      agreeReligionTerm: user.customer?.religionAgree,
      status: ScreenStatus.success,
      nameStatus: nameStatus,
      schoolStatus: schoolStatus,
    ));
  }

  void prev() {
    var page = state.page;
    if (page != 0) {
      emit(state.copyWith(page: page - 1, isComplete: false));
    }
  }

  void next() async {
    var page = state.page;
    var result = false;
    var isComplete = false;
    try {
      if (state.page == 0) {
        result = await _saveBaseInfo();
      } else if (state.page == 1) {
        result = await _saveHeightInfo();
      } else if (state.page == 2) {
        result = await _saveRegionInfo();
      } else if (state.page == 3) {
        result = await _saveWorkRegionInfo();
      } else if (state.page == 4) {
        result = await _saveAcademicInfo();
      } else if (state.page == 5) {
        result = await _saveJobInfo();
      } else if (state.page == 6) {
        result = await _saveMarriageInfo();
      } else if (state.page == 7) {
        result = await _saveReligionInfo();
        isComplete = result;
      }
      if (result) {
        emit(state.copyWith(
          page: min(page + 1, 7),
          isComplete: isComplete,
          updateAt: DateTime.now(),
        ));
      }
    } catch (_) {}
  }

  // Enter Value =========================

  enterBaseInfo({Gender? gender, String? name, String? birth}) {
    NickNameFieldStatus nameStatus =
        Validator.nameNameValidator(name ?? state.name ?? "");

    emit(state.copyWith(
      gender: gender,
      name: name,
      nameStatus: nameStatus,
      birth: birth,
    ));
  }

  enterImage({UserImage? image}) {
    if (image != null) {
      emit(state.copyWith(images: image));
    }
  }

  enterHeightInfo({String? height}) {
    HeightFieldStatus heightStatus = HeightFieldStatus.initial;

    if ((height ?? "").isNotEmpty) {
      if (int.parse(height!) >= 120 && int.parse(height) <= 300) {
        heightStatus = HeightFieldStatus.success;
      } else {
        heightStatus = HeightFieldStatus.invalid;
      }
    }

    emit(state.copyWith(height: height,heightStatus:heightStatus));
  }

  enterRegionInfo({City? city, Country? country}) async {
    // 시티가 입력이 됐고, 기존꺼가 없는경우
    // 시티가 입력이 됐고, 기존꺼와 다른 경우
    List<Country>? countries;
    if (city != null &&
        (state.city == null ||
            (state.city != null && city.id != state.city!.id))) {
      countries = await commonRepository.getCountry("${city.id}");
    }

    emit(state.copyWith(
      city: city,
      country: country,
      countries: countries,
    ));
  }

  enterWorkRegionInfo({City? city, Country? country}) async {
    // 시티가 입력이 됐고, 기존꺼가 없는경우
    // 시티가 입력이 됐고, 기존꺼와 다른 경우
    List<Country>? countries;
    if (city != null &&
        (state.workCity == null ||
            (state.workCity != null && city.id != state.workCity!.id))) {
      countries = await commonRepository.getCountry("${city.id}");
    }

    emit(state.copyWith(
      workCity: city,
      workCounty: country,
      workCountries: countries,
    ));
  }

  enterAcademicInfo({AcademicType? academic, String? schoolName}) {
    SchoolFieldStatus schoolStatus =
        Validator.schoolValidator(schoolName ?? "");
    emit(state.copyWith(
      academic: academic,
      schoolName: schoolName,
      schoolStatus: schoolStatus,
    ));
  }

  enterJobInfo({JobType? job}) {
    emit(state.copyWith(job: job));
  }

  enterMarriageInfo({
    MarriageType? marriage,
    HasChildrenType? hasChildren,
    String? childrenMan,
    String? childrenWomen,
  }) {
    emit(state.copyWith(
      marriage: marriage,
      hasChildren: hasChildren,
      childrenMan: childrenMan,
      childrenWomen: childrenWomen,
    ));
  }

  enterReligionInfo({String? religion}) {
    emit(state.copyWith(religion: religion));
  }

  religionAgree() {
    try {
      var user = state.user.copyWith(
          customer: state.user.customer?.copyWith(religionAgree: true));
      emit(state.copyWith(user: user, agreeReligionTerm: true));
    } catch (_) {
      emit(state.copyWith(status: ScreenStatus.fail));
    }
  }

  enterImages() {}

// Save Value =========================
// 임시저장 느낌
//
  Future<bool> _saveBaseInfo() async {
    var user = state.user.copyWith(
        customer: state.user.customer?.copyWith(
          name: state.name,
          gender: state.gender,
          birth: state.birth,
        ),
        image: state.images);
    try {
      await userRepository.editCustomer(user.customer!);
      emit(state.copyWith(user: user));
      return true;
    } catch (_) {
      emit(state.copyWith(status: ScreenStatus.fail));
      return false;
    }
  }

  Future<bool> _saveHeightInfo() async {
    var user = state.user.copyWith(
      profile:
          state.user.profile?.copyWith(myHeight: int.parse(state.height ?? "")),
    );
    try {
      await userRepository.editProfile(user.profile!);
      emit(state.copyWith(user: user));
      return true;
    } catch (_) {
      emit(state.copyWith(status: ScreenStatus.fail));
      return false;
    }
  }

  Future<bool> _saveRegionInfo() async {
    var user = state.user.copyWith(
      profile: state.user.profile?.copyWith(
          myCityId: state.city!.id!, myCountryId: state.country!.id!),
    );
    try {
      await userRepository.editProfile(user.profile!);
      emit(state.copyWith(user: user));
      return true;
    } catch (_) {
      emit(state.copyWith(status: ScreenStatus.fail));
      return false;
    }
  }

  Future<bool> _saveWorkRegionInfo() async {
    var user = state.user.copyWith(
      profile: state.user.profile?.copyWith(
          myWorkCityId: state.workCity!.id!,
          myWorkCountryId: state.workCounty!.id!),
    );
    try {
      await userRepository.editProfile(user.profile!);
      emit(state.copyWith(user: user));
      return true;
    } catch (_) {
      emit(state.copyWith(status: ScreenStatus.fail));
      return false;
    }
  }

//
  Future<bool> _saveAcademicInfo() async {
    var user = state.user.copyWith(
      profile: state.user.profile?.copyWith(
        mySchoolName: state.schoolName,
        myAcademic: state.academic,
      ),
    );
    try {
      await userRepository.editProfile(user.profile!);
      emit(state.copyWith(user: user));
      return true;
    } catch (_) {
      emit(state.copyWith(status: ScreenStatus.fail));
      return false;
    }
  }

  Future<bool> _saveJobInfo() async {
    var user = state.user.copyWith(
      profile: state.user.profile?.copyWith(myJob: state.job),
    );
    try {
      await userRepository.editProfile(user.profile!);
      emit(state.copyWith(user: user));
      return true;
    } catch (_) {
      emit(state.copyWith(status: ScreenStatus.fail));
      return false;
    }
  }

  Future<bool> _saveMarriageInfo() async {
    var user = state.user.copyWith(
      profile: state.user.profile?.copyWith(
        myMarriage: state.marriage,
        myChildren: state.hasChildren,
        myChildrenMan: int.parse((state.childrenMan ?? "").isNotEmpty ? state.childrenMan! : "0"),
        myChildrenWoman: int.parse((state.childrenWomen ?? "").isNotEmpty ? state.childrenWomen! : "0"),
      ),
    );
    try {
      await userRepository.editProfile(user.profile!);
      emit(state.copyWith(user: user));
      return true;
    } catch (_) {
      emit(state.copyWith(status: ScreenStatus.fail));
      return false;
    }
  }

  Future<bool> _saveReligionInfo() async {
    var user = state.user.copyWith(
      profile: state.user.profile?.copyWith(myReligion: state.religion),
    );
    try {
      await userRepository.editProfile(user.profile!);
      emit(state.copyWith(user: user));
      return true;
    } catch (_) {
      emit(state.copyWith(status: ScreenStatus.fail));
      return false;
    }
  }
}
