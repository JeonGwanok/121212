import 'dart:math';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:oasis/api_client/api_client.dart';
import 'package:oasis/bloc/my_story/bloc.dart';
import 'package:oasis/enum/my_story/my_story.dart';
import 'package:oasis/repository/my_story_repository.dart';
import 'package:oasis/repository/user_repository.dart';

import 'couple_story_detail_state.dart';

class CoupleStoryDetailCubit extends Cubit<CoupleStoryDetailState> {
  final int myStoryId;
  final MyStoryType type;
  final UserRepository userRepository;
  final MyStoryRepository myStoryRepository;
  final MyStoryBloc myStoryBloc;
  CoupleStoryDetailCubit({
    required this.myStoryId,
    required this.type,
    required this.userRepository,
    required this.myStoryRepository,
    required this.myStoryBloc,
  }) : super(CoupleStoryDetailState());

  initialize() async {
    try {
      emit(state.copyWith(status: CoupleStoryDetailStatus.loading));
      var _item = await myStoryRepository.getMyStory(
          myStoryId: "$myStoryId", type: type);
      var user = await userRepository.getUser();

      emit(
        state.copyWith(
          status: CoupleStoryDetailStatus.success,
          dislikeStatus: _item?.dislikeStatus ?? false,
          dislike: _item?.dislike ?? 0,
          likeStatus: _item?.likeStatus ?? false,
          like: _item?.like ?? 0,
          item: _item,
          user: user,
        ),
      );
    } on ApiClientException {
      emit(state.copyWith(status: CoupleStoryDetailStatus.fail));
    } catch (err) {
      emit(state.copyWith(status: CoupleStoryDetailStatus.fail));
    }
  }

  previous() async {
    try {
      emit(state.copyWith(status: CoupleStoryDetailStatus.loading));
      var _item = await myStoryRepository.getPreviousMyStory(
        myStoryId: "${state.item.id}",
        type: type,
      );

      emit(
        state.copyWith(
          status: CoupleStoryDetailStatus.success,
          item: _item,
          dislikeStatus: _item?.dislikeStatus ?? false,
          dislike: _item?.dislike ?? 0,
          likeStatus: _item?.likeStatus ?? false,
          like: _item?.like ?? 0,
        ),
      );
    } on ApiClientException catch (err) {
      if (err.detail.contains("No MyStory")) {
        emit(state.copyWith(status: CoupleStoryDetailStatus.notFound));
      } else {
        emit(state.copyWith(status: CoupleStoryDetailStatus.fail));
      }
    } catch (err) {
      emit(state.copyWith(status: CoupleStoryDetailStatus.fail));
    }
  }

  next() async {
    try {
      emit(state.copyWith(status: CoupleStoryDetailStatus.loading));
      var _item = await myStoryRepository.getNextMyStory(
        myStoryId: "${state.item.id}",
        type: type,
      );

      emit(
        state.copyWith(
          status: CoupleStoryDetailStatus.success,
          item: _item,
          dislikeStatus: _item?.dislikeStatus ?? false,
          dislike: _item?.dislike ?? 0,
          likeStatus: _item?.likeStatus ?? false,
          like: _item?.like ?? 0,
        ),
      );
    } on ApiClientException catch (err) {
      if (err.detail.contains("No MyStory")) {
        emit(state.copyWith(status: CoupleStoryDetailStatus.notFound));
      } else {
        emit(state.copyWith(status: CoupleStoryDetailStatus.fail));
      }
    } catch (err) {
      emit(state.copyWith(status: CoupleStoryDetailStatus.fail));
    }
  }

  like() async {
    try {
      emit(state.copyWith(status: CoupleStoryDetailStatus.loading));
      if (!state.likeStatus) {
        await myStoryRepository.likeDislikeMyStory(
          myStoryId: "${state.item.id}",
          isLike: true,
        );
      } else {
        await myStoryRepository.cancelLikeDislikeMyStory(
          myStoryId: "${state.item.id}",
          isLike: true,
        );
      }
      myStoryBloc.add(MyStoryUpdate());
      emit(
        state.copyWith(
          status: CoupleStoryDetailStatus.success,
          dislike: state.dislikeStatus ? state.dislike - 1 : null,
          dislikeStatus: false,
          likeStatus: !state.likeStatus,
          like: state.likeStatus ? max(0, state.like - 1) : state.like + 1,
        ),
      );
    } on ApiClientException catch (err) {
      if (err.detail == "Dislike already exist") {
        emit(state.copyWith(status: CoupleStoryDetailStatus.alreadyDislike));
      } else {
        emit(state.copyWith(status: CoupleStoryDetailStatus.fail));
      }
    } catch (err) {
      emit(state.copyWith(status: CoupleStoryDetailStatus.fail));
    }
  }

  dislike() async {
    try {
      emit(state.copyWith(status: CoupleStoryDetailStatus.loading));
      if (!state.dislikeStatus) {
        await myStoryRepository.likeDislikeMyStory(
          myStoryId: "${state.item.id}",
          isLike: false,
        );
      } else {
        await myStoryRepository.cancelLikeDislikeMyStory(
          myStoryId: "${state.item.id}",
          isLike: false,
        );
      }
      myStoryBloc.add(MyStoryUpdate());
      emit(
        state.copyWith(
          status: CoupleStoryDetailStatus.success,
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
        emit(state.copyWith(status: CoupleStoryDetailStatus.alreadyLike));
      } else {
        emit(state.copyWith(status: CoupleStoryDetailStatus.fail));
      }
    } catch (err) {
      emit(state.copyWith(status: CoupleStoryDetailStatus.fail));
    }
  }

  report() async {
    try {
      emit(state.copyWith(status: CoupleStoryDetailStatus.loading));
      await myStoryRepository.reportMysStory(
        myStoryId: "${state.item.id}",
      );
      emit(
        state.copyWith(
          status: CoupleStoryDetailStatus.reportSuccess,
        ),
      );
    } on ApiClientException {
      emit(state.copyWith(status: CoupleStoryDetailStatus.fail));
    } catch (err) {
      emit(state.copyWith(status: CoupleStoryDetailStatus.fail));
    }
  }

  delete() async {
    try {
      emit(state.copyWith(status: CoupleStoryDetailStatus.loading));
      await myStoryRepository.deleteMyStory(
        myStoryId: "${state.item.id}",
      );
      myStoryBloc.add(MyStoryUpdate());
      emit(
        state.copyWith(
          status: CoupleStoryDetailStatus.deleteSuccess,
        ),
      );
    } on ApiClientException {
      emit(state.copyWith(status: CoupleStoryDetailStatus.fail));
    } catch (err) {
      emit(state.copyWith(status: CoupleStoryDetailStatus.fail));
    }
  }

  comment(String comment) async {
    try {
      emit(state.copyWith(status: CoupleStoryDetailStatus.loading));
      await myStoryRepository.commentMyStory(
          myStoryId: "${state.item.id}", comment: comment);

      var _item = await myStoryRepository.getMyStory(
        myStoryId: "${state.item.id}",
        type: type,
      );

      myStoryBloc.add(MyStoryUpdate());

      emit(
        state.copyWith(
          status: CoupleStoryDetailStatus.success,
          dislikeStatus: _item?.dislikeStatus ?? false,
          dislike: _item?.dislike ?? 0,
          likeStatus: _item?.likeStatus ?? false,
          like: _item?.like ?? 0,
          item: _item,
        ),
      );
    } on ApiClientException {
      emit(state.copyWith(status: CoupleStoryDetailStatus.fail));
    } catch (err) {
      emit(state.copyWith(status: CoupleStoryDetailStatus.fail));
    }
  }
}
