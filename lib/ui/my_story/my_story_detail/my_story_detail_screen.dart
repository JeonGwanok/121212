import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:oasis/bloc/my_story/bloc.dart';
import 'package:oasis/model/my_story/my_story.dart';
import 'package:oasis/repository/my_story_repository.dart';
import 'package:oasis/repository/user_repository.dart';
import 'package:oasis/ui/common/base_scaffold.dart';
import 'package:oasis/ui/common/custom_icon.dart';
import 'package:oasis/ui/common/default_dialog.dart';
import 'package:oasis/ui/common/default_small_button.dart';
import 'package:oasis/ui/common/write/tags_object.dart';
import 'package:oasis/ui/common/write_option_pop_menu.dart';
import 'package:oasis/ui/my_story/my_story_detail/cubit/my_story_detail_state.dart';
import 'package:oasis/ui/my_story/my_story_write/my_story_write_screen.dart';
import 'package:pinch_zoom_image_last/pinch_zoom_image_last.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';

import '../../theme.dart';
import 'cubit/my_story_detail_cubit.dart';

class MyScreenDetailScreen extends StatefulWidget {
  final BuildContext myStoryContext;
  final MyStory item;
  MyScreenDetailScreen({
    required this.item,
    required this.myStoryContext,
  });
  @override
  _MyScreenDetailScreenState createState() => _MyScreenDetailScreenState();
}

class _MyScreenDetailScreenState extends State<MyScreenDetailScreen> {
  PageController? controller;

