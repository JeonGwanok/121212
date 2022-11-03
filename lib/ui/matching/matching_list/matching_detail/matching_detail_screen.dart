import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:oasis/bloc/app/app_bloc.dart';
import 'package:oasis/model/matching/matchings.dart';
import 'package:oasis/repository/matching_repository.dart';
import 'package:oasis/repository/user_repository.dart';
import 'package:oasis/ui/common/base_scaffold.dart';
import 'package:oasis/ui/common/default_dialog.dart';
import 'package:oasis/ui/common/image_dialog.dart';
import 'package:oasis/ui/common/matching_profile/matching_user_detail/matching_user_detail_object.dart';
import 'package:oasis/ui/matching/matching_list/matching_detail/cubit/matching_detail_state.dart';
import 'package:oasis/ui/theme.dart';
import 'package:screen_capture_event/screen_capture_event.dart';

import 'cubit/matching_detail_cubit.dart';

class MatchingDetailScreen extends StatefulWidget {
  final BuildContext mainContext;
  final Matching matching;
  MatchingDetailScreen({required this.mainContext, required this.matching});
  @override
  _MatchingDetailScreenState createState() => _MatchingDetailScreenState();
}

// 해당페이지에서 pop은 이전 페이지 리스트에서 intialize 필요한지 보는 부분
class _MatchingDetailScreenState extends State<MatchingDetailScreen> {
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
      create: (BuildContext context) => MatchingDetailCubit(
        matching: widget.matching,
        appBloc: widget.mainContext.read<AppBloc>(),
        matchingRepository: context.read<MatchingRepository>(),
        userRepository: context.read<UserRepository>(),
      )..initialize(),
      child: BlocListener<MatchingDetailCubit, MatchingDetailState>(
        listener: (context, state) async {
          switch (state.matchingStatus) {
            case MatchingStatus.initial:
              break;
            case MatchingStatus.notEnoughMeeting:
              await DefaultDialog.show(
                context,
                title: "만남권이 부족합니다.",
                description: "만남권을 구매해주세요.",
                defaultButtonTitle: "확인",
              );
              Navigator.pop(context, true);
              break;
            case MatchingStatus.notFoundUser:
              await DefaultDialog.show(
                context,
                title: "탈퇴한 회원입니다.",
                defaultButtonTitle: "확인",
              );
              Navigator.pop(context, true);
              break;
            case MatchingStatus.unableUser:
              await DefaultDialog.show(
                context,
                title: "연결 될 수 없는 사용자입니다.",
                defaultButtonTitle: "확인",
              );
              Navigator.pop(context, true);
              break;
            case MatchingStatus.success:
              await ImageDialog.show(
                context,
                title: "프로포즈 전달 완료",
                defaultButtonTitle: "확인",
                imagePath: "photos/heart_photo",
                description:
                    "${widget.matching.fromCustomer?.customer?.name ?? "--"}님에게 프로포즈가 정상적으로\n전달되었습니다.",
              );
              Navigator.pop(context, true);
              Navigator.pop(context, true);
              break;
            case MatchingStatus.reject:
              Navigator.pop(context, true);
              break;
            case MatchingStatus.fail:
              break;
          }
        },
        child: BlocBuilder<MatchingDetailCubit, MatchingDetailState>(
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
                if ((widget.matching.proposeStatus ?? true) != false &&
                    !(widget.matching.autoReject ?? false)) ...[
                  BaseScaffoldDefaultButtonScheme(
                      title: "PASS",
                      color: mainMint,
                      onTap: () {
                        DefaultDialog.show(context,
                            title: "정말 PASS 하시겠습니까?",
                            description:
                                "PASS한 프로필은 프로포즈 신청할 수 없습니다.\nPASS된 프로필은 지난 추천 프로필 내역에서 확인하실 수 있습니다.",
                            onTap: () {
                          context.read<MatchingDetailCubit>().acceptCard(
                              proposeId: "${widget.matching.cardId!}",
                              accepted: false);
                        });
                      }),
                  BaseScaffoldDefaultButtonScheme(
                    color: darkBlue,
                    title: "프로포즈 신청",
                    onTap: () {
                      ImageDialog.show(context,
                          title: "프로포즈를 신청하시겠습니까?",
                          description:
                              "프로포즈를 상대방이 수락 후 실제 만남이 진행되면\n만남권이 1회 차감됩니다.\n또한, 만남이 종료될 때까지 새로운 매칭이 중지됩니다.",
                          imagePath: "photos/ring_photo", onTap: () {
                        context.read<MatchingDetailCubit>().acceptCard(
                            proposeId: "${widget.matching.cardId!}",
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
                  userProfile: widget.matching.fromCustomer,
                  matchingRate: widget.matching.matchingRate ?? 0,
                  compareTendency: state.compareTendency,
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
