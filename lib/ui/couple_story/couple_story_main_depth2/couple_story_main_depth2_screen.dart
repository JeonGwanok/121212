import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:oasis/bloc/my_story/my_story_bloc.dart';
import 'package:oasis/enum/my_story/my_story.dart';
import 'package:oasis/repository/my_story_repository.dart';
import 'package:oasis/repository/user_repository.dart';
import 'package:oasis/ui/common/base_scaffold.dart';
import 'package:oasis/ui/common/search_bar.dart';
import 'package:oasis/ui/couple_story/component/couple_story_popular_tile.dart';
import 'package:oasis/ui/couple_story/component/couple_story_tile.dart';
import 'package:oasis/ui/couple_story/couple_story_detail/couple_story_detail_screen.dart';
import 'package:oasis/ui/couple_story/couple_story_main_depth2/cubit/couple_story_main_depth2_state.dart';
import 'package:oasis/ui/my_story/my_story_write/my_story_write_screen.dart';
import 'package:oasis/ui/theme.dart';

import 'cubit/couple_story_main_depth2_cubit.dart';

class CoupleStoryMainDepth2Screen extends StatefulWidget {
  final BuildContext myStoryContext;
  final MyStoryType type;
  CoupleStoryMainDepth2Screen({
    required this.myStoryContext,
    required this.type,
  });
  @override
  _CoupleStoryMainDepth2ScreenState createState() =>
      _CoupleStoryMainDepth2ScreenState();
}

class _CoupleStoryMainDepth2ScreenState
    extends State<CoupleStoryMainDepth2Screen> {
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
      _context?.read<CoupleStoryMainDepth2Cubit>().pagination();
    }
  }

  BuildContext? _context;
  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (BuildContext context) => CoupleStoryMainDepth2Cubit(
        userRepository: context.read<UserRepository>(),
        myStoryBloc: widget.myStoryContext.read<MyStoryBloc>(),
        myStoryRepository: context.read<MyStoryRepository>(),
        type: widget.type,
      )..initialize(),
      child:
          BlocBuilder<CoupleStoryMainDepth2Cubit, CoupleStoryMainDepth2State>(
        builder: (context, state) {
          _context = context;
          return BaseScaffold(
            title: "",
            backgroundColor: backgroundColor,
            onBack: () {
              Navigator.pop(context);
            },
            body: Container(
              padding: EdgeInsets.symmetric(horizontal: 16),
              width: double.infinity,
              height: double.infinity,
              child: Column(
                children: [
                  SizedBox(height: 16),
                  Expanded(
                    child: SingleChildScrollView(
                      controller: controller,
                      child: Column(
                        children: [
                          SearchBar(
                            title: widget.type.title,
                            searchItems: SearchSortType.values,
                            searchText: "",
                            searchType: state.searchSortType,
                            onChangeType: (type) {
                              context
                                  .read<CoupleStoryMainDepth2Cubit>()
                                  .changeSearchType(type);
                            },
                            onChangeText: (text) {
                              context
                                  .read<CoupleStoryMainDepth2Cubit>()
                                  .changeSearchText(text);
                            },
                            onSearch: () {
                              context
                                  .read<CoupleStoryMainDepth2Cubit>()
                                  .initialize();
                            },
                          ),
                          SizedBox(height: 32),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              _title(
                                title: "인기 이야기 ✨",
                                onAdd: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) => MyStoryWriteScreen(
                                        myStoryContext: widget.myStoryContext,
                                      ),
                                    ),
                                  );
                                },
                              ),
                              SizedBox(height: 12),
                              if (state.popular.isEmpty)
                                Container(
                                  height: 100,
                                  width: double.infinity,
                                  alignment: Alignment.center,
                                  child: Text(
                                    '인기이야기가 없습니다.',
                                    style: header02.copyWith(color: gray300),
                                  ),
                                ),
                              ...state.popular
                                  .asMap()
                                  .map((i, e) => MapEntry(
                                        i,
                                        CoupleStoryPopularTile(
                                          idx: i,
                                          item: e,
                                          onTap: () {
                                            Navigator.push(
                                              context,
                                              MaterialPageRoute(
                                                builder: (_) =>
                                                    CoupleStoryDetailScreen(
                                                  myStoryContext:
                                                      widget.myStoryContext,
                                                  type: widget.type,
                                                  myStoryId: e.id ?? 0,
                                                ),
                                              ),
                                            );
                                          },
                                        ),
                                      ))
                                  .values
                                  .toList(),
                            ],
                          ),
                          SizedBox(height: 24),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              _title(
                                title: "새로 들어온 이야기 👀",
                                onAdd: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) => MyStoryWriteScreen(
                                          myStoryContext:
                                              widget.myStoryContext),
                                    ),
                                  );
                                },
                              ),
                              SizedBox(height: 12),
                              if ((state.myStorys ?? []).isEmpty)
                                Container(
                                  height: 100,
                                  width: double.infinity,
                                  alignment: Alignment.center,
                                  child: Text(
                                    '연애이야기가 없습니다.',
                                    style: header02.copyWith(color: gray300),
                                  ),
                                ),
                              ...(state.myStorys ?? [])
                                  .asMap()
                                  .map(
                                    (i, e) => MapEntry(
                                      i,
                                      CoupleStoryTile(
                                        idx: i,
                                        item: e,
                                        onTap: () {
                                          Navigator.push(
                                            context,
                                            MaterialPageRoute(
                                              builder: (_) =>
                                                  CoupleStoryDetailScreen(
                                                myStoryContext:
                                                    widget.myStoryContext,
                                                type: widget.type,
                                                myStoryId: e.id ?? 0,
                                              ),
                                            ),
                                          );
                                        },
                                      ),
                                    ),
                                  )
                                  .values
                                  .toList(),
                            ],
                          ),
                          SizedBox(
                            height: MediaQuery.of(context).padding.bottom + 30,
                          )
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  _title({
    required String title,
    required Function onAdd,
  }) {
    return Text(
      title,
      style: header02.copyWith(color: darkBlue),
    );
  }
}
