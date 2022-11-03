import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:oasis/api_client/api_client.dart';
import 'package:oasis/enum/screen_status.dart';
import 'package:oasis/repository/matching_repository.dart';
import 'package:oasis/repository/user_repository.dart';

import 'matching_user_detail_object_state.dart';

class MatchingUserDetailObjectCubit extends Cubit<MatchingUserDetailObjectState> {
  final MatchingRepository matchingRepository;
  final UserRepository userRepository;

  MatchingUserDetailObjectCubit({
    required this.matchingRepository,
    required this.userRepository,
  }) : super(MatchingUserDetailObjectState());

  initialize() async {
    try {
      var user = await userRepository.getUser();
      var certificate =
          await userRepository.getCertificate("${user.customer!.id}");
      emit(state.copyWith(
        status: ScreenStatus.success,
        certificate: certificate,
      ));
    } on ApiClientException catch (err) {
      emit(state.copyWith(status: ScreenStatus.fail));
      throw err.type;
    } catch (err) {
      emit(state.copyWith(status: ScreenStatus.fail));
    }
  }
}
