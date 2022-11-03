import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:oasis/bloc/app/app_bloc.dart';
import 'package:oasis/model/user/user_profile.dart';
import 'package:oasis/repository/user_repository.dart';
import 'package:oasis/ui/common/base_scaffold.dart';
import 'package:oasis/ui/common/default_dialog.dart';
import 'package:oasis/ui/common/matching_profile/matching_user_detail/matching_user_detail_object.dart';
import 'package:oasis/ui/other_user_profile/cubit/other_user_profile_cubit.dart';
import 'package:oasis/ui/theme.dart';
import 'package:screen_capture_event/screen_capture_event.dart';

import 'cubit/other_user_profile_state.dart';

class OtherUserProfileScreen extends StatefulWidget {
  final BuildContext mainContext;
  final UserProfile user;
  OtherUserProfileScreen({required this.mainContext, required this.user});
  @override
  _OtherUserProfileScreenState createState() => _OtherUserProfileScreenState();
}

class _OtherUserProfileScreenState extends State<OtherUserProfileScreen> {
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
      create: (BuildContext context) => OtherUserProfileCubit(
        appBloc: widget.mainContext.read<AppBloc>(),
        userRepository: context.read<UserRepository>(),
        user: widget.user,
      )..initialize(),
      child: BlocListener<OtherUserProfileCubit, OtherUserProfileState>(
        listener: (context, state) async {},
        child: BlocBuilder<OtherUserProfileCubit, OtherUserProfileState>(
          builder: (context, state) {
            return OverrapBaseScaffold(
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
                child: MatchingUserDetailObject(
                  userProfile: widget.user,
                  // matchingRate: widget.propose.matchingRate ?? 0,
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
