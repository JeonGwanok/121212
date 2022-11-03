import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:oasis/bloc/app/app_bloc.dart';
import 'package:oasis/enum/screen_status.dart';
import 'package:oasis/repository/user_repository.dart';
import 'package:oasis/ui/common/base_scaffold.dart';
import 'package:oasis/ui/common/custom_icon.dart';
import 'package:oasis/ui/common/default_dialog.dart';
import 'package:oasis/ui/common/default_small_button.dart';
import 'package:oasis/ui/opti_test/mbti_test/mbti_test_screen.dart';
import 'package:oasis/ui/opti_test/tendenct_test/tendency_test_screen.dart';
import 'package:oasis/ui/theme.dart';
import 'package:oasis/ui/util/bold_generator.dart';

import 'cubit/opti_test_cubit.dart';

class OPTITestScreen extends StatefulWidget {
  final Function onNext;
  final Function onPrev;

  OPTITestScreen({
    required this.onNext,
    required this.onPrev,
  });

  @override
  _OPTITestScreenState createState() => _OPTITestScreenState();
}

class _OPTITestScreenState extends State<OPTITestScreen> {
  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (BuildContext context) => OPTITestCubit(
        userRepository: context.read<UserRepository>(),
      )..initialize(),
      child: BlocListener<OPTITestCubit, OPTITestState>(
        listener: (context, state) {
          if (state.status == ScreenStatus.success) {
            widget.onNext();
          }
        },
        child: BlocBuilder<OPTITestCubit, OPTITestState>(
          builder: (context, state) {
            var ratio = MediaQuery.of(context).size.height / 896;
            return BaseScaffold(
              title: "성향 분석 검사",
              onBack: () {
                widget.onPrev();
              },
              buttons: [
                BaseScaffoldDefaultButtonScheme(
                  title: "다음",
                  onTap: state.user.customer?.mbti != null &&
                          (state.mbtiDetail.tendencyAnswer ?? []).isNotEmpty
                      ? () {
                          widget.onNext();
                        }
                      : null,
                ),
              ],
              body: Container(
                height: double.infinity,
                margin: EdgeInsets.symmetric(vertical: 28 * ratio),
                padding: EdgeInsets.symmetric(horizontal: 16),
                alignment: Alignment.center,
                child: Column(
                  children: [
                    Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        BoldMsgGenerator.toRichText(
                            msg:
                                "OPTI\n*(Oasis psychological type Indicator)*\n오아시스 연애의 발견",
                            style: header03.copyWith(color: gray900),
                            boldFontSize: 16,
                            textAlign: TextAlign.center,
                            boldWeight: FontWeight.w400),
                        SizedBox(height: 24 * ratio),
                        Container(
                          width: 134 * ratio,
                          height: 166 * ratio,
                          child: CustomIcon(
                            path: "icons/certificate",
                          ),
                        ),
                        SizedBox(height: 24 * ratio),
                        Text(
                          '검사 소개',
                          style: header02,
                        ),
                      ],
                    ),
                    SizedBox(height: 8),
                    Expanded(
                      child: SingleChildScrollView(
                        child: Text(
                          """
Oasis 매칭 유형검사는  마이어스와 브릭스 등이 제작한
MBTI(Myers-Briggs Type Indicatior) 검사의 문항, 용의 심리유형론
(Psychological Type Theory), 스탠버그(Stemberg)의
사랑의 삼각형 이론을 바탕으로 문항을 수정, 첨가하여  대인관계 및
매칭 관계를 심리학을 기반으로 KAFKA 심리연구소에서 제작하였습니다.
더하여, 생활 속 개인 취향 및 성향을 파악할 수 있는 문항을  바탕으로,
실제 결혼 생활에서  마주칠 수 있는 문제들을 사실적인 관점으로
파악할 수 있습니다.
                          """,
                          textAlign: TextAlign.center,
                          style: body01.copyWith(color: gray600),
                        ),
                      ),
                    ),
                    SizedBox(height: 8),
                    Column(
                      children: [
                        DefaultSmallButton(
                          reverse: true,
                          title:
                              '연애 MBTI (소요시간 12분) ${state.user.customer?.mbti == null ? "미완료" : "완료"}',
                          onTap: state.user.customer?.mbti == null
                              ? () async {
                                  var result = await Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) => MBTITestScreen(),
                                      ));

                                  if (result ?? false) {
                                    context.read<OPTITestCubit>().initialize();
                                  }
                                }
                              : null,
                        ),
                        SizedBox(height: 16 * ratio),
                        DefaultSmallButton(
                          reverse: true,
                          title:
                              '생활 성향 검사 (소요시간 8분) ${(state.mbtiDetail.tendencyAnswer ?? []).isEmpty ? "미완료" : "완료"}',
                          onTap: (state.mbtiDetail.tendencyAnswer ?? []).isEmpty
                              ? () async {
                                  var result = await Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) =>
                                            TendencyTestScreen(),
                                      ));

                                  if (result ?? false) {
                                    context.read<OPTITestCubit>().initialize();
                                  }
                                }
                              : null,
                        ),
                      ],
                    )
                  ],
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
