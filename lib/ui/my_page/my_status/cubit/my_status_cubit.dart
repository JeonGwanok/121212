import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:oasis/bloc/app/app_bloc.dart';
import 'package:oasis/bloc/app/app_event.dart';
import 'package:oasis/enum/screen_status.dart';
import 'package:oasis/model/matching/meeting.dart';
import 'package:oasis/repository/matching_repository.dart';
import 'package:oasis/repository/user_repository.dart';

import 'my_status_state.dart';

class MyStatusCubit extends Cubit<MyStatusState> {
  final AppBloc appBloc;
  final UserRepository userRepository;
  final MatchingRepository matchingRepository;
  MyStatusCubit({
    required this.userRepository,
    required this.matchingRepository,
    required this.appBloc,
  }) : super(MyStatusState());

  initialize() async {
    emit(state.copyWith(status: ScreenStatus.loading));
    var user = await userRepository.getUser();
    MeetingResponse? meeting;
    var matchings = await matchingRepository.getMatchings(
        customerId: "${user.customer?.id}");

    (matchings ?? []).sort((a, b) => a.cardId!.compareTo(b.cardId!));

    if ((matchings ?? []).length >= 4) {
      matchings = (matchings ?? []).sublist(0, 4);
    }

    if ((user.customer?.nowStatus ?? "WAIT") != "WAIT" && (user.customer?.nowStatus ?? "WAIT") != "PROPOSE") {
      meeting = await matchingRepository.getMeetingInfo(
          customerId: "${user.customer?.id}");
    }

    emit(
      state.copyWith(
        user: user,
        meeting: meeting,
        status: ScreenStatus.loaded,
        uncheckedMatchingCount: (matchings ?? [])
            .where((e) => !(e.openStatus ?? false))
            .toList()
            .length,
      ),
    );
  }

  breakUp() async {
    try {
      await matchingRepository.breakUp(
          meetingId: "${state.meeting?.meeting?.id}");
      appBloc.add(AppUpdate());
      emit(state.copyWith(status: ScreenStatus.success));
      initialize();
    } catch (err) {}
  }
}
