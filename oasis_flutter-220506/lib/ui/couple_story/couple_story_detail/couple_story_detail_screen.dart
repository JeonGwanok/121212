import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:oasis/bloc/my_story/bloc.dart';
import 'package:oasis/enum/my_story/my_story.dart';
import 'package:oasis/repository/my_story_repository.dart';
import 'package:oasis/repository/user_repository.dart';
import 'package:oasis/ui/common/base_scaffold.dart';
import 'package:oasis/ui/common/cache_image.dart';
import 'package:oasis/ui/common/comment/comment_object.dart';
import 'package:oasis/ui/common/community/like_object.dart';
import 'package:oasis/ui/common/custom_icon.dart';
import 'package:oasis/ui/common/default_dialog.dart';
import 'package:oasis/ui/common/default_small_button.dart';
import 'package:oasis/ui/common/write/tags_object.dart';
import 'package:oasis/ui/couple_story/couple_story_detail/cubit/couple_story_detail_state.dart';
import 'package:oasis/ui/couple_story/couple_story_write/couple_story_write_screen.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';

import '../../theme.dart';
import 'cubit/couple_story_detail_cubit.dart';

class CoupleStoryDetailScreen extends StatefulWidget {
  final int myStoryId;
  final MyStoryType type;
  final BuildContext myStoryContext;
  CoupleStoryDetailScreen({
    required this.myStoryId,
    required this.type,
    required this.myStoryContext,
  });
  @override
  _CoupleStoryDetailScreenState createState() =>
      _CoupleStoryDetailScreenState();
}

