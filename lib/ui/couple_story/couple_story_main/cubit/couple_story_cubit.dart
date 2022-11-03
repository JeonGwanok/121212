import 'dart:async';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:oasis/api_client/api_client.dart';
import 'package:oasis/bloc/my_story/my_story_bloc.dart';
import 'package:oasis/bloc/my_story/my_story_state.dart';
import 'package:oasis/enum/my_story/my_story.dart';
import 'package:oasis/enum/screen_status.dart';
import 'package:oasis/repository/my_story_repository.dart';
import 'package:oasis/repository/user_repository.dart';

import 'couple_story_state.dart';

class CoupleStoryCubit extends Cubit<CoupleStoryState> {
  final UserRepository userRepository;
  final MyStoryBloc myStoryBloc;
  final MyStoryRepository myStoryRepository;

  StreamSubscription? _subscription;

  CoupleStoryCubit({
    required this.userRepository,
    required this.myStoryBloc,
    required this.myStoryRepository,
  }) : super(CoupleStoryState()) {
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
      var loveStories = await myStoryRepository.getMyStorys(
          customerId: "${user.customer?.id}",
          page: 1,
          type: MyStoryType.love,
          searchType: null,
          searchText: null);

      var marryStories = await myStoryRepository.getMyStorys(
          customerId: "${user.customer?.id}",
          page: 1,
          type: MyStoryType.marry,
          searchType: null,
          searchText: null);

      emit(
        state.copyWith(
          user: user,
          status: ScreenStatus.success,
          marries: marryStories,
          loves: loveStories,
        ),
      );
    } on ApiClientException {
      emit(state.copyWith(status: ScreenStatus.fail));
    } catch (err){
      emit(state.copyWith(status: ScreenStatus.fail));
    }
  }

  @override
  Future<void> close() {
    _subscription?.cancel();
    return super.close();
  }
}
