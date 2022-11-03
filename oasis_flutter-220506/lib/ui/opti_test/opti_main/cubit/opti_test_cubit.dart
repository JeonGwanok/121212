import 'dart:async';

import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:oasis/bloc/app/app_bloc.dart';
import 'package:oasis/bloc/app/app_state.dart';
import 'package:oasis/enum/screen_status.dart';
import 'package:oasis/model/user/opti/user_mbti_detail.dart';
import 'package:oasis/model/user/opti/user_mbti_main.dart';
import 'package:oasis/model/user/user_profile.dart';
import 'package:oasis/repository/user_repository.dart';

part 'opti_test_state.dart';

class OPTITestCubit extends Cubit<OPTITestState> {
  final UserRepository userRepository;

  OPTITestCubit({
    required this.userRepository,
  }) : super(OPTITestState());

  initialize() async {
    try {
      emit(state.copyWith(status: ScreenStatus.loading));
      var user = await userRepository.getUser();
      var mbti =
          await userRepository.getUserMBTIMain(customerId: user.customer?.id);
      var mbtiDetail =
          await userRepository.getUserMBTIDetail(customerId: user.customer?.id);
      emit(state.copyWith(
        user: user,
        mbtiMain: mbti,
        mbtiDetail: mbtiDetail,
        status: ScreenStatus.loaded,
      ));
    } catch (err) {
      print(err);
    }
  }
}
