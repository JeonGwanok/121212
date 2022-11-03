import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:oasis/bloc/app/app_bloc.dart';
import 'package:oasis/model/user/user_profile.dart';
import 'package:oasis/repository/user_repository.dart';

import 'other_user_profile_state.dart';

class OtherUserProfileCubit extends Cubit<OtherUserProfileState> {
  final UserProfile user;
  final UserRepository userRepository;
  final AppBloc appBloc;

  OtherUserProfileCubit({
    required this.user,
    required this.appBloc,
    required this.userRepository,
  }) : super(OtherUserProfileState());

  initialize() async {
    try {
      var compareTendency = await userRepository.compareTendency(
          customerId: user.customer?.id);
      emit(state.copyWith(compareTendency: compareTendency));
    } catch (err) {}
  }
}
