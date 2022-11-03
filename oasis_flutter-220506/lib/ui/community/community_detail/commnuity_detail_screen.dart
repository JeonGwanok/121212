import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:oasis/bloc/community/bloc.dart';
import 'package:oasis/enum/community/community.dart';
import 'package:oasis/model/user/user_profile.dart';
import 'package:oasis/repository/community_repository.dart';
import 'package:oasis/repository/user_repository.dart';
import 'package:oasis/ui/common/base_scaffold.dart';
import 'package:oasis/ui/common/cache_image.dart';
import 'package:oasis/ui/common/comment/comment_object.dart';
import 'package:oasis/ui/common/community/like_object.dart';
import 'package:oasis/ui/common/custom_icon.dart';
import 'package:oasis/ui/common/default_dialog.dart';
import 'package:oasis/ui/common/default_small_button.dart';
import 'package:oasis/ui/common/report_dialog.dart';
import 'package:oasis/ui/common/write/tags_object.dart';
import 'package:oasis/ui/common/write_option_pop_menu.dart';
import 'package:oasis/ui/community/community_detail/cubit/commnuity_detail_cubit.dart';
import 'package:oasis/ui/community/community_detail/cubit/commnuity_detail_state.dart';
import 'package:oasis/ui/community/community_write/community_write_screen.dart';
import 'package:pinch_zoom_image_last/pinch_zoom_image_last.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../theme.dart';

class CommunityDetailScreen extends StatefulWidget {
  final BuildContext communityContext;
  final int communityId;
  final int? customerId;
  final CommunitySubType type;
  CommunityDetailScreen({
    required this.communityContext,
    required this.communityId,
    required this.type,
    required this.customerId,
  });
  @override
  _CommunityDetailScreenState createState() => _CommunityDetailScreenState();
}

