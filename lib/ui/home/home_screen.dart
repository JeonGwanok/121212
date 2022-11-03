import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:oasis/bloc/app/app_bloc.dart';
import 'package:oasis/enum/screen_status.dart';
import 'package:oasis/model/matching/propose.dart';
import 'package:oasis/repository/common_repository.dart';
import 'package:oasis/repository/matching_repository.dart';
import 'package:oasis/repository/user_repository.dart';
import 'package:oasis/ui/common/base_scaffold.dart';
import 'package:oasis/ui/common/chart/octagon.dart';
import 'package:oasis/ui/common/chart/triangle_chart.dart';
import 'package:oasis/ui/common/custom_icon.dart';
import 'package:oasis/ui/home/component/home_conent_object.dart';
import 'package:oasis/ui/home/cubit/home_cubit.dart';
import 'package:oasis/ui/home/cubit/home_state.dart';
import 'package:oasis/ui/matching/ai_matching_list/ai_matching_list_screen.dart';
import 'package:oasis/ui/matching/matching_list/matching_list/matching_list_screen.dart';
import 'package:oasis/ui/matching/received_propose_list/received_propose_list/received_propose_list_screen.dart';
import 'package:oasis/ui/meeting/after_meeting/after_metting_screen.dart';
import 'package:oasis/ui/meeting/confirm_metting/confirm_meeting_screen.dart';
import 'package:oasis/ui/meeting/select_meeting_schedule/select_meeting_schedule_screen.dart';
import 'package:oasis/ui/my_page/my_page_main/my_page_main_screen.dart';
import 'package:oasis/ui/my_page/my_status/my_status_screen.dart';
import 'package:oasis/ui/my_page/my_temper_result/my_temper_result_screen.dart';
import 'package:oasis/ui/notification/notification_list/notification_list_screen.dart';
import 'package:oasis/ui/register_cerificate/register_cerfication_main/register_certificate_screen.dart';
import 'package:oasis/ui/sent_propose_profile/sent_propose_profile_screen.dart';

