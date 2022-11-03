import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:oasis/api_client/api_client.dart';
import 'package:oasis/bloc/app/app_bloc.dart';
import 'package:oasis/bloc/app/app_event.dart';
import 'package:oasis/enum/screen_status.dart';
import 'package:oasis/model/matching/matchings.dart';
import 'package:oasis/model/matching/propose.dart';
import 'package:oasis/repository/matching_repository.dart';
import 'package:oasis/repository/user_repository.dart';
import 'package:oasis/ui/matching/received_propose_list/received_propose_list/cubit/received_propose_list_state.dart';
import 'package:oasis/ui/matching/received_propose_list/received_propose_detail/cubit/received_propose_detail_state.dart';

import 'matching_detail_state.dart';

class MatchingDetailCubit extends Cubit<MatchingDetailState> {
  final Matching matching;
  final AppBloc appBloc;
  final MatchingRepository matchingRepository;
  final UserRepository userRepository;

  MatchingDetailCubit({
    required this.matching,
    required this.appBloc,
    required this.matchingRepository,
    required this.userRepository,
  }) : super(MatchingDetailState());

  initialize() async {
    var compareTendency = await userRepository.compareTendency(
        customerId: matching.fromCustomer?.customer?.id);
    emit(state.copyWith(compareTendency: compareTendency));
  }

  openCard({required String proposeId}) async {
    try {
      emit(state.copyWith(status: ScreenStatus.initial));
      await matchingRepository.acceptMatching(
          cardId: "${matching.cardId}", openStatus: true);
      emit(state.copyWith(status: ScreenStatus.success));
    } on ApiClientException catch (err) {
      emit(state.copyWith(status: ScreenStatus.fail));
    }
  }

  acceptCard({required String proposeId, required bool accepted}) async {
    try {
      emit(state.copyWith(matchingStatus: MatchingStatus.initial));
      await matchingRepository.acceptMatching(
        cardId: "${matching.cardId}",
        openStatus: true,
        proposeStatus: accepted,
      );
      appBloc.add(AppUpdate());
      if (accepted) {
        emit(state.copyWith(matchingStatus: MatchingStatus.success));
      } else {
        emit(state.copyWith(matchingStatus: MatchingStatus.reject));
      }
    } on ApiClientException catch (err) {
      print("에러 $err");
      if (err.statusCode == 404) {
        // 없는 카드 입니다.
      }
      if (err.statusCode == 402) {
        emit(state.copyWith(matchingStatus: MatchingStatus.notEnoughMeeting));
      } else {
        if  (!(err.success ?? true)) {
          if (err.detail == "탈퇴한 회원입니다.") {
            emit(state.copyWith(matchingStatus: MatchingStatus.notFoundUser));
          } else /*if (err.detail == "상대방이 프로포즈 받을 수 없는 상태입니다.")*/ {
            emit(state.copyWith(matchingStatus: MatchingStatus.unableUser));
          }
        }
      }
    }
  }
}
