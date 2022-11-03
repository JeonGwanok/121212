import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:oasis/bloc/my_story/my_story_bloc.dart';
import 'package:oasis/bloc/my_story/my_story_state.dart';
import 'package:oasis/enum/my_story/my_story.dart';
import 'package:oasis/enum/screen_status.dart';
import 'package:oasis/repository/my_story_repository.dart';
import 'package:oasis/repository/user_repository.dart';
import 'package:oasis/ui/common/base_scaffold.dart';
import 'package:oasis/ui/common/default_small_button.dart';
import 'package:oasis/ui/couple_story/component/couple_story_base_tile.dart';
import 'package:oasis/ui/couple_story/couple_story_detail/couple_story_detail_screen.dart';
import 'package:oasis/ui/couple_story/couple_story_main/cubit/couple_story_state.dart';
import 'package:oasis/ui/couple_story/couple_story_main_depth2/couple_story_main_depth2_screen.dart';
import 'package:oasis/ui/couple_story/couple_story_write/couple_story_write_screen.dart';
import 'package:oasis/ui/theme.dart';

import 'cubit/couple_story_cubit.dart';

class CoupleStoryMainScreen extends StatefulWidget {
  @override
  _CoupleStoryMainScreenState createState() => _CoupleStoryMainScreenState();
}

class _CoupleStoryMainScreenState extends State<CoupleStoryMainScreen> {
  BuildContext? myStoryContext;

  @override
  Widget build(BuildContext context) {
    return BlocProvider<MyStoryBloc>(
      create: (context) => MyStoryBloc(),
      child: BlocBuilder<MyStoryBloc, MyStoryState>(
        builder: (myStoryContext, state) {
          if (this.myStoryContext == null) {
            this.myStoryContext = myStoryContext;
          }

          return BlocProvider(
            create: (BuildContext context) => CoupleStoryCubit(
              userRepository: context.read<UserRepository>(),
              myStoryBloc: myStoryContext.read<MyStoryBloc>(),
              myStoryRepository: context.read<MyStoryRepository>(),
            )..initialize(),
            child: BlocBuilder<CoupleStoryCubit, CoupleStoryState>(
              builder: (context, state) {
                return BaseScaffold(
                  title: "",
                  onLoading: state.status == ScreenStatus.loading,
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
                            child: Column(
                              children: [
                                Column(
                                  children: [
                                    _title(
                                      title: "연애 이야기 💕",
                                      onAdd: () {
                                        Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                            builder: (context) =>
                                                CoupleStoryMainDepth2Screen(
                                                    myStoryContext:
                                                        myStoryContext,
                                                    type: MyStoryType.love),
                                          ),
                                        );
                                      },
                                    ),
                                    SizedBox(height: 12),
                                    if ((state.loves?.results ?? []).isEmpty)
                                      Container(
                                        height: 100,
                                        width: double.infinity,
                                        alignment: Alignment.center,
                                        child: Text(
                                          '연애이야기가 없습니다.',
                                          style:
                                              header02.copyWith(color: gray300),
                                        ),
                                      ),
                                    ...(((state.loves?.results ?? []).length >
                                                10)
                                            ? ((state.loves?.results ?? [])
                                                .sublist(0, 10))
                                            : (state.loves?.results ?? []))
                                        .asMap()
                                        .map((i, e) => MapEntry(
                                              i,
                                              CoupleStoryBaseTile(
                                                idx: i,
                                                item: e,
                                                onTap: () {
                                                  Navigator.push(
                                                    context,
                                                    MaterialPageRoute(
                                                      builder: (_) =>
                                                          CoupleStoryDetailScreen(
                                                        type: MyStoryType.love,
                                                        myStoryId: e.id ?? 0,
                                                        myStoryContext:
                                                            myStoryContext,
                                                      ),
                                                    ),
                                                  );
                                                },
                                              ),
                                            ))
                                        .values
                                        .toList(),
                                    SizedBox(height: 8),
                                    DefaultSmallButton(
                                      title: "내 연애 이야기 들려주기",
                                      onTap: () {
                                        Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                            builder: (_) =>
                                                CoupleStoryWriteScreen(
                                              myStoryContext: myStoryContext,
                                              type: MyStoryType.love,
                                            ),
                                          ),
                                        );
                                      },
                                    )
                                  ],
                                ),
                                SizedBox(height: 24),
                                Column(
                                  children: [
                                    _title(
                                      title: "결혼 이야기 👩‍❤️‍👨",
                                      onAdd: () {
                                        Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                            builder: (context) =>
                                                CoupleStoryMainDepth2Screen(
                                                    myStoryContext:
                                                        myStoryContext,
                                                    type: MyStoryType.marry),
                                          ),
                                        );
                                      },
                                    ),
                                    SizedBox(height: 12),
                                    if ((state.marries?.results ?? []).isEmpty)
                                      Container(
                                        height: 100,
                                        width: double.infinity,
                                        alignment: Alignment.center,
                                        child: Text(
                                          '결혼이야기가 없습니다.',
                                          style:
                                              header02.copyWith(color: gray300),
                                        ),
                                      ),
                                    ...(((state.marries?.results ?? []).length >
                                                10)
                                            ? ((state.marries?.results ?? [])
                                                .sublist(0, 10))
                                            : (state.marries?.results ?? []))
                                        .asMap()
                                        .map((i, e) => MapEntry(
                                              i,
                                              CoupleStoryBaseTile(
                                                idx: i,
                                                item: e,
                                                onTap: () {
                                                  Navigator.push(
                                                    context,
                                                    MaterialPageRoute(
                                                      builder: (_) =>
                                                          CoupleStoryDetailScreen(
                                                        myStoryContext:
                                                            myStoryContext,
                                                        type: MyStoryType.marry,
                                                        myStoryId: e.id ?? 0,
                                                      ),
                                                    ),
                                                  );
                                                },
                                              ),
                                            ))
                                        .values
                                        .toList(),
                                    SizedBox(height: 8),
                                    DefaultSmallButton(
                                      title: "내 결혼 이야기 들려주기",
                                      onTap: () {
                                        Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                            builder: (_) =>
                                                CoupleStoryWriteScreen(
                                              myStoryContext: myStoryContext,
                                              type: MyStoryType.marry,
                                            ),
                                          ),
                                        );
                                      },
                                    )
                                  ],
                                ),
                                SizedBox(
                                  height:
                                      MediaQuery.of(context).padding.bottom +
                                          30,
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
        },
      ),
    );
  }

  _title({
    required String title,
    required Function onAdd,
  }) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          title,
          style: header02.copyWith(color: darkBlue),
        ),
        Container(
          width: 66,
          height: 44,
          alignment: Alignment.center,
          decoration: BoxDecoration(
            color: Colors.white,
            boxShadow: cardShadow,
            borderRadius: BorderRadius.circular(8),
          ),
          child: DefaultSmallButton(
            title: "더보기",
            reverse: true,
            hideBorder: true,
            onTap: () {
              onAdd();
            },
          ),
        ),
      ],
    );
  }
}
