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

class ReceivedProposeDetailCubit extends Cubit<ReceivedProposeListState> {
  final Propose propose;
  final AppBloc appBloc;
  final MatchingRepository matchingRepository;
  final UserRepository userRepository;

  ReceivedProposeDetailCubit({
    required this.propose,
    required this.appBloc,
    required this.matchingRepository,
    required this.userRepository,
  }) : super(ReceivedProposeListState());

  initialize()  async {
    try {
      var compareTendency = await userRepository.compareTendency(
          customerId: propose.fromCustomer?.customer?.id);
      emit(state.copyWith(compareTendency:compareTendency));
    }catch(err){}
  }

  openCard({required String proposeId}) async {
    try {
      emit(state.copyWith(status: ScreenStatus.initial));
      await matchingRepository.openProposes(proposeId: proposeId);
      emit(state.copyWith(status: ScreenStatus.success));
    } on ApiClientException catch (err) {
      emit(state.copyWith(status: ScreenStatus.fail));
    }
  }

  acceptCard({required String proposeId, required bool accepted}) async {
    try {
      emit(state.copyWith(proposeStatus: ReceivedProposeStatus.initial));
      await matchingRepository.acceptPropose(
          proposeId: proposeId, accepted: accepted);
      appBloc.add(AppUpdate());
      if (accepted) {
        emit(state.copyWith(proposeStatus: ReceivedProposeStatus.success));
      } else {
        emit(state.copyWith(proposeStatus: ReceivedProposeStatus.reject));
      }
    } on ApiClientException catch (err) {
      if (err.statusCode == 402) {
        emit(state.copyWith(
            proposeStatus: ReceivedProposeStatus.notEnoughMeeting));
      } else {
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
    }
  }
}
