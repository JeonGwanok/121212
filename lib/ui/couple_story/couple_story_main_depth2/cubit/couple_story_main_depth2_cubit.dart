import 'dart:async';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:oasis/api_client/api_client.dart';
import 'package:oasis/bloc/my_story/my_story_bloc.dart';
import 'package:oasis/bloc/my_story/my_story_state.dart';
import 'package:oasis/enum/my_story/my_story.dart';
import 'package:oasis/enum/screen_status.dart';
import 'package:oasis/model/my_story/my_story_response.dart';
import 'package:oasis/repository/my_story_repository.dart';
import 'package:oasis/repository/user_repository.dart';
import 'package:oasis/ui/common/search_bar.dart';

import 'couple_story_main_depth2_state.dart';

class CoupleStoryMainDepth2Cubit extends Cubit<CoupleStoryMainDepth2State> {
  final MyStoryType type;
  final UserRepository userRepository;
  final MyStoryBloc myStoryBloc;
  final MyStoryRepository myStoryRepository;

  StreamSubscription? _subscription;

  CoupleStoryMainDepth2Cubit({
    required this.type,
    required this.userRepository,
    required this.myStoryBloc,
    required this.myStoryRepository,
  }) : super(CoupleStoryMainDepth2State()) {
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
      MyStoryResponse? response;

      switch (type) {
        case MyStoryType.daily:
          break;
        case MyStoryType.love:
          response = await myStoryRepository.getMyStorys(
            customerId: "${user.customer?.id}",
            page: 1,
            type: MyStoryType.love,
            searchType: state.searchSortType.key,
            searchText: state.searchText.isNotEmpty ? state.searchText : null,
          );
          break;
        case MyStoryType.marry:
          response = await myStoryRepository.getMyStorys(
            customerId: "${user.customer?.id}",
            page: 1,
            type: MyStoryType.marry,
            searchType: state.searchSortType.key,
            searchText: state.searchText.isNotEmpty ? state.searchText : null,
          );
          break;
      }

      emit(
        state.copyWith(
          user: user,
          status: ScreenStatus.success,
          totalCount: response?.count,
          page: 1,
          popular: type == MyStoryType.marry
              ? response?.marryList
              : response?.loveList,
          myStorys: response?.results ?? [],
        ),
      );
    } on ApiClientException {
      emit(state.copyWith(status: ScreenStatus.fail));
    } catch (err) {
      emit(state.copyWith(status: ScreenStatus.fail));
    }
  }

  pagination() async {
    try {
      if (state.totalCount > (state.myStorys?.length ?? 0)) {
        emit(state.copyWith(status: ScreenStatus.loading));

        MyStoryResponse? response;

        switch (type) {
          case MyStoryType.daily:
            break;
          case MyStoryType.love:
            response = await myStoryRepository.getMyStorys(
                customerId: "${state.user.customer?.id}",
                page: state.page + 1,
                type: MyStoryType.love,
                searchType: null,
                searchText: null);
            break;
          case MyStoryType.marry:
            response = await myStoryRepository.getMyStorys(
                customerId: "${state.user.customer?.id}",
                page: state.page + 1,
                type: MyStoryType.marry,
                searchType: null,
                searchText: null);
            break;
        }

        emit(
          state.copyWith(
            status: ScreenStatus.success,
            page: state.page + 1,
            myStorys: [...(state.myStorys ?? []), ...(response?.results ?? [])],
          ),
        );
      }
    } on ApiClientException {
      emit(state.copyWith(status: ScreenStatus.fail));
    } catch (err) {
      emit(state.copyWith(status: ScreenStatus.fail));
    }
  }

  changeSearchType(SearchSortType type) {
    emit(state.copyWith(searchSortType: type));
  }

  changeSearchText(String text) {
    emit(state.copyWith(searchText: text));
  }
}
