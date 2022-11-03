import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:oasis/enum/screen_status.dart';
import 'package:oasis/model/common/citys.dart';
import 'package:oasis/repository/common_repository.dart';
import 'package:oasis/repository/user_repository.dart';
import 'package:oasis/ui/common/base_scaffold.dart';
import 'package:oasis/ui/common/custom_icon.dart';
import 'package:oasis/ui/common/default_ignore_field.dart';
import 'package:oasis/ui/common/object_text_default_frame.dart';
import 'package:oasis/ui/common/radio_button_set.dart';
import 'package:oasis/ui/common/showBottomSheet.dart';
import 'package:oasis/ui/common/range_slider.dart';

import '../theme.dart';
import 'cubit/register_partner_info_cubit.dart';
import 'cubit/register_partner_info_state.dart';

class RegisterPartnerInfoScreen extends StatelessWidget {
  final Function onNext;
  final Function onPrev;

  RegisterPartnerInfoScreen({
    required this.onNext,
    required this.onPrev,
  });

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (BuildContext context) => RegisterPartnerInfoCubit(
        userRepository: context.read<UserRepository>(),
        commonRepository: context.read<CommonRepository>(),
      )..initialize(),
      child: BlocListener<RegisterPartnerInfoCubit, RegisterPartnerInfoState>(
        listener: (context, state) async {
          if (state.status == ScreenStatus.success) {
            onNext();
          }
        },
        child: BlocBuilder<RegisterPartnerInfoCubit, RegisterPartnerInfoState>(
          builder: (context, state) {
            return BaseScaffold(
              title: "이상형 입력",
              onBack: () {
                onPrev();
              },
              buttons: [
                BaseScaffoldDefaultButtonScheme(
                  title: "다음",
                  onTap: state.enable
                      ? () {
                          context.read<RegisterPartnerInfoCubit>().update();
                        }
                      : null,
                )
              ],
              body: state.status != ScreenStatus.initial
                  ? Container(
                      child: SingleChildScrollView(
                        child: Column(
                          children: [
                            _message(),
                            Container(
                              padding: EdgeInsets.symmetric(horizontal: 16),
                              child: Column(
                                children: [
                                  ObjectTextDefaultFrame(
                                    title: "* 거주기반지역",
                                    body: DefaultIgnoreField(
                                      hintMsg: "지역선택 1 (최대 2곳 선택 가능)",
                                      initialValue:
                                          state.selectedCities.isNotEmpty
                                              ? state.selectedCities
                                                  .map((e) => e.name)
                                                  .toList()
                                                  .toString()
                                                  .replaceAll("[", "")
                                                  .replaceAll("]", "")
                                              : null,
                                      onTap: () async {
                                        var citys =
                                            await showBottomMultipleOptionSheet(
                                                context,
                                                title: "거주기반지역 ",
                                                optionDescription:
                                                    "(최대 2곳 선택 가능)",
                                                minChildSize: 0.8,
                                                items: state.cities,
                                                labels: state.cities
                                                    .map((e) => e.name ?? "")
                                                    .toList(),
                                                initialValues:
                                                    state.selectedCities);
                                        if (citys != null) {
                                          context
                                              .read<RegisterPartnerInfoCubit>()
                                              .enterValue(
                                                  selectedCities:
                                                      (citys as List<dynamic>)
                                                          .map((e) => e as City)
                                                          .toList());
                                        }
                                      },
                                    ),
                                  ),
                                  SizedBox(height: 20),
                                  ObjectTextDefaultFrame(
                                    title: "* 직장기반지역",
                                    body: DefaultIgnoreField(
                                      hintMsg: "지역선택 2 (최대 2곳 선택 가능)",
                                      initialValue:
                                          state.selectedOfficeCities.isNotEmpty
                                              ? state.selectedOfficeCities
                                                  .map((e) => e.name)
                                                  .toList()
                                                  .toString()
                                                  .replaceAll("[", "")
                                                  .replaceAll("]", "")
                                              : null,
                                      onTap: () async {
                                        var citys =
                                            await showBottomMultipleOptionSheet(
                                                context,
                                                title: "직장기반지역 ",
                                                optionDescription:
                                                    "(최대 2곳 선택 가능)",
                                                minChildSize: 0.8,
                                                items: state.cities,
                                                labels: state.cities
                                                    .map((e) => e.name ?? "")
                                                    .toList(),
                                                initialValues:
                                                    state.selectedOfficeCities);
                                        if (citys != null) {
                                          context
                                              .read<RegisterPartnerInfoCubit>()
                                              .enterValue(
                                                  selectedOfficeCities:
                                                      (citys as List<dynamic>)
                                                          .map((e) => e as City)
                                                          .toList());
                                        }
                                      },
                                    ),
                                  ),
                                  SizedBox(height: 20),
                                  ObjectTextDefaultFrame(
                                    title: "* 나이",
                                    body: DefaultRangeSlider(
                                        onChange: (start, end) {
                                          context
                                              .read<RegisterPartnerInfoCubit>()
                                              .enterValue(
                                                  startAge: start, endAge: end);
                                        },
                                        max: 70,
                                        min: 20,
                                        unit: "세",
                                        divisions: 50,
                                        labelDivision: 10,
                                        initialStartValue: state.startAge * 1.0,
                                        initialEndValue: state.endAge * 1.0),
                                  ),
                                  SizedBox(height: 20),
                                  ObjectTextDefaultFrame(
                                    title: "* 키",
                                    body: DefaultRangeSlider(
                                        onChange: (start, end) {
                                          context
                                              .read<RegisterPartnerInfoCubit>()
                                              .enterValue(
                                                  startHeight: start,
                                                  endHeight: end);
                                        },
                                        max: 200,
                                        min: 120,
                                        unit: "cm",
                                        divisions: 80,
                                        labelDivision: 10,
                                        initialStartValue:
                                            state.startHeight * 1.0,
                                        initialEndValue: state.endHeight * 1.0),
                                  ),
                                  SizedBox(height: 20),
                                  ObjectTextDefaultFrame(
                                    title: "* 혼인 여부",
                                    description: "이상형의 혼인 여부를 선택해주세요.",
                                    body: RadioButtonSet(
                                        initialValue: state.marriage,
                                        items: ["관계없음", "미혼만", "재혼만"],
                                        labels: ["관계없음", "미혼만", "재혼만"],
                                        onTap: (type) {
                                          context
                                              .read<RegisterPartnerInfoCubit>()
                                              .enterValue(
                                                  marriage: type as String);
                                        }),
                                  ),
                                  SizedBox(height: 20),
                                  ObjectTextDefaultFrame(
                                    title: "* 자녀유무",
                                    description: "이상형의 자녀여부를 선택해주세요.",
                                    body: RadioButtonSet(
                                      initialValue: state.children == null
                                          ? null
                                          : state.children!
                                              ? "관계없음"
                                              : "없어야함",
                                      items: ["관계없음", "없어야함"],
                                      labels: ["관계없음", "없어야함"],
                                      onTap: (type) {
                                        context
                                            .read<RegisterPartnerInfoCubit>()
                                            .enterValue(
                                                children:
                                                    (type as String) == "관계없음"
                                                        ? true
                                                        : false);
                                      },
                                    ),
                                  ),
                                  SizedBox(height: 20),
                                  ObjectTextDefaultFrame(
                                    title: "* 종교",
                                    body: DefaultIgnoreField(
                                      hintMsg: "이상형의 종교를 선택해주세요.",
                                      initialValue: state.religion,
                                      onTap: () async {
                                        var items = [
                                          "관계없음",
                                          "무교",
                                          "기독교",
                                          "불교",
                                          "천주교",
                                          "기타"
                                        ];
                                        var religion =
                                            await showBottomOptionSheet(
                                          context,
                                          title: "종교",
                                          items: items,
                                          labels: items,
                                        );
                                        if (religion != null) {
                                          context
                                              .read<RegisterPartnerInfoCubit>()
                                              .enterValue(religion: religion);
                                        }
                                      },
                                    ),
                                  ),
                                  SizedBox(height: 20),
                                  ObjectTextDefaultFrame(
                                    title: "* 학력",
                                    body: DefaultIgnoreField(
                                      hintMsg: "이상형의 학력를 선택해주세요.",
                                      initialValue: state.academic,
                                      onTap: () async {
                                        var items = [
                                          "관계 없음",
                                          "고졸 이상",
                                          "대학 졸업 이상",
                                          "대학원 졸업 이상",
                                          "박사 이상"
                                        ];
                                        var academic =
                                            await showBottomOptionSheet(context,
                                                title: "학력",
                                                items: items,
                                                labels: items);
                                        if (academic != null) {
                                          context
                                              .read<RegisterPartnerInfoCubit>()
                                              .enterValue(academic: academic);
                                        }
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
                    )
                  : Container(),
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
    String? optionDescription,
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
                          border: Border(bottom: BorderSide(color: gray100))),
                      child: Row(mainAxisSize: MainAxisSize.min, children: [
                        Text(
                          title,
                          style: header05,
                        ),
                        Text(
                          optionDescription ?? "",
                          style: header05.copyWith(color: mainMint),
                        ),
                      ]),
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
                                if (values.length < 2) {
                                  values.add(items[index]);
                                  setState(() {
                                    (tempValues ?? []).add(items[index]);
                                  });
                                } else {
                                  values.removeAt(1);
                                  values.add(items[index]);
                                  setState(() {
                                    (tempValues ?? []).removeAt(1);
                                    (tempValues ?? []).add(items[index]);
                                  });
                                }
                              }

                              if (values.length == 2) {
                                Navigator.pop(context);
                              }
                            },
                            child: Container(
                              color: Colors.white,
                              height: 54,
                              padding: EdgeInsets.symmetric(horizontal: 16),
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
                                            : Colors.black),
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
      padding: EdgeInsets.symmetric(horizontal: 16),
      height: 78,
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
        '상대방 최소 조건 항목은 필수입력사항으로 빠짐없이 신중히 입력해주시기 바랍니다. AI매니저가 이상형 정보를 바탕으로 매칭을 추천드립니다.',
        style: body01.copyWith(color: gray700),
      ),
    );
  }
}
