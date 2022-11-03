import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:oasis/bloc/community/bloc.dart';
import 'package:oasis/enum/community/community.dart';
import 'package:oasis/model/community/community.dart';
import 'package:oasis/repository/community_repository.dart';
import 'package:oasis/ui/common/base_scaffold.dart';
import 'package:oasis/ui/common/search_bar.dart';
import 'package:oasis/ui/community/community_detail/commnuity_detail_screen.dart';
import 'package:oasis/ui/community/community_main_more/component/community_main_more_tile.dart';
import 'package:oasis/ui/community/community_main_more/cubit/community_main_more_cubit.dart';
import 'package:oasis/ui/theme.dart';

import 'cubit/community_main_more_state.dart';

class CommunityMainMoreScreen extends StatefulWidget {
  final BuildContext communityContext;
  final int? customerId;
  final CommunitySubType type;
  CommunityMainMoreScreen({required this.communityContext, required this.type, required this.customerId,});

  @override
  _CommunityMainMoreScreenState createState() =>
      _CommunityMainMoreScreenState();
}

class _CommunityMainMoreScreenState extends State<CommunityMainMoreScreen> {
  late ScrollController controller;
  @override
  void initState() {
    super.initState();
    controller = ScrollController()
      ..addListener(() {
        pagination();
      });
  }

  void pagination() {
    if ((controller.position.pixels == controller.position.maxScrollExtent)) {
      _context?.read<CommunityMainMoreCubit>().pagination();
    }
  }

  BuildContext? _context;

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (BuildContext context) => CommunityMainMoreCubit(
        communityRepository: context.read<CommunityRepository>(),
        type: widget.type,
          customerId:widget.customerId,
        communityBloc: widget.communityContext.read<CommunityBloc>(),
      )..initialize(),
      child: BlocBuilder<CommunityMainMoreCubit, CommunityMainMoreState>(
        builder: (context, state) {
          _context = context;
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
                controller: controller,
                child: Column(
                  children: [
                    SizedBox(height: 24),
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
                            .read<CommunityMainMoreCubit>()
                            .changeSearchType(type);
                      },
                      onChangeText: (text) {
                        context
                            .read<CommunityMainMoreCubit>()
                            .changeSearchText(text);
                      },
                      onSearch: () {
                        context.read<CommunityMainMoreCubit>().initialize();
                      },
                    ),
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
                    ...List.generate(((state.items ?? []).length / 2).ceil(),
                            (idx) => _tileRow(context, state.items ?? [], idx))
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
              type: widget.type.parent,
              onTap: () async {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => CommunityDetailScreen(
                      communityContext: widget.communityContext,customerId:widget.customerId,
                      communityId: items[idx * 2].community?.id ?? 0,
                      type: widget.type,
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
                    type: widget.type.parent,
                    onTap: () async {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => CommunityDetailScreen(
                            communityContext: widget.communityContext,customerId:widget.customerId,
                            communityId: items[idx * 2 + 1].community?.id ?? 0,
                            type: widget.type,
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
