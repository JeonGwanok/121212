import 'dart:core';

import 'package:equatable/equatable.dart';
import 'package:oasis/enum/profile/academic_type.dart';
import 'package:oasis/enum/profile/job_type.dart';
import 'package:oasis/enum/profile/marriage_type.dart';

class Profile extends Equatable {
  final int? id; // 0,
  final int? myHeight; // 0,my_height
  final AcademicType? myAcademic; // string,my_academic
  final String? mySchoolName; // string,my_school_name
  final JobType? myJob; // string,my_job
  final MarriageType? myMarriage; // string,my_marriage
  final HasChildrenType? myChildren; // true,my_children
  final int? myChildrenMan; // 0,my_children_man
  final int? myChildrenWoman; // 0,my_children_woman
  final String? myReligion; // string,my_religion
  final String? myParents; // string,my_parents
  final bool? mySiblings; // true,my_siblings
  final int? myBrotherNumber; // 0,my_brother_number
  final int? mySisterNumber; // 0,my_sister_number
  final int? mySiblingRank; // 0,my_sibling_rank
  final String? myHobby; // string,my_hobby
  final String? myBloodType; // string,my_blood_type
  final String? myDrink; // string,my_drink
  final bool? mySmoke; // true,my_smoke
  final String? myIntroduce; // string,my_introduce
  final String? myWorkIntro; // string,my_work_intro
  final String? myFamilyIntro; // string,my_family_intro
  final String? myHealing; // string,my_healing
  final String? myVoiceToLover; // string,my_voice_to_lover
  final int? loverAgeStart; // 0,lover_age_start
  final int? loverAgeEnd; // lover_age_end
  final int? loverHeightStart; // 0,lover_height_start
  final int? loverHeightEnd; // 0,lover_height_end
  final String? loverMarriage; // string,lover_marriage
  final bool? loverChildren; // true,lover_children
  final String? loverReligion; // string,lover_religion
  final String? loverAcademic; // string,lover_academic
  final int? myCityId; // 0,my_city_id
  final int? myCountryId; // 0,my_country_id
  final int? myWorkCityId; //"my_work_city_id": 0,
  final int? myWorkCountryId; //'"my_work_country_id": 0,
  final int? loverResidenceCity1Id; // 0,lover_residence_city1_id
  final int? loverResidenceCity2Id; // 0,lover_residence_city2_id
  final int? loverWorkCity1Id; // 0,lover_work_city1_id
  final int? loverWorkCity2Id; // 0,lover_work_city2_id
  final String? recommendCode; // recommend_code

  const Profile({
    this.id,
    this.myHeight,
    this.myAcademic,
    this.mySchoolName,
    this.myJob,
    this.myMarriage,
    this.myChildren,
    this.myChildrenMan,
    this.myChildrenWoman,
    this.myReligion,
    this.myParents,
    this.mySiblings,
    this.myBrotherNumber,
    this.mySisterNumber,
    this.mySiblingRank,
    this.myHobby,
    this.myBloodType,
    this.myDrink,
    this.mySmoke,
    this.loverAgeEnd,
    this.myIntroduce,
    this.myWorkIntro,
    this.myFamilyIntro,
    this.myHealing,
    this.myVoiceToLover,
    this.loverAgeStart,
    this.loverHeightStart,
    this.loverHeightEnd,
    this.loverMarriage,
    this.loverChildren,
    this.loverReligion,
    this.loverAcademic,
    this.myCityId,
    this.myCountryId,
    this.loverResidenceCity1Id,
    this.loverResidenceCity2Id,
    this.loverWorkCity1Id,
    this.loverWorkCity2Id,
    this.recommendCode,
    this.myWorkCityId,
    this.myWorkCountryId,
  });

  static const empty = Profile();

