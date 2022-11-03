import 'dart:async';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:oasis/api_client/api_client.dart';
import 'package:oasis/bloc/my_story/bloc.dart';
import 'package:oasis/enum/my_story/my_story.dart';
import 'package:oasis/enum/screen_status.dart';
import 'package:oasis/repository/my_story_repository.dart';
import 'package:oasis/repository/user_repository.dart';

import 'my_story_main_state.dart';

// 나든 아니든 무조건 customerId 받고, 만약 없으면 모두의 글
class MyStoryMainCubit extends Cubit<MyStoryMainState> {
  final UserRepository userRepository;
  final int? customerId;
  final MyStoryBloc myStoryBloc;
  final MyStoryRepository myStoryRepository;

  StreamSubscription? _subscription;

  MyStoryMainCubit({
    this.customerId,
    required this.userRepository,
    required this.myStoryBloc,
    required this.myStoryRepository,
  }) : super(MyStoryMainState()) {
    _subscription = myStoryBloc.stream.listen(_update);
  }

  void _update(MyStoryState communityState) {
    MyStoryState _myState = myStoryBloc.state;
    if (_myState is MyStoryLoaded) {
      initialize();
    }
  }

  initialize() async {
    try {
      emit(state.copyWith(status: ScreenStatus.loading));
      var user = await userRepository.getUser();
      var myStorys = customerId != null
          ? await myStoryRepository.getMyStorys(
              customerId: "$customerId",
              page: 1,
              type: MyStoryType.daily,
              searchType: null,
              searchText: null)
          : await myStoryRepository.getAllMyStorys(page: 1);

      emit(
        state.copyWith(
          user: user,
          customerId: customerId,
          status: ScreenStatus.success,
          totalCount: myStorys?.count,
          page: 1,
          myStorys: myStorys?.results ?? [],
        ),
      );
    } on ApiClientException catch (err) {
      emit(state.copyWith(status: ScreenStatus.fail));
    } catch (err) {
      emit(state.copyWith(status: ScreenStatus.fail));
    }
  }

  pagination() async {
    try {
      if (state.totalCount > (state.myStorys?.length ?? 0)) {
        emit(state.copyWith(status: ScreenStatus.loading));
        var myStorys = customerId != null
            ? await myStoryRepository.getMyStorys(
                customerId: "$customerId",
                page: state.page + 1,
                type: MyStoryType.daily,
                searchType: null,
                searchText: null)
            : await myStoryRepository.getAllMyStorys(page: 1);

        emit(
          state.copyWith(
            status: ScreenStatus.success,
            page: state.page + 1,
            myStorys: [...(state.myStorys ?? []), ...(myStorys?.results ?? [])],
          ),
        );
      }
    } on ApiClientException catch (err) {
      emit(state.copyWith(status: ScreenStatus.fail));
    } catch (err) {
      emit(state.copyWith(status: ScreenStatus.fail));
    }
  }

  @override
  Future<void> close() {
    _subscription?.cancel();
    return super.close();
  }
}
