import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:oasis/enum/community/community.dart';
import 'package:oasis/model/user/opti/user_mbti_main.dart';
import 'package:oasis/model/user/user_profile.dart';
import 'package:oasis/ui/common/default_dialog.dart';
import 'package:oasis/ui/common/info_field.dart';
import 'package:oasis/ui/community/community_main/community_main_screen.dart';
import 'package:oasis/ui/couple_story/couple_story_main/couple_story_main_screen.dart';
import 'package:oasis/ui/home/component/community_tile.dart';
import 'package:oasis/ui/home/component/home_button_frame.dart';
import 'package:oasis/ui/my_page/my_partner_info/my_partner_info_screen.dart';
import 'package:oasis/ui/my_page/my_temper_result/my_temper_result_screen.dart';
import 'package:oasis/ui/my_story/my_story_main/my_story_screen.dart';
import 'package:oasis/ui/theme.dart';

class HomeContentObject extends StatefulWidget {
  final UserProfile userProfile;
  final UserMBTIMain userMBTIMain;
  final String loverCities; // 서버에서 지역정보 가져와야해서..
  final String loverWorkCities;
  HomeContentObject({
    required this.userProfile,
    required this.loverCities,
    required this.loverWorkCities,
    required this.userMBTIMain,
  });
  @override
  _HomeContentObjectState createState() => _HomeContentObjectState();
}

class _HomeContentObjectState extends State<HomeContentObject> {
  @override
  Widget build(BuildContext context) {
    var profile = widget.userProfile.profile;

    return Container(
      child: Column(
        children: [
          Container(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                HomeButtonFrame(
                  title: "내 성향",
                  onMore: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => TemperResultScreen(),
                      ),
                    );
                  },
                  body: Container(
                    child: Text(
                      widget.userMBTIMain.myTendency ?? "",
                      style: body02.copyWith(color: gray600),
                    ),
                  ),
                ),
                SizedBox(height: 16),
                HomeButtonFrame(
                  title: "내가 바라는 이상형",
                  moreTitle: "상세보기",
                  onMore: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (_) =>
                                RegisterPartnerInfoScreen(context)));
                  },
                  body: Container(
                    child: Column(
                      children: [
                        Row(
                          children: [
                            Expanded(
                                child: InfoField(
                                    title: "거주지역",
                                    value: widget.loverCities
                                        .replaceAll("(", "")
                                        .replaceAll(")", ""))),
                            SizedBox(width: 8),
                            Expanded(
                                child: InfoField(
                                    title: "직장지역",
                                    value: widget.loverWorkCities
                                        .replaceAll("(", "")
                                        .replaceAll(")", "")))
                          ],
                        ),
                        SizedBox(height: 8),
                        Row(
                          children: [
                            Expanded(
                                child: InfoField(
                                    title: "나이",
                                    value:
                                        "${profile?.loverAgeStart}세 ~ ${profile?.loverAgeEnd}세")),
                            SizedBox(width: 8),
                            Expanded(
                                child: InfoField(
                                    title: "키",
                                    value:
                                        "${profile?.loverHeightStart} ~ ${profile?.loverHeightEnd}cm"))
                          ],
                        ),
                        SizedBox(height: 8),
                        Row(
                          children: [
                            Expanded(
                                child: InfoField(
                                    title: "혼인",
                                    value: "${profile?.loverMarriage}")),
                            SizedBox(width: 8),
                            Expanded(
                                child: InfoField(
                                    title: "자녀",
                                    value:
                                        "${!(profile?.loverChildren ?? false) ? "없어야함" : "관계없음"}"))
                          ],
                        ),
                        SizedBox(height: 8),
                        Row(
                          children: [
                            Expanded(
                                child: InfoField(
                                    title: "종교",
                                    value: "${profile?.loverReligion}")),
                            SizedBox(width: 8),
                            Expanded(
                                child: InfoField(
                                    title: "학력",
                                    value: "${profile?.loverAcademic}")),
                          ],
                        )
                      ],
                    ),
                  ),
                ),
                SizedBox(height: 16),
                HomeButtonFrame(
                  title: "일상 공유",
                  titleBottomPadding: 8,
                  isMoreIcon: true,
                  onMore: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => MyStoryScreen(),
                      ),
                    );
                  },
                  body: Container(
                    child: Text(
                      '멋진 일상을 공유해보세요!',
                      style: body02.copyWith(color: gray600),
                    ),
                  ),
                ),
                // SizedBox(height: 16),
                // HomeButtonFrame(
                //   title: "연애 ・ 결혼 이야기",
                //   isMoreIcon: true,
                //   titleBottomPadding: 8,
                //   onMore: () {
                //     Navigator.push(
                //       context,
                //       MaterialPageRoute(
                //         builder: (context) => CoupleStoryMainScreen(),
                //       ),
                //     );
                //   },
                //   body: Container(
                //     child: Text(
                //       '이야기를 들려주세요!',
                //       style: body02.copyWith(color: gray600),
                //     ),
                //   ),
                // ),
                SizedBox(height: 16),
                HomeButtonFrame(
                  title: "정보 커뮤니티",
                  titleBottomPadding: 25,
                  body: Container(
                    width: double.infinity,
                    height: 165,
                    child: SingleChildScrollView(
                      // clipBehavior: Clip.none,
                      scrollDirection: Axis.horizontal,
                      child: Row(
                        children: [
                          CommunityTile(
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => CommunityMainScreen(
                                    type: CommunityType.stylist,
                                  ),
                                ),
                              );
                            },
                            iconPath: "icons/clothes",
                            title: "코디",
                            tags: ["#남자코디", "#여자코디", "#시즌별"],
                          ),
                          CommunityTile(
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => CommunityMainScreen(
                                    type: CommunityType.date,
                                  ),
                                ),
                              );
                            },
                            iconPath: "icons/date",
                            title: "데이트",
                            tags: ["#맛집", "#드라이브", "#핫플레이스", "#선물"],
                          ),
                          CommunityTile(
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => CommunityMainScreen(
                                    type: CommunityType.love,
                                  ),
                                ),
                              );
                            },
                            iconPath: "icons/couple",
                            title: "연애",
                            tags: ["#연애팁", "#연애심리", "#관계개선"],
                          ),
                          CommunityTile(
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => CommunityMainScreen(
                                    type: CommunityType.marry,
                                  ),
                                ),
                              );
                            },
                            iconPath: "icons/ring",
                            title: "결혼",
                            tags: ["#결혼준비", "#혼수", "#신혼집", "#대출"],
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
                SizedBox(height: 20),
              ],
            ),
          )
        ],
      ),
    );
  }
}
