import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:oasis/bloc/app/app_bloc.dart';
import 'package:oasis/enum/screen_status.dart';
import 'package:oasis/repository/matching_repository.dart';
import 'package:oasis/repository/user_repository.dart';
import 'package:oasis/ui/common/base_scaffold.dart';
import 'package:oasis/ui/common/default_dialog.dart';
import 'package:oasis/ui/matching/matching_list/matching_list/matching_list_screen.dart';
import 'package:oasis/ui/my_page/my_status/component/user_status_card.dart';
import 'package:oasis/ui/my_page/my_status/cubit/my_status_cubit.dart';
import 'package:oasis/ui/my_page/my_status/cubit/my_status_state.dart';
import 'package:oasis/ui/purchase/purchase_screen.dart';
import 'package:oasis/ui/theme.dart';
import 'package:oasis/ui/util/date.dart';

class MyStatusScreen extends StatefulWidget {
  final BuildContext mainContext;
  MyStatusScreen({required this.mainContext});
  @override
  _MyStatusScreenState createState() => _MyStatusScreenState();
}

class _MyStatusScreenState extends State<MyStatusScreen> {
  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (BuildContext context) => MyStatusCubit(
        matchingRepository: context.read<MatchingRepository>(),
        appBloc: widget.mainContext.read<AppBloc>(),
        userRepository: context.read<UserRepository>(),
      )..initialize(),
      child: BlocListener<MyStatusCubit, MyStatusState>(
        listener: (context, state) {
          if (state.status == ScreenStatus.success) {
            var name = "${state.meeting?.loverInfo?.customer?.nickName}";
            DefaultDialog.show(
              context,
              title: "$name님과 연애가 종료되었습니다.",
              defaultButtonTitle: "확인",
            );
          }
        },
        child: BlocBuilder<MyStatusCubit, MyStatusState>(
          builder: (context, state) {
            String meetingEnableCountLabel = "";
            bool enablePurchase = false;
            int remainCount = state.user.customer?.meetingRemainCount ?? 0;
            if (state.user.customer?.membership == null) {
              enablePurchase = true;
              meetingEnableCountLabel = "미결제";
            } else if (state.user.customer?.membership == "diamond") {
              meetingEnableCountLabel = "제한없음";
            } else {
              enablePurchase = true;
              meetingEnableCountLabel =
                  "${state.user.customer?.meetingTotalCount}회중 $remainCount회 남음";
            }

            if (state.user.customer?.membership == "blue" && state.user.customer!.membership_end_date!.isBefore(DateTime.now())) {
              meetingEnableCountLabel = "무제한";
            }

            Color buttonColor = darkBlue;
            String title = "이상형을 찾는 중";
            String icon = "";
            Function onTap = () {};

            switch (state.user.customer?.nowStatus) {
              case "WAIT":
                title = "이상형을 찾는중";
                break;
              case "PROPOSE":
                title = "프로포즈 진행중";
                break;
              case "MEETING":
                title = "만남 진행중";
                break;
              case "LOVE":
                var name = "${state.meeting?.loverInfo?.customer?.nickName}";
                title = "$name 님과 연애중";
                buttonColor = heartRed;
                icon = "icons/heart";
                onTap = () {
                  DefaultDialog.show(
                    context,
                    title: "$name님과 연애를 그만하시겠습니까?",
                    description: "그만하시게 될 경우\n다시 되돌릴 수 없습니다.",
                    onTap: () {
                      context.read<MyStatusCubit>().breakUp();
                    },
                  );
                };
                break;
            }

            var heightRatio = MediaQuery.of(context).size.height / 896;

            return BaseScaffold(
              title: "",
              onBack: () {
                Navigator.pop(context);
              },
              buttons: [
                BaseScaffoldDefaultButtonScheme(
                  title: title,
                  color: buttonColor,
                  icon: icon,
                  onTap: () {
                    onTap();
                  },
                )
              ],
              onLoading: state.status == ScreenStatus.loading,
              backgroundColor: backgroundColor,
              body: Container(
                padding: EdgeInsets.symmetric(horizontal: 16),
                width: double.infinity,
                child: SingleChildScrollView(
                  child: Column(
                    children: [
                      Container(height: 40 * heightRatio),
                      state.meeting == null
                          ? UserStatusCard(
                              customer: state.user.customer,
                              imageUrl: state.user.image?.representative1 ?? "",
                            )
                          : Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                UserStatusCard(
                                  customer: state.user.customer,
                                  imageUrl:
                                      state.user.image?.representative1 ?? "",
                                ),
                                SizedBox(width: 18),
                                UserStatusCard(
                                  customer: state.meeting?.loverInfo?.customer,
                                  imageUrl: state.meeting?.loverInfo?.image
                                          ?.representative1 ??
                                      "",
                                )
                              ],
                            ),
                      SizedBox(height: 16 * heightRatio),
                      Row(
                        children: [
                          Expanded(
                            child: _textCard(
                              title: "미확인 추천 카드",
                              onTap: () {
                                if (state.user.customer?.nowStatus == "WAIT") {
                                  Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (_) => MatchingListScreen(
                                              mainContext:
                                                  widget.mainContext)));
                                }
                              },
                              color: mainMint,
                              value: "${state.uncheckedMatchingCount}",
                            ),
                          ),
                          SizedBox(width: 18 * heightRatio),
                          Expanded(
                            child: _textCard(
                              title: "남은 미팅 횟수",
                              onTap: () {
                                if (enablePurchase && remainCount == 0) {
                                  Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (_) => PurchaseScreen(
                                              mainContext:
                                                  widget.mainContext)));
                                }
                              },
                              color: red500,
                              value: meetingEnableCountLabel,
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: 16 * heightRatio),
                      _meetingCard(
                          value: state.meeting != null &&
                                  state.meeting?.meeting?.utcDate != null && state.user.customer!.lastMeeting != null
                              ? "${DateFormat("yyyy년 MM월 dd일").format(state.user.customer!.lastMeeting!)} (${getWeekKorean(state.meeting!.meeting!.utcDate!.weekday)}) ${DateFormat("HH:mm시").format(state.meeting!.meeting!.utcDate!)}"
                              : "--"),
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

  Widget _textCard({
    required Function onTap,
    required String title,
    required Color color,
    required String value,
  }) {
    var heightRatio = MediaQuery.of(context).size.height / 896;

    return GestureDetector(
      onTap: () {
        onTap();
      },
      child: Container(
        padding: EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(8),
          border: Border.all(color: color),
          boxShadow: cardShadow,
        ),
        child: Column(
          children: [
            Text(
              title,
              style: header05.copyWith(
                color: color,
              ),
            ),
            SizedBox(height: 16 * heightRatio),
            Text(
              value,
              style: header05.copyWith(
                color: gray600,
              ),
            )
          ],
        ),
      ),
    );
  }

  Widget _meetingCard({
    required String value,
  }) {
    var heightRatio = MediaQuery.of(context).size.height / 896;

    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8),
        boxShadow: cardShadow,
      ),
      child: Column(
        children: [
          Container(
            width: double.infinity,
            child: Text(
              "마지막 만남일",
              style: header05.copyWith(color: mainNavy),
            ),
          ),
          SizedBox(height: 29 * heightRatio),
          Text(
            value,
            style: header05.copyWith(
              color: gray600,
            ),
          ),
          SizedBox(height: 16 * heightRatio),
        ],
      ),
    );
  }
}
