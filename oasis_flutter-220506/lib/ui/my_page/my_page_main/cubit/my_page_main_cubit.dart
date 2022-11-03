import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:oasis/enum/screen_status.dart';
import 'package:oasis/repository/user_repository.dart';

import 'my_page_main_state.dart';

class MyPageMainCubit extends Cubit<MyPageMainState> {
  final UserRepository userRepository;

  MyPageMainCubit({
    required this.userRepository,
  }) : super(MyPageMainState());

  initialize() async {
    try {
      var user = await userRepository.getUser();
      emit(state.copyWith(user: user, status: ScreenStatus.success));
    } catch (err) {
      emit(state.copyWith(status: ScreenStatus.fail));
    }
  }
}
