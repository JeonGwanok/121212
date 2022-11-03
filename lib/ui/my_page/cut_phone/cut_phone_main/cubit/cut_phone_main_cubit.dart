import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:oasis/enum/screen_status.dart';
import 'package:oasis/repository/user_repository.dart';

import 'cut_phone_main_state.dart';

class CutPhoneMainCubit extends Cubit<CutPhoneMainState> {
  final UserRepository userRepository;
  CutPhoneMainCubit({
    required this.userRepository,
  }) : super(CutPhoneMainState());

  initialize() async {
    try {
      emit(state.copyWith(status: ScreenStatus.loading));
      var user = await userRepository.getUser();
      var registered =
          await userRepository.getCutPhones(customerId: "${user.customer?.id}");
      emit(
          state.copyWith(status: ScreenStatus.success, registered: registered));
    } catch (err) {
      emit(state.copyWith(status: ScreenStatus.fail));
    }
  }
}
