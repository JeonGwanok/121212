import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:oasis/enum/screen_status.dart';
import 'package:oasis/model/matching/matchings.dart';
import 'package:oasis/model/user/user_profile.dart';
import 'package:oasis/repository/matching_repository.dart';
import 'package:oasis/repository/user_repository.dart';
import 'package:oasis/ui/common/base_scaffold.dart';
import 'package:oasis/ui/common/custom_icon.dart';
import 'package:oasis/ui/common/default_dialog.dart';
import 'package:oasis/ui/common/default_small_button.dart';
import 'package:oasis/ui/matching/last_matching_history/last_matching_history_screen.dart';
import 'package:oasis/ui/matching/matching_list/component/matching_card.dart';
import 'package:oasis/ui/matching/matching_list/matching_detail/matching_detail_screen.dart';
import 'package:oasis/ui/my_page/my_page_main/my_page_main_screen.dart';
import 'package:oasis/ui/purchase/purchase_screen.dart';
import 'package:oasis/ui/theme.dart';
import 'package:oasis/ui/util/bold_generator.dart';
import 'package:screen_capture_event/screen_capture_event.dart';

import 'cubit/matching_list_cubit.dart';
import 'cubit/matching_list_state.dart';

class MatchingListScreen extends StatefulWidget {
  final BuildContext mainContext;
  MatchingListScreen({required this.mainContext});

  @override
  _MatchingListScreenState createState() => _MatchingListScreenState();
}

class _MatchingListScreenState extends State<MatchingListScreen> {
  final ScreenCaptureEvent screenListener = ScreenCaptureEvent();
  @override
  void initState() {
    super.initState();
    screenListener.preventAndroidScreenShot(true);
    listenScreenShot();
  }

  bool showPopup = false;

