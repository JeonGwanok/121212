import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:oasis/enum/screen_status.dart';
import 'package:oasis/model/matching/last_matching.dart';
import 'package:oasis/repository/matching_repository.dart';
import 'package:oasis/repository/user_repository.dart';
import 'package:oasis/ui/matching/last_matching_history/last_matching_detail/cubit/last_matching_detail_state.dart';

class LastMatchingDetailCubit extends Cubit<LastMatchingDetailState> {
  final LastMatching lastMatching;
  final MatchingRepository matchingRepository;
  final UserRepository userRepository;

  LastMatchingDetailCubit({
    required this.lastMatching,
    required this.matchingRepository,
    required this.userRepository,
  }) : super(LastMatchingDetailState());

  initialize() async {
    try {
      var matching = await matchingRepository.getMatching(
          cardId: "${lastMatching.cardId}");

      var compareTendency = await userRepository.compareTendency(
          customerId: matching?.fromCustomer?.customer?.id);

      emit(state.copyWith(
          matching: matching,
          status: ScreenStatus.success,
          compareTendency: compareTendency));
    } catch (err) {}
  }
}
