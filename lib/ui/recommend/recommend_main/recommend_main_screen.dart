import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:oasis/bloc/community/bloc.dart';
import 'package:oasis/enum/community/community.dart';
import 'package:oasis/enum/screen_status.dart';
import 'package:oasis/model/community/community.dart';
import 'package:oasis/repository/matching_repository.dart';
import 'package:oasis/repository/user_repository.dart';
import 'package:oasis/ui/common/base_scaffold.dart';
import 'package:oasis/ui/common/custom_icon.dart';
import 'package:oasis/ui/community/community_detail/commnuity_detail_screen.dart';
import 'package:oasis/ui/community/community_main_more/component/community_main_more_tile.dart';
import 'package:oasis/ui/recommend/recommend_main/cubit/recommend_main_cubit.dart';
import 'package:oasis/ui/theme.dart';

import 'cubit/recommend_main_state.dart';

class RecommendMainScreen extends StatefulWidget {
  final int meetingId;
  final CommunitySubType subType;
  final CommunityType type;
  RecommendMainScreen({
    required this.type,
    required this.subType,
    required this.meetingId,
  });

  @override
  _RecommendMainScreenState createState() => _RecommendMainScreenState();
}

class _RecommendMainScreenState extends State<RecommendMainScreen> {

  BuildContext? communityContext;

  @override
  Widget build(BuildContext context) {
    return BlocProvider<CommunityBloc>(
      create: (context) => CommunityBloc(),
      child: BlocBuilder<CommunityBloc, CommunityState>(
        builder: (communityContext, state) {
          if (this.communityContext == null) {
            this.communityContext = communityContext;
          }

          return BlocProvider(
            create: (BuildContext context) => RecommendMainCubit(
              userRepository: context.read<UserRepository>(),
              matchingRepository: context.read<MatchingRepository>(),
              type: widget.type,
              communityBloc: context.read<CommunityBloc>(),
              meetingId: widget.meetingId,
            )..initialize(),
            child: BlocBuilder<RecommendMainCubit, RecommendMainState>(
              builder: (context, state) {
                return BaseScaffold(
                  title: "",
                  onLoading: state.status == ScreenStatus.loading,
                  backgroundColor: backgroundColor,
                  onBack: () {
                    Navigator.pop(context);
                  },
                  body: Container(
                    width: double.infinity,
                    padding: EdgeInsets.symmetric(horizontal: 16),
                    child: SingleChildScrollView(
                      child: Column(
                        children: [
                          SizedBox(height: 24),
                          Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Row(
                                      children: [
                                        Text(
                                          '${state.user.customer?.nickName ?? "---"}님',
                                          style:
                                              header02.copyWith(color: gray900),
                                        ),
                                        Text(
                                          '을',
                                          style:
                                              header02.copyWith(color: gray400),
                                        ),
                                      ],
                                    ),
                                    Text(
                                      widget.type == CommunityType.stylist
                                          ? '위한 맞춤 코디 제안'
                                          : "위한 맞춤 맛집 제안",
                                      style: header02.copyWith(color: gray400),
                                    ),
                                  ],
                                ),
                                GestureDetector(
                                  onTap: () {
                                    context
                                        .read<RecommendMainCubit>()
                                        .initialize();
                                  },
                                  child: Container(
                                    width: 44,
                                    height: 44,
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(8),
                                      color: Colors.white,
                                      boxShadow: cardShadow,
                                    ),
                                    alignment: Alignment.center,
                                    child: CustomIcon(
                                      path: "icons/refresh",
                                      width: 32,
                                      height: 32,
                                    ),
                                  ),
                                )
                              ]),
                          SizedBox(height: 24),
                          if ((state.items ?? []).isEmpty)
                            Container(
                              height: 100,
                              width: double.infinity,
                              alignment: Alignment.center,
                              child: Text(
                                '게시글이 없습니다.',
                                style: header02.copyWith(color: gray300),
                              ),
                            ),
                          ...List.generate(
                                  ((state.items ?? []).length / 2).ceil(),
                                  (idx) =>
                                      _tileRow(context, state.items ?? [], idx))
                              .toList(),
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
          );
        },
      ),
    );
  }

  Widget _tileRow(
    BuildContext context,
    List<CommunityResponseItem> items,
    int idx,
  ) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 10),
      child: Row(
        children: [
          Expanded(
            child: CommunityMainMoreTile(
              type: widget.type,
              onTap: () async {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => CommunityDetailScreen(
                      communityContext: communityContext!,
                      customerId: null,
                      communityId: items[idx * 2].community?.id ?? 0,
                      type: widget.subType,
                    ),
                  ),
                );
              },
              item: items[idx * 2],
            ),
          ),
          SizedBox(width: 18),
          Expanded(
            child: (idx * 2 + 1 < items.length)
                ? CommunityMainMoreTile(
                    type: widget.type,
                    onTap: () async {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => CommunityDetailScreen(
                            communityContext: communityContext!,
                            communityId: items[idx * 2 + 1].community?.id ?? 0,
                            type: widget.subType,
                            customerId: null,
                          ),
                        ),
                      );
                    },
                    item: items[idx * 2 + 1],
                  )
                : Container(),
          ),
        ],
      ),
    );
  }
}
