import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:oasis/enum/screen_status.dart';
import 'package:oasis/repository/common_repository.dart';
import 'package:oasis/repository/user_repository.dart';
import 'package:oasis/ui/common/base_scaffold.dart';
import 'package:oasis/ui/common/default_dialog.dart';
import 'package:oasis/ui/opti_test/mbti_test/component/mbit_main_description.dart';
import 'package:oasis/ui/opti_test/tendenct_test/component/tendency_test_component.dart';
import 'package:oasis/ui/theme.dart';
import 'cubit/tendency_test_cubit.dart';

class TendencyTestScreen extends StatefulWidget {
  @override
  _TendencyTestScreenState createState() => _TendencyTestScreenState();
}

class _TendencyTestScreenState extends State<TendencyTestScreen> {
  late ScrollController scrollController;

  @override
  void initState() {
    scrollController = ScrollController();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (BuildContext context) => TendencyTestCubit(
        userRepository: context.read<UserRepository>(),
        commonRepository: context.read<CommonRepository>(),
      )..initialize(),
      child: BlocListener<TendencyTestCubit, TendencyTestState>(
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
        child: BlocBuilder<TendencyTestCubit, TendencyTestState>(
          builder: (context, state) {
            var ratio = MediaQuery.of(context).size.height / 896;
            Widget screen = Container();

            if (state.mainPage == 0) {
              screen = MBITMainDescription(
                title: "생활 성향 검사 문항 응답 요령",
                description: """
1. 여러분의 생활 속 성향을 파악하기 위해 총 15문항이 제시됩니다.

2. 각 문항을 읽으신 후 평소 자신의 생활 방식이나 가지고  있던 의견에 가깝다고 생각되는 것에 클릭합니다.

3. 생활 성향 검사는  프로필 열람시 공개되는 정보이며, 상대방의 만남 의사를 판단하는 중요한 근거가 될 수 있으니 정확하게 응답하시기를 권장합니다.""",
              );
            }

            if (state.mainPage == 1) {
              screen = TendencyTestComponent(
                questions: state.tendencies.length >= 5
                    ? state.tendencies.sublist(0, 5)
                    : [],
                initialAnswers: state.answers,
                onClick: (question, value) {
                  context
                      .read<TendencyTestCubit>()
                      .enterAnswer(question, value);
                },
              );
            }

            if (state.mainPage == 2) {
              screen = TendencyTestComponent(
                questions: state.tendencies.length >= 10
                    ? state.tendencies.sublist(5, 10)
                    : [],
                initialAnswers: state.answers,
                onClick: (question, value) {
                  context
                      .read<TendencyTestCubit>()
                      .enterAnswer(question, value);
                },
              );
            }

            Function? onTap;

            if (state.mainPage == 0) {
              onTap = () {
                context.read<TendencyTestCubit>().next();
              };
            } else if (state.mainPage == 1) {
              if (state.answers.length >= 5) {
                onTap = () {
                  context.read<TendencyTestCubit>().next();
                  scrollController.jumpTo(0);
                };
              }
            } else if (state.mainPage == 2) {
              if (state.answers.length == state.tendencies.length) {
                onTap = () {
                  context.read<TendencyTestCubit>().update();
                };
              }
            }

            return BaseScaffold(
              title: "성향 분석 검사",
              onLoading: state.status == ScreenStatus.loading,
              showAppbarUnderline: true,
              backgroundColor:
                  state.mainPage != 0 ? backgroundColor : Colors.white,
              onBack: state.mainPage == 0
                  ? () {
                      if (state.mainPage == 0) {
                        Navigator.pop(context);
                      } else {
                        context.read<TendencyTestCubit>().prev();
                      }
                    }
                  : null,
              buttons: [
                BaseScaffoldDefaultButtonScheme(
                    title: state.mainPage == 2 ? "완료" : "다음", onTap: onTap)
              ],
              body: Column(
                children: [
                  Expanded(
                      child: SingleChildScrollView(
                          controller: scrollController, child: screen)),
                  if (state.mainPage != 0)
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
                              Expanded(
                                  child: Text(
                                "2",
                                textAlign: TextAlign.right,
                                style: caption01.copyWith(color: gray400),
                              )),
                            ],
                          ),
                          SizedBox(height: 4),
                          Row(
                            children: [
                              Expanded(
                                flex: state.mainPage,
                                child: Container(
                                  margin: EdgeInsets.only(
                                    bottom:
                                        10,
                                  ),
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(100),
                                    color: mainMint,
                                  ),
                                  height: 4,
                                ),
                              ),
                              Expanded(
                                flex: 2 - state.mainPage,
                                child: Container(
                                  margin: EdgeInsets.only(
                                    bottom: 10,
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
                ],
              ),
            );
          },
        ),
      ),
    );
  }
}
