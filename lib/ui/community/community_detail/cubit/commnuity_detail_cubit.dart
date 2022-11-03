import 'dart:math';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:oasis/api_client/api_client.dart';
import 'package:oasis/bloc/community/bloc.dart';
import 'package:oasis/enum/community/community.dart';
import 'package:oasis/repository/community_repository.dart';
import 'package:oasis/repository/user_repository.dart';
import 'package:oasis/util/text_filter.dart';

import 'commnuity_detail_state.dart';

class CommunityDetailCubit extends Cubit<CommunityDetailState> {
  final int communityId;
  final int? customerId;
  final CommunitySubType type;
  final UserRepository userRepository;
  final CommunityRepository communityRepository;
  final CommunityBloc communityBloc;
  CommunityDetailCubit({
    required this.communityBloc,
    required this.userRepository,
    required this.communityId,
    required this.type,
    required this.customerId,
    required this.communityRepository,
  }) : super(CommunityDetailState());

  initialize() async {
    try {
      emit(state.copyWith(status: CommunityDetailStatus.loading));
      var user = await userRepository.getUser();
      var _item = await communityRepository.getCommunity(
        communityId: "$communityId",
        type: type,
      );

      emit(
        state.copyWith(
          status: CommunityDetailStatus.success,
          dislikeStatus: _item?.dislikeStatus ?? false,
          dislike: _item?.dislike ?? 0,
          likeStatus: _item?.likeStatus ?? false,
          like: _item?.like ?? 0,
          item: _item,
          user: user,
        ),
      );
    } on ApiClientException {
      emit(state.copyWith(status: CommunityDetailStatus.fail));
    } catch (err) {
      emit(state.copyWith(status: CommunityDetailStatus.fail));
    }
  }

  previous() async {
    try {
      emit(state.copyWith(status: CommunityDetailStatus.loading));
      var _item = await communityRepository.getPreviousCommunity(
        communityId: "${state.item.id}",
        customerId: customerId,
        type: type,
      );

      emit(
        state.copyWith(
          status: CommunityDetailStatus.success,
          item: _item,
          dislikeStatus: _item?.dislikeStatus ?? false,
          dislike: _item?.dislike ?? 0,
          likeStatus: _item?.likeStatus ?? false,
          like: _item?.like ?? 0,
        ),
      );
    } on ApiClientException catch (err) {
      if (err.detail.contains("No Community")) {
        emit(state.copyWith(status: CommunityDetailStatus.notFound));
      } else {
        emit(state.copyWith(status: CommunityDetailStatus.fail));
      }
    } catch (err) {
      emit(state.copyWith(status: CommunityDetailStatus.fail));
    }
  }

  next() async {
    try {
      emit(state.copyWith(status: CommunityDetailStatus.loading));
      var _item = await communityRepository.getNextCommunity(
        communityId: "${state.item.id}",
        customerId: customerId,
        type: type,
      );

      emit(
        state.copyWith(
          status: CommunityDetailStatus.success,
          item: _item,
          dislikeStatus: _item?.dislikeStatus ?? false,
          dislike: _item?.dislike ?? 0,
          likeStatus: _item?.likeStatus ?? false,
          like: _item?.like ?? 0,
        ),
      );
    } on ApiClientException catch (err) {
      if (err.detail.contains("No Community")) {
        emit(state.copyWith(status: CommunityDetailStatus.notFound));
      } else {
        emit(state.copyWith(status: CommunityDetailStatus.fail));
      }
    } catch (err) {
      emit(state.copyWith(status: CommunityDetailStatus.fail));
    }
  }

  like() async {
    try {
      emit(state.copyWith(status: CommunityDetailStatus.loading));
      if (!state.likeStatus) {
        await communityRepository.likeDislikeCommunity(
          communityId: "${state.item.id}",
          isLike: true,
        );
      } else {
        await communityRepository.cancelLikeDislikeCommunity(
          communityId: "${state.item.id}",
          isLike: true,
        );
      }
      communityBloc.add(CommunityUpdate());
      emit(
        state.copyWith(
          status: CommunityDetailStatus.success,
          dislike: state.dislikeStatus ? state.dislike - 1 : null,
          dislikeStatus: false,
          likeStatus: !state.likeStatus,
          like: state.likeStatus ? max(0, state.like - 1) : state.like + 1,
        ),
      );
    } on ApiClientException catch (err) {
      if (err.detail == "Dislike already exist") {
        emit(state.copyWith(status: CommunityDetailStatus.alreadyDislike));
      } else {
        emit(state.copyWith(status: CommunityDetailStatus.fail));
      }
    } catch (err) {
      emit(state.copyWith(status: CommunityDetailStatus.fail));
    }
  }

