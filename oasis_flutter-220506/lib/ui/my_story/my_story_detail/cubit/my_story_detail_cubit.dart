import 'dart:math';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:oasis/api_client/api_client.dart';
import 'package:oasis/bloc/my_story/bloc.dart';
import 'package:oasis/enum/my_story/my_story.dart';
import 'package:oasis/model/my_story/my_story.dart';
import 'package:oasis/repository/my_story_repository.dart';
import 'package:oasis/repository/user_repository.dart';

import 'my_story_detail_state.dart';

class MyStoryDetailCubit extends Cubit<MyStoryDetailState> {
  final MyStory myStory;
  final MyStoryBloc myStoryBloc;
  final UserRepository userRepository;
  final MyStoryRepository myStoryRepository;
  MyStoryDetailCubit({
    required this.myStory,
    required this.myStoryBloc,
    required this.userRepository,
    required this.myStoryRepository,
  }) : super(MyStoryDetailState());

  initialize() async {
    try {
      emit(state.copyWith(status: MyStoryDetailStatus.loading));
      var _myStory = await myStoryRepository.getMyStory(
        myStoryId: "${myStory.id}",
        type: MyStoryType.daily,
      );

      var user = await userRepository.getUser();

      emit(
        state.copyWith(
          status: MyStoryDetailStatus.success,
          likeStatus: _myStory?.likeStatus ?? false,
          like: _myStory?.like ?? 0,
          myStory: _myStory,
          user: user,
        ),
      );
    } on ApiClientException catch (err) {
      emit(state.copyWith(status: MyStoryDetailStatus.fail));
    } catch (err) {
      emit(state.copyWith(status: MyStoryDetailStatus.fail));
    }
  }

  previous() async {
    try {
      emit(state.copyWith(status: MyStoryDetailStatus.loading));
      var _myStory = await myStoryRepository.getPreviousMyStory(
        myStoryId: "${state.myStory.id}",
        type: MyStoryType.daily,
      );

      emit(
        state.copyWith(
          status: MyStoryDetailStatus.success,
          myStory: _myStory,
          likeStatus: _myStory?.likeStatus ?? false,
          like: _myStory?.like ?? 0,
        ),
      );
    } on ApiClientException catch (err) {
      if (err.detail == "No MyStory Daily") {
        emit(state.copyWith(status: MyStoryDetailStatus.notFound));
      } else {
        emit(state.copyWith(status: MyStoryDetailStatus.fail));
      }
    } catch (err) {
      emit(state.copyWith(status: MyStoryDetailStatus.fail));
    }
  }

  next() async {
    try {
      emit(state.copyWith(status: MyStoryDetailStatus.loading));
      var _myStory = await myStoryRepository.getNextMyStory(
        myStoryId: "${state.myStory.id}",
        type: MyStoryType.daily,
      );

      emit(
        state.copyWith(
          status: MyStoryDetailStatus.success,
          myStory: _myStory,
          likeStatus: _myStory?.likeStatus ?? false,
          like: _myStory?.like ?? 0,
        ),
      );
    } on ApiClientException catch (err) {
      if (err.detail == "No MyStory Daily") {
        emit(state.copyWith(status: MyStoryDetailStatus.notFound));
      } else {
        emit(state.copyWith(status: MyStoryDetailStatus.fail));
      }
    } catch (err) {
      emit(state.copyWith(status: MyStoryDetailStatus.fail));
    }
  }

  like() async {
    try {
      emit(state.copyWith(status: MyStoryDetailStatus.loading));
      if (!state.likeStatus) {
        await myStoryRepository.likeDislikeMyStory(
          myStoryId: "${state.myStory.id}",
          isLike: true,
        );
      } else {
        await myStoryRepository.cancelLikeDislikeMyStory(
          myStoryId: "${state.myStory.id}",
          isLike: true,
        );
      }myStoryBloc.add(MyStoryUpdate());
      emit(
        state.copyWith(
          status: MyStoryDetailStatus.success,
          likeStatus: !state.likeStatus,
          like: state.likeStatus ? max(0, state.like - 1) : state.like + 1,
        ),
      );
    } on ApiClientException catch (err) {
      emit(state.copyWith(status: MyStoryDetailStatus.fail));
    } catch (err) {
      emit(state.copyWith(status: MyStoryDetailStatus.fail));
    }
  }

  report(String content) async {
    try {
      emit(state.copyWith(status: MyStoryDetailStatus.loading));
      await myStoryRepository.reportMysStory(
        myStoryId: "${state.myStory.id}",
      );
      myStoryBloc.add(MyStoryUpdate());
      emit(
        state.copyWith(
          status: MyStoryDetailStatus.reportSuccess,
        ),
      );
    } on ApiClientException catch (err) {
      emit(state.copyWith(status: MyStoryDetailStatus.fail));
    } catch (err) {
      emit(state.copyWith(status: MyStoryDetailStatus.fail));
    }
  }

  block() async {
    try {
      emit(state.copyWith(status: MyStoryDetailStatus.loading));
      await userRepository.blockUser(
        customerId: "${state.myStory.customerId}",
      );
      myStoryBloc.add(MyStoryUpdate());
      emit(
        state.copyWith(
          status: MyStoryDetailStatus.blockSuccess,
        ),
      );
    } on ApiClientException catch (err) {
      emit(state.copyWith(status: MyStoryDetailStatus.fail));
    } catch (err) {
      emit(state.copyWith(status: MyStoryDetailStatus.fail));
    }
  }

  delete() async {
    try {
      emit(state.copyWith(status: MyStoryDetailStatus.loading));
      await myStoryRepository.deleteMyStory(
        myStoryId: "${state.myStory.id}",
      );
      myStoryBloc.add(MyStoryUpdate());
      emit(
        state.copyWith(
          status: MyStoryDetailStatus.deleteSuccess,
        ),
      );
    } on ApiClientException catch (err) {
      emit(state.copyWith(status: MyStoryDetailStatus.fail));
    } catch (err) {
      emit(state.copyWith(status: MyStoryDetailStatus.fail));
    }
  }
}