  @override
  void dispose() {
    controller?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (BuildContext context) => MyStoryDetailCubit(
        myStory: widget.item,
        myStoryBloc: widget.myStoryContext.read<MyStoryBloc>(),
        userRepository: context.read<UserRepository>(),
        myStoryRepository: context.read<MyStoryRepository>(),
      )..initialize(),
      child: BlocListener<MyStoryDetailCubit, MyStoryDetailState>(
        listener: (context, state) async {
          if (state.status == MyStoryDetailStatus.notFound) {
            DefaultDialog.show(
              context,
              title: "글이 없습니다",
              defaultButtonTitle: "확인",
            );
          }

          if (state.status == MyStoryDetailStatus.reportSuccess) {
            await DefaultDialog.show(
              context,
              title: "신고가 정상처리되었습니다.",
              defaultButtonTitle: "확인",
            );
            Navigator.pop(context);
          }

          if (state.status == MyStoryDetailStatus.blockSuccess) {
            await DefaultDialog.show(
              context,
              title: "차단이 정상처리되었습니다.",
              defaultButtonTitle: "확인",
            );
            Navigator.pop(context);
          }

          if (state.status == MyStoryDetailStatus.deleteSuccess) {
            Navigator.pop(context);
          }

          controller = PageController();
        },
        listenWhen: (pre, cur) =>
            pre.status != cur.status || pre.myStory != cur.myStory,
        child: BlocBuilder<MyStoryDetailCubit, MyStoryDetailState>(
          builder: (context, state) {
            return BaseScaffold(
              title: "",
              onBack: () {
                Navigator.pop(context);
              },
              backgroundColor: backgroundColor,
              body: Container(
                padding: EdgeInsets.symmetric(horizontal: 16),
                child: Column(
                  children: [
                    _title(
                      onPrevious: () {
                        context.read<MyStoryDetailCubit>().previous();
                      },
                      onNext: () {
                        context.read<MyStoryDetailCubit>().next();
                      },
                    ),
                    Expanded(
                      child: SingleChildScrollView(
                        child: Column(
                          children: [
                            Container(
                              // constraints: BoxConstraints(minHeight: 682),
                              padding: EdgeInsets.all(16),
                              decoration: BoxDecoration(
                                  color: Colors.white,
                                  boxShadow: cardShadow,
                                  borderRadius: BorderRadius.circular(8)),
                              child: Container(
                                child: Column(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween,
                                          children: [
                                            Expanded(
                                              child: Text(
                                                "${state.myStory.nickName ?? "--"}",
                                                style: header03.copyWith(
                                                  color: gray500,
                                                  fontSize: 10.5,
                                                ),
                                              ),
                                            ),
                                            SizedBox(width: 8),
                                            Row(
                                              children: [
                                                Text(
                                                  state.myStory.createdAt !=
                                                          null
                                                      ? DateFormat(
                                                              "yyyy.MM.dd HH:mm:ss")
                                                          .format(state.myStory
                                                              .createdAt!)
                                                      : "--",
                                                  style: body02.copyWith(
                                                    color: gray300,
                                                    fontSize: 10.5,
                                                  ),
                                                ),
                                                SizedBox(width: 8),
                                                Text(
                                                  "조회수: ${state.myStory.hits ?? 0}",
                                                  style: body02.copyWith(
                                                      color: gray300,
                                                      fontSize: 10.5),
                                                ),
                                                WriteOptionPopMenuList(
                                                    userId: state.user.customer
                                                            ?.id ??
                                                        0,
                                                    writtenById: state.myStory
                                                            .customerId ??
                                                        0,
                                                    onEdit: () async {
                                                      await Navigator.push(
                                                        context,
                                                        MaterialPageRoute(
                                                          builder: (context) =>
                                                              MyStoryWriteScreen(
                                                            myStoryContext: widget
                                                                .myStoryContext,
                                                            editItem:
                                                                state.myStory,
                                                          ),
                                                        ),
                                                      );

                                                      context
                                                          .read<
                                                              MyStoryDetailCubit>()
                                                          .initialize();
                                                    },
                                                    onDelete: () {
                                                      context
                                                          .read<
                                                              MyStoryDetailCubit>()
                                                          .delete();
                                                    },
                                                    onReport: (content) {
                                                      context
                                                          .read<
                                                              MyStoryDetailCubit>()
                                                          .report(content);
                                                    },
                                                    onBlock: () {
                                                      context
                                                          .read<
                                                              MyStoryDetailCubit>()
                                                          .block();
                                                    }),
                                              ],
                                            )
                                          ],
                                        ),
                                        Container(
                                          margin: EdgeInsets.symmetric(
                                              vertical: 20),
                                          child: Text(
                                            state.myStory.title ?? "--",
                                            style: header08,
                                          ),
                                        ),
                                        AspectRatio(
                                          aspectRatio: 1,
                                          child: Container(
                                            child: PageView(
                                              controller: controller,
                                              children: state.myStory.imageList
                                                  .map(
                                                    (e) => Container(
                                                      clipBehavior:
                                                          Clip.antiAlias,
                                                      decoration: BoxDecoration(
                                                          borderRadius:
                                                              BorderRadius
                                                                  .circular(8)),
                                                      child: PinchZoomImage(
                                                        image: Image.network(
                                                          e.image ?? "",
                                                          fit: BoxFit.cover,
                                                          width:
                                                              double.infinity,
                                                          height:
                                                              double.infinity,
                                                          alignment:
                                                              Alignment.center,
                                                        ),
                                                        zoomedBackgroundColor:
                                                            Colors.black
                                                                .withOpacity(
                                                                    0.1),
                                                        hideStatusBarWhileZooming:
                                                            true,
                                                      ),
                                                    ),
                                                  )
                                                  .toList(),
                                            ),
                                          ),
                                        ),
                                        Container(
                                          margin:
                                              EdgeInsets.symmetric(vertical: 8),
                                          alignment: Alignment.center,
                                          child: SmoothPageIndicator(
                                            controller:
                                                controller ?? PageController(),
                                            count:
                                                state.myStory.imageList.length,
                                            effect: WormEffect(
                                                dotHeight: 8,
                                                dotWidth: 8,
                                                spacing: 8,
                                                dotColor: gray300,
                                                activeDotColor: mainMint),
                                          ),
                                        ),
                                        Text(
                                          state.myStory.content ?? "--",
                                          style:
                                              body01.copyWith(color: gray900),
                                        ),
                                      ],
                                    ),
                                    SizedBox(height: 20),
                                    TagsObject(tags: state.myStory.hashTag)
                                  ],
                                ),
                              ),
                            ),
                            SizedBox(height: 18),
                            GestureDetector(
                              onTap: () {
                                context.read<MyStoryDetailCubit>().like();
                              },
                              child: Container(
                                width: 80,
                                height: 50,
                                alignment: Alignment.center,
                                color: Colors.transparent,
                                child: Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    Text(
                                      "${state.like}",
                                      style: header03.copyWith(color: gray600),
                                    ),
                                    SizedBox(width: 15),
                                    CustomIcon(
                                      path: "icons/heart",
                                      height: 28,
                                      width: 28,
                                      color: heartRed,
                                    )
                                  ],
                                ),
                              ),
                            ),
                            SizedBox(
                                height:
                                    MediaQuery.of(context).padding.bottom + 50),
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
      ),
    );
  }

  _title({
    required Function onPrevious,
    required Function onNext,
  }) {
    return Container(
      margin: EdgeInsets.only(
        top: 20,
        bottom: 12,
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            '일상 공유 🏠',
            style: header02.copyWith(color: darkBlue),
          ),
          Row(
            children: [
              Container(
                height: 44,
                child: DefaultSmallButton(
                  title: "이전글",
                  onTap: () {
                    onPrevious();
                  },
                  fontSize: 12,
                  reverse: true,
                  hideBorder: true,
                  showShadow: true,
                ),
              ),
              SizedBox(width: 16),
              Container(
                height: 44,
                child: DefaultSmallButton(
                  title: "다음글",
                  onTap: () {
                    onNext();
                  },
                  fontSize: 12,
                  reverse: true,
                  hideBorder: true,
                  showShadow: true,
                ),
              ),
            ],
          )
        ],
      ),
    );
  }
}
