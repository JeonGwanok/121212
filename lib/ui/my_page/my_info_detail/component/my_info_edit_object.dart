import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:oasis/enum/profile/academic_type.dart';
import 'package:oasis/enum/profile/job_type.dart';
import 'package:oasis/enum/profile/marriage_type.dart';
import 'package:oasis/model/common/hobby.dart';
import 'package:oasis/model/user/certificate.dart';
import 'package:oasis/ui/common/custom_icon.dart';
import 'package:oasis/ui/common/info_field.dart';
import 'package:oasis/ui/common/showBottomSheet.dart';
import 'package:oasis/ui/my_page/my_info_detail/cubit/my_info_detail_cubit.dart';
import 'package:oasis/ui/my_page/my_info_detail/cubit/my_info_detail_state.dart';

import '../../../theme.dart';

class MyInfoEditObject extends StatefulWidget {
  @override
  _MyInfoEditObjectState createState() => _MyInfoEditObjectState();
}

class _MyInfoEditObjectState extends State<MyInfoEditObject> {
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<MyInfoDetailCubit, MyInfoDetailState>(
      builder: (context, state) {
        return Container(
          color: Colors.white,
          child: Column(
            children: [
              _objectMargin(
                InfoField(
                  title: "휴대폰 번호",
                  titleWidth: 90,
                  enabled: false,
                  value: (state.userProfile.customer?.username ?? "입력안함").replaceAllMapped(
                      RegExp(r'(\d{3})(\d{4})(\d+)'), (m) => "${m[1]}-${m[2]}-${m[3]}"),
                ),
              ),
              _objectMargin(
                InfoField(
                  title: "이메일 주소",
                  titleWidth: 90,
                  enabled: false,
                  value: state.userProfile.customer?.email ?? "입력안함",
                ),
              ),
              _objectMargin(
                InfoField(
                  title: "별명 (닉네임)",
                  titleWidth: 90,
                  enabled: false,
                  value: state.userProfile.customer?.nickName ?? "입력안함",
                ),
              ),
              _objectMargin(
                InfoField(
                  title: "추천인 코드",
                  titleWidth: 90,
                  enabled: false,
                  value: state.userProfile.customer?.recommandCode ?? "입력안함",
                ),
              ),
              _objectMargin(
                InfoField(
                  title: "연애 MBTI",
                  titleWidth: 90,
                  enabled: false,
                  value: state.userProfile.customer?.mbti ?? "입력안함",
                ),
              ),
              _objectMargin(
                InfoField(
                  title: "사랑의 삼각형",
                  titleWidth: 90,
                  enabled: false,
                  value: state.userProfile.customer?.loveType ?? "입력안함",
                ),
              ),
              _objectMargin(
                InfoField(
                  title: "이름",
                  titleWidth: 90,
                  enabled: false,
                  value: state.userProfile.customer?.name ?? "입력안함",
                ),
              ),
              _objectMargin(
                InfoField(
                  title: "나이",
                  titleWidth: 90,
                  enabled: false,
                  value: state.userProfile.customer?.age != null
                      ? "${state.userProfile.customer?.age}세"
                      : "입력안함",
                ),
              ),
              _objectMargin(
                InfoField(
                  title: "키",
                  titleWidth: 90,
                  enabled: false,
                  value: "${state.userProfile.profile?.myHeight ?? "입력안함"}cm",
                ),
              ),
              _objectMargin(
                InfoField(
                  title: "거주지역",
                  titleWidth: 90,
                  enabled: false,
                  value: state.region ?? "입력안함",
                ),
              ),
              _verifiedObjectMargin(
                  InfoField(
                    title: "학력",
                    titleWidth: 90,
                    enabled: false,
                    value:
                        "${state.userProfile.profile?.myAcademic != null ? "${(state.userProfile.profile?.myAcademic as AcademicType).title}" : "입력안함"}/${state.userProfile.profile?.mySchoolName ?? "입력안함"}",
                  ),
                  state.certificate.graduationStatus),
              _verifiedObjectMargin(
                  InfoField(
                    title: "직업",
                    titleWidth: 90,
                    enabled: false,
                    value:
                        "${state.userProfile.profile?.myJob != null ? (state.userProfile.profile?.myJob as JobType).title : "입력안함"}",
                  ),
                  state.certificate.jobStatus),
              _verifiedObjectMargin(
                  InfoField(
                    title: "혼인 여부",
                    titleWidth: 90,
                    enabled: false,
                    value:
                        "${state.userProfile.profile?.myMarriage != null ? (state.userProfile.profile?.myMarriage as MarriageType).title : "입력안함"}",
                  ),
                  state.certificate.marriageStatus),
              _objectMargin(
                InfoField(
                  title: "자녀여부",
                  titleWidth: 90,
                  enabled: false,
                  value:
                      "${state.userProfile.profile?.myChildren != null ? (state.userProfile.profile?.myChildren as HasChildrenType).title : "입력안함"} ${state.userProfile.profile?.myChildren != null ? "${(state.userProfile.profile?.myChildrenMan ?? 0) == 0 ? "" : "${state.userProfile.profile?.myChildrenMan}남"} ${(state.userProfile.profile?.myChildrenWoman ?? 0) == 0 ? "" : "${state.userProfile.profile?.myChildrenWoman}녀"}" : ""}",
                ),
              ),
              SizedBox(height: 24),
              _objectMargin(
                InfoField(
                  title: "종교",
                  titleWidth: 90,
                  enabled: false,
                  value: "${state.userProfile.profile?.myReligion ?? "입력안함"}",
                ),
              ),
              _objectMargin(
                InfoField(
                  title: "부모관계",
                  titleWidth: 90,
                  enabled: false,
                  value: "${state.userProfile.profile?.myParents ?? "입력안함"}",
                ),
              ),
              _objectMargin(
                InfoField(
                    title: "형제관계",
                    titleWidth: 90,
                    enabled: false,
                    value:
                        "${(state.userProfile.profile?.mySiblings ?? false) ? "있음" : "없음"}"),
              ),
              _objectMargin(
                InfoField(
                  title: "취미",
                  titleWidth: 90,
                  onTap: () async {
                    var hobbies = await showBottomMultipleOptionSheet(context,
                        minChildSize: 0.8,
                        title: "취미 선택",
                        items: state.hobbies,
                        labels: state.hobbies.map((e) => e.name ?? "").toList(),
                        initialValues: state.selectedHobbies);
                    if (hobbies != null) {
                      context.read<MyInfoDetailCubit>().changeHobby(
                            (hobbies as List<dynamic>)
                                .map((e) => e as Hobby)
                                .toList(),
                          );
                    }
                  },
                  value: state.selectedHobbies
                      .map((e) => e.name)
                      .toString()
                      .replaceAll("(", "")
                      .replaceAll(")", ""),
                ),
              ),
              _objectMargin(
                InfoField(
                  title: "혈액형",
                  titleWidth: 90,
                  enabled: false,
                  value: "${state.userProfile.profile?.myBloodType ?? "입력안함"}",
                ),
              ),
              _objectMargin(
                InfoField(
                  title: "음주",
                  titleWidth: 90,
                  onTap: () async {
                    var items = ["마시지않음", "가끔 마심", "자주 마심"];
                    var drink = await showBottomOptionSheet(
                      context,
                      title: "음주",
                      items: items,
                      labels: items,
                      
                    );
                    if (drink != null) {
                      context.read<MyInfoDetailCubit>().changeDrink(drink);
                    }
                  },
                  value: "${state.myDrink} ",
                ),
              ),
              _objectMargin(
                InfoField(
                  title: "흡연",
                  titleWidth: 90,
                  onTap: () async {
                    var items = ["흡연", "비흡연"];
                    var smoke = await showBottomOptionSheet(
                      context,
                      title: "흡연",
                      items: items,
                      labels: items,
                    );
                    if (smoke != null) {
                      context
                          .read<MyInfoDetailCubit>()
                          .changeSmoke(smoke == "흡연" ? true : false);
                    }
                  },
                  value: "${state.mySmoke ? "흡연" : "비흡연"}",
                ),
              ),
            ],
          ),
        );
      },
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

  List<dynamic>? tempValues;
  showBottomMultipleOptionSheet<T>(
    context, {
    required List<T> initialValues,
    required String title,
    required List<T> items,
    required List<String> labels,
    double maxChildSize = 0.8,
    double minChildSize = 0.4,
  }) async {
    List<T>? values = [...initialValues];
    tempValues = [...initialValues];
    await showModalBottomSheet(
      isScrollControlled: true,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(
          top: Radius.circular(15.0),
        ),
      ),
      context: context,
      builder: (context) {
        return StatefulBuilder(
          builder: (BuildContext context, StateSetter setState) {
            return DraggableScrollableSheet(
              initialChildSize: minChildSize,
              expand: false,
              minChildSize: minChildSize,
              maxChildSize: maxChildSize,
              builder:
                  (BuildContext context, ScrollController scrollController) {
                return Column(
                  children: <Widget>[
                    Container(
                      margin: EdgeInsets.symmetric(vertical: 8),
                      width: 40,
                      height: 5,
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(100),
                          color: gray200),
                    ),
                    Container(
                      height: 72,
                      padding: EdgeInsets.symmetric(horizontal: 20),
                      alignment: Alignment.center,
                      decoration: BoxDecoration(
                        border: Border(bottom: BorderSide(color: gray100)),
                      ),
                      child: Text(
                        title,
                        style: header05,
                      ),
                    ),
                    Expanded(
                      child: ListView.separated(
                        itemCount: items.length,
                        separatorBuilder: (context, int) {
                          return Container();
                        },
                        itemBuilder: (context, index) {
                          return GestureDetector(
                            onTap: () {
                              if (values.contains(items[index])) {
                                values.remove(items[index]);
                                setState(() {
                                  (tempValues ?? []).remove(items[index]);
                                });
                              } else {
                                if (values.length < 5) {
                                  values.add(items[index]);
                                  setState(() {
                                    (tempValues ?? []).add(items[index]);
                                  });
                                } else {
                                  values.removeAt(4);
                                  values.add(items[index]);
                                  setState(() {
                                    (tempValues ?? []).removeAt(4);
                                    (tempValues ?? []).add(items[index]);
                                  });
                                }
                              }

                              if (values.length == 5) {
                                Navigator.pop(context);
                              }
                            },
                            child: Container(
                              height: 56,
                              padding: EdgeInsets.symmetric(horizontal: 20),
                              width: double.infinity,
                              color: Colors.white.withOpacity(0),
                              child: Container(
                                alignment: Alignment.centerLeft,
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text(
                                      labels[index],
                                      style: header04.copyWith(
                                        color: (tempValues ?? [])
                                                .contains(items[index])
                                            ? mainMint
                                            : Colors.black,
                                      ),
                                    ),
                                    (tempValues ?? []).contains(items[index])
                                        ? CustomIcon(
                                            path: "icons/lineCheck",
                                            width: 20,
                                            height: 20,
                                          )
                                        : Container()
                                  ],
                                ),
                              ),
                            ),
                          );
                        },
                      ),
                    ),
                  ],
                );
              },
            );
          },
        );
      },
    );
    return tempValues;
  }
}
