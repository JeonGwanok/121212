import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:oasis/bloc/app/app_bloc.dart';
import 'package:oasis/model/matching/propose.dart';
import 'package:oasis/repository/matching_repository.dart';
import 'package:oasis/repository/user_repository.dart';
import 'package:oasis/ui/common/base_scaffold.dart';
import 'package:oasis/ui/common/default_dialog.dart';
import 'package:oasis/ui/common/image_dialog.dart';
import 'package:oasis/ui/common/matching_profile/matching_user_detail/matching_user_detail_object.dart';
import 'package:oasis/ui/matching/received_propose_list/received_propose_list/cubit/received_propose_list_state.dart';
import 'package:oasis/ui/meeting/select_meeting_schedule/select_meeting_schedule_screen.dart';
import 'package:oasis/ui/theme.dart';
import 'package:screen_capture_event/screen_capture_event.dart';

import 'cubit/received_propose_detail_cubit.dart';
import 'cubit/received_propose_detail_state.dart';

class ReceivedProposeDetailScreen extends StatefulWidget {
  final BuildContext mainContext;
  final Propose propose;
  ReceivedProposeDetailScreen({
    required this.propose,
    required this.mainContext,
  });
  @override
  _ReceivedProposeDetailScreenState createState() =>
      _ReceivedProposeDetailScreenState();
}

// 해당페이지에서 pop은 이전 페이지 리스트에서 intialize 필요한지 보는 부분
class _ReceivedProposeDetailScreenState
    extends State<ReceivedProposeDetailScreen> {
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
        create: (BuildContext context) => ReceivedProposeDetailCubit(
              propose: widget.propose,
              appBloc: widget.mainContext.read<AppBloc>(),
              matchingRepository: context.read<MatchingRepository>(),
              userRepository: context.read<UserRepository>(),
            )..initialize(),
        child:
            BlocListener<ReceivedProposeDetailCubit, ReceivedProposeListState>(
          listener: (context, state) async {
            switch (state.proposeStatus) {
              case ReceivedProposeStatus.initial:
                break;
              case ReceivedProposeStatus.notEnoughMeeting:
                await DefaultDialog.show(
                  context,
                  title: "만남권이 부족합니다.",
                  description: "만남권을 구매해주세요.",
                  defaultButtonTitle: "확인",
                );
                Navigator.pop(context, true);
                break;
              case ReceivedProposeStatus.notFoundUser:
                await DefaultDialog.show(
                  context,
                  title: "탈퇴한 회원입니다.",
                  defaultButtonTitle: "확인",
                );
                Navigator.pop(context, true);
                break;
              case ReceivedProposeStatus.unableUser:
                await DefaultDialog.show(
                  context,
                  title: "연결 될 수 없는 사용자입니다.",
                  defaultButtonTitle: "확인",
                );
                Navigator.pop(context, true);
                break;
              case ReceivedProposeStatus.success:
                await ImageDialog.show(
                  context,
                  title: "프로포즈 수락 전달 완료",
                  defaultButtonTitle: "확인",
                  imagePath: "photos/couple_ring",
                  description:
                      "${widget.propose.fromCustomer?.customer?.name ?? "--"}님에게 프로포즈 수락이\n전달되었습니다.",
                );
                Navigator.pop(context, true);
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (_) => SelectMeetingScheduleScreen(
                            mainContext: widget.mainContext)));
                break;
              case ReceivedProposeStatus.reject:
                Navigator.pop(context, true);
                break;
              case ReceivedProposeStatus.fail:
                break;
            }
          },
          child:
              BlocBuilder<ReceivedProposeDetailCubit, ReceivedProposeListState>(
            builder: (context, state) {
              return OverrapBaseScaffold(
                title: "",
                appbarColor: backgroundColor,
                backgroundColor: backgroundColor,
                showAppbarUnderline: false,
                onBack: () {
                  Navigator.pop(context);
                },
                buttons: [
                  if (widget.propose.status == ProposeStatus.opened) ...[
                    BaseScaffoldDefaultButtonScheme(
                      title: "거절",
                      color: mainMint,
                      onTap: () {
                        context.read<ReceivedProposeDetailCubit>().acceptCard(
                            proposeId: "${widget.propose.proposeId!}",
                            accepted: false);
                      },
                    ),
                    BaseScaffoldDefaultButtonScheme(
                      color: darkBlue,
                      title: "프로포즈 수락",
                      onTap: () {
                        ImageDialog.show(context,
                            title: "프로포즈를 수락하시겠습니까?",
                            description:
                                "프로포즈를 수락 후 실제 만남이 진행되면\n만남권이 1회 차감됩니다.\n또한, 만남이 종료될 때까지 새로운 매칭이 중지됩니다.",
                            imagePath: "photos/hand_ring_photo", onTap: () {
                          context.read<ReceivedProposeDetailCubit>().acceptCard(
                              proposeId: "${widget.propose.proposeId!}",
                              accepted: true);
                        });
                      },
                    ),
                  ],
                ],
                body: Container(
                  width: double.infinity,
                  height: double.infinity,
                  child: MatchingUserDetailObject(
                    userProfile: widget.propose.fromCustomer,
                    matchingRate: widget.propose.matchingRate ?? 0,
                    compareTendency: state.compareTendency,
                  ),
                ),
              );
            },
          ),
        ));
  }
}