class _CoupleStoryDetailScreenState extends State<CoupleStoryDetailScreen> {
  PageController controller = PageController();
  GlobalKey globalKey = GlobalKey();

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (BuildContext context) => CoupleStoryDetailCubit(
        type: widget.type,
        myStoryBloc: widget.myStoryContext.read<MyStoryBloc>(),
        myStoryId: widget.myStoryId,
        myStoryRepository: context.read<MyStoryRepository>(),
        userRepository: context.read<UserRepository>(),
      )..initialize(),
      child: BlocListener<CoupleStoryDetailCubit, CoupleStoryDetailState>(
        listener: (context, state) {
          if (state.status == CoupleStoryDetailStatus.notFound) {
            DefaultDialog.show(
              context,
              title: "글이 없습니다",
              defaultButtonTitle: "확인",
            );
          }

          if (state.status == CoupleStoryDetailStatus.alreadyLike) {
            DefaultDialog.show(
              context,
              title: "좋아요를 취소한 뒤 클릭해주세요",
              defaultButtonTitle: "확인",
            );
          }

          if (state.status == CoupleStoryDetailStatus.alreadyDislike) {
            DefaultDialog.show(
              context,
              title: "싫어요를 취소한 뒤 클릭해주세요",
              defaultButtonTitle: "확인",
            );
          }

          if (state.status == CoupleStoryDetailStatus.reportSuccess) {
            DefaultDialog.show(
              context,
              title: "신고가 정상처리되었습니다.",
              defaultButtonTitle: "확인",
            );
          }

          if (state.status == CoupleStoryDetailStatus.deleteSuccess) {
            Navigator.pop(context);
          }

          controller = PageController();
          globalKey = GlobalKey();
        },
        listenWhen: (pre, cur) =>
            pre.status != cur.status || pre.item != cur.item,
        child: BlocBuilder<CoupleStoryDetailCubit, CoupleStoryDetailState>(
          builder: (context, state) {
            return BaseScaffold(
              title: "",
              resizeToAvoidBottomInset: true,
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
                        context.read<CoupleStoryDetailCubit>().previous();
                      },
                      onNext: () {
                        context.read<CoupleStoryDetailCubit>().next();
                      },
                    ),
                    Expanded(
                      child: SingleChildScrollView(
                        child: Column(
                          children: [
                            Container(
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
                                            Text(
                                              "${state.item.nickName ?? "--"}",
                                              style: header03.copyWith(
                                                  color: gray500),
                                            ),
                                            Row(
                                              children: [
                                                Text(
                                                  state.item.createdAt != null
                                                      ? DateFormat(
                                                              "yyyy.MM.dd HH:mm:ss")
                                                          .format(state
                                                              .item.createdAt!)
                                                      : "--",
                                                  style: body02.copyWith(
                                                    color: gray300,
                                                  ),
                                                ),
                                                SizedBox(width: 16),
                                                Text(
                                                  "조회수: ${state.item.hits ?? 0}",
                                                  style: body02.copyWith(
                                                    color: gray300,
                                                  ),
                                                ),
                                                PopupMenuButton(
                                                  elevation: 1.5,
                                                  offset: Offset(0, 40),
                                                  shape: RoundedRectangleBorder(
                                                    borderRadius:
                                                    BorderRadius.all(
                                                        Radius.circular(8)),
                                                  ),
                                                  itemBuilder: (context) {
                                                    return [
                                                      if (state.item
                                                          .customerId ==
                                                          state.user.customer
                                                              ?.id)
                                                        PopupMenuItem(
                                                          value: "edit",
                                                          child: Container(
                                                            alignment: Alignment
                                                                .center,
                                                            child: Text(
                                                              "수정",
                                                              style: body02
                                                                  .copyWith(
                                                                color: mainMint,
                                                              ),
                                                            ),
                                                          ),
                                                        ),
                                                      if (state.item
                                                          .customerId ==
                                                          state.user.customer
                                                              ?.id)
                                                        PopupMenuItem(
                                                          value: 'delete',
                                                          child: Container(
                                                            alignment: Alignment
                                                                .center,
                                                            child: Text(
                                                              "삭제",
                                                              style: body02
                                                                  .copyWith(
                                                                color: mainMint,
                                                              ),
                                                            ),
                                                          ),
                                                        ),
                                                      PopupMenuItem(
                                                        value: 'report',
                                                        child: Container(
                                                          alignment:
                                                          Alignment.center,
                                                          child: Text(
                                                            "신고",
                                                            style:
                                                            body02.copyWith(
                                                              color: Colors.red,
                                                            ),
                                                          ),
                                                        ),
                                                      ),
                                                    ];
                                                  },
                                                  child: Container(
                                                    child: CustomIcon(
                                                      path: "icons/more",
                                                    ),
                                                  ),
                                                  onSelected: (val) async {
                                                    if (val == "edit") {
                                                      await  Navigator.push(
                                                        context,
                                                        MaterialPageRoute(
                                                          builder: (context) =>
                                                              CoupleStoryWriteScreen(
                                                                myStoryContext: widget.myStoryContext,
                                                                editItem: state.item,
                                                                type: widget.type,
                                                              ),
                                                        ),
                                                      );

                                                      context
                                                          .read<
                                                          CoupleStoryDetailCubit>()
                                                          .initialize();
                                                    }
                                                    if (val == "delete") {
                                                      DefaultDialog.show(
                                                          context,
                                                          title: "정말 삭제하시겠습니까?",
                                                          onTap: () {
                                                            context
                                                                .read<
                                                                CoupleStoryDetailCubit>()
                                                                .delete();
                                                          });
                                                    }
                                                    if (val == "report") {
                                                      DefaultDialog.show(
                                                          context,
                                                          title: "정말 신고하시겠습니까?",
                                                          onTap: () {
                                                            context
                                                                .read<
                                                                CoupleStoryDetailCubit>()
                                                                .report();
                                                          });
                                                    }
                                                  },
                                                )
                                              ],
                                            )
                                          ],
                                        ),
                                        Container(
                                          margin: EdgeInsets.symmetric(
                                              vertical: 20),
                                          child: Text(
                                            state.item.title ?? "--",
                                            style: header08,
                                          ),
                                        ),
                                        if(state.item.imageList.isNotEmpty)
                                        AspectRatio(
                                          aspectRatio: 1,
                                          child: Container(
                                            child: PageView(
                                              controller: controller,
                                              children: state.item.imageList
                                                  .map(
                                                    (e) => Container(
                                                      clipBehavior:
                                                          Clip.antiAlias,
                                                      decoration: BoxDecoration(
                                                          borderRadius:
                                                              BorderRadius
                                                                  .circular(8)),
                                                      child: CacheImage(
                                                          url: e.image ?? ""),
                                                    ),
                                                  )
                                                  .toList(),
                                            ),
                                          ),
                                        ),
                                        if (state.item.imageList.isNotEmpty)
                                          Container(
                                            margin: EdgeInsets.symmetric(
                                                vertical: 8),
                                            alignment: Alignment.center,
                                            child: SmoothPageIndicator(
                                              controller: controller,
                                              count:
                                                  state.item.imageList.length,
                                              effect: WormEffect(
                                                  dotHeight: 8,
                                                  dotWidth: 8,
                                                  spacing: 8,
                                                  dotColor: gray300,
                                                  activeDotColor: mainMint),
                                            ),
                                          ),
                                        Text(
                                          state.item.content ?? "--",
                                          style:
                                              body01.copyWith(color: gray900),
                                          overflow: TextOverflow.ellipsis,
                                        ),
                                      ],
                                    ),
                                    SizedBox(height: 20),
                                    TagsObject(tags: state.item.hashTag)
                                  ],
                                ),
                              ),
                            ),
                            SizedBox(height: 28),
                            LikeObject(
                                like: state.like,
                                likePressed: state.likeStatus,
                                dislike: state.dislike,
                                dislikePressed: state.dislikeStatus,
                                onLike: () {
                                  context.read<CoupleStoryDetailCubit>().like();
                                },
                                onDislike: () {
                                  context
                                      .read<CoupleStoryDetailCubit>()
                                      .dislike();
                                }),
                            // CommentObject(
                            //   globalKey,
                            //   user: state.user,
                            //   onComment: (text) {
                            //     context
                            //         .read<CoupleStoryDetailCubit>()
                            //         .comment(text);
                            //   },
                            //   comments: state.item.comment ?? [],
                            // ),
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
            widget.type.title,
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
