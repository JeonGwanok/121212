import 'dart:async';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:oasis/api_client/api_client.dart';
import 'package:oasis/bloc/community/community_bloc.dart';
import 'package:oasis/bloc/community/community_state.dart';
import 'package:oasis/enum/community/community.dart';
import 'package:oasis/enum/screen_status.dart';
import 'package:oasis/repository/community_repository.dart';
import 'package:oasis/ui/common/search_bar.dart';
import 'community_main_more_state.dart';

class CommunityMainMoreCubit extends Cubit<CommunityMainMoreState> {
  final CommunitySubType type;
  final CommunityBloc communityBloc;
  final CommunityRepository communityRepository;
  final int? customerId;

  StreamSubscription? _subscription;

  CommunityMainMoreCubit({
    required this.type,
    required this.communityBloc,
    required this.communityRepository,
    this.customerId,
  }) : super(CommunityMainMoreState()) {
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
      var items = await communityRepository.getCommunitySub(
        page: 1,
        type: type,
        customerId:customerId,
        searchType: state.searchSortType.key,
        searchText: state.searchText.isNotEmpty ? state.searchText : null,
      );

      emit(
        state.copyWith(
          status: ScreenStatus.success,
          totalCount: items?.count,
          page: 1,
          items: items?.results ?? [],
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
      if (state.totalCount > (state.items?.length ?? 0)) {
        emit(state.copyWith(status: ScreenStatus.loading));
        var items = await communityRepository.getCommunitySub(
            page: state.page + 1,
            customerId:customerId,
            type: type,
            searchType: null,
            searchText: null);

        emit(
          state.copyWith(
            status: ScreenStatus.success,
            page: state.page + 1,
            items: [...(state.items ?? []), ...(items?.results ?? [])],
          ),
        );
      }
    } on ApiClientException catch (err) {
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
