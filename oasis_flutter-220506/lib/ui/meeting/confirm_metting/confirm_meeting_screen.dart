import 'dart:async';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:naver_map_plugin/naver_map_plugin.dart';
import 'package:oasis/bloc/app/app_bloc.dart';
import 'package:oasis/enum/community/community.dart';
import 'package:oasis/enum/screen_status.dart';
import 'package:oasis/model/matching/meeting.dart';
import 'package:oasis/model/user/customer/customer.dart';
import 'package:oasis/model/user/user_profile.dart';
import 'package:oasis/repository/matching_repository.dart';
import 'package:oasis/repository/my_story_repository.dart';
import 'package:oasis/repository/user_repository.dart';
import 'package:oasis/ui/common/base_scaffold.dart';
import 'package:oasis/ui/common/custom_icon.dart';
import 'package:oasis/ui/common/default_dialog.dart';
import 'package:oasis/ui/common/default_small_button.dart';
import 'package:oasis/ui/common/illust.dart';
import 'package:oasis/ui/common/info_field.dart';
import 'package:oasis/ui/meeting/confirm_metting/cubit/confirm_meeting_cubit.dart';
import 'package:oasis/ui/my_page/my_status/component/user_status_card.dart';
import 'package:oasis/ui/my_story/my_story_main/my_story_screen.dart';
import 'package:oasis/ui/other_user_profile/sent_propose_profile_screen.dart';
import 'package:oasis/ui/recommend/recommend_main/recommend_main_screen.dart';
import 'package:oasis/ui/theme.dart';
import 'package:oasis/ui/util/date.dart';
import 'package:url_launcher/url_launcher.dart';
import 'cubit/confirm_meeting_state.dart';

class ConfirmMeetingScreen extends StatefulWidget {
  final BuildContext mainContext;
  ConfirmMeetingScreen({required this.mainContext});
  @override
  _ConfirmMeetingScreenState createState() => _ConfirmMeetingScreenState();
}