  listenScreenShot() {
    screenListener.addScreenShotListener((filePath) async {
      if (Platform.isIOS) {
        if (!showPopup) {
          showPopup = true;
          await DefaultDialog.show(context,
              title: '스크린샷이 감지되었습니다.',
              description: "무단 유포시에 법적 처벌을 받을 수 있습니다.",
              defaultButtonTitle: "확인");
          showPopup = false;
        }
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (BuildContext context) => MatchingListCubit(
        matchingRepository: context.read<MatchingRepository>(),
        userRepository: context.read<UserRepository>(),
      )..initialize(),
      child: BlocBuilder<MatchingListCubit, MatchingListState>(
        builder: (context, state) {
          return BlocListener<MatchingListCubit, MatchingListState>(
            listener: (context, state) async {
              if (state.status == ScreenStatus.success) {
                var requiredInitialize = await Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => MatchingDetailScreen(
                      mainContext: widget.mainContext,
                      matching: state.current,
                    ),
                  ),
                );

                if (requiredInitialize ?? false) {
                  context.read<MatchingListCubit>().initialize();
                }
              }

              switch (state.matchingListStatus) {
                case MatchingListStatus.initial:
                  break;
                case MatchingListStatus.notEnoughMeeting:
                  await DefaultDialog.show(context,
                      title: "만남권이 부족합니다.",
                      description: "만남권을 구매해주세요.", onTap: () {
                    Navigator.pop(context);
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (_) => PurchaseScreen(
                                mainContext: widget.mainContext)));
                  });
                  break;
                case MatchingListStatus.notFoundUser:
                  await DefaultDialog.show(
                    context,
                    title: "탈퇴한 회원입니다.",
                    defaultButtonTitle: "확인",
                  );
                  break;
                case MatchingListStatus.unableUser:
                  await DefaultDialog.show(
                    context,
                    title: "연결 될 수 없는 사용자입니다.",
                    defaultButtonTitle: "확인",
                  );
                  break;
                case MatchingListStatus.fail:
                  break;
                default:
                  break;
              }
            },
            listenWhen: (pre, cur) =>
                pre.status != cur.status ||
                pre.matchingListStatus != cur.matchingListStatus,
            child: BaseScaffold(
              title: "",
              appbarColor: backgroundColor,
              backgroundColor: backgroundColor,
              showAppbarUnderline: false,
              onBack: () {
                Navigator.pop(context);
              },
              body: Container(
                width: double.infinity,
                height: double.infinity,
                padding: EdgeInsets.symmetric(horizontal: 16),
                child: SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      SizedBox(height: 20),
                      Container(
                        width: 140,
                        height: 44,
                        child: DefaultSmallButton(
                          title: "지난 추천 프로필 내역",
                          hideBorder: true,
                          reverse: true,
                          showShadow: true,
                          onTap: () {
                            if (state.userProfile.customer?.membership ==
                                null) {
                              DefaultDialog.show(context,
                                  title: "회원권이 없습니다.",
                                  yesRatio: 2,
                                  description: "회원권을 구매해주세요.", onTap: () {
                                Navigator.pop(context);
                                Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (_) => PurchaseScreen(
                                            mainContext: widget.mainContext)));
                              });
                            } else {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (_) => LastMatchingHistoryScreen(),
                                ),
                              );
                            }
                          },
                        ),
                      ),
                      SizedBox(height: 16),
                      Container(
                        width: double.infinity,
                        padding:
                            EdgeInsets.symmetric(vertical: 16, horizontal: 12),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(8),
                          boxShadow: cardShadow,
                        ),
                        child: BoldMsgGenerator.toRichText(
                          msg:
                              "카드를 확인할 수 있는 기간은 *14일*입니다.\n발급된 카드를 모두 거절할 경우\n재발급까지 최대 14일이 소요됩니다.",
                          style: body01.copyWith(color: gray600),
                          boldWeight: FontWeight.bold,
                        ),
                      ),
                      SizedBox(height: 28),
                      if (state.status != ScreenStatus.initial)
                        Container(
                          width: double.infinity,
                          height: 220 * 2 + 18,
                          child: Stack(
                            children: [
                              Container(
                                alignment: Alignment.bottomCenter,
                                child: Container(
                                  height: 220,
                                  child: Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      if (state.matchings.length > 1)
                                        _tile(
                                          context,
                                          widget.mainContext,
                                          state.matchings,
                                          2,
                                          state.userProfile,
                                          state.userProfile.customer
                                                      ?.membership ==
                                                  "basic" ||
                                              state.userProfile.customer
                                                      ?.membership ==
                                                  null,
                                        ),
                                      if (state.matchings.length > 2)
                                        _tile(
                                          context,
                                          widget.mainContext,
                                          state.matchings,
                                          3,
                                          state.userProfile,
                                          state.userProfile.customer
                                                      ?.membership ==
                                                  "basic" ||
                                              state.userProfile.customer
                                                      ?.membership ==
                                                  null,
                                        )
                                    ],
                                  ),
                                ),
                              ),
                              Container(
                                height: 220,
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    if (state.matchings.length >= 0)
                                      _tile(
                                        context,
                                        widget.mainContext,
                                        state.matchings,
                                        0,
                                        state.userProfile,
                                        state.userProfile.customer
                                                    ?.membership ==
                                                "basic" ||
                                            state.userProfile.customer
                                                    ?.membership ==
                                                null,
                                      ),
                                    if (state.matchings.length > 0)
                                      _tile(
                                        context,
                                        widget.mainContext,
                                        state.matchings,
                                        1,
                                        state.userProfile,
                                        state.userProfile.customer
                                                    ?.membership ==
                                                "basic" ||
                                            state.userProfile.customer
                                                    ?.membership ==
                                                null,
                                      )
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                      SizedBox(
                        height: MediaQuery.of(context).padding.bottom + 50,
                      )
                    ],
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _tile(
    BuildContext context,
    BuildContext mainContext,
    List<Matching> items,
    int idx,
    UserProfile user,
    bool isUnderGoldMembership, // 골드회원보다 아래 등급인 회원
  ) {
    return Container(
      width: ((MediaQuery.of(context).size.width - 32) - 20) / 2,
      child: MatchingCard(
        onGoldTap: () {
          Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (_) => PurchaseScreen(
                        mainContext: widget.mainContext,
                        showOnlyMembership: true,
                      )));
        },
        onTap: () async {
          if (user.customer?.membership == null) {
            DefaultDialog.show(context,
                title: "회원권이 없습니다.",
                yesRatio: 2,
                description: "회원권을 구매해주세요.", onTap: () {
              Navigator.pop(context);
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (_) =>
                          PurchaseScreen(mainContext: widget.mainContext)));
            });
          } else {
            if ((user.customer?.meetingRemainCount ?? 0) > 0 ||
                (user.customer?.membership == "blue" &&
                    (user.customer?.membership_end_date ?? DateTime.now())
                        .isBefore(DateTime.now()))) {
              if (!(isUnderGoldMembership && (idx == items.length))) {
                context
                    .read<MatchingListCubit>()
                    .openCard(matching: items[idx]);
              }
            } else {
              DefaultDialog.show(context,
                  title: "만남권이 부족합니다.", description: "만남권을 구매해주세요.", onTap: () {
                Navigator.pop(context);
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (_) =>
                            PurchaseScreen(mainContext: widget.mainContext)));
              });
            }
          }
        },
        matching: idx < items.length ? items[idx] : null,
        isLocked: isUnderGoldMembership && (idx == items.length),
      ),
    );
  }
}
