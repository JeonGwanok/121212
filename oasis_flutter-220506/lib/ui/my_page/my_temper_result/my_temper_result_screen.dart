import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:oasis/enum/screen_status.dart';
import 'package:oasis/repository/common_repository.dart';
import 'package:oasis/repository/user_repository.dart';
import 'package:oasis/ui/common/base_scaffold.dart';
import 'package:oasis/ui/common/chart/octagon.dart';
import 'package:oasis/ui/common/chart/triangle_chart.dart';
import 'package:oasis/ui/common/custom_icon.dart';
import 'package:oasis/ui/common/default_dialog.dart';
import 'package:oasis/ui/common/default_field.dart';
import 'package:oasis/ui/common/default_small_button.dart';
import 'package:oasis/ui/common/illust.dart';
import 'package:oasis/ui/common/info_field.dart';
import 'package:oasis/ui/common/showBottomSheet.dart';
import 'package:oasis/ui/my_page/my_temper_result/cubit/my_temper_result_state.dart';
import 'package:oasis/ui/util/bold_generator.dart';
import 'package:provider/provider.dart';

import '../../theme.dart';
import 'cubit/my_temper_result_cubit.dart';

enum TemperResultType { mbti, temperament }

extension TemperResultTypeExtension on TemperResultType {
  String get title {
    switch (this) {
      case TemperResultType.mbti:
        return "내 연애  MBTI";
      case TemperResultType.temperament:
        return "내 사랑의 삼각형";
    }
  }
}

class TemperResultScreen extends StatefulWidget {
  @override
  _TemperResultScreenState createState() => _TemperResultScreenState();
}

