import 'dart:math' as math;

import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:oasis/bloc/app/app_bloc.dart';
import 'package:oasis/bloc/app/app_event.dart';
import 'package:oasis/enum/screen_status.dart';
import 'package:oasis/model/opti/answer.dart';
import 'package:oasis/model/opti/mbti.dart';
import 'package:oasis/model/opti/tendencies.dart';
import 'package:oasis/repository/common_repository.dart';
import 'package:oasis/repository/user_repository.dart';

part 'tendency_test_state.dart';

class TendencyTestCubit extends Cubit<TendencyTestState> {
  final UserRepository userRepository;
  final CommonRepository commonRepository;

  TendencyTestCubit({
    required this.userRepository,
    required this.commonRepository,
  }) : super(TendencyTestState());

  initialize() async {
    try {
      var tendencies = await commonRepository.getTendencies();
      emit(state.copyWith(tendencies: tendencies));
    } catch (err) {}
  }

  next() {
    var page = math.min((state.mainPage + 1), 2);
    emit(state.copyWith(mainPage: page));
  }

  prev() {
    var page = math.max((state.mainPage - 1), 0);
    emit(state.copyWith(mainPage: page));
  }

  enterAnswer(Tendency question, bool value) {
    var result = {...state.answers};

    if (result.containsKey(question.numbering) &&result[question.numbering]!.answer == value  ) {
      result.remove(question.numbering!);
    } else {
      result[question.numbering!] = question.copyWith(answer: value);
    }

    emit(state.copyWith(answers: result));
  }

  update() async {
    try {
      emit(state.copyWith(status: ScreenStatus.loading));
      var user = await userRepository.getUser();
      await userRepository.uploadTendency(
        "${user.customer!.id}",
        state.answers.values.toList(),
      );
      emit(state.copyWith(status: ScreenStatus.success));
    } catch (err) {
      emit(state.copyWith(status: ScreenStatus.fail));
    }
  }
}
