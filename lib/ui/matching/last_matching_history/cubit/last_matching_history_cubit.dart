import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:oasis/enum/screen_status.dart';
import 'package:oasis/repository/matching_repository.dart';
import 'package:oasis/repository/user_repository.dart';

import 'last_matching_history_state.dart';


class LastMatchingHistoryCubit extends Cubit<LastMatchingHistoryState> {
  final UserRepository userRepository;
  final MatchingRepository matchingRepository;
  LastMatchingHistoryCubit({
    required this.userRepository,
    required this.matchingRepository,
  }) : super(LastMatchingHistoryState());

  initialize() async {
    emit(state.copyWith(status: ScreenStatus.loading));
    var user = await userRepository.getUser();
    var matchings = await matchingRepository.getLastMatching(
        customerId: "${user.customer?.id}");
    emit(
      state.copyWith(
        user: user,
        status: ScreenStatus.success,
          matchings:matchings,
      ),
    );
  }
}
