import 'dart:math' as math;

import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:oasis/bloc/app/app_bloc.dart';
import 'package:oasis/bloc/app/app_event.dart';
import 'package:oasis/enum/screen_status.dart';
import 'package:oasis/model/opti/answer.dart';
import 'package:oasis/model/opti/mbti.dart';
import 'package:oasis/repository/common_repository.dart';
import 'package:oasis/repository/user_repository.dart';

part 'mbti_test_state.dart';

class MBTITestCubit extends Cubit<MBTITestState> {
  final UserRepository userRepository;
  final CommonRepository commonRepository;

  MBTITestCubit({
    required this.userRepository,
    required this.commonRepository,
  }) : super(MBTITestState());

  initialize() async {
    try {
      emit(state.copyWith(status: ScreenStatus.loading));
      var mbti = await commonRepository.getMBTI();
      emit(state.copyWith(mbti: mbti, status:  ScreenStatus.loaded));
    } catch (err) {
      emit(state.copyWith(status: ScreenStatus.fail));
    }
  }

  next() {
    if (state.mainPage == 0) {
      _nextMainPage();
    } else if (state.mainPage == 1) {
      _nextMainPage();
    } else if (state.mainPage == 2) {
      _nextQuestion();
    }
  }

  prev() {
    if (state.mainPage == 0) {
    } else if (state.mainPage == 1) {
      _prevMainPage();
    } else if (state.mainPage == 2) {
      if (state.questionNumber == 0) {
        _prevMainPage();
      } else if (state.questionNumber > 0) {
        _prevQuestion();
      }
    }
  }

  _nextMainPage() {
    var page = math.min(state.mainPage + 1, 2);

    emit(state.copyWith(
        mainPage: page,
        currentQuestion: page == 2 && state.questionNumber == 0
            ? state.mbti.preMbti.first
            : null));
  }

  _prevMainPage() {
    var page = math.max((state.mainPage - 1), 0);
    emit(state.copyWith(mainPage: page, currentQuestion: MBTIQuestion.empty));
  }

  _nextQuestion() {
    var questionNumber = math.min(
      state.questionNumber + 1,
      state.mbti.mainMbti.length +
          state.mbti.preMbti.length, // pre + main + 본인 mbti 입력
    );

    var question = MBTIQuestion.empty;

    if (questionNumber < 3) {
      question = state.mbti.preMbti[questionNumber];
    } else if (questionNumber == 3) {
      question = MBTIQuestion.empty;
    } else if (questionNumber > 3) {
      question = state.mbti.mainMbti[questionNumber - 4];
    }
    if (state.questionNumber + 1  > state.mbti.mainMbti.length + state.mbti.preMbti.length) {
      update();
    }
    emit(
      state.copyWith(questionNumber: questionNumber, currentQuestion: question),
    );
  }

  _prevQuestion() {
    var questionNumber = math.max((state.questionNumber - 1), 0);
    var question = MBTIQuestion.empty;

    if (questionNumber < 3) {
      question = state.mbti.preMbti[questionNumber];
    } else if (questionNumber == 3) {
      question = MBTIQuestion.empty;
    } else if (questionNumber > 3) {
      question = state.mbti.mainMbti[questionNumber - 4];
    }

    emit(state.copyWith(
        questionNumber: questionNumber, currentQuestion: question));
  }

  answerPrev(MBTIExample example) async {
    var result = {...state.preAnswers};
    result[state.currentQuestion.numbering!] =
        example.copyWith(questionNumber: state.currentQuestion.numbering);

    emit(
      state.copyWith(
        preAnswers: result,
      ),
    );

    await Future.delayed(Duration(milliseconds: 100));
    next();
  }

  answerMain(MBTIExample example) async {
    var result = {...state.mainAnswers};
    result[state.currentQuestion.numbering!] =
        example.copyWith(questionNumber: state.currentQuestion.numbering);
    ;

    emit(
      state.copyWith(
        mainAnswers: result,
      ),
    );

    // await Future.delayed(Duration(milliseconds: 100));
    next();
  }

  enterMBTI(String mbti) {
    emit(state.copyWith(myMBTI: mbti));
  }

  update() async {
    try {
      emit(state.copyWith(status: ScreenStatus.loading));
      var user = await userRepository.getUser();
      await userRepository.uploadMBTI(
        "${user.customer!.id}",
        state.myMBTI,
        state.preAnswers.values
            .map((e) =>
                OBTIAnswer(numbering: e.questionNumber, example: e.numbering))
            .toList(),
        state.mainAnswers.values
            .map((e) =>
                OBTIAnswer(numbering: e.questionNumber, example: e.numbering))
            .toList(),
      );
      emit(state.copyWith(status: ScreenStatus.success));
    } catch (err) {
      emit(state.copyWith(status: ScreenStatus.fail));
    }
  }
}