  dislike() async {
    try {
      emit(state.copyWith(status: CommunityDetailStatus.loading));
      if (!state.dislikeStatus) {
        await communityRepository.likeDislikeCommunity(
          communityId: "${state.item.id}",
          isLike: false,
        );
      } else {
        await communityRepository.cancelLikeDislikeCommunity(
          communityId: "${state.item.id}",
          isLike: false,
        );
      }
      communityBloc.add(CommunityUpdate());
      emit(
        state.copyWith(
          status: CommunityDetailStatus.success,
          like: state.likeStatus ? state.like - 1 : null,
          likeStatus: false,
          dislikeStatus: !state.dislikeStatus,
          dislike: state.dislikeStatus
              ? max(0, state.dislike - 1)
              : state.dislike + 1,
        ),
      );
    } on ApiClientException catch (err) {
      if (err.detail == "Like already exist") {
        emit(state.copyWith(status: CommunityDetailStatus.alreadyLike));
      } else {
        emit(state.copyWith(status: CommunityDetailStatus.fail));
      }
    } catch (err) {
      emit(state.copyWith(status: CommunityDetailStatus.fail));
    }
  }

  report(String content) async {
    try {
      emit(state.copyWith(status: CommunityDetailStatus.loading));
      await communityRepository.reportCommunity(
        communityId: "${state.item.id}",
      );
      communityBloc.add(CommunityUpdate());
      emit(
        state.copyWith(
          status: CommunityDetailStatus.reportSuccess,
        ),
      );
    } on ApiClientException {
      emit(state.copyWith(status: CommunityDetailStatus.fail));
    } catch (err) {
      emit(state.copyWith(status: CommunityDetailStatus.fail));
    }
  }

  block({String? customerId}) async {
    try {
      emit(state.copyWith(status: CommunityDetailStatus.loading));
      await userRepository.blockUser(
        customerId: customerId ?? "${state.item.customerId}",
      );
      communityBloc.add(CommunityUpdate());
      emit(
        state.copyWith(
          status: CommunityDetailStatus.blockSuccess,
        ),
      );
    } on ApiClientException {
      emit(state.copyWith(status: CommunityDetailStatus.fail));
    } catch (err) {
      emit(state.copyWith(status: CommunityDetailStatus.fail));
    }
  }

  delete() async {
    try {
      await communityRepository.deleteCommunity(
        communityId: "${state.item.id}",
      );
      communityBloc.add(CommunityUpdate());
      emit(
        state.copyWith(
          status: CommunityDetailStatus.deleteSuccess,
        ),
      );
    } on ApiClientException {
      emit(state.copyWith(status: CommunityDetailStatus.fail));
    } catch (err) {
      emit(state.copyWith(status: CommunityDetailStatus.fail));
    }
  }

  comment(String comment) async {
    emit(state.copyWith(status: CommunityDetailStatus.loading));

    var hasSlang = false;
    for (var item in textFilter) {
      if (comment.contains(item)) {
        hasSlang = true;
        break;
      }
    }

    if (hasSlang) {
      emit(state.copyWith(status: CommunityDetailStatus.hasSlang));
    } else {
      try {
        await communityRepository.commentCommunity(
          communityId: "${state.item.id}",
          comment: comment,
        );

        var _item = await communityRepository.getCommunity(
          communityId: "${state.item.id}",
          type: type,
        );
        communityBloc.add(CommunityUpdate());
        emit(
          state.copyWith(
            status: CommunityDetailStatus.success,
            dislikeStatus: _item?.dislikeStatus ?? false,
            dislike: _item?.dislike ?? 0,
            likeStatus: _item?.likeStatus ?? false,
            like: _item?.like ?? 0,
            item: _item,
          ),
        );
      } on ApiClientException {
        emit(state.copyWith(status: CommunityDetailStatus.fail));
      } catch (err) {
        emit(state.copyWith(status: CommunityDetailStatus.fail));
      }
    }
  }

  // 댓글 관련
  commentReport(String commentId,String content) async {
    try {
      emit(state.copyWith(status: CommunityDetailStatus.loading));
      await communityRepository.reportCommunityComment(
        commentId: "$commentId",
        content: content,
      );
      communityBloc.add(CommunityUpdate());
      emit(
        state.copyWith(
          status: CommunityDetailStatus.reportSuccess,
        ),
      );
    } on ApiClientException {
      emit(state.copyWith(status: CommunityDetailStatus.fail));
    } catch (err) {
      emit(state.copyWith(status: CommunityDetailStatus.fail));
    }
  }

  commentDelete(String commentId) async {
    try {
      emit(state.copyWith(status: CommunityDetailStatus.loading));
      await communityRepository.deleteCommentCommunity(
        commentId: "$commentId",
      );
      communityBloc.add(CommunityUpdate());
      emit(
        state.copyWith(
          status: CommunityDetailStatus.commentDeleteSuccess,
        ),
      );
      initialize();
    } on ApiClientException {
      emit(state.copyWith(status: CommunityDetailStatus.fail));
    } catch (err) {
      emit(state.copyWith(status: CommunityDetailStatus.fail));
    }
  }


}
