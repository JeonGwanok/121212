import 'dart:core';

import 'package:equatable/equatable.dart';
import 'package:oasis/enum/profile/academic_type.dart';
import 'package:oasis/enum/profile/job_type.dart';
import 'package:oasis/enum/profile/marriage_type.dart';
import 'package:oasis/enum/screen_status.dart';
import 'package:oasis/model/common/citys.dart';
import 'package:oasis/model/common/terms.dart';
import 'package:oasis/model/user/image/user_image.dart';
import 'package:oasis/model/user/user_profile.dart';
import 'package:oasis/ui/register_user_info/common/base_info/gender_select.dart';
import 'package:oasis/ui/sign/util/field_status.dart';

class RegisterUserInfoState extends Equatable {
  final ScreenStatus status;

  final Terms? terms;

  final UserProfile user;

  final Gender? gender;
  final String? name;
  final NickNameFieldStatus nameStatus;
  final String? birth;

  final String? height;
  final HeightFieldStatus? heightStatus;

  final List<City> cities;
  final List<Country> countries;
  final List<Country> workCountries;

  final City? city;
  final Country? country;

  final City? workCity;
  final Country? workCounty;

  final AcademicType? academic;
  final String? schoolName;
  final SchoolFieldStatus schoolStatus;

  final JobType? job;

  final MarriageType? marriage;
  final HasChildrenType? hasChildren;
  final String? childrenMan;
  final String? childrenWomen;

  final bool agreeReligionTerm;
  final String? religion;

  final bool isComplete;
  final DateTime? updateAt; // 네비게이터를 위함
  final int page;

  final UserImage images;

  RegisterUserInfoState({
    this.status = ScreenStatus.initial,
    this.user = UserProfile.empty,
    this.images = UserImage.empty,
    this.gender,
    this.name,
    this.nameStatus = NickNameFieldStatus.initial,
    this.birth,
    this.height,
    this.cities = const [],
    this.countries = const [],
    this.workCountries = const [],
    this.country,
    this.workCity,
    this.workCounty,
    this.childrenMan,
    this.childrenWomen,
    this.city,
    this.academic,
    this.schoolName,
    this.job,
    this.marriage,
    this.hasChildren,
    this.religion,
    this.page = 0,
    this.agreeReligionTerm = false,
    this.isComplete = false,
    this.updateAt,
    this.terms,
    this.schoolStatus = SchoolFieldStatus.initial,
    this.heightStatus = HeightFieldStatus.initial,
  });

  bool get isLast => page == 7;

  bool get enableButton {
    if (page == 0) {
      // 기본 정보
      return nameStatus == NickNameFieldStatus.success &&
          (birth ?? "").isNotEmpty &&
          (DateTime.now().year -
                  int.parse((birth ?? "2022").substring(0, 4)) +
                  1) >=
              20 &&
          gender != null &&
          (images.representative1 ?? "").isNotEmpty &&
          (images.representative2 ?? "").isNotEmpty;
    } else if (page == 1) {
      return heightStatus == HeightFieldStatus.success;
    } else if (page == 2) {
      return city != null && country != null;
    } else if (page == 3) {
      return workCity != null && workCounty != null;
    } else if (page == 4) {
      return academic != null &&
          schoolName != null &&
          schoolStatus == SchoolFieldStatus.success;
    } else if (page == 5) {
      return job != null;
    } else if (page == 6) {
      if (marriage == null) {
        return false;
      } else {
        if (marriage == MarriageType.married) {
          if (hasChildren == null) {
            return false;
          } else {
            if (hasChildren == HasChildrenType.yes) {
              var man = childrenMan ?? "";
              var woman = childrenWomen ?? "";
              if ((man.isEmpty && woman.isEmpty)) {
                return false;
              } else {
                return true;
              }
            } else {
              return true;
            }
          }
        } else {
          return true;
        }
      }
    } else if (page == 7) {
      return agreeReligionTerm && (religion ?? "").isNotEmpty;
    }

    return false;
  }

  RegisterUserInfoState copyWith({
    UserProfile? user,
    bool? isComplete,
    ScreenStatus? status,
    UserImage? images,
    Gender? gender,
    String? name,
    NickNameFieldStatus? nameStatus,
    String? birth,
    String? height,
    List<City>? cities,
    List<Country>? countries,
    List<Country>? workCountries,
    City? city,
    Country? country,
    String? childrenMan,
    String? childrenWomen,
    AcademicType? academic,
    String? schoolName,
    JobType? job,
    MarriageType? marriage,
    HasChildrenType? hasChildren,
    String? religion,
    int? page,
    DateTime? updateAt,
    bool? agreeReligionTerm,
    City? workCity,
    Country? workCounty,
    SchoolFieldStatus? schoolStatus,
    Terms? terms,
    HeightFieldStatus? heightStatus,
  }) {
    return RegisterUserInfoState(
      user: user ?? this.user,
      status: status ?? this.status,
      images: images ?? this.images,
      gender: gender ?? this.gender,
      name: name ?? this.name,
      birth: birth ?? this.birth,
      height: height ?? this.height,
      city: city ?? this.city,
      country: country ?? this.country,
      workCountries: workCountries ?? this.workCountries,
      workCity: workCity ?? this.workCity,
      workCounty: workCounty ?? this.workCounty,
      academic: academic ?? this.academic,
      schoolName: schoolName ?? this.schoolName,
      childrenMan: childrenMan ?? this.childrenMan,
      schoolStatus: schoolStatus ?? this.schoolStatus,
      childrenWomen: childrenWomen ?? this.childrenWomen,
      cities: cities ?? this.cities,
      countries: countries ?? this.countries,
      job: job ?? this.job,
      marriage: marriage ?? this.marriage,
      hasChildren: hasChildren ?? this.hasChildren,
      religion: religion ?? this.religion,
      page: page ?? this.page,
      isComplete: isComplete ?? this.isComplete,
      agreeReligionTerm: agreeReligionTerm ?? this.agreeReligionTerm,
      updateAt: updateAt ?? this.updateAt,
      nameStatus: nameStatus ?? this.nameStatus,
      terms: terms ?? this.terms,
      heightStatus: heightStatus ?? this.heightStatus,
    );
  }

  @override
  List<Object?> get props => [
        status,
        images,
        user,
        gender,
        cities,
        countries,
        workCountries,
        name,
        birth,
        height,
        city,
        country,
        academic,
        schoolName,
        job,
        childrenMan,
        childrenWomen,
        marriage,
        hasChildren,
        religion,
        page,
        workCounty,
        agreeReligionTerm,
        isComplete,
        updateAt,
        nameStatus,
        terms,
        schoolStatus,
        heightStatus,
      ];
}