import '../theme.dart';

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
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

  BuildContext? _context;
  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (BuildContext context) => HomeCubit(
        appBloc: context.read<AppBloc>(),
        userRepository: context.read<UserRepository>(),
        commonRepository: context.read<CommonRepository>(),
        matchingRepository: context.read<MatchingRepository>(),
      )..initialize(),
      child: BlocListener<HomeCubit, HomeState>(
        listener: (context, state) {},
        child: BlocBuilder<HomeCubit, HomeState>(builder: (context, state) {
          _context = context;
          var firstColor = gray300;
          var firstButtonTitle = "프로포즈 기다리는 중...";
          var firstShowGif = HeartAnimationType.none;
          var firstDescriptionTitle = "";
          var firstButtonAction = () {
            Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (_) => ReceivedProposeListScreen(
                        mainContext: context)));
          };

          var secondColor = mainNavy;
          var secondButtonTitle = "준비중입니다.";
          var secondShowGif = HeartAnimationType.none;
          var secondDescriptionTitle = "";
          var secondDescriptionIcon = "";
          var secondButtonAction = () {};

          if (!(state.completeCertificate ?? false)) {
            secondColor = mainNavy;
            secondButtonTitle = "서류 인증 미완료";
            secondDescriptionTitle = "인증이 완료되어야 매칭이 진행됩니다.";
            secondButtonAction = () {
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (_) => RegisterCertificateScreen(
                            type: RegisterCertificateScreenType.afterSignUp,
                            mainContext: context,
                          )));
            };
          } else {
            if (state.user.customer?.nowStatus == "WAIT") {
              if (state.matchings.isEmpty) {
                secondColor = mainNavy;
                secondButtonTitle = "나의 이상형 찾는 중";
                secondDescriptionTitle = "";
                secondButtonAction = () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => AiMatchingListScreen()));
                };
              } else {
                secondColor = heartRed2;
                secondButtonTitle = "나의 이상형 도착";
                secondShowGif = HeartAnimationType.pink;
                secondDescriptionTitle = "";
                secondButtonAction = () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (_) =>
                              MatchingListScreen(mainContext: context)));
                };
              }

              if (state.proposes.isEmpty) {
              } else if (state.proposes
                  .where((e) =>
                      e.status == ProposeStatus.intial ||
                      e.status == ProposeStatus.opened)
                  .toList()
                  .isNotEmpty) {
                if (state.proposes.isNotEmpty) {
                  firstColor = heartRed;
                  firstButtonTitle = "받은 프로포즈";
                  firstShowGif = HeartAnimationType.pink;
                  firstDescriptionTitle = "";
                  firstButtonAction = () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (_) => ReceivedProposeListScreen(
                                mainContext: context)));
                  };
                }
              }
            } else if (state.user.customer?.nowStatus == "PROPOSE") {
              secondColor = mainNavy;
              secondButtonTitle = "프로포즈 진행중";
              secondDescriptionTitle = "";
              secondButtonAction = () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (_) => SentProposeProfileScreen(
                              mainContext: context,
                              propose: state.myPropose ?? Propose.empty,
                            )));
              };
            } else if (state.user.customer?.nowStatus == "MEETING") {
              if ((state.meeting?.schedule ?? []).isEmpty) {
                if (state.meeting?.sendStatus ?? false) {
                  // 내가 보낸 프로포즈인경우
                  secondButtonTitle = "상대방이 만남을 수락";
                  secondDescriptionTitle = "만남 일정 선택";
                } else {
                  secondButtonTitle = "만남일정을 선택해주세요";
                  secondDescriptionTitle = "만남 일정 선택";
                }

                secondColor = mainNavy;
                secondButtonAction = () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (_) => SelectMeetingScheduleScreen(
                              mainContext: context)));
                };
              } else if (!(state.meeting?.meeting?.scheduleState ?? false)) {
                secondColor = mainNavy;
                secondButtonTitle = "상대방이 일정 선택 중";
                secondDescriptionTitle = "";
                secondButtonAction = () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (_) => SelectMeetingScheduleScreen(
                              mainContext: context)));
                };
              } else if ((state.meeting?.meeting?.scheduleState ?? false) &&
                  (state.meeting?.meeting?.location == null)) {
                secondColor = mainNavy;
                secondButtonTitle = "상대방이 일정 선택 중";
                secondDescriptionTitle = "";
                secondButtonAction = () {};
              } else if ((state.meeting?.meeting?.scheduleState ?? false) &&
                  state.meeting?.meeting?.location != null &&
                  state.meeting?.meeting?.date != null) {
                if (((state.meeting?.meeting?.utcDate) ?? DateTime.now())
                    .isBefore(DateTime.now().add(Duration(hours: 3)))) {
                  // 만남 시간 3 시간 이후인 경우
                  if ((state.meeting?.storyWrite ?? "WAIT") == "WAIT") {
                    secondColor = mainNavy;
                    secondButtonTitle = "만남 후 이야기 작성";
                    secondDescriptionTitle = "* 미작성시 신규 매칭 불가";
                    secondButtonAction = () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (_) =>
                                  AfterMeetingScreen(mainContext: context)));
                    };
                  } else if ((state.meeting?.storyWrite ?? "WAIT") == "END") {
                    secondColor = mainNavy;
                    secondButtonTitle = "상대방이 만남 고려중...";
                    secondDescriptionTitle = "";
                    secondButtonAction = () {};
                  } else {
                    secondColor = mainNavy;
                    secondButtonTitle = "관리자에게 문의";
                    secondDescriptionTitle = "";
                    secondButtonAction = () {};
                  }
                } else {
                  // 만남 시간 이전이면
                  secondColor = heartRed;
                  secondButtonTitle = "일정 확정";
                  secondShowGif = HeartAnimationType.pink;
                  secondDescriptionTitle = "";
                  secondButtonAction = () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (_) =>
                                ConfirmMeetingScreen(mainContext: context)));
                  };
                }
              }
            } else if (state.user.customer?.nowStatus == "LOVE") {
              secondColor = heartRed2;
              secondButtonTitle =
                  "${state.meeting?.loverInfo?.customer?.nickName} 님과 연애중";
              secondDescriptionIcon = "icons/heart";
              secondDescriptionTitle = "";
              secondButtonAction = () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) =>
                            MyStatusScreen(mainContext: context)));
              };
            }
          }

          if (state.status == ScreenStatus.loading) {
            firstColor = gray50;
            firstButtonTitle = "";
            firstDescriptionTitle = "";
            firstButtonAction = () {};

            secondColor = gray50;
            secondButtonTitle = "";
            secondDescriptionTitle = "";
            secondDescriptionIcon = "";
            secondButtonAction = () {};
          }

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

          var widthRatio = MediaQuery.of(context).size.width / 414;

          return BaseScaffold(
            title: "",
            onTitleTap: () {
              _context!.read<HomeCubit>().initialize(onRefresh: true);
            },
            isFirstPage: true,
            backItem: GestureDetector(
              onTap: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (_) => NotificationListScreen()));
              },
              child: Container(
                child: CustomIcon(path: "icons/bell"),
              ),
            ),
            action: GestureDetector(
              onTap: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (_) => MyPageMainScreen(
                              mainContext: context,
                            )));
              },
              child: Container(
                  alignment: Alignment.center,
                  child: CustomIcon(
                    path: "icons/hamburger",
                  )),
            ),
            buttons: [
              if ((state.user.customer?.nowStatus ?? "WAIT") == "WAIT")
                BaseScaffoldDefaultButtonScheme(
                    title: firstButtonTitle,
                    color: firstColor,
                    showGif: firstShowGif,
                    description: firstDescriptionTitle,
                    onTap: firstButtonAction),
              BaseScaffoldDefaultButtonScheme(
                title: secondButtonTitle,
                description: secondDescriptionTitle,
                showGif: secondShowGif,
                icon: secondDescriptionIcon,
                color: secondColor,
                onTap: secondButtonAction,
              ),
            ],
            backgroundColor: gray50,
            showAppbarUnderline: false,
            body: Container(
              child: CustomScrollView(
                physics: BouncingScrollPhysics(),
                slivers: [
                  CupertinoSliverRefreshControl(
                    builder: (_, __, ___, ____, _____) {
                      return Container();
                    },
                    onRefresh: () async {
                      _context!.read<HomeCubit>().initialize(onRefresh: true);
                    },
                  ),
                  SliverList(
                    delegate: SliverChildBuilderDelegate(
                        (context, index) => Container(
                              padding: EdgeInsets.symmetric(horizontal: 16),
                              child: Column(
                                children: [
                                  if (state.status == ScreenStatus.refresh)
                                    Container(
                                      height: 100,
                                      width: double.infinity,
                                      child: Container(
                                        alignment: Alignment.center,
                                        child: Container(
                                          width: 20,
                                          height: 20,
                                          child: CircularProgressIndicator(
                                            backgroundColor: gray300,
                                            strokeWidth: 3,
                                            valueColor:
                                                AlwaysStoppedAnimation<Color>(
                                                    Colors.white),
                                          ),
                                        ),
                                      ),
                                    ),
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
                                              width: MediaQuery.of(context)
                                                      .size
                                                      .width -
                                                  32,
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
                                                    type !=
                                                            TemperResultType
                                                                .temperament
                                                        ? state.user.customer
                                                                ?.mbti ??
                                                            ""
                                                        : text,
                                                    style: TextStyle(
                                                      fontFamily: "Godo",
                                                      letterSpacing: 5,
                                                      fontSize: 58 * widthRatio,
                                                      fontWeight:
                                                          FontWeight.bold,
                                                      foreground: Paint()
                                                        ..style =
                                                            PaintingStyle.stroke
                                                        ..strokeWidth = 2
                                                        ..color =
                                                            gray200, // <-- Border color
                                                    ),
                                                  ),
                                                  Text(
                                                    type !=
                                                            TemperResultType
                                                                .temperament
                                                        ? state.user.customer
                                                                ?.mbti ??
                                                            ""
                                                        : text,
                                                    style: TextStyle(
                                                      fontFamily: "Godo",
                                                      letterSpacing: 5,
                                                      fontSize: 58 * widthRatio,
                                                      fontWeight:
                                                          FontWeight.bold,
                                                      color: Colors
                                                          .white, // <-- Inner color
                                                    ),
                                                  ),
                                                ],
                                              ),
                                              PageView(
                                                controller: pageController,
                                                children: [
                                                  Opacity(
                                                    opacity: type !=
                                                            TemperResultType
                                                                .mbti
                                                        ? 0.4
                                                        : 1,
                                                    child: Container(
                                                      alignment:
                                                          Alignment.centerLeft,
                                                      child: Container(
                                                        width: type !=
                                                                TemperResultType
                                                                    .mbti
                                                            ? 105
                                                            : 170,
                                                        height: type !=
                                                                TemperResultType
                                                                    .mbti
                                                            ? 105
                                                            : 170,
                                                        child: CustomPaint(
                                                          painter: OctagonChart(
                                                            mbtiMain:
                                                                state.mbtiMain,
                                                            mbti: state
                                                                    .user
                                                                    .customer
                                                                    ?.mbti ??
                                                                "",
                                                          ),
                                                        ),
                                                      ),
                                                    ),
                                                  ),
                                                  Opacity(
                                                    opacity: type ==
                                                            TemperResultType
                                                                .mbti
                                                        ? 0.4
                                                        : 1,
                                                    child: Container(
                                                      margin: EdgeInsets.only(
                                                          left: 20),
                                                      alignment:
                                                          Alignment.centerLeft,
                                                      child: Container(
                                                        width: type ==
                                                                TemperResultType
                                                                    .mbti
                                                            ? 105
                                                            : 150,
                                                        height: type ==
                                                                TemperResultType
                                                                    .mbti
                                                            ? 105
                                                            : 150,
                                                        child: CustomPaint(
                                                          painter:
                                                              TriangleChart(
                                                            mbtiMain:
                                                                state.mbtiMain,
                                                            mbti: state
                                                                    .user
                                                                    .customer
                                                                    ?.mbti ??
                                                                "",
                                                          ),
                                                        ),
                                                      ),
                                                    ),
                                                  ),
                                                ],
                                              )
                                            ]),
                                      ],
                                    ),
                                  ),
                                  HomeContentObject(
                                    userMBTIMain: state.mbtiMain,
                                    userProfile: state.user,
                                    loverCities: state.loverCities ?? "",
                                    loverWorkCities:
                                        state.loverWorkerCities ?? "",
                                  )
                                ],
                              ),
                            ),
                        childCount: 1),
                  ),
                ],
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
