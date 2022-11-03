import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:oasis/model/opti/compare_tendency.dart';
import 'package:oasis/model/user/user_profile.dart';
import 'package:oasis/repository/matching_repository.dart';
import 'package:oasis/repository/user_repository.dart';
import 'package:oasis/ui/common/info/user_image_set_object.dart';
import 'package:oasis/ui/common/info/user_info_set_object/user_info_set_object.dart';
import 'package:oasis/ui/common/info/user_text_info_set_object.dart';
import 'package:oasis/ui/common/matching_profile/matching_profile_mbti/matching_user_mbti_detail_object.dart';
import 'package:oasis/ui/theme.dart';

import 'cubit/matching_user_detail_object_cubit.dart';
import 'cubit/matching_user_detail_object_state.dart';

class MatchingUserDetailObject extends StatefulWidget {
  final UserProfile? userProfile;
  final CompareTendency? compareTendency;
  final int? matchingRate;
  MatchingUserDetailObject({
    required this.userProfile,
     this.matchingRate,
    required this.compareTendency,
  });

  @override
  _MatchingUserDetailObjectState createState() =>
      _MatchingUserDetailObjectState();
}

enum MatchingDetailType {
  profile,
  tendency,
}

class _MatchingUserDetailObjectState extends State<MatchingUserDetailObject> {
  MatchingDetailType type = MatchingDetailType.profile;

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (BuildContext context) => MatchingUserDetailObjectCubit(
        matchingRepository: context.read<MatchingRepository>(),
        userRepository: context.read<UserRepository>(),
      )..initialize(),
      child: BlocBuilder<MatchingUserDetailObjectCubit,
          MatchingUserDetailObjectState>(
        builder: (context, state) {
          return Container(
            child: SingleChildScrollView(
              child: Column(
                children: [
                  UserImageSetObject(
                    userImage: widget.userProfile?.image,
                    matchingRate: widget.matchingRate,
                  ),
                  SizedBox(height: 20),
                  Stack(
                    children: [
                      Column(
                        children: [
                          Container(
                            padding: EdgeInsets.symmetric(horizontal: 16),
                            child: Row(
                              children: [
                                Expanded(
                                  child: GestureDetector(
                                    onTap: () {
                                      setState(() {
                                        type = MatchingDetailType.profile;
                                      });
                                    },
                                    child: Container(
                                      height: 65,
                                      alignment: Alignment.center,
                                      decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(8),
                                        boxShadow:
                                            type == MatchingDetailType.profile
                                                ? cardShadow
                                                : null,
                                        color:
                                            type == MatchingDetailType.profile
                                                ? Colors.white
                                                : Colors.transparent,
                                      ),
                                      child: Container(
                                        margin: EdgeInsets.only(bottom: 10),
                                        child: Text(
                                          '${widget.userProfile?.customer?.nickName ?? "--"}님의 프로필',
                                          style: header02.copyWith(
                                              fontFamily: "Godo",
                                              color: type !=
                                                      MatchingDetailType.profile
                                                  ? Colors.black
                                                      .withOpacity(0.3)
                                                  : Colors.black),
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                                Expanded(
                                  child: GestureDetector(
                                    onTap: () {
                                      setState(() {
                                        type = MatchingDetailType.tendency;
                                      });
                                    },
                                    child: Container(
                                      height: 65,
                                      alignment: Alignment.center,
                                      decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(8),
                                        boxShadow:
                                            type != MatchingDetailType.profile
                                                ? cardShadow
                                                : null,
                                        color:
                                            type != MatchingDetailType.profile
                                                ? Colors.white
                                                : Colors.transparent,
                                      ),
                                      child: Container(
                                        margin: EdgeInsets.only(bottom: 10),
                                        child: Text(
                                          '${widget.userProfile?.customer?.nickName ?? "--"}님의 성향분석',
                                          style: header02.copyWith(
                                              fontFamily: "Godo",
                                              color: type ==
                                                      MatchingDetailType.profile
                                                  ? Colors.black
                                                      .withOpacity(0.3)
                                                  : Colors.black),
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                          if (type != MatchingDetailType.profile)
                            MatchingUserMBTIDetailObject(
                              userProfile:
                                  widget.userProfile ?? UserProfile.empty,
                              compareTendency: widget.compareTendency ??
                                  CompareTendency.empty,
                            ),
                          if (type == MatchingDetailType.profile)
                            Container(
                              padding: EdgeInsets.symmetric(horizontal: 16),
                              child: Column(
                                children: [
                                  Container(
                                    decoration: BoxDecoration(
                                      color: Colors.white,
                                      borderRadius: BorderRadius.circular(8),
                                      boxShadow: cardShadow,
                                    ),
                                    padding: EdgeInsets.symmetric(
                                        horizontal: 16, vertical: 12),
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        UserInfoSetObject(
                                          certificate: state.certificate,
                                          user: widget.userProfile ??
                                              UserProfile.empty,
                                        ),
                                      ],
                                    ),
                                  ),
                                  SizedBox(height: 16),
                                  Container(
                                    decoration: BoxDecoration(
                                      color: Colors.white,
                                      borderRadius: BorderRadius.circular(8),
                                      boxShadow: cardShadow,
                                    ),
                                    padding: EdgeInsets.symmetric(
                                        horizontal: 16, vertical: 12),
                                    child: UserTextInfoSetObject(
                                      user: widget.userProfile ??
                                          UserProfile.empty,
                                    ),
                                  ),
                                  SizedBox(height: 16),
                                ],
                              ),
                            )
                        ],
                      ),
                      Container(
                        margin: EdgeInsets.only(top: 65 - 10),
                        padding: EdgeInsets.symmetric(horizontal: 16),
                        child: Row(
                          children: [
                            Expanded(
                              child: Container(
                                height: 20,
                                color: Colors.white,
                              ),
                            ),
                            Expanded(
                              child: Container(
                                height: 20,
                                color: Colors.white,
                              ),
                            ),
                          ],
                        ),
                      )
                    ],
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
