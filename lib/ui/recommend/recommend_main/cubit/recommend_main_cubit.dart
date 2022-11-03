import 'dart:async';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:oasis/api_client/api_client.dart';
import 'package:oasis/bloc/community/community_bloc.dart';
import 'package:oasis/bloc/community/community_state.dart';
import 'package:oasis/enum/community/community.dart';
import 'package:oasis/enum/screen_status.dart';
import 'package:oasis/repository/matching_repository.dart';
import 'package:oasis/repository/user_repository.dart';
import 'package:oasis/ui/recommend/recommend_main/cubit/recommend_main_state.dart';

class RecommendMainCubit extends Cubit<RecommendMainState> {
  final CommunityType type;
  final int meetingId;
  final CommunityBloc communityBloc;
  final UserRepository userRepository;
  final MatchingRepository matchingRepository;

  StreamSubscription? _subscription;

  RecommendMainCubit({
    required this.type,
    required this.meetingId,
    required this.communityBloc,
    required this.matchingRepository,
    required this.userRepository,
  }) : super(RecommendMainState()) {
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
      var user = await userRepository.getUser();
      var items = await matchingRepository.getRecommend(
        meetingId: "$meetingId",
        type: type,
      );

      emit(
        state.copyWith(
          user:user,
          status: ScreenStatus.success,
          items: items ?? [],
        ),
      );
    } on ApiClientException {
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
