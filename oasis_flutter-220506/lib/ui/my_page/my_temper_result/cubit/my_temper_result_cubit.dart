import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:oasis/enum/screen_status.dart';
import 'package:oasis/model/opti/tendencies.dart';
import 'package:oasis/repository/common_repository.dart';
import 'package:oasis/repository/user_repository.dart';

import 'my_temper_result_state.dart';

class TemperResultCubit extends Cubit<TemperResultState> {
  final UserRepository userRepository;
  final CommonRepository commonRepository;

  TemperResultCubit({
    required this.userRepository,
    required this.commonRepository,
  }) : super(TemperResultState());

  initialize() async {
    try {
      emit(state.copyWith(status: ScreenStatus.loading));
      var user = await userRepository.getUser();
      var mbtiDetail = await userRepository.getUserMBTIDetail(
        customerId: user.customer?.id,
      );
      var mbtiMain = await userRepository.getUserMBTIMain(
        customerId: user.customer?.id,
      );
      var tendencies = await commonRepository.getTendencies();

      Map<int, Tendency> result = {};

      for (var item in tendencies) {
        result[item.numbering!] = item;
      }

      emit(state.copyWith(
        status: ScreenStatus.loaded,
        user: user,
        mbtiDetail: mbtiDetail,
        mbtiMain: mbtiMain,
        tendencies: result,
        myMBTI: "${mbtiDetail?.beforeMbtiResult ?? ""}",
      ));
    } catch (err) {}
  }

  enterMyMBTI(String mpti) {
    emit(state.copyWith(myMBTI: mpti));
  }

  updateMyMBTI() async {
    try {
      emit(state.copyWith(status: ScreenStatus.loaded));
      await userRepository.changeOriginMBTI(
          customerId: state.user.customer?.id, customerMbti: state.myMBTI);
      emit(state.copyWith(status: ScreenStatus.success));
      initialize();
    } catch (err) {
      emit(state.copyWith(status: ScreenStatus.fail));
    }
  }
}
