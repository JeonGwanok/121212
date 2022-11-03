import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:oasis/bloc/app/app_bloc.dart';
import 'package:oasis/enum/my_story/my_story.dart';
import 'package:oasis/enum/screen_status.dart';
import 'package:oasis/repository/matching_repository.dart';
import 'package:oasis/repository/my_story_repository.dart';
import 'package:oasis/repository/user_repository.dart';

import 'confirm_meeting_state.dart';

class ConfirmMeetingCubit extends Cubit<ConfirmMeetingState> {
  final UserRepository userRepository;
  final AppBloc appBloc;
  final MyStoryRepository myStoryRepository;
  final MatchingRepository matchingRepository;
  ConfirmMeetingCubit({
    required this.appBloc,
    required this.userRepository,
    required this.matchingRepository,
    required this.myStoryRepository,
  }) : super(ConfirmMeetingState());

  initialize() async {
    try {
      emit(state.copyWith(status: ScreenStatus.loading));
      var user = await userRepository.getUser();
      var meeting = await matchingRepository.getMeetingInfo(
          customerId: "${user.customer?.id}");

      var myStory = await myStoryRepository.getMyStorys(
          customerId: "${meeting?.myInfo?.customer?.id}",
          page: 1,
          type: MyStoryType.daily,
          searchType: null,
          searchText: null);

      var partnerStory = await myStoryRepository.getMyStorys(
          customerId: "${meeting?.loverInfo?.customer?.id}",
          page: 1,
          type: MyStoryType.daily,
          searchType: null,
          searchText: null);

      emit(
        state.copyWith(
          user: user,
          status: ScreenStatus.success,
          myStoryCount: myStory?.results.length ?? 0,
          partnerStoryCount: partnerStory?.results.length ?? 0,
          meeting: meeting,
        ),
      );
    } catch (err) {
      state.copyWith(status: ScreenStatus.fail);
    }
  }
}
