import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:oasis/bloc/community/bloc.dart';
import 'package:oasis/enum/community/community.dart';
import 'package:oasis/model/community/community_main/date.dart';
import 'package:oasis/model/community/community_main/love.dart';
import 'package:oasis/model/community/community_main/marry.dart';
import 'package:oasis/model/community/community_main/stylist.dart';
import 'package:oasis/model/community/community_simple.dart';
import 'package:oasis/repository/community_repository.dart';
import 'package:oasis/ui/common/base_scaffold.dart';
import 'package:oasis/ui/common/cache_image.dart';
import 'package:oasis/ui/common/default_small_button.dart';
import 'package:oasis/ui/common/search_bar.dart';
import 'package:oasis/ui/community/community_detail/commnuity_detail_screen.dart';
import 'package:oasis/ui/community/community_main/cubit/community_main_state.dart';
import 'package:oasis/ui/community/community_main_more/community_main_more_screen.dart';
import 'package:oasis/ui/community/community_write/community_write_screen.dart';
import 'package:oasis/ui/theme.dart';

import 'cubit/community_main_cubit.dart';

class CommunityMainScreen extends StatefulWidget {
  final CommunityType type;
  final int? customerId;
  CommunityMainScreen({required this.type, this.customerId});

  @override
  _CommunityMainScreenState createState() => _CommunityMainScreenState();
}

class _CommunityMainScreenState extends State<CommunityMainScreen> {

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
            create: (BuildContext context) => CommunityMainCubit(
              communityRepository: context.read<CommunityRepository>(),
              communityBloc: communityContext.read<CommunityBloc>(),
              customerId:widget.customerId,
              type: widget.type,
            )..initialize(),
            child: BlocBuilder<CommunityMainCubit, CommunityMainState>(
              builder: (context, state) {
                List<Widget> items = [];
                if (state.communityMain != null) {
                  switch (widget.type) {
                    case CommunityType.stylist:
                      CommunityStylist result =
                          state.communityMain! as CommunityStylist;
                      for (var item in widget.type.subs) {
                        switch (item) {
                          case CommunitySubType.man:
                            items
                                .add(_tile(type: item, items: result.manStyle));
                            break;
                          case CommunitySubType.woman:
                            items
                                .add(_tile(type: item, items: result.womanStyle));
                            break;
                          case CommunitySubType.season:
                            items
                                .add(_tile(type: item, items: result.seasonStyle));
                            break;
                          default:
                            break;
                        }
                      }
                      break;
                    case CommunityType.date:
                      CommunityDate result =
                          state.communityMain! as CommunityDate;
                      for (var item in widget.type.subs) {
                        switch (item) {
                          case CommunitySubType.restaurant:
                            items.add(_tile(
                                type: item, items: result.famousRestaurant));
                            break;
                          case CommunitySubType.drive:
                            items.add(_tile(type: item, items: result.drive));
                            break;
                          case CommunitySubType.place:
                            items
                                .add(_tile(type: item, items: result.hotPlace));
                            break;
                          case CommunitySubType.gift:
                            items.add(_tile(type: item, items: result.gift));
                            break;
                          default:
                            break;
                        }
                      }
                      break;
                    case CommunityType.love:
                      CommunityLove result =
                          state.communityMain! as CommunityLove;
                      for (var item in widget.type.subs) {
                        switch (item) {
                          case CommunitySubType.tip:
                            items.add(_tile(type: item, items: result.loveTip));
                            break;
                          case CommunitySubType.psychology:
                            items.add(_tile(
                                type: item, items: result.lovePsychology));
                            break;
                          case CommunitySubType.relationship:
                            items.add(_tile(
                                type: item, items: result.loveRelationship));
                            break;
                          default:
                            break;
                        }
                      }
                      break;
                    case CommunityType.marry:
                      CommunityMarry result =
                          state.communityMain! as CommunityMarry;
                      for (var item in widget.type.subs) {
                        switch (item) {
                          case CommunitySubType.preparation:
                            items.add(_tile(
                                type: item, items: result.marryPreparation));
                            break;
                          case CommunitySubType.dowry:
                            items.add(_tile(type: item, items: result.dowry));
                            break;
                          case CommunitySubType.house:
                            items.add(
                                _tile(type: item, items: result.newlywedHouse));
                            break;
                          case CommunitySubType.loan:
                            items.add(_tile(type: item, items: result.loan));
                            break;
                          default:
                            break;
                        }
                      }
                      break;
                  }
                }

                return BaseScaffold(
                  title: "",
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
                          SearchBar(
                            title: "${widget.customerId != null ? "내가 작성한" : ""} ${widget.type.title}",
                            searchItems: [
                              SearchSortType.nickName,
                              SearchSortType.tag,
                            ],
                            searchText: state.searchText, // 적는 의미 없음
                            searchType: state.searchSortType,
                            onChangeType: (type) {
                              context
                                  .read<CommunityMainCubit>()
                                  .changeSearchType(type);
                            },
                            onChangeText: (text) {
                              context
                                  .read<CommunityMainCubit>()
                                  .changeSearchText(text);
                            },
                            onSearch: () {
                              context.read<CommunityMainCubit>().initialize();
                            },
                            action: Container(
                              height: 44,
                              child: DefaultSmallButton(
                                title: "글 작성",
                                fontSize: 12,
                                reverse: true,
                                onTap: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) =>
                                          CommunityWriteScreen(
                                            communityContext: communityContext,
                                        type: widget.type.subs.first,
                                      ),
                                    ),
                                  );
                                },
                                showShadow: true,
                                hideBorder: true,
                              ),
                            ),
                          ),
                          SizedBox(height: 32),
                          ...items,
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

  _tile({
    required CommunitySubType type,
    required List<CommunitySimple> items,
  }) {
    return Column(
      children: [
      Container(child:   Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              type.title,
              style: header02.copyWith(color: gray900),
            ),
            Container(
              height: 44,
              child: DefaultSmallButton(
                title: "더보기",
                fontSize: 12,
                reverse: true,
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => CommunityMainMoreScreen(
                        communityContext: communityContext!,
                        customerId:widget.customerId,
                        type: type,
                      ),
                    ),
                  );
                },
                showShadow: true,
                hideBorder: true,
              ),
            )
          ],
        ),),
        SizedBox(height: 12),
        Container(
          width: double.infinity,
          height: 132,
          child: SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              children: [
                ...items.map(
                  (e) => GestureDetector(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => CommunityDetailScreen(
                            communityContext: communityContext!,
                            customerId:widget.customerId,
                            type: type,
                            communityId: e.communityId!,
                          ),
                        ),
                      );
                    },
                    child: Container(
                      margin: EdgeInsets.only(right: 16),
                      child: AspectRatio(
                        aspectRatio: 1,
                        child: Container(
                          clipBehavior: Clip.antiAlias,
                          decoration: BoxDecoration(
                              boxShadow: cardShadow,
                              color: backgroundColor,
                              border: Border.all(color: Colors.white),
                              borderRadius: BorderRadius.circular(8)),
                          child: CacheImage(
                            url: e.image ?? "",
                            boxFit: BoxFit.cover,
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
        SizedBox(height: 24),
      ],
    );
  }
}
