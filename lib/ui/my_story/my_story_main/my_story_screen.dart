import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:oasis/bloc/my_story/bloc.dart';
import 'package:oasis/repository/my_story_repository.dart';
import 'package:oasis/repository/user_repository.dart';
import 'package:oasis/ui/common/base_scaffold.dart';
import 'package:oasis/ui/common/custom_icon.dart';
import 'package:oasis/ui/common/default_small_button.dart';
import 'package:oasis/ui/my_story/my_story_detail/my_story_detail_screen.dart';
import 'package:oasis/ui/my_story/my_story_main/component/my_story_tile.dart';
import 'package:oasis/ui/my_story/my_story_write/my_story_write_screen.dart';
import 'package:oasis/ui/theme.dart';
import 'package:oasis/ui/util/bold_generator.dart';

import 'cubit/my_story_main_cubit.dart';
import 'cubit/my_story_main_state.dart';

class MyStoryScreen extends StatefulWidget {
  final int? customerId;
  MyStoryScreen({this.customerId});
  @override
  _MyStoryScreenState createState() => _MyStoryScreenState();
}

class _MyStoryScreenState extends State<MyStoryScreen> {
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
            create: (BuildContext context) => MyStoryMainCubit(
              customerId: widget.customerId,
              userRepository: context.read<UserRepository>(),
              myStoryRepository: context.read<MyStoryRepository>(),
              myStoryBloc: myStoryContext.read<MyStoryBloc>(),
            )..initialize(),
            child: BlocBuilder<MyStoryMainCubit, MyStoryMainState>(
              builder: (context, state) {
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
                        _title(
                          showWriteButton:
                          widget.customerId == null ||    state.user?.customer?.id == widget.customerId,
                          onAdd: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => MyStoryWriteScreen(
                                  myStoryContext: myStoryContext,
                                ),
                              ),
                            );
                          },
                        ),
                        SizedBox(height: 16),
                        Expanded(
                          child: SingleChildScrollView(
                            child: Column(
                              children: [
                                if (widget.customerId != null)
                                  Container(
                                    width: double.infinity,
                                    padding: EdgeInsets.symmetric(
                                        vertical: 12, horizontal: 16),
                                    decoration: BoxDecoration(
                                      color: Colors.white,
                                      boxShadow: cardShadow,
                                      borderRadius: BorderRadius.circular(8),
                                    ),
                                    child: BoldMsgGenerator.toRichText(
                                        msg:
                                            "이상형과 만남이 확정되면, *나의 일상*을 *공개* 할 수 있습니다.\n(비공개 처리한 사진은 보여지지 않습니다.)\n일상 사진이 있으면 만남 확률이 높아집니다.",
                                        style: body01.copyWith(color: gray600),
                                        boldWeight: FontWeight.bold),
                                  ),
                                if (widget.customerId != null)
                                  SizedBox(height: 30),
                                if ((state.myStorys ?? []).isEmpty)
                                  Container(
                                    height: 100,
                                    width: double.infinity,
                                    alignment: Alignment.center,
                                    child: Text(
                                      '등록된 나의 일상이 없습니다.',
                                      style: header02.copyWith(color: gray300),
                                    ),
                                  ),
                                ...(state.myStorys ?? [])
                                    .map(
                                      (e) => MyStoryTile(
                                        item: e,
                                        onTap: () {
                                          Navigator.push(
                                            context,
                                            MaterialPageRoute(
                                              builder: (_) =>
                                                  MyScreenDetailScreen(
                                                myStoryContext: myStoryContext,
                                                item: e,
                                              ),
                                            ),
                                          );
                                        },
                                      ),
                                    )
                                    .toList(),
                                SizedBox(height: 24),
                                if ((state.myStorys ?? []).isNotEmpty && state.totalCount > 20 )
                                  DefaultSmallButton(
                                    title: "더보기",
                                    reverse: true,
                                    onTap: () {
                                      context
                                          .read<MyStoryMainCubit>()
                                          .pagination();
                                    },
                                  ),
                                SizedBox(
                                  height:
                                      MediaQuery.of(context).padding.bottom +
                                          10,
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

  _title({required Function onAdd, required bool showWriteButton}) {
    return Container(
      height: 44,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            widget.customerId == null ? '일상 공유 🏠' : '나의 일상 🏠',
            style: header02.copyWith(  fontFamily: "Godo",color: darkBlue),
          ),
          if (showWriteButton)
            GestureDetector(
              onTap: () {
                onAdd();
              },
              child: Container(
                width: 44,
                height: 44,
                alignment: Alignment.center,
                decoration: BoxDecoration(
                  color: Colors.white,
                  boxShadow: cardShadow,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: CustomIcon(
                  path: "icons/big_plus",
                  color: mainMint,
                  width: 20,
                  height: 20,
                ),
              ),
            ),
        ],
      ),
    );
  }
}
