import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:oasis/bloc/app/app_bloc.dart';
import 'package:oasis/enum/screen_status.dart';
import 'package:oasis/model/matching/propose.dart';
import 'package:oasis/repository/matching_repository.dart';
import 'package:oasis/repository/user_repository.dart';
import 'package:oasis/ui/common/base_scaffold.dart';
import 'package:oasis/ui/common/default_dialog.dart';
import 'package:oasis/ui/common/image_dialog.dart';
import 'package:oasis/ui/matching/received_propose_list/received_propose_detail/cubit/received_propose_detail_state.dart';
import 'package:oasis/ui/matching/received_propose_list/received_propose_detail/received_propose_detail_screen.dart';
import 'package:oasis/ui/purchase/purchase_screen.dart';

import 'package:oasis/ui/theme.dart';
import 'package:oasis/ui/util/bold_generator.dart';

import '../component/received_propose_card.dart';
import 'cubit/received_propose_list_cubit.dart';
import 'cubit/received_propose_list_state.dart';

class ReceivedProposeListScreen extends StatefulWidget {
  final BuildContext mainContext;
  ReceivedProposeListScreen({required this.mainContext});

  @override
  _ReceivedProposeListScreenState createState() =>
      _ReceivedProposeListScreenState();
}

class _ReceivedProposeListScreenState extends State<ReceivedProposeListScreen> {
  Propose? tempPropse;
  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (BuildContext context) => ReceivedProposeListCubit(
        appBloc: widget.mainContext.read<AppBloc>(),
        matchingRepository: context.read<MatchingRepository>(),
        userRepository: context.read<UserRepository>(),
      )..initialize(),
      child: BlocListener<ReceivedProposeListCubit, ReceivedProposeListState>(
        listener: (context, state) async {
          if (state.status == ScreenStatus.success) {
            var requiredInitialize = await Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => ReceivedProposeDetailScreen(
                  mainContext: widget.mainContext,
                  propose: state.current,
                ),
              ),
            );

            if (requiredInitialize ?? false) {
              context.read<ReceivedProposeListCubit>().initialize();
            }
          }

          switch (state.proposeStatus) {
            case ReceivedProposeStatus.initial:
              break;
            case ReceivedProposeStatus.notEnoughMeeting:
              await DefaultDialog.show(
                context,
                title: "만남권이 부족합니다.",
                defaultButtonTitle: "확인",
                description: "만남권을 구매해주세요.",
              );
              break;
            case ReceivedProposeStatus.notFoundUser:
              await DefaultDialog.show(
                context,
                title: "탈퇴한 회원입니다.",
                defaultButtonTitle: "확인",
              );
              break;
            case ReceivedProposeStatus.unableUser:
              await DefaultDialog.show(
                context,
                title: "연결 될 수 없는 사용자입니다.",
                defaultButtonTitle: "확인",
              );
              break;
            case ReceivedProposeStatus.success:
              await ImageDialog.show(
                context,
                title: "프로포즈 수락 전달 완료",
                defaultButtonTitle: "확인",
                imagePath: "photos/couple_ring",
                description:
                    "${tempPropse?.fromCustomer?.customer?.name ?? '--'}님에게 프로포즈 수락이 전달되었습니다.",
              );
              Navigator.pop(context);
              break;
            case ReceivedProposeStatus.reject:
              break;
            case ReceivedProposeStatus.fail:
              break;
          }
        },
        listenWhen: (pre, cur) =>
            pre.status != cur.status || pre.proposeStatus != cur.proposeStatus,
        child: BlocBuilder<ReceivedProposeListCubit, ReceivedProposeListState>(
          builder: (context, state) {
            return BaseScaffold(
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
                        width: double.infinity,
                        padding:
                            EdgeInsets.symmetric(vertical: 16, horizontal: 12),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(8),
                          boxShadow: cardShadow,
                        ),
                        child: BoldMsgGenerator.toRichText(
                          maxLine: 2,
                          msg:
                              "프로포즈 신청에 대해 *24시간 이내 답변*하지 않을 경우 자동 거절 되며,*3회 이상 답변 미선택시* 신규 매칭에서 일정기간 제외됩니다.",
                          style: body01.copyWith(color: gray600),
                          boldWeight: FontWeight.bold,
                        ),
                      ),
                      SizedBox(height: 28),
                      state.proposes.isEmpty
                          ? Container(
                              width: double.infinity,
                              alignment: Alignment.center,
                              margin: EdgeInsets.only(top: 100),
                              child: Text(
                                '받은 프로포즈가 없습니다.',
                                style: header02.copyWith(color: gray300),
                              ),
                            )
                          : Column(
                              children: [
                                ...state.proposes
                                    .map(
                                      (e) => ProposeCard(
                                        propose: e,
                                        // acceptPropose: () async {
                                        //   if ((state.userProfile.customer
                                        //               ?.meetingRemainCount ??
                                        //           0) >
                                        //       0) {
                                        //     ImageDialog.show(context,
                                        //         title: "프로포즈를 수락하시겠습니까?",
                                        //         description:
                                        //             "프로포즈를 수락하시면 신청 횟수가 1회 차감됩니다.\n또한, 만남이 종료될때까지 새로운 매칭이 중지됩니다.",
                                        //         imagePath:
                                        //             "photos/hand_ring_photo",
                                        //         onTap: () {
                                        //       context
                                        //           .read<
                                        //               ReceivedProposeListCubit>()
                                        //           .acceptCard(
                                        //               proposeId:
                                        //                   "${e.proposeId!}",
                                        //               accepted: true);
                                        //       setState(() {
                                        //         tempPropse = e;
                                        //       });
                                        //     });
                                        //   } else {
                                        //     DefaultDialog.show(
                                        //       context,
                                        //       title: "만남권이 부족합니다.",
                                        //       defaultButtonTitle: "확인",
                                        //       description: "만남권을 구매해주세요.",
                                        //     );
                                        //   }
                                        // },
                                        openPropose: () async {
                                          if (state.userProfile.customer
                                                  ?.membership ==
                                              null) {
                                            DefaultDialog.show(context,
                                                title: "회원권이 없습니다.",
                                                yesRatio: 2,
                                                description: "회원권을 구매해주세요.",
                                                onTap: () {
                                              Navigator.pop(context);
                                              Navigator.push(
                                                  context,
                                                  MaterialPageRoute(
                                                      builder: (_) =>
                                                          PurchaseScreen(
                                                              mainContext: widget
                                                                  .mainContext)));
                                            });
                                          } else {
                                            if ((state.userProfile.customer
                                                            ?.meetingRemainCount ??
                                                        0) >
                                                    0 ||
                                                (state.userProfile.customer
                                                            ?.membership ==
                                                        "blue" &&
                                                    (state.userProfile.customer
                                                                ?.membership_end_date ??
                                                            DateTime.now())
                                                        .isBefore(
                                                            DateTime.now()))) {
                                              context
                                                  .read<
                                                      ReceivedProposeListCubit>()
                                                  .openCard(propose: e);
                                            } else {
                                              DefaultDialog.show(context,
                                                  title: "만남권이 부족합니다.",
                                                  description: "만남권을 구매해주세요.",
                                                  onTap: () {
                                                Navigator.pop(context);
                                                Navigator.push(
                                                    context,
                                                    MaterialPageRoute(
                                                        builder: (_) => PurchaseScreen(
                                                            mainContext: widget
                                                                .mainContext)));
                                              });
                                            }
                                          }
                                        },
                                      ),
                                    )
                                    .toList()
                              ],
                            ),
                      SizedBox(
                        height: MediaQuery.of(context).padding.bottom + 30,
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
}