class _TemperResultScreenState extends State<TemperResultScreen> {
  TemperResultType type = TemperResultType.mbti;
  late PageController pageController;
  @override
  void initState() {
    pageController = PageController(initialPage: 0, viewportFraction: 0.7);
    pageController
      ..addListener(() {
        if (pageController.page!.round() == 0) {
          if (type != TemperResultType.mbti) {
            setState(() {
              type = TemperResultType.mbti;
            });
          }
        }

        if (pageController.page!.round() == 1) {
          if (type != TemperResultType.temperament) {
            setState(() {
              type = TemperResultType.temperament;
            });
          }
        }
      });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    var widthRatio = MediaQuery.of(context).size.width / 414;
    return BlocProvider(
      create: (BuildContext context) => TemperResultCubit(
        userRepository: context.read<UserRepository>(),
        commonRepository: context.read<CommonRepository>(),
      )..initialize(),
      child: BlocListener<TemperResultCubit, TemperResultState>(
        listener: (context, state) {},
        child: BlocBuilder<TemperResultCubit, TemperResultState>(
            builder: (context, state) {
          var text = "결심/헌심";
          var test = [
            (state.mbtiMain.responsibilityValue ?? 0),
            (state.mbtiMain.dedicationValue ?? 0),
            (state.mbtiMain.passionValue ?? 0)
          ];

          if (test[0] >= test[1] && test[0] >= test[2]) {
            text = "책임감";
          }

          if (test[1] >= test[0] && test[1] >= test[2]) {
            text = "결심/헌신";
          }

          if (test[2] >= test[0] && test[2] >= test[1]) {
            text = "열정";
          }

          return BaseScaffold(
            title: "",
            onBack: () {
              Navigator.pop(context);
            },
            backgroundColor: gray50,
            onLoading: state.status == ScreenStatus.loading,
            showAppbarUnderline: false,
            body: Container(
              padding: EdgeInsets.symmetric(horizontal: 16),
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    Row(
                      children: [
                        _button(TemperResultType.mbti),
                        SizedBox(width: 24),
                        _button(TemperResultType.temperament)
                      ],
                    ),
                    Container(
                      height: 240,
                      child: Stack(
                        alignment: Alignment.centerRight,
                        children: [
                          Positioned(
                            left: 120,
                            child: Container(
                              child: CustomIcon(
                                path: "icons/main_ring",
                                type: "png",
                                width: MediaQuery.of(context).size.width - 32,
                                height: 240,
                              ),
                            ),
                          ),
                          Stack(
                            alignment: Alignment.topRight,
                            children: [
                              Stack(
                                children: <Widget>[
                                  Text(
                                    type != TemperResultType.temperament
                                        ? state.user.customer?.mbti ?? ""
                                        : text,
                                    style: TextStyle(
                                      fontFamily: "Godo",
                                      letterSpacing: 5,
                                      fontSize: 58 * widthRatio,
                                      fontWeight: FontWeight.bold,
                                      foreground: Paint()
                                        ..style = PaintingStyle.stroke
                                        ..strokeWidth = 2
                                        ..color = gray200, // <-- Border color
                                    ),
                                  ),
                                  Text(
                                    type != TemperResultType.temperament
                                        ? state.user.customer?.mbti ?? ""
                                        : text,
                                    style: TextStyle(
                                      fontFamily: "Godo",
                                      letterSpacing: 5,
                                      fontSize: 58 * widthRatio,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.white, // <-- Inner color
                                    ),
                                  ),
                                ],
                              ),
                              PageView(
                                controller: pageController,
                                children: [
                                  Opacity(
                                    opacity:
                                        type != TemperResultType.mbti ? 0.4 : 1,
                                    child: Container(
                                      alignment: Alignment.centerLeft,
                                      child: Container(
                                        width: type != TemperResultType.mbti
                                            ? 105
                                            : 170,
                                        height: type != TemperResultType.mbti
                                            ? 105
                                            : 170,
                                        child: CustomPaint(
                                          painter: OctagonChart(
                                            mbtiMain: state.mbtiMain,
                                            mbti:
                                                state.user.customer?.mbti ?? "",
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                  Opacity(
                                    opacity:
                                        type == TemperResultType.mbti ? 0.4 : 1,
                                    child: Container(
                                      margin: EdgeInsets.only(left: 20),
                                      alignment: Alignment.centerLeft,
                                      child: Container(
                                        width: type == TemperResultType.mbti
                                            ? 105
                                            : 150,
                                        height: type == TemperResultType.mbti
                                            ? 105
                                            : 150,
                                        child: CustomPaint(
                                          painter: TriangleChart(
                                            mbtiMain: state.mbtiMain,
                                            mbti:
                                                state.user.customer?.mbti ?? "",
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                ],
                              )
                            ],
                          ),
                        ],
                      ),
                    ),
                    Container(
                      width: double.infinity,
                      padding: EdgeInsets.symmetric(
                        horizontal: 16,
                        vertical: 20,
                      ),
                      alignment: Alignment.center,
                      decoration: BoxDecoration(
                        color: Colors.white,
                        boxShadow: cardShadow,
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Column(
                        children: [
                          InfoField(
                              title: "나의 현재 심리 상태",
                              valuePadding: 16,
                              titleWidth: 120,
                              value: state.mbtiDetail.emotion ?? "--"),
                          SizedBox(height: 8),
                          InfoField(
                              title: "나의 연애 MBTI",
                              valuePadding: 16,
                              titleWidth: 120,
                              value: state.mbtiDetail.mbtiResult ?? "--"),
                          SizedBox(height: 8),
                          InfoField(
                              title: "내 사랑의 삼각형",
                              valuePadding: 16,
                              titleWidth: 120,
                              value: state.mbtiDetail.loveType ?? "--"),
                          SizedBox(height: 8),
                          Row(
                            children: [
                              Container(
                                height: 36,
                                width: 120,
                                alignment: Alignment.centerLeft,
                                decoration: BoxDecoration(
                                    color: gray100,
                                    borderRadius: BorderRadius.only(
                                        topLeft: Radius.circular(8),
                                        bottomLeft: Radius.circular(8))),
                                padding: EdgeInsets.only(left: 10, right: 20),
                                child: Text(
                                  '내 MBTI',
                                  style: header03.copyWith(color: gray600),
                                ),
                              ),
                              SizedBox(width: 10),
                              Expanded(
                                child: GestureDetector(
                                  onTap: () async {
                                    var items = [
                                      "ISTJ",
                                      "ISTP",
                                      "ISFJ",
                                      "ISFP",
                                      "INTJ",
                                      "INTP",
                                      "INFJ",
                                      "INFP",
                                      "ESTJ",
                                      "ESTP",
                                      "ESFJ",
                                      "ESFP",
                                      "ENTJ",
                                      "ENTP",
                                      "ENFJ",
                                      "ENFP",
                                    ];
                                    var mbti = await showBottomOptionSheet(
                                      context,
                                      title: "내 MBTI",
                                      items: items,
                                      labels: items,
                                    );
                                    if (mbti != null) {
                                      if (state.user.customer?.mbti != mbti) {
                                        context
                                            .read<TemperResultCubit>()
                                            .enterMyMBTI(mbti);
                                      } else {
                                        DefaultDialog.show(context,
                                          title:
                                              "연애 MBTI와 동일한 MBTI를 선택할 수 없습니다.",
                                          defaultButtonTitle: "확인",
                                        );
                                      }
                                    }
                                  },
                                  child: Container(
                                    height: 36,
                                    alignment: Alignment.centerLeft,
                                    padding:
                                        EdgeInsets.symmetric(horizontal: 12),
                                    decoration: BoxDecoration(
                                      color: Colors.white,
                                      border: Border.all(color: gray100),
                                      borderRadius: BorderRadius.circular(8),
                                    ),
                                    child: Text(
                                      state.myMBTI,
                                      style: body01.copyWith(
                                        color: gray600,
                                        fontSize: 11.5,
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                              SizedBox(width: 10),
                              GestureDetector(
                                onTap: state.myMBTI.isNotEmpty &&
                                        state.myMBTI.length == 4
                                    ? () {
                                        context
                                            .read<TemperResultCubit>()
                                            .updateMyMBTI();
                                      }
                                    : null,
                                child: Container(
                                  width: 66,
                                  height: 36,
                                  alignment: Alignment.center,
                                  decoration: BoxDecoration(
                                      color: mainMint,
                                      borderRadius: BorderRadius.circular(8)),
                                  child: Container(
                                    child: Text(
                                      "저장",
                                      style:
                                          body02.copyWith(color: Colors.white),
                                    ),
                                  ),
                                ),
                              )
                            ],
                          ),
                          SizedBox(height: 37),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                '1. 연애 MBTI',
                                style: header02.copyWith(
                                    color: gray900, fontFamily: "Godo"),
                              ),
                              SizedBox(height: 16),
                              Image.asset(
                                "assets/photos/mbti_chart.png",
                              ),
                            ],
                          ),
                          SizedBox(height: 37),
                          Container(
                            width: double.infinity,
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  children: [
                                    BoldMsgGenerator.toRichText(
                                        msg:
                                            '나의 연애 MBTI  *${state.mbtiDetail.mbtiResult}*',
                                        style: header02.copyWith(
                                            color: gray900, fontFamily: "Godo"),
                                        boldWeight: FontWeight.w700,
                                        boldColor: mainMint),
                                    Text(
                                      "  ${state.mbtiDetail.mbtiType ?? ""}",
                                      style: header02.copyWith(
                                          color: heartRed, fontFamily: "Godo"),
                                    )
                                  ],
                                ),
                                SizedBox(height: 16),
                                Container(
                                  padding: EdgeInsets.all(16),
                                  decoration: BoxDecoration(
                                      border:
                                          Border.all(color: backgroundColor),
                                      borderRadius: BorderRadius.circular(8)),
                                  child: Text(
                                    (state.mbtiDetail.mbtiExplain ?? "")
                                            .split(".")
                                            .isNotEmpty
                                        ? (state.mbtiDetail.mbtiExplain ?? "")
                                        : "",
                                    style: body06.copyWith(color: gray600),
                                  ),
                                )
                              ],
                            ),
                          ),
                          SizedBox(height: 37),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                '2. 사랑의 삼각형',
                                style: header02.copyWith(
                                    color: gray900, fontFamily: "Godo"),
                              ),
                              SizedBox(height: 16),
                              Image.asset(
                                "assets/photos/heart_chart.png",
                              ),
                              SizedBox(height: 16),
                              Container(
                                width: double.infinity,
                                alignment: Alignment.center,
                                padding: EdgeInsets.symmetric(
                                    horizontal: 16, vertical: 16),
                                decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(8),
                                    border: Border.all(color: gray100)),
                                child: Text(
                                  state.mbtiDetail.loveElement ?? "",
                                  style: header04.copyWith(color: gray600),
                                ),
                              )
                            ],
                          ),
                          SizedBox(height: 20),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                crossAxisAlignment: CrossAxisAlignment.end,
                                children: [
                                  BoldMsgGenerator.toRichText(
                                      msg:
                                          '내 사랑의 삼각형  *${(state.mbtiDetail.loveType ?? "").split("(").isNotEmpty ? (state.mbtiDetail.loveType ?? "").split("(").first : ""}*',
                                      style: header02.copyWith(
                                          color: gray900, fontFamily: "Godo"),
                                      boldWeight: FontWeight.w700,
                                      boldColor: mainMint),
                                  Text(
                                    " (${(state.mbtiDetail.loveType ?? "").split("(").length > 1 ? (state.mbtiDetail.loveType ?? "").split("(")[1].replaceAll(")", "") : ""})",
                                    style: header02.copyWith(
                                        fontSize: 16 * widthRatio,
                                        color: heartRed,
                                        fontFamily: "Godo"),
                                  )
                                ],
                              ),
                              SizedBox(height: 16),
                              Container(
                                padding: EdgeInsets.all(16),
                                decoration: BoxDecoration(
                                    border: Border.all(color: backgroundColor),
                                    borderRadius: BorderRadius.circular(8)),
                                child: Text(
                                  state.mbtiDetail.loveTypeExplain ?? "",
                                  style: body06.copyWith(color: gray600),
                                ),
                              )
                            ],
                          ),
                          SizedBox(height: 37),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                '3. 연애 MBTI와 MBTI 차이',
                                style: header02.copyWith(
                                    color: gray900, fontFamily: "Godo"),
                              ),
                              SizedBox(height: 16),
                              if ((state.mbtiDetail.mbtiChange?.before_mbti ??
                                      "")
                                  .isEmpty)
                                Container(
                                  height: 30,
                                  width: double.infinity,
                                  alignment: Alignment.center,
                                  child: Text(
                                    '차이가 없습니다.',
                                    style: body02.copyWith(color: gray300),
                                  ),
                                ),
                              if ((state.mbtiDetail.mbtiChange?.before_mbti ??
                                      "")
                                  .isNotEmpty)
                                ...(state.mbtiDetail.mbtiChange?.before_mbti ??
                                        "")
                                    .split("")
                                    .asMap()
                                    .map(
                                      (i, e) => MapEntry(
                                        i,
                                        Container(
                                          margin:
                                              EdgeInsets.symmetric(vertical: 8),
                                          padding: EdgeInsets.symmetric(
                                              horizontal: 20),
                                          child: Row(
                                            children: [
                                              Container(
                                                width: 62,
                                                height: 62,
                                                alignment: Alignment.center,
                                                decoration: BoxDecoration(
                                                    color: Colors.white,
                                                    boxShadow: cardShadow,
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            100),
                                                    border: Border.all(
                                                        color: gray300)),
                                                child: Text(
                                                  state.mbtiDetail.mbtiChange
                                                          ?.before_mbti?[i] ??
                                                      "",
                                                  style: header02.copyWith(
                                                      color: gray600,
                                                      fontFamily: "Godo"),
                                                ),
                                              ),
                                              Expanded(
                                                child: Padding(
                                                  padding: EdgeInsets.symmetric(
                                                      horizontal: 12),
                                                  child: CustomIcon(
                                                    path: "icons/mbti_arrow",
                                                    width: double.infinity,
                                                  ),
                                                ),
                                              ),
                                              Container(
                                                width: 62,
                                                height: 62,
                                                alignment: Alignment.center,
                                                decoration: BoxDecoration(
                                                  color: Colors.white,
                                                  borderRadius:
                                                      BorderRadius.circular(
                                                          100),
                                                  border: Border.all(
                                                      color: gray300),
                                                  boxShadow: cardShadow,
                                                ),
                                                child: Text(
                                                  state.mbtiDetail.mbtiChange
                                                          ?.after_mbti?[i] ??
                                                      "",
                                                  style: header02.copyWith(
                                                      color: gray600,
                                                      fontFamily: "Godo"),
                                                ),
                                              )
                                            ],
                                          ),
                                        ),
                                      ),
                                    )
                                    .values
                                    .toList(),
                              if ((state.mbtiDetail.mbtiChange?.before_mbti ??
                                      "")
                                  .isNotEmpty)
                                Container(
                                  margin: EdgeInsets.only(top: 10),
                                  padding: EdgeInsets.all(16),
                                  decoration: BoxDecoration(
                                      border:
                                          Border.all(color: backgroundColor),
                                      borderRadius: BorderRadius.circular(8)),
                                  child: Text(
                                    state.mbtiDetail.mbtiChange?.context ?? "",
                                    style: body06.copyWith(color: gray600),
                                  ),
                                ),
                              SizedBox(height: 37),
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    '4. 생활 성향',
                                    style: header02.copyWith(
                                        color: gray900, fontFamily: "Godo"),
                                  ),
                                  SizedBox(height: 17),
                                  Column(
                                    children: [
                                      ...(state.mbtiDetail.tendencyAnswer ?? [])
                                          .map(
                                            (e) => Container(
                                              margin: EdgeInsets.symmetric(
                                                  vertical: 4),
                                              padding: EdgeInsets.symmetric(
                                                  vertical: 9, horizontal: 12),
                                              decoration: BoxDecoration(
                                                  borderRadius:
                                                      BorderRadius.circular(8),
                                                  border: Border.all(
                                                      color: backgroundColor)),
                                              child: Row(
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.start,
                                                children: [
                                                  Expanded(
                                                    child: Row(
                                                      crossAxisAlignment:
                                                          CrossAxisAlignment
                                                              .start,
                                                      children: [
                                                        Text(
                                                          "Q${state.tendencies[e.numbering]?.numbering}",
                                                          style:
                                                              body01.copyWith(
                                                                  color:
                                                                      gray600),
                                                        ),
                                                        Expanded(
                                                          child: Container(
                                                              padding: EdgeInsets
                                                                  .symmetric(
                                                                      horizontal:
                                                                          8),
                                                              child: Text(
                                                                state
                                                                        .tendencies[
                                                                            e.numbering]
                                                                        ?.question ??
                                                                    "--",
                                                                style: body01
                                                                    .copyWith(
                                                                        color:
                                                                            gray600),
                                                              )),
                                                        ),
                                                      ],
                                                    ),
                                                  ),
                                                  Text(
                                                    (e.answer ?? false)
                                                        ? "O"
                                                        : "X",
                                                    style: body01.copyWith(
                                                        color: gray600),
                                                  ),
                                                ],
                                              ),
                                            ),
                                          )
                                          .toList(),
                                    ],
                                  )
                                ],
                              )
                            ],
                          ),
                        ],
                      ),
                    ),
                    SizedBox(
                        height: MediaQuery.of(context).padding.bottom + 30),
                  ],
                ),
              ),
            ),
          );
        }),
      ),
    );
  }

  _button(TemperResultType type) {
    return GestureDetector(
      onTap: () {
        if (type == TemperResultType.temperament) {
          pageController.animateToPage(1,
              duration: Duration(milliseconds: 500), curve: Curves.ease);
        } else {
          pageController.animateToPage(0,
              duration: Duration(milliseconds: 500), curve: Curves.ease);
        }
      },
      child: Container(
        height: 40,
        color: Colors.transparent,
        child: Row(
          children: [
            Container(
              margin: EdgeInsets.only(left: 12),
              width: 4,
              height: 4,
              decoration: BoxDecoration(
                color: this.type == type ? mainNavy : gray400.withOpacity(0),
                borderRadius: BorderRadius.circular(100),
              ),
            ),
            SizedBox(width: 10),
            Text(
              type.title,
              style: header02.copyWith(
                  fontFamily: "Godo",
                  color: this.type == type ? mainNavy : gray400),
            )
          ],
        ),
      ),
    );
  }
}
