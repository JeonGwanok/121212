import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:oasis/bloc/app/app_bloc.dart';
import 'package:oasis/enum/screen_status.dart';
import 'package:oasis/model/common/citys.dart';
import 'package:oasis/repository/common_repository.dart';
import 'package:oasis/repository/user_repository.dart';
import 'package:oasis/ui/common/base_scaffold.dart';
import 'package:oasis/ui/common/custom_icon.dart';
import 'package:oasis/ui/common/default_dialog.dart';
import 'package:oasis/ui/common/default_ignore_field.dart';
import 'package:oasis/ui/common/default_small_button.dart';
import 'package:oasis/ui/common/object_text_default_frame.dart';
import 'package:oasis/ui/common/showBottomSheet.dart';
import 'package:oasis/ui/common/range_slider.dart';
import 'package:oasis/ui/my_page/my_partner_info/cubit/my_partner_info_cubit.dart';
import 'package:oasis/ui/my_page/my_partner_info/cubit/my_partner_info_state.dart';

import '../../theme.dart';

class RegisterPartnerInfoScreen extends StatelessWidget {
  BuildContext mainContext;
  RegisterPartnerInfoScreen(this.mainContext);
  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (BuildContext context) => MyPartnerInfoCubit(
        appBloc: mainContext.read<AppBloc>(),
        userRepository: context.read<UserRepository>(),
        commonRepository: context.read<CommonRepository>(),
      )..initialize(),
      child: BlocListener<MyPartnerInfoCubit, MyPartnerInfoState>(
        listener: (context, state) async {
          if (state.status == ScreenStatus.success) {
            DefaultDialog.show(
              context,
              defaultButtonTitle: "확인",
              title: "수정이 완료되었습니다.\n매칭 검색이 새롭게 진행됩니다.",
            );
          }
          if (state.status == ScreenStatus.fail) {
            DefaultDialog.show(
              context,
              defaultButtonTitle: "확인",
              title: "다시시도해주세요.",
            );
          }
        },
        listenWhen: (pre, cur) => pre.status != cur.status,
        child: BlocBuilder<MyPartnerInfoCubit, MyPartnerInfoState>(
          builder: (context, state) {
            return BaseScaffold(
              backgroundColor: backgroundColor,
              title: "",
              onBack: () {
                Navigator.pop(context);
              },
              body: state.status != ScreenStatus.initial
                  ? Container(
                      child: SingleChildScrollView(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: [
                            _description(context),
                            Container(
                              width: 77,
                              margin: EdgeInsets.only(right: 16),
                              child: DefaultSmallButton(
                                title: "수정하기",
                                reverse: true,
                                showShadow: true,
                                hideBorder: true,
                                onTap: () {
                                  context.read<MyPartnerInfoCubit>().update();
                                },
                              ),
                            ),
                            Container(
                              padding: EdgeInsets.symmetric(horizontal: 16),
                              child: Column(
                                children: [
                                  ObjectTextDefaultFrame(
                                    title: "거주기반지역",
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
                                              .read<MyPartnerInfoCubit>()
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
                                    title: "직장기반지역",
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
                                              .read<MyPartnerInfoCubit>()
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
                                    title: "나이",
                                    body: DefaultRangeSlider(
                                        onChange: (start, end) {
                                          context
                                              .read<MyPartnerInfoCubit>()
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
                                    title: "키",
                                    body: DefaultRangeSlider(
                                        onChange: (start, end) {
                                          context
                                              .read<MyPartnerInfoCubit>()
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
                                    title: "혼인 여부",
                                    body: DefaultIgnoreField(
                                      hintMsg: "이상형의 혼인 여부를 선택해주세요.",
                                      initialValue: state.marriage,
                                      onTap: () async {
                                        var items = ["관계없음", "미혼만", "재혼만"];
                                        var marriage =
                                            await showBottomOptionSheet(
                                          context,
                                          title: "혼인 여부",
                                          items: items,
                                          labels: items,
                                        );
                                        if (marriage != null) {
                                          context
                                              .read<MyPartnerInfoCubit>()
                                              .enterValue(marriage: marriage);
                                        }
                                      },
                                    ),
                                  ),
                                  SizedBox(height: 20),
                                  ObjectTextDefaultFrame(
                                    title: "자녀유무",
                                    body: DefaultIgnoreField(
                                      hintMsg: "이상형의 혼인 여부를 선택해주세요.",
                                      initialValue: state.children == null
                                          ? null
                                          : state.children!
                                              ? "관계없음"
                                              : "없어야함",
                                      onTap: () async {
                                        var items = ["관계없음", "없어야함"];
                                        var children =
                                            await showBottomOptionSheet(
                                          context,
                                          title: "자녀유무",
                                          minChildSize: 0.4,
                                          items: items,
                                          labels: items,
                                        );
                                        if (children != null) {
                                          context
                                              .read<MyPartnerInfoCubit>()
                                              .enterValue(
                                                  children: children == "관계없음"
                                                      ? true
                                                      : false);
                                        }
                                      },
                                    ),
                                  ),
                                  SizedBox(height: 20),
                                  ObjectTextDefaultFrame(
                                    title: "종교",
                                    body: DefaultIgnoreField(
                                      hintMsg: "이상형의 종교를 선택해주세요.",
                                      initialValue: state.religion,
                                      onTap: () async {
                                        var items = [
                                          "관계 없음",
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
                                          minChildSize: 0.6,
                                          items: items,
                                          labels: items,
                                        );
                                        if (religion != null) {
                                          context
                                              .read<MyPartnerInfoCubit>()
                                              .enterValue(religion: religion);
                                        }
                                      },
                                    ),
                                  ),
                                  SizedBox(height: 20),
                                  ObjectTextDefaultFrame(
                                    title: "학력",
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
                                                minChildSize: 0.6,
                                                items: items,
                                                labels: items);
                                        if (academic != null) {
                                          context
                                              .read<MyPartnerInfoCubit>()
                                              .enterValue(academic: academic);
                                        }
                                      },
                                    ),
                                  ),
                                  SizedBox(
                                      height: MediaQuery.of(context)
                                              .padding
                                              .bottom +
                                          10),
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

  _description(BuildContext context) {
    return Container(
      alignment: Alignment.centerLeft,
      padding: EdgeInsets.symmetric(horizontal: 16, vertical: 5),
      margin: EdgeInsets.only(bottom: 30, left: 16, right: 16),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: red400),
        color: Colors.white,
        boxShadow: cardShadow,
      ),
      child: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                CustomIcon(
                  path: "icons/alert",
                  color: Colors.red,
                ),
                SizedBox(width: 3),
                Text(
                  '주의해주세요!',
                  style: header02.copyWith(color: red500),
                ),
              ],
            ),
            SizedBox(height: 10),
            Text(
              '이상형 정보 수정이 진행되면 매칭이 새로 시작됩니다.\n매칭에 시간이 필요함으로 신중히 선택해 주시기 바랍니다.',
              style: body01.copyWith(color: gray600),
            ),
            SizedBox(height: 10),
          ],
        ),
      ),
    );
  }
}
