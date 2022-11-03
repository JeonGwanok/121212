import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:oasis/api_client/api_client.dart';
import 'package:oasis/enum/screen_status.dart';
import 'package:oasis/model/matching/ai_matching.dart';
import 'package:oasis/repository/matching_repository.dart';
import 'package:oasis/repository/user_repository.dart';

import 'ai_matching_list_state.dart';

class AiMatchingListCubit extends Cubit<AiMatchingListState> {
  final MatchingRepository matchingRepository;
  final UserRepository userRepository;

  AiMatchingListCubit({
    required this.matchingRepository,
    required this.userRepository,
  }) : super(AiMatchingListState());

  initialize() async {
    try {
      var user = await userRepository.getUser();
      var aiMatchings = await matchingRepository.getAiMatchings(
          customerId: "${user.customer!.id!}");
      (aiMatchings ?? []).insert(0, AiMatching.empty);
      emit(state.copyWith(
        status: ScreenStatus.success,
        aiMatchings: aiMatchings,
      ));
    } on ApiClientException catch (err) {
      emit(state.copyWith(status: ScreenStatus.fail));
      throw err.type;
    } catch (err) {
      emit(state.copyWith(status: ScreenStatus.fail));
    }
  }
}