class _ConfirmMeetingScreenState extends State<ConfirmMeetingScreen> {
  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (BuildContext context) => ConfirmMeetingCubit(
        appBloc: widget.mainContext.read<AppBloc>(),
        matchingRepository: context.read<MatchingRepository>(),
        myStoryRepository: context.read<MyStoryRepository>(),
        userRepository: context.read<UserRepository>(),
      )..initialize(),
      child: BlocListener<ConfirmMeetingCubit, ConfirmMeetingState>(
        listener: (context, state) {},
        child: BlocBuilder<ConfirmMeetingCubit, ConfirmMeetingState>(
          builder: (context, state) {
            var ratio = MediaQuery.of(context).size.width / 414;
            return BaseScaffold(
              title: "",
              onBack: () {
                Navigator.pop(context);
              },
              onLoading: state.status == ScreenStatus.loading,
              backgroundColor: backgroundColor,
              body: Container(
                width: double.infinity,
                child: SingleChildScrollView(
                  child: Container(
                    padding: EdgeInsets.symmetric(horizontal: 16),
                    child: Column(
                      children: [
                        SizedBox(height: 20),
                        Container(
                          width: MediaQuery.of(context).size.width,
                          height: 114,
                          child: Stack(
                            children: <Widget>[
                              Positioned(
                                right: -165 * ratio,
                                child: Container(
                                  height: 114 * ratio,
                                  child: Image.asset(
                                    "assets/icons/meeting_confirm.png",
                                    fit: BoxFit.contain,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                        Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            _userStatusCard(
                              enabled: state.myStoryCount > 0,
                              customer: state.meeting?.myInfo?.customer,
                              imageUrl: state.user.image?.representative1 ?? "",
                            ),
                            SizedBox(width: 18),
                            GestureDetector(
                              onTap: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) =>
                                          OtherUserProfileScreen(
                                              mainContext: widget.mainContext,
                                              user: state.meeting?.loverInfo ??
                                                  UserProfile.empty)),
                                );
                              },
                              child: _userStatusCard(
                                enabled: state.partnerStoryCount > 0,
                                customer: state.meeting?.loverInfo?.customer,
                                imageUrl: state.meeting?.loverInfo?.image
                                        ?.representative1 ??
                                    "",
                              ),
                            ),
                          ],
                        ),
                        _dateCard(state.meeting),
                        SizedBox(
                            height: MediaQuery.of(context).padding.bottom + 30)
                      ],
                    ),
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }

  _userStatusCard(
      {required bool enabled,
      required Customer? customer,
      required String? imageUrl}) {
    var ratio = MediaQuery.of(context).size.width / 414;
    return Column(
      children: [
        UserStatusCard(
          customer: customer,
          imageUrl: imageUrl ?? "",
        ),
        SizedBox(height: 12),
        Container(
          width: 170 * ratio,
          child: DefaultSmallButton(
            title: "나의 일상",
            onTap: enabled
                ? () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => MyStoryScreen(
                          customerId: customer?.id,
                        ),
                      ),
                    );
                  }
                : null,
          ),
        )
      ],
    );
  }

  _dateCard(MeetingResponse? meeting) {
    var position = LatLng(double.parse(meeting?.meeting?.latlngX ?? "0"),
        double.parse(meeting?.meeting?.latlngY ?? "0"));

    if (markerImage01 != null) {
      marker = Marker(
        markerId: "marker",
        position: position,
        captionTextSize: 10.0,
        alpha: 0.8,
        captionOffset: 5,
        icon: markerImage01,
        anchor: AnchorPoint(0.5, 1),
        width: 30,
        height: 30,
      );
    }

    return Container(
      width: double.infinity,
      margin: EdgeInsets.only(top: 20),
      padding: EdgeInsets.symmetric(vertical: 16, horizontal: 16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8),
        boxShadow: cardShadow,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            '데이트 일정',
            style: header02.copyWith(color: gray900),
          ),
          SizedBox(height: 20),
          InfoField(
              title: "만남 시간",
              titleWidth: 75,
              value: meeting?.meeting?.utcDate != null
                  ? "${DateFormat("yyyy년 MM월 dd일").format(meeting?.meeting?.utcDate ?? DateTime.now())} (${getWeekKorean((meeting?.meeting?.utcDate ?? DateTime.now()).weekday)}) ${DateFormat("hh시").format(meeting?.meeting?.utcDate ?? DateTime.now())}"
                  : "--"),
          SizedBox(height: 8),
          InfoField(
              title: "날씨 정보",
              titleWidth: 75,
              value: meeting?.weather != null ? "${meeting?.weather}" : "--"),
          SizedBox(height: 8),
          InfoField(
              title: "만남 장소",
              titleWidth: 75,
              maxLines: 2,
              value: meeting?.meeting?.location ?? "--"),
          SizedBox(height: 20),
          if (position.latitude != 0)
            Column(crossAxisAlignment: CrossAxisAlignment.end, children: [
              GestureDetector(
                onTap: () async {
                  var bundleId = "com.nisoft.oasis";

                  if (Platform.isIOS) {
                    bundleId = "com.example.oasis";
                  }

                  var url = (Uri.encodeFull(
                          "nmap://place?lat=${position.latitude}&lng=${position.longitude}&name=${(meeting?.meeting?.buildingName ?? "")}&appname=$bundleId")
                      .replaceAll(" ", ""));

                  print(url);
                  var enableUrl = await canLaunch(url);
                  if (enableUrl) {
                    try {
                      await launch(url);
                    } catch (err) {
                      DefaultDialog.show(context,
                          title: "잘못된 주소 입니다.", defaultButtonTitle: "확인");
                    }
                  } else {
                    DefaultDialog.show(context,
                        title: "네이버지도 어플을 실행해주세요.", defaultButtonTitle: "확인");
                  }
                },
                child: Text(
                  '상세보기',
                  style: body01.copyWith(color: mainMint),
                ),
              ),
              SizedBox(height: 12),
              Container(
                width: double.infinity,
                height: 200,
                child: NaverMap(
                  onMapCreated: _onMapCreated,
                  initialCameraPosition: CameraPosition(target: position),
                  markers: marker != null ? [marker!] : [],
                ),
              ),
            ]),
          SizedBox(height: 12),
          Row(
            children: [
              Expanded(
                child: DefaultSmallButton(
                  title: "추천 코디",
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => RecommendMainScreen(
                                type: CommunityType.stylist,
                                subType: CommunitySubType.season,
                                meetingId: meeting?.meeting?.id ?? 0,
                              )),
                    );
                  },
                ),
              ),
              SizedBox(width: 12),
              Expanded(
                child: DefaultSmallButton(
                  title: "맛집 추천",
                  reverse: true,
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => RecommendMainScreen(
                                type: CommunityType.date,
                                subType: CommunitySubType.place,
                                meetingId: meeting?.meeting?.id ?? 0,
                              )),
                    );
                  },
                ),
              ),
            ],
          )
        ],
      ),
    );
  }

  OverlayImage? markerImage01;
  Marker? marker;
  @override
  void initState() {
    WidgetsBinding.instance!.addPostFrameCallback((_) {
      OverlayImage.fromAssetImage(
        assetName: "assets/icons/marker.png",
      ).then((image) {
        markerImage01 = image;
        setState(() {});
      });
    });
    super.initState();
  }

  late NaverMapController _naverMapController;
  Completer<NaverMapController> _controller = Completer();

  void _onMapCreated(NaverMapController controller) async {
    _controller.complete(controller);
    _naverMapController = controller;
  }

  @override
  void dispose() {
    _naverMapController.clearMapView();
    super.dispose();
  }
}
