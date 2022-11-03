import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:oasis/api_client/api_client.dart';
import 'package:oasis/enum/screen_status.dart';
import 'package:oasis/model/matching/matchings.dart';
import 'package:oasis/repository/matching_repository.dart';
import 'package:oasis/repository/user_repository.dart';

import 'matching_list_state.dart';

class MatchingListCubit extends Cubit<MatchingListState> {
  final MatchingRepository matchingRepository;
  final UserRepository userRepository;

  MatchingListCubit({
    required this.matchingRepository,
    required this.userRepository,
  }) : super(MatchingListState());

  initialize() async {
    try {
      var user = await userRepository.getUser();
      var matchings = await matchingRepository.getMatchings(
          customerId: "${user.customer!.id!}");

      (matchings ?? []).sort((a, b) => a.cardId!.compareTo(b.cardId!));

      if ((matchings ?? []).length >= 4) {
        matchings = (matchings ?? []).sublist(0, 4);
      }

      matchings = (matchings ?? [])
          .where((element) =>
              (element.proposeStatus == null || element.proposeStatus!))
          .toList();

      emit(state.copyWith(
        userProfile: user,
        status: ScreenStatus.loaded,
        matchings: matchings,
      ));
    } on ApiClientException catch (err) {
      emit(state.copyWith(status: ScreenStatus.fail));
      throw err.type;
    } catch (err) {
      emit(state.copyWith(status: ScreenStatus.fail));
    }
  }

  openCard({required Matching matching}) async {
    // 오픈한적 없거나, 오픈 상태가 false인 경우에만 해줌
    // if (matching.openStatus == null || matching.openStatus == false) {
      try {
        emit(state.copyWith(
            status: ScreenStatus.initial,
            matchingListStatus: MatchingListStatus.initial));
        await matchingRepository.acceptMatching(
            cardId: "${matching.cardId}", openStatus: true);
        emit(state.copyWith(status: ScreenStatus.success, current: matching));
      } on ApiClientException catch (err) {
        if (err.statusCode == 402) {
          emit(state.copyWith(
              matchingListStatus: MatchingListStatus.notEnoughMeeting));
        } else {
          if (!(err.success ?? true)) {
            if (err.detail == "탈퇴한 회원입니다.") {
              emit(state.copyWith(
                  matchingListStatus: MatchingListStatus.notFoundUser));
            } else /*if (err.detail == "상대방이 프로포즈 받을 수 없는 상태입니다.")*/ {
              emit(state.copyWith(
                  matchingListStatus: MatchingListStatus.unableUser));
            }
          }
        }
      }
      initialize();
    // }
  }
}