class _CommunityDetailScreenState extends State<CommunityDetailScreen> {
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
      create: (BuildContext context) => CommunityDetailCubit(
        type: widget.type,
        customerId: widget.customerId,
        communityBloc: widget.communityContext.read<CommunityBloc>(),
        communityId: widget.communityId,
        userRepository: context.read<UserRepository>(),
        communityRepository: context.read<CommunityRepository>(),
      )..initialize(),
      child: BlocListener<CommunityDetailCubit, CommunityDetailState>(
        listener: (context, state) async {
          if (state.status == CommunityDetailStatus.notFound) {
            DefaultDialog.show(
              context,
              title: "글이 없습니다",
              defaultButtonTitle: "확인",
            );
          }

          if (state.status == CommunityDetailStatus.alreadyLike) {
            DefaultDialog.show(
              context,
              title: "좋아요를 취소한 뒤 클릭해주세요",
              defaultButtonTitle: "확인",
            );
          }

          if (state.status == CommunityDetailStatus.alreadyDislike) {
            DefaultDialog.show(
              context,
              title: "싫어요를 취소한 뒤 클릭해주세요",
              defaultButtonTitle: "확인",
            );
          }

          if (state.status == CommunityDetailStatus.hasSlang) {
            DefaultDialog.show(context,
                title: "비속어를 포함할 수 없습니다.", defaultButtonTitle: "확인");
          }

          if (state.status == CommunityDetailStatus.blockSuccess) {
            await DefaultDialog.show(
              context,
              title: "차단이 정상처리되었습니다.",
              defaultButtonTitle: "확인",
            );
            Navigator.pop(context);
          }

          if (state.status == CommunityDetailStatus.reportSuccess) {
            await DefaultDialog.show(
              context,
              title: "신고가 정상처리되었습니다.",
              defaultButtonTitle: "확인",
            );
          }

          if (state.status == CommunityDetailStatus.commentDeleteSuccess) {
            DefaultDialog.show(
              context,
              title: "댓글이 삭제되었습니다.",
              defaultButtonTitle: "확인",
            );
          }

          if (state.status == CommunityDetailStatus.deleteSuccess) {
            Navigator.pop(context);
          }

          controller = PageController();
          globalKey = GlobalKey();
        },
        listenWhen: (pre, cur) =>
            pre.status != cur.status || pre.item != cur.item,
        child: BlocBuilder<CommunityDetailCubit, CommunityDetailState>(
          builder: (context, state) {
            return BaseScaffold(
              title: "",
              resizeToAvoidBottomInset: true,
              onBack: () {
                Navigator.pop(context);
              },
              onLoading: state.status == CommunityDetailStatus.loading,
              backgroundColor: backgroundColor,
              body: Container(
                padding: EdgeInsets.symmetric(horizontal: 16),
                child: Column(
                  children: [
                    _title(
                      onPrevious: () {
                        context.read<CommunityDetailCubit>().previous();
                      },
                      onNext: () {
                        context.read<CommunityDetailCubit>().next();
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
                                                "${state.item.nickName ?? "--"}",
                                                style: header03.copyWith(
                                                  color: gray500,
                                                  fontSize: 10.5,
                                                ),
                                              ),
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
                                                    fontSize: 10.5,
                                                  ),
                                                ),
                                                SizedBox(width: 16),
                                                Text(
                                                  "조회수: ${state.item.hits ?? 0}",
                                                  style: body02.copyWith(
                                                    color: gray300,
                                                    fontSize: 10.5,
                                                  ),
                                                ),
                                                SizedBox(width: 12),
                                                WriteOptionPopMenuList(
                                                    userId: state.user.customer
                                                            ?.id ??
                                                        0,
                                                    writtenById:
                                                        state.item.customerId ??
                                                            0,
                                                    onEdit: () async {
                                                      await Navigator.push(
                                                        context,
                                                        MaterialPageRoute(
                                                          builder: (context) =>
                                                              CommunityWriteScreen(
                                                            communityContext: widget
                                                                .communityContext,
                                                            editItem:
                                                                state.item,
                                                            type: widget.type,
                                                          ),
                                                        ),
                                                      );

                                                      context
                                                          .read<
                                                              CommunityDetailCubit>()
                                                          .initialize();
                                                    },
                                                    onDelete: () {
                                                      context
                                                          .read<
                                                              CommunityDetailCubit>()
                                                          .delete();
                                                    },
                                                    onReport: (content) {
                                                      context
                                                          .read<
                                                              CommunityDetailCubit>()
                                                          .report(content);
                                                    },
                                                    onBlock: () {
                                                      context
                                                          .read<
                                                              CommunityDetailCubit>()
                                                          .block();
                                                    }),
                                              ],
                                            )
                                          ],
                                        ),
                                        widget.type.parent ==
                                                    CommunityType.date ||
                                                widget.type.parent ==
                                                    CommunityType.stylist
                                            ? Container(
                                                height: 20,
                                              )
                                            : Container(
                                                margin: EdgeInsets.symmetric(
                                                    vertical: 20),
                                                child: Text(
                                                  state.item.title ?? "--",
                                                  style: header08,
                                                ),
                                              ),
                                        AspectRatio(
                                          aspectRatio: 1,
                                          child: Container(
                                            child: PageView(
                                              controller: controller,
                                              children: (state.item.image ?? [])
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
                                        if ((state.item.image ?? []).length > 0)
                                          Container(
                                            margin: EdgeInsets.symmetric(
                                                vertical: 8),
                                            alignment: Alignment.center,
                                            child: SmoothPageIndicator(
                                              controller: controller,
                                              count: (state.item.image ?? [])
                                                  .length,
                                              effect: WormEffect(
                                                  dotHeight: 8,
                                                  dotWidth: 8,
                                                  spacing: 8,
                                                  dotColor: gray300,
                                                  activeDotColor: mainMint),
                                            ),
                                          ),
                                        Text(
                                          widget.type.parent ==
                                                      CommunityType.date ||
                                                  widget.type.parent ==
                                                      CommunityType.stylist
                                              ? state.item.info ?? "--"
                                              : state.item.content ?? "--",
                                          style:
                                              body01.copyWith(color: gray900),
                                        ),
                                      ],
                                    ),
                                    SizedBox(height: 20),
                                    if ((state.item.url ?? "").isNotEmpty)
                                      GestureDetector(
                                        onTap: () async {

                                          var url = "https://";

                                          if (!(state.item.url ?? "").contains("http")) {
                                            url = url + (state.item.url ?? "");
                                          } else {
                                            url = state.item.url ?? "";
                                          }

                                          if (await canLaunch(
                                              url)) {
                                            launch(url);
                                          } else {
                                            DefaultDialog.show(context,
                                                title: "잘못된 주소입니다.",
                                                defaultButtonTitle: "확인");
                                          }
                                        },
                                        child: Container(
                                          color: Colors.cyan.withOpacity(0),
                                          padding: EdgeInsets.only(bottom: 20),
                                          child: Text(
                                            state.item.url ?? "",
                                            style: body01.copyWith(
                                                color: Colors.blue,
                                                decoration:
                                                    TextDecoration.underline),
                                          ),
                                        ),
                                      ),
                                    TagsObject(tags: state.item.hashTag ?? [])
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
                                  context.read<CommunityDetailCubit>().like();
                                },
                                onDislike: () {
                                  context
                                      .read<CommunityDetailCubit>()
                                      .dislike();
                                }),
                            CommentObject(
                              globalKey,
                              user: state.user,
                              onComment: (text) {
                                context
                                    .read<CommunityDetailCubit>()
                                    .comment(text);
                              },
                              comments: state.item.comment ?? [],
                              onEdit: (commentId) {},
                              onDelete: (commentId) {
                                context
                                    .read<CommunityDetailCubit>()
                                    .commentDelete("$commentId");
                              },
                              onReport: (commentId, content) {
                                context
                                    .read<CommunityDetailCubit>()
                                    .commentReport("$commentId", content);
                              },
                              onBlock: (customerId) {
                                context
                                    .read<CommunityDetailCubit>()
                                    .block(customerId: "$customerId");
                              },
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
