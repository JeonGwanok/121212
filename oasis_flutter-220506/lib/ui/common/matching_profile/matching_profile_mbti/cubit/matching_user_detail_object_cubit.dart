import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:oasis/api_client/api_client.dart';
import 'package:oasis/enum/screen_status.dart';
import 'package:oasis/model/opti/tendencies.dart';
import 'package:oasis/repository/common_repository.dart';
import 'package:oasis/repository/matching_repository.dart';
import 'package:oasis/repository/user_repository.dart';

import 'matching_user_detail_object_state.dart';

class MatchingUserMBTIDetailCubit extends Cubit<MatchingUserMBTIDetailState> {
  final CommonRepository commonRepository;

  MatchingUserMBTIDetailCubit({
    required this.commonRepository,
  }) : super(MatchingUserMBTIDetailState());

  initialize() async {
    try {
      var tendencies = await commonRepository.getTendencies();
      Map<int, Tendency> result = {};
      for (var item in tendencies) {
        result[item.numbering!] = item;
      }

      emit(state.copyWith(
        tendencies: result,
      ));
    } on ApiClientException catch (err) {
      emit(state.copyWith(status: ScreenStatus.fail));
      throw err.type;
    } catch (err) {
      emit(state.copyWith(status: ScreenStatus.fail));
    }
  }
}
