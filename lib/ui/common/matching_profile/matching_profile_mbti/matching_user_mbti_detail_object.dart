import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:oasis/model/opti/compare_tendency.dart';
import 'package:oasis/model/user/user_profile.dart';
import 'package:oasis/repository/common_repository.dart';
import 'package:oasis/ui/common/matching_profile/matching_profile_mbti/cubit/matching_user_detail_object_state.dart';
import 'package:oasis/ui/theme.dart';

import 'cubit/matching_user_detail_object_cubit.dart';

class MatchingUserMBTIDetailObject extends StatefulWidget {
  final UserProfile userProfile;
  final CompareTendency compareTendency;

  MatchingUserMBTIDetailObject({
    required this.userProfile,
    required this.compareTendency,
  });

  @override
  _MatchingUserMBTIDetailObjectState createState() =>
      _MatchingUserMBTIDetailObjectState();
}

enum MatchingDetailType {
  profile,
  tendency,
}

class _MatchingUserMBTIDetailObjectState
    extends State<MatchingUserMBTIDetailObject> {
  MatchingDetailType type = MatchingDetailType.profile;

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (BuildContext context) => MatchingUserMBTIDetailCubit(
        commonRepository: context.read<CommonRepository>(),
      )..initialize(),
      child:
          BlocBuilder<MatchingUserMBTIDetailCubit, MatchingUserMBTIDetailState>(
        builder: (context, state) {
          return Container(
            child: SingleChildScrollView(
              child: Column(
                children: [
                  Container(
                    margin: EdgeInsets.symmetric(horizontal: 16),
                    padding: EdgeInsets.all(16),
                    decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(8),
                        boxShadow: cardShadow),
                    child: Column(
                      children: [
                        Row(
                          children: [
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  children: [
                                    Container(
                                      width: 130,
                                      child: Text(
                                        '나의 연애 MBTI',
                                        style: header02.copyWith(
                                            fontFamily: "Godo"),
                                      ),
                                    ),
                                    Text(
                                      widget.compareTendency.tendencyCompare
                                              ?.myMbti ??
                                          "--",
                                      style: header02.copyWith(
                                          color: mainMint, fontFamily: "Godo"),
                                    ),
                                  ],
                                ),
                                SizedBox(height: 12),
                                Row(
                                  children: [
                                    Container(
                                      width: 130,
                                      child: Text('상대의 연애 MBTI',
                                          style: header02.copyWith(
                                              fontFamily: "Godo")),
                                    ),
                                    Text(
                                      widget.compareTendency.tendencyCompare
                                              ?.loverMbti ??
                                          "--",
                                      style: header02.copyWith(
                                          color: mainMint, fontFamily: "Godo"),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                            SizedBox(width: 15),
                            Expanded(
                              child: Container(
                                alignment: Alignment.center,
                                child: Text(
                                  widget.compareTendency.tendencyCompare
                                          ?.compatibility ??
                                      "--",
                                  style: header02.copyWith(fontFamily: "Godo",color: heartRed,),
                                ),
                              ),
                            )
                          ],
                        ),
                        SizedBox(height: 29),
                        Text(
                          widget.compareTendency.tendencyCompare?.explain ??
                              "--",
                          style: body01.copyWith(color: gray600),
                        )
                      ],
                    ),
                  ),
                  SizedBox(height: 16),
                  Container(
                    margin: EdgeInsets.symmetric(horizontal: 16),
                    width: double.infinity,
                    padding: EdgeInsets.all(16),
                    decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(8),
                        boxShadow: cardShadow),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          '생활 성향 검사',
                          style: header02,
                        ),
                        Column(
                          children: [
                            ...widget.compareTendency.tendencyAnswer
                                .map(
                                  (e) => Container(
                                    margin: EdgeInsets.symmetric(vertical: 4),
                                    padding: EdgeInsets.symmetric(
                                        vertical: 9, horizontal: 12),
                                    decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(8),
                                        border:
                                            Border.all(color: backgroundColor)),
                                    child: Row(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Expanded(
                                          child: Row(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              Text(
                                                "Q${e.numbering}",
                                                style: body01.copyWith(
                                                    color: gray600),
                                              ),
                                              Expanded(
                                                child: Container(
                                                    padding:
                                                        EdgeInsets.symmetric(
                                                            horizontal: 8),
                                                    child: Text(
                                                      state
                                                              .tendencies[
                                                                  e.numbering]
                                                              ?.question ??
                                                          "--",
                                                      style: body01.copyWith(
                                                          color: gray600),
                                                    )),
                                              ),
                                            ],
                                          ),
                                        ),
                                        Text(
                                          (e.answer ?? false) ? "O" : "X",
                                          style:
                                              body01.copyWith(color: gray600),
                                        ),
                                      ],
                                    ),
                                  ),
                                )
                                .toList(),
                          ],
                        )
                      ],
                    ),
                  ),
                  SizedBox(height: 16),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
