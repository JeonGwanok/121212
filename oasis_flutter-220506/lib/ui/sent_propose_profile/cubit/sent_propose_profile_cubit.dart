import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:oasis/bloc/app/app_bloc.dart';
import 'package:oasis/model/matching/propose.dart';
import 'package:oasis/repository/user_repository.dart';
import 'sent_propose_profile_state.dart';

class SentProposeProfileCubit extends Cubit<SentProposeProfileState> {
  final Propose propose;
  final UserRepository userRepository;
  final AppBloc appBloc;

  SentProposeProfileCubit({
    required this.propose,
    required this.appBloc,
    required this.userRepository,
  }) : super(SentProposeProfileState(propose: propose));

  initialize() async {
    try {
      var compareTendency = await userRepository.compareTendency(
          customerId: propose.toCustomer?.customer?.id);
      emit(state.copyWith(compareTendency: compareTendency));
    } catch (err) {}
  }
}