  factory Profile.fromJson(Map<String, dynamic> json) {
    return Profile(
      id: json["id"], // 0,
      myHeight: json["my_height"],
      myAcademic: json["my_academic"] != null
          ? academicStringToType(json["my_academic"])
          : null,
      mySchoolName: json["my_school_name"],
      myJob: json["my_job"] != null ? jobStringToType(json["my_job"]) : null,
      myMarriage: json["my_marriage"] != null
          ? marriageStringToType(json["my_marriage"])
          : null,
      myChildren: json["my_children"] != null
          ? hasChildrenStringToType(json["my_children"])
          : null,
      myChildrenMan: json["my_children_man"],
      myChildrenWoman: json["my_children_woman"],
      myReligion: json["my_religion"],
      myParents: json["my_parents"],
      mySiblings: json["my_siblings"],
      myBrotherNumber: json["my_brother_number"],
      mySisterNumber: json["my_sister_number"],
      mySiblingRank: json["my_sibling_rank"],
      myHobby: json["my_hobby"],
      myBloodType: json["my_blood_type"],
      myDrink: json["my_drink"],
      mySmoke: json["my_smoke"],
      loverAgeEnd: json["lover_age_end"],
      myIntroduce: json["my_introduce"],
      myWorkIntro: json["my_work_intro"],
      myFamilyIntro: json["my_family_intro"],
      myHealing: json["my_healing"],
      myVoiceToLover: json["my_voice_to_lover"],
      loverAgeStart: json["lover_age_start"],
      loverHeightStart: json["lover_height_start"],
      loverHeightEnd: json["lover_height_end"],
      loverMarriage: json["lover_marriage"],
      loverChildren: json["lover_children"],
      loverReligion: json["lover_religion"],
      loverAcademic: json["lover_academic"],
      myCityId: json["my_city_id"],
      myCountryId: json["my_country_id"],
      loverResidenceCity1Id: json["lover_residence_city1_id"],
      loverResidenceCity2Id: json["lover_residence_city2_id"],
      loverWorkCity1Id: json["lover_work_city1_id"],
      loverWorkCity2Id: json["lover_work_city2_id"],
      recommendCode: json["recommend_code"],
      myWorkCityId: json["my_work_city_id"],
      myWorkCountryId: json["my_work_country_id"],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      "id": id,
      "my_height": myHeight,
      "my_academic": myAcademic != null ? myAcademic!.title : null,
      "my_school_name": mySchoolName,
      "my_job": myJob != null ? myJob!.title : null,
      "my_marriage": myMarriage != null ? myMarriage!.title : null,
      "my_children": myChildren != null
          ? (myChildren == HasChildrenType.yes ? true : false)
          : null,
      "my_children_man": myChildrenMan,
      "my_children_woman": myChildrenWoman,
      "my_religion": myReligion,
      "my_parents": myParents,
      "lover_age_end": loverAgeEnd,
      "my_siblings": mySiblings,
      "my_brother_number": myBrotherNumber,
      "my_sister_number": mySisterNumber,
      "my_sibling_rank": mySiblingRank,
      "my_hobby": myHobby,
      "my_blood_type": myBloodType,
      "my_drink": myDrink,
      "my_smoke": mySmoke,
      "my_introduce": myIntroduce,
      "my_work_intro": myWorkIntro,
      "my_family_intro": myFamilyIntro,
      "my_healing": myHealing,
      "my_voice_to_lover": myVoiceToLover,
      "lover_age_start": loverAgeStart,
      "lover_height_start": loverHeightStart,
      "lover_height_end": loverHeightEnd,
      "lover_marriage": loverMarriage,
      "lover_children": loverChildren,
      "lover_religion": loverReligion,
      "lover_academic": loverAcademic,
      "my_city_id": myCityId,
      "my_country_id": myCountryId,
      "lover_residence_city1_id": loverResidenceCity1Id,
      "lover_residence_city2_id": loverResidenceCity2Id,
      "lover_work_city1_id": loverWorkCity1Id,
      "lover_work_city2_id": loverWorkCity2Id,
      "recommend_code": recommendCode,
      "my_work_city_id": myWorkCityId,
      "my_work_country_id": myWorkCountryId,
    };
  }

