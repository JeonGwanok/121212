
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:oasis/api_client/api_client.dart';
import 'package:oasis/bloc/app/app_bloc.dart';
import 'package:oasis/bloc/app/app_event.dart';
import 'package:oasis/enum/screen_status.dart';
import 'package:oasis/model/matching/propose.dart';
import 'package:oasis/repository/matching_repository.dart';
import 'package:oasis/repository/user_repository.dart';
import 'package:oasis/ui/matching/received_propose_list/received_propose_list/cubit/received_propose_list_state.dart';
import 'package:oasis/ui/matching/received_propose_list/received_propose_detail/cubit/received_propose_detail_state.dart';

class ReceivedProposeListCubit extends Cubit<ReceivedProposeListState> {
  final MatchingRepository matchingRepository;
  final AppBloc appBloc;
  final UserRepository userRepository;

  ReceivedProposeListCubit({
    required this.appBloc,
    required this.matchingRepository,
    required this.userRepository,
  }) : super(ReceivedProposeListState());

  initialize() async {
    try {
      var user = await userRepository.getUser();
      var proposes = await matchingRepository.getProposes(
          customerId: "${user.customer!.id!}");

      (proposes ?? []).sort((a, b) => (a.createdAt ?? DateTime.now())
          .compareTo(b.createdAt ?? DateTime.now()));

      emit(state.copyWith(
        userProfile: user,
        status: ScreenStatus.loaded,
        proposes: proposes,
      ));
    } on ApiClientException catch (err) {
      emit(state.copyWith(status: ScreenStatus.fail));
      throw err.type;
    } catch (err) {
      emit(state.copyWith(status: ScreenStatus.fail));
    }
  }

  openCard({required Propose propose}) async {
    // if (!(propose.openStatus ?? false)) {
      try {
        emit(state.copyWith(
            status: ScreenStatus.initial,
            proposeStatus: ReceivedProposeStatus.initial));
        await matchingRepository.openProposes(
            proposeId: "${propose.proposeId}");
        emit(state.copyWith(status: ScreenStatus.success, current: propose));
      } on ApiClientException catch (err) {
        if (!(err.success ?? true)) {
          if (err.detail == "탈퇴한 회원입니다.") {
            emit(state.copyWith(
                proposeStatus: ReceivedProposeStatus.notFoundUser));
          } else /*if (err.detail == "상대방이 프로포즈 받을 수 없는 상태입니다.")*/ {
            emit(state.copyWith(
                proposeStatus: ReceivedProposeStatus.unableUser));
          }
        }
      }
      initialize();
    // }
  }

  acceptCard({required String proposeId, required bool accepted}) async {
    try {
      emit(state.copyWith(
          status: ScreenStatus.initial,
          proposeStatus: ReceivedProposeStatus.initial));
      await matchingRepository.acceptPropose(
          proposeId: proposeId, accepted: accepted);
      if (accepted) {
        appBloc.add(AppUpdate());
        emit(state.copyWith(proposeStatus: ReceivedProposeStatus.success));
      } else {
        emit(state.copyWith(proposeStatus: ReceivedProposeStatus.reject));
      }
    } on ApiClientException catch (err) {
      if (err.statusCode == 402) {
        emit(state.copyWith(
            proposeStatus: ReceivedProposeStatus.notEnoughMeeting));
      } else {
        if  (!(err.success ?? true)) {
          if (err.detail == "탈퇴한 회원입니다.") {
            emit(state.copyWith(
                proposeStatus: ReceivedProposeStatus.notFoundUser));
          } else /*if (err.detail == "상대방이 프로포즈 받을 수 없는 상태입니다.")*/ {
            emit(state.copyWith(
                proposeStatus: ReceivedProposeStatus.unableUser));
          }
        }
      }
    }
    initialize();
  }
}
