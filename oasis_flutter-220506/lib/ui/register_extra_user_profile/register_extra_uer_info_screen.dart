import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:oasis/enum/screen_status.dart';
import 'package:oasis/model/common/hobby.dart';
import 'package:oasis/repository/common_repository.dart';
import 'package:oasis/repository/user_repository.dart';
import 'package:oasis/ui/common/base_scaffold.dart';
import 'package:oasis/ui/common/custom_icon.dart';
import 'package:oasis/ui/common/default_field.dart';
import 'package:oasis/ui/common/default_ignore_field.dart';
import 'package:oasis/ui/common/object_text_default_frame.dart';
import 'package:oasis/ui/common/radio_button_set.dart';
import 'package:oasis/ui/common/radio_value_set.dart';
import 'package:oasis/ui/common/showBottomSheet.dart';
import 'package:oasis/ui/register_partner/component/silbing_page.dart';

import '../theme.dart';
import 'cubit/register_extra_user_info_cubit.dart';
import 'cubit/register_extra_user_info_state.dart';

class RegisterExtraUserInfoScreen extends StatelessWidget {
  final Function onNext;
  final Function onPrev;

  RegisterExtraUserInfoScreen({
    required this.onNext,
    required this.onPrev,
  });
  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (BuildContext context) => RegisterExtraUserInfoCubit(
        userRepository: context.read<UserRepository>(),
        commonRepository: context.read<CommonRepository>(),
      )..initialize(),
      child:
          BlocListener<RegisterExtraUserInfoCubit, RegisterExtraUserInfoState>(
        listener: (context, state) async {
          if (state.status == ScreenStatus.success) {
            onNext();
          }
        },
        child:
            BlocBuilder<RegisterExtraUserInfoCubit, RegisterExtraUserInfoState>(
          builder: (context, state) {
            return BaseScaffold(
              resizeToAvoidBottomInset: true,
              title: "추가정보 입력",
              onBack: () {
                onPrev();
              },
              buttons: [
                BaseScaffoldDefaultButtonScheme(
                  title: "다음",
                  onTap: state.enableButton
                      ? () {
                          context.read<RegisterExtraUserInfoCubit>().update();
                        }
                      : null,
                ),
              ],
              body: Container(
                child: SingleChildScrollView(
                  child: Column(
                    children: [
                      _message(),
                      Container(
                        padding: EdgeInsets.symmetric(horizontal: 16),
                        child: Column(
                          children: [
                            ObjectTextDefaultFrame(
                              title: "부모관계",
                              body: DefaultIgnoreField(
                                hintMsg: "부모관계 선택",
                                initialValue: state.parent,
                                onTap: () async {
                                  var items = [
                                    "모두 계심",
                                    "모두 안계심",
                                    "부만 계심",
                                    "모만 계심"
                                  ];
                                  var parent = await showBottomOptionSheet(
                                      context,
                                      title: "부모관계",
                                      items: items,
                                      labels: items);
                                  if (parent != null) {
                                    context
                                        .read<RegisterExtraUserInfoCubit>()
                                        .enterValue(parent: parent);
                                  }
                                },
                              ),
                            ),
                            SizedBox(height: 20),
                            RegisterSiblingPage(),
                            SizedBox(height: 20),
                            ObjectTextDefaultFrame(
                              title: "취미선택",
                              body: DefaultIgnoreField(
                                hintMsg: "취미를 선택해주세요. (최대 5개)",
                                initialValue: state.selectedHobbies.isNotEmpty
                                    ? state.selectedHobbies
                                        .map((e) => e.name)
                                        .toList()
                                        .toString()
                                        .replaceAll("[", "")
                                        .replaceAll("]", "")
                                    : null,
                                onTap: () async {
                                  var hobbies =
                                      await showBottomMultipleOptionSheet(
                                          context,
                                          minChildSize: 0.8,
                                          title: "취미 선택",
                                          items: state.hobbies,
                                          labels: state.hobbies
                                              .map((e) => e.name ?? "")
                                              .toList(),
                                          initialValues: state.selectedHobbies);
                                  if (hobbies != null) {
                                    context
                                        .read<RegisterExtraUserInfoCubit>()
                                        .enterValue(
                                          selectedHobbies:
                                              (hobbies as List<dynamic>)
                                                  .map((e) => e as Hobby)
                                                  .toList(),
                                        );
                                  }
                                },
                              ),
                            ),
                            SizedBox(height: 20),
                            ObjectTextDefaultFrame(
                              title: "혈액형",
                              body: RadioValueSet(
                                initialValue: state.bloodType,
                                items: ["A형", "B형", "O형", "AB형"],
                                labels: ["A형", "B형", "O형", "AB형"],
                                onTap: (type) {
                                  context
                                      .read<RegisterExtraUserInfoCubit>()
                                      .enterValue(bloodType: type as String);
                                },
                              ),
                            ),
                            SizedBox(height: 20),
                            ObjectTextDefaultFrame(
                              title: "음주여부",
                              description: "음주여부를 선택해주세요.",
                              body: RadioButtonSet(
                                initialValue: state.drinkType,
                                items: ["마시지않음", "가끔 마심", "자주 마심"],
                                labels: ["마시지않음", "가끔 마심", "자주 마심"],
                                onTap: (type) {
                                  context
                                      .read<RegisterExtraUserInfoCubit>()
                                      .enterValue(drinkType: type as String);
                                },
                              ),
                            ),
                            SizedBox(height: 20),
                            ObjectTextDefaultFrame(
                              title: "흡연여부",
                              description: "흡연여부를 선택해주세요.",
                              body: RadioButtonSet(
                                initialValue: state.smoke == null
                                    ? null
                                    : (state.smoke! ? "흡연" : "비흡연"),
                                items: ["비흡연", "흡연"],
                                labels: ["비흡연", "흡연"],
                                onTap: (type) {
                                  context
                                      .read<RegisterExtraUserInfoCubit>()
                                      .enterValue(
                                        smoke: (type as String) == "흡연"
                                            ? true
                                            : false,
                                      );
                                },
                              ),
                            ),
                            SizedBox(height: 20),
                            ObjectTextDefaultFrame(
                              title: "자기소개 (매력・장점・인사말)",
                              body: DefaultField(
                                textLimit: 200,
                                maxLine: 4,
                                hintText: "최소 10자~최대200자",
                                onError: state.disabledMyself,
                                showCount: true,
                                guideText: state.disabledMyself
                                    ? "최소 10자 ~ 최대 200자"
                                    : "",
                                initialValue: state.introduceMySelf,
                                onChange: (text) {
                                  context
                                      .read<RegisterExtraUserInfoCubit>()
                                      .enterValue(introduceMySelf: text);
                                },
                              ),
                            ),
                            SizedBox(height: 20),
                            ObjectTextDefaultFrame(
                              title: "나의 업무 소개",
                              body: DefaultField(
                                hintText: "최소 10자~최대200자",
                                maxLine: 4,
                                textLimit: 200,
                                showCount: true,
                                onError: state.disabledMyWork,
                                guideText: state.disabledMyWork
                                    ? "최소 10자 ~ 최대 200자"
                                    : "",
                                initialValue: state.introduceMyWork,
                                onChange: (text) {
                                  context
                                      .read<RegisterExtraUserInfoCubit>()
                                      .enterValue(introduceMyWork: text);
                                },
                              ),
                            ),
                            SizedBox(height: 20),
                            ObjectTextDefaultFrame(
                              title: "나의 가족 소개",
                              body: DefaultField(
                                hintText: "최소 10자~최대200자",
                                showCount: true,
                                maxLine: 4,
                                textLimit: 200,
                                onError: state.disabledFamily,
                                guideText: state.disabledFamily
                                    ? "최소 10자 ~ 최대 200자"
                                    : "",
                                initialValue: state.introduceMyFamily,
                                onChange: (text) {
                                  context
                                      .read<RegisterExtraUserInfoCubit>()
                                      .enterValue(introduceMyFamily: text);
                                },
                              ),
                            ),
                            SizedBox(height: 20),
                            ObjectTextDefaultFrame(
                              title: "나만의 힐링법",
                              body: DefaultField(
                                hintText: "최소 10자~최대200자",
                                textLimit: 200,
                                maxLine: 4,
                                initialValue: state.myHealing,
                                onError: state.disabledMyHealing,
                                showCount: true,
                                guideText: state.disabledMyHealing
                                    ? "최소 10자 ~ 최대 200자"
                                    : "",
                                onChange: (text) {
                                  context
                                      .read<RegisterExtraUserInfoCubit>()
                                      .enterValue(myHealing: text);
                                },
                              ),
                            ),
                            SizedBox(height: 20),
                            ObjectTextDefaultFrame(
                              title: "미래 배우자에게 한마디",
                              body: DefaultField(
                                hintText: "최소 10자~최대200자",
                                showCount: true,
                                maxLine: 4,
                                textLimit: 200,
                                onError: state.disabledToPartner,
                                guideText: state.disabledToPartner
                                    ? "최소 10자 ~ 최대 200자"
                                    : "",
                                initialValue: state.toPartner,
                                onChange: (text) {
                                  context
                                      .read<RegisterExtraUserInfoCubit>()
                                      .enterValue(toPartner: text);
                                },
                              ),
                            ),
                            SizedBox(height: 10),
                          ],
                        ),
                      )
                    ],
                  ),
                ),
              ),
            );
          },
        ),
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

  _message() {
    return Container(
      margin: EdgeInsets.only(top: 20, bottom: 30, left: 16, right: 16),
      width: double.infinity,
      alignment: Alignment.centerLeft,
      padding: EdgeInsets.symmetric(horizontal: 20, vertical: 16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 8,
            offset: Offset(0, 2),
          ),
        ],
      ),
      child: Text(
        '추가 프로필은 가입 이후에도 작성이 가능하며, 내용입력은 선택사항입니다.\n※ 선택 정보를 기입할 시 본인이 원하는 이상형과의 매칭 확률이 올라갑니다.',
        style: body01.copyWith(color: gray700),
      ),
    );
  }
}
