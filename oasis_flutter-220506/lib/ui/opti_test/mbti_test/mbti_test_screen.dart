import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:oasis/enum/screen_status.dart';
import 'package:oasis/repository/common_repository.dart';
import 'package:oasis/repository/user_repository.dart';
import 'package:oasis/ui/common/base_scaffold.dart';
import 'package:oasis/ui/common/default_dialog.dart';
import 'package:oasis/ui/opti_test/mbti_test/component/mbti_main_component.dart';
import 'package:oasis/ui/opti_test/mbti_test/component/mbti_prev_component.dart';
import 'package:oasis/ui/opti_test/mbti_test/cubit/mbti_test_cubit.dart';
import 'package:oasis/ui/theme.dart';

import 'component/mbit_main_description.dart';
import 'component/mbti_enter_origin_mbti.dart';
import 'cubit/mbti_test_cubit.dart';

class MBTITestScreen extends StatefulWidget {
  @override
  _MBTITestScreenState createState() => _MBTITestScreenState();
}

class _MBTITestScreenState extends State<MBTITestScreen> {
  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (BuildContext context) => MBTITestCubit(
        userRepository: context.read<UserRepository>(),
        commonRepository: context.read<CommonRepository>(),
      )..initialize(),
      child: BlocListener<MBTITestCubit, MBTITestState>(
        listener: (context, state) async {
          if (state.status == ScreenStatus.success) {
            await DefaultDialog.show(
              context,
              title: "검사가 완료되었습니다.",
              defaultButtonTitle: "확인",
            );
            Navigator.pop(context, true);
          }

          if (state.status == ScreenStatus.fail) {
            DefaultDialog.show(
              context,
              title: "다시시도해주세요.",
              defaultButtonTitle: "확인",
            );
          }
        },
        listenWhen: (pre, cur) => pre.status != cur.status,
        child: BlocBuilder<MBTITestCubit, MBTITestState>(
          builder: (context, state) {
            var ratio = MediaQuery.of(context).size.height / 896;
            var buttonTitle = "";
            Widget screen = Container();

            if (state.mainPage == 0) {
              buttonTitle = "다음";
              screen = MBITMainDescription(
                title: "연애 MBTI 검사 목적",
                description: """
오른손, 왼손을 써서 자신의 이름을 써보면 자신이 주로  쓰는 손이 훨씬 편하고 잘 쓸 수 있다는 것을 알 수가 있습니다.
좋아하는 과일은 다를 수  있고 어떤 과일이 가장 좋은 과일이냐는 이러한 물음은 오히려 어리석을 질문이 될  수  있습니다.
인간의 심리유형도  이와 마찬가지로 개인마다 선호되는 특성이 있습니다.
자신이 어떤 심리유형을 가졌다고 하는 것은  좋다 나쁘다 등의 가치가 부여되는 것이 결코 아닙니다.

심지학자 칼 융의 말처럼 '자기존재의 개성화 - 진정으로 그 사람이 그 사람답게 사는 것'은 자신 스스로  자신의 심리유형을 인식하고, 가장 자신다운 자기가 어떤 모습인지 알아보고, 진정한 자신을 찾아가는 것이 이 검사의 목적입니다.""",
              );
            }

            if (state.mainPage == 1) {
              screen = MBITMainDescription(
                  title: "연애 MBTI 문항 응답 요령", description: """
1. 여러분의 성격유형을 파악하기 위해 총 35문항이 제시될 것입니다.

2. 각 문항을 읽으신 후 자신에게 좀 더 가깝다고 생각되는 것에 클릭합니다. 자신에게 습관처럼 편안하고, 자연스런 행동이나 특성을 선택하시면 됩니다.

3. 시간제한은 없지만 너무 오래 생각하지 마시고 단순하게 답하는것이 바람직합니다.



직관적으로 답해보시기를 권장합니다.

직분에 따른 의도적 역할이나 사회적으로  바람직하다고 여겨지는 기준에 맞추어 응답하는 것이 아니라  평소의  자기다운 모습, 즉 쉽게 자주하시는 행동을 떠올려 응답하시면 됩니다.""");
              buttonTitle = "검사 시작";
            }

            if (state.questionNumber == 3) {
              buttonTitle = "다음";
            }

            if (state.mainPage == 2) {
              // question 0, 1, 2 까지가 prev // 3 은 본인 mbti 입력 // 그 이후로는 메인 mbti
              if (state.questionNumber < 3) {
                screen = PrevMBTIComponent(
                  idx: state.questionNumber,
                  answer: state.preAnswers[state.currentQuestion.numbering],
                  question: state.mbti.preMbti[state.questionNumber],
                  onClick: (result) {
                    context.read<MBTITestCubit>().answerPrev(result);
                  },
                );
              } else if (state.questionNumber == 3) {
                screen = MBTIEnterOriginMBTI(
                  initialValue: state.myMBTI,
                  onEnter: (text) {
                    context.read<MBTITestCubit>().enterMBTI(text);
                  },
                );
              } else if (state.questionNumber > 3) {
                screen = MainMBTIComponent(
                    idx: state.questionNumber,
                    answer: state.mainAnswers[state.currentQuestion.numbering],
                    onClick: (result) {
                      context.read<MBTITestCubit>().answerMain(result);
                    },
                    question: state.mbti.mainMbti[state.questionNumber - 4]);
              }
            }

            String appBarTitle = "성향 분석 검사";
            if (state.mainPage == 2) {
              appBarTitle = "사전 질문";
              if (state.questionNumber > 3) {
                appBarTitle = "MBTI";
              }
            }

            return BaseScaffold(
              title: appBarTitle,
              onLoading: state.status == ScreenStatus.loading,
              showAppbarUnderline: state.mainPage != 2 ||
                  (state.questionNumber == 1 || state.questionNumber == 2),
              backgroundColor:
                  state.mainPage == 2 ? backgroundColor : Colors.white,
              onBack: state.mainPage >= 2
                  ? null
                  : () {
                      if (state.mainPage == 0) {
                        Navigator.pop(context);
                      } else {
                        context.read<MBTITestCubit>().prev();
                      }
                    },
              buttons: state.mainPage != 2 || state.questionNumber == 3
                  ? [
                      BaseScaffoldDefaultButtonScheme(
                          title: buttonTitle,
                          onTap: () {
                            context.read<MBTITestCubit>().next();
                          })
                    ]
                  : null,
              body: Column(children: [
                Expanded(child: screen),
                if (state.mainPage == 2 && state.questionNumber != 3)
                  Container(
                    padding: EdgeInsets.symmetric(horizontal: 16),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Container(height: 4),
                        Row(
                          children: [
                            Expanded(
                                child: Text(
                              '1',
                              textAlign: TextAlign.right,
                              style: caption01.copyWith(color: gray400),
                            )),
                          if(  state.questionNumber < 3)
                                Expanded(
                                child: Text(
                                  '2',
                                  textAlign: TextAlign.right,
                                  style: caption01.copyWith(color: gray400),
                                )),
                            Expanded(
                                flex:   state.questionNumber < 3 ? 1 : 31,
                                child: Text(
                                  state.questionNumber < 3 ? '3' : '32',
                                  textAlign: TextAlign.right,
                                  style: caption01.copyWith(color: gray400),
                                )),
                          ],
                        ),
                        SizedBox(height: 4),
                        Row(
                          children: [
                            Expanded(
                              flex: state.questionNumber < 3 &&
                                      state.questionNumber != 3
                                  ? state.questionNumber + 1
                                  : state.questionNumber - 4 + 1,
                              child: Container(
                                margin: EdgeInsets.only(
                                  bottom:
                                      MediaQuery.of(context).padding.bottom +
                                          15,
                                ),
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(100),
                                  color: mainMint,
                                ),
                                height: 4,
                              ),
                            ),
                            Expanded(
                              flex: state.questionNumber < 3 &&
                                      state.questionNumber != 3
                                  ? 3 - (state.questionNumber + 1)
                                  : 32 - (state.questionNumber + 1) + 4,
                              child: Container(
                                margin: EdgeInsets.only(
                                  bottom:
                                      MediaQuery.of(context).padding.bottom +
                                          15,
                                ),
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(100),
                                  color: gray300,
                                ),
                                height: 4,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
              ]),
            );
          },
        ),
      ),
    );
  }
}
