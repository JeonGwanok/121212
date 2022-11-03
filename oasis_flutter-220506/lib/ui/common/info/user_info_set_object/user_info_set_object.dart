import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:oasis/enum/profile/academic_type.dart';
import 'package:oasis/enum/profile/job_type.dart';
import 'package:oasis/enum/profile/marriage_type.dart';
import 'package:oasis/model/user/certificate.dart';
import 'package:oasis/model/user/user_profile.dart';
import 'package:oasis/repository/common_repository.dart';
import 'package:oasis/ui/common/custom_icon.dart';
import 'package:oasis/ui/common/info_field.dart';

import '../../../theme.dart';
import 'cubit/user_info_set_object_cubit.dart';
import 'cubit/user_info_set_object_state.dart';

class UserInfoSetObject extends StatefulWidget {
  final UserProfile user;
  final Certificate certificate;

  const UserInfoSetObject({
    required this.user,
    required this.certificate,
  });

  @override
  _UserInfoSetState createState() => _UserInfoSetState();
}

class _UserInfoSetState extends State<UserInfoSetObject> {
  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (BuildContext context) => UserInfoSetObjectCubit(
          commonRepository: context.read<CommonRepository>(),
          myHobbies: widget.user.profile?.myHobby,
          cityId: widget.user.profile?.myCityId,
          countryId: widget.user.profile?.myCountryId)
        ..initialize(),
      child: BlocListener<UserInfoSetObjectCubit, UserInfoSetObjectState>(
        listener: (context, state) {},
        child: BlocBuilder<UserInfoSetObjectCubit, UserInfoSetObjectState>(
          builder: (context, state) {
            return Container(
              color: Colors.white,
              child: Column(
                children: [
                  _objectMargin(
                    InfoField(
                      title: "연애 MBTI",
                      titleWidth: 93,
                      value: widget.user.customer?.mbti ?? "--",
                    ),
                  ),
                  _objectMargin(
                    InfoField(
                      title: "사랑의 삼각형",
                      titleWidth: 93,
                      value: widget.user.customer?.loveType ?? "--",
                    ),
                  ),
                  _objectMargin(
                    InfoField(
                      title: "이름",
                      titleWidth: 93,
                      value: widget.user.customer?.name ?? "--",
                    ),
                  ),
                  _objectMargin(
                    InfoField(
                      title: "나이",
                      titleWidth: 93,
                      value: widget.user.customer?.age != null
                          ? "${widget.user.customer?.age}세"
                          : "--",
                    ),
                  ),
                  _objectMargin(
                    InfoField(
                      title: "키",
                      titleWidth: 93,
                      value: "${widget.user.profile?.myHeight ?? "--"}cm",
                    ),
                  ),
                  _objectMargin(
                    InfoField(
                        title: "거주지역",
                        titleWidth: 93,
                        value:
                            "${state.city != null ? "${state.city?.name}" : "--"} ${state.country != null ? "${state.country?.name}" : "--"}"),
                  ),
                  _verifiedObjectMargin(
                      InfoField(
                        title: "학력",
                        titleWidth: 93,
                        value:
                            "${widget.user.profile?.myAcademic != null ? "${(widget.user.profile?.myAcademic as AcademicType).title}" : "--"}/${widget.user.profile?.mySchoolName ?? "--"}",
                      ),
                      widget.certificate.graduationStatus),
                  _verifiedObjectMargin(
                      InfoField(
                        title: "직업",
                        titleWidth: 93,
                        value:
                            "${widget.user.profile?.myJob != null ? (widget.user.profile?.myJob as JobType).title : "--"}",
                      ),
                      widget.certificate.jobStatus),
                  _verifiedObjectMargin(
                      InfoField(
                        title: "혼인 여부",
                        titleWidth: 93,
                        value:
                            "${widget.user.profile?.myMarriage != null ? (widget.user.profile?.myMarriage as MarriageType).title : "--"}",
                      ),
                      widget.certificate.marriageStatus),
                  _objectMargin(
                    InfoField(
                      title: "자녀여부",
                      titleWidth: 93,
                      value:
                      "${widget.user.profile?.myChildren != null ? (widget.user.profile?.myChildren as HasChildrenType).title : "--"} ${widget.user.profile?.myChildren != null ? "${(widget.user.profile?.myChildrenMan ?? 0) == 0 ? "" : "${widget.user.profile?.myChildrenMan}남"} ${(widget.user.profile?.myChildrenWoman ?? 0) == 0 ? "" : "${widget.user.profile?.myChildrenWoman}녀"}" : ""}",
                    ),
                  ),
                  _objectMargin(
                    InfoField(
                      title: "종교",
                      titleWidth: 93,
                      value: "${widget.user.profile?.myReligion ?? "--"}",
                    ),
                  ),
                  _objectMargin(
                    InfoField(
                      title: "부모관계",
                      titleWidth: 93,
                      value: "${widget.user.profile?.myParents ?? "--"}",
                    ),
                  ),
                  _objectMargin(
                    InfoField(
                        title: "형제관계",
                        titleWidth: 93,
                        value:
                            "${(widget.user.profile?.mySiblings ?? false) ? "있음" : "없음"}"),
                  ),
                  _objectMargin(
                    InfoField(
                      title: "취미",
                      titleWidth: 93,
                      value:
                          "${state.hobbies.map((e) => e.name).toString().replaceAll("(", "").replaceAll(")", "")}",
                    ),
                  ),
                  _objectMargin(
                    InfoField(
                      title: "혈액형",
                      titleWidth: 93,
                      value: "${widget.user.profile?.myBloodType ?? "--"}",
                    ),
                  ),
                  _objectMargin(
                    InfoField(
                      title: "음주",
                      titleWidth: 93,
                      value: "${widget.user.profile?.myDrink ?? "--"}",
                    ),
                  ),
                  _objectMargin(
                    InfoField(
                      title: "흡연",
                      titleWidth: 93,
                      value:
                          "${widget.user.profile?.mySmoke != null ? (widget.user.profile!.mySmoke! ? "흡연" : "비흡연") : "--"}",
                    ),
                  ),
                ],
              ),
            );
          },
        ),
      ),
    );
  }

  _objectMargin(Widget child) {
    return Container(margin: EdgeInsets.symmetric(vertical: 4), child: child);
  }

  _verifiedObjectMargin(Widget child, CertificateStatusType status) {
    return Container(
      margin: EdgeInsets.symmetric(vertical: 4),
      child: Row(
        children: [
          Expanded(child: child),
          SizedBox(width: 12),
          Container(
            height: 36,
            width: 96,
            alignment: Alignment.center,
            decoration: BoxDecoration(
              color: lightMint,
              borderRadius: BorderRadius.circular(8),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  status.statusTitle,
                  style: body02.copyWith(color: mainMint),
                ),
                Container(
                  margin: EdgeInsets.only(left: 6),
                  child: CustomIcon(
                    path: "icons/lineCheck",
                    width: 20,
                    height: 20,
                  ),
                ),
              ],
            ),
          )
        ],
      ),
    );
  }
}