  Profile copyWith({
    int? id, // 0,
    int? myHeight, // 0,my_height
    AcademicType? myAcademic, // string,my_academic
    String? mySchoolName, // string,my_school_name
    JobType? myJob, // string,my_job
    MarriageType? myMarriage, // string,my_marriage
    HasChildrenType? myChildren, // true,my_children
    int? myChildrenMan, // 0,my_children_man
    int? myChildrenWoman, // 0,my_children_woman
    String? myReligion, // string,my_religion
    String? myParents, // string,my_parents
    bool? mySiblings, // true,my_siblings
    int? myBrotherNumber, // 0,my_brother_number
    int? mySisterNumber, // 0,my_sister_number
    int? mySiblingRank, // 0,my_sibling_rank
    int? loverAgeEnd,
    String? myHobby, // string,my_hobby
    String? myBloodType, // string,my_blood_type
    String? myDrink, // string,my_drink
    bool? mySmoke, // true,my_smoke
    String? myIntroduce, // string,my_introduce
    String? myWorkIntro, // string,my_work_intro
    String? myFamilyIntro, // string,my_family_intro
    String? myHealing, // string,my_healing
    String? myVoiceToLover, // string,my_voice_to_lover
    int? loverAgeStart, // 0,lover_age_start
    int? loverHeightStart, // 0,lover_height_start
    int? loverHeightEnd, // 0,lover_height_end
    String? loverMarriage, // string,lover_marriage
    bool? loverChildren, // true,lover_children
    String? loverReligion, // string,lover_religion
    String? loverAcademic, // string,lover_academic
    int? myCityId, // 0,my_city_id
    int? myCountryId, // 0,my_country_id
    int? loverResidenceCity1Id, // 0,lover_residence_city1_id
    int? loverResidenceCity2Id, // 0,lover_residence_city2_id
    int? loverWorkCity1Id, // 0,lover_work_city1_id
    int? loverWorkCity2Id, // 0,lover_work_city2_id
    String? recommendCode,
    int? myWorkCityId,
    int? myWorkCountryId,
  }) {
    return Profile(
      id: id ?? this.id,
      myHeight: myHeight ?? this.myHeight,
      myAcademic: myAcademic ?? this.myAcademic,
      mySchoolName: mySchoolName ?? this.mySchoolName,
      loverAgeEnd: loverAgeEnd ?? this.loverAgeEnd,
      myJob: myJob ?? this.myJob,
      myMarriage: myMarriage ?? this.myMarriage,
      myChildren: myChildren ?? this.myChildren,
      myChildrenMan: myChildrenMan ?? this.myChildrenMan,
      myChildrenWoman: myChildrenWoman ?? this.myChildrenWoman,
      myReligion: myReligion ?? this.myReligion,
      myParents: myParents ?? this.myParents,
      mySiblings: mySiblings ?? this.mySiblings,
      myBrotherNumber: myBrotherNumber ?? this.myBrotherNumber,
      mySisterNumber: mySisterNumber ?? this.mySisterNumber,
      mySiblingRank: mySiblingRank ?? this.mySiblingRank,
      myHobby: myHobby ?? this.myHobby,
      myBloodType: myBloodType ?? this.myBloodType,
      myDrink: myDrink ?? this.myDrink,
      mySmoke: mySmoke ?? this.mySmoke,
      myIntroduce: myIntroduce ?? this.myIntroduce,
      myWorkIntro: myWorkIntro ?? this.myWorkIntro,
      myFamilyIntro: myFamilyIntro ?? this.myFamilyIntro,
      myHealing: myHealing ?? this.myHealing,
      myVoiceToLover: myVoiceToLover ?? this.myVoiceToLover,
      loverAgeStart: loverAgeStart ?? this.loverAgeStart,
      loverHeightStart: loverHeightStart ?? this.loverHeightStart,
      loverHeightEnd: loverHeightEnd ?? this.loverHeightEnd,
      loverMarriage: loverMarriage ?? this.loverMarriage,
      loverChildren: loverChildren ?? this.loverChildren,
      loverReligion: loverReligion ?? this.loverReligion,
      loverAcademic: loverAcademic ?? this.loverAcademic,
      myCityId: myCityId ?? this.myCityId,
      myCountryId: myCountryId ?? this.myCountryId,
      loverResidenceCity1Id:
          loverResidenceCity1Id ?? this.loverResidenceCity1Id,
      loverResidenceCity2Id:
          loverResidenceCity2Id ?? this.loverResidenceCity2Id,
      loverWorkCity1Id: loverWorkCity1Id ?? this.loverWorkCity1Id,
      loverWorkCity2Id: loverWorkCity2Id ?? this.loverWorkCity2Id,
      recommendCode: recommendCode ?? this.recommendCode,
      myWorkCityId: myWorkCityId ?? this.myWorkCityId,
      myWorkCountryId: myWorkCountryId ?? this.myWorkCountryId,
    );
  }

  @override
  List<Object?> get props => [
        id,
        myHeight,
        myAcademic,
        mySchoolName,
        myJob,
        myMarriage,
        myChildren,
        myChildrenMan,
        myChildrenWoman,
        myReligion,
        myParents,
        mySiblings,
        myBrotherNumber,
        loverAgeEnd,
        mySisterNumber,
        mySiblingRank,
        myHobby,
        myBloodType,
        myDrink,
        mySmoke,
        myIntroduce,
        myWorkIntro,
        myFamilyIntro,
        myHealing,
        myVoiceToLover,
        loverAgeStart,
        loverHeightStart,
        loverHeightEnd,
        loverMarriage,
        loverChildren,
        loverReligion,
        loverAcademic,
        myCityId,
        myCountryId,
        loverResidenceCity1Id,
        loverResidenceCity2Id,
        loverWorkCity1Id,
        loverWorkCity2Id,
        recommendCode,
        myWorkCityId,
        myWorkCountryId,
      ];
}
