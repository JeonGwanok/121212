
import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:oasis/enum/screen_status.dart';
import 'package:oasis/model/matching/last_matching.dart';
import 'package:oasis/model/user/user_profile.dart';
import 'package:oasis/repository/matching_repository.dart';
import 'package:oasis/repository/user_repository.dart';
import 'package:oasis/ui/common/base_scaffold.dart';
import 'package:oasis/ui/common/default_dialog.dart';
import 'package:oasis/ui/common/matching_profile/matching_user_detail/matching_user_detail_object.dart';
import 'package:oasis/ui/matching/last_matching_history/last_matching_detail/cubit/last_matching_detail_cubit.dart';
import 'package:oasis/ui/theme.dart';
import 'package:screen_capture_event/screen_capture_event.dart';

import 'cubit/last_matching_detail_state.dart';

class LastMatchingDetailScreen extends StatefulWidget {
  final LastMatching matching;
  LastMatchingDetailScreen({required this.matching});
  @override
  _LastMatchingDetailScreenState createState() =>
      _LastMatchingDetailScreenState();
}

class _LastMatchingDetailScreenState extends State<LastMatchingDetailScreen> {
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
      create: (BuildContext context) => LastMatchingDetailCubit(
        lastMatching: widget.matching,
        matchingRepository: context.read<MatchingRepository>(),
        userRepository: context.read<UserRepository>(),
      )..initialize(),
      child: BlocBuilder<LastMatchingDetailCubit, LastMatchingDetailState>(
        builder: (context, state) {
          return OverrapBaseScaffold(
            title: "",
            appbarColor: backgroundColor,
            backgroundColor: backgroundColor,
            showAppbarUnderline: false,
            onBack: () {
              Navigator.pop(context);
            },
            body: state.status != ScreenStatus.initial ? Container(
              width: double.infinity,
              height: double.infinity,
              child: MatchingUserDetailObject(
                userProfile: state.matching.fromCustomer ?? UserProfile.empty,
                matchingRate: state.matching.matchingRate ?? 0,
                compareTendency: state.compareTendency,
              ),
            ) : Container(),
          );
        },
      ),
    );
  }
}
