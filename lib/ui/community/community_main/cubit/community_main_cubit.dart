import 'dart:async';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:oasis/api_client/api_client.dart';
import 'package:oasis/bloc/community/bloc.dart';
import 'package:oasis/enum/community/community.dart';
import 'package:oasis/enum/screen_status.dart';
import 'package:oasis/repository/community_repository.dart';
import 'package:oasis/ui/common/search_bar.dart';

import 'community_main_state.dart';

class CommunityMainCubit extends Cubit<CommunityMainState> {
  final CommunityType type;
  final CommunityBloc communityBloc;
  final CommunityRepository communityRepository;
  final int? customerId; // 커스터머 유저 id가 있는 경우 특정 유저의 글만 가져옴

  StreamSubscription? _subscription;

  CommunityMainCubit({
    required this.type,
    required this.communityBloc,
    required this.communityRepository,
    this.customerId,
  }) : super(CommunityMainState()) {
    _subscription = communityBloc.stream.listen(_update);
  }

  void _update(CommunityState communityState) {
    CommunityState _communityState = communityBloc.state;
    if (_communityState is CommunityLoaded) {
      initialize();
    }
  }

  initialize() async {
    try {
      emit(state.copyWith(status: ScreenStatus.loading));
      var communityMain = await communityRepository.getCommunityMain(
        type: type,
        customerId: customerId,
        searchType: state.searchSortType.key,
        searchText: state.searchText.isNotEmpty ? state.searchText : null,
      );

      emit(
        state.copyWith(
          status: ScreenStatus.success,
          communityMain: communityMain,
        ),
      );
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

  @override
  Future<void> close() {
    _subscription?.cancel();
    return super.close();
  }
}
