import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:oasis/repository/common_repository.dart';

import 'frequently_question_state.dart';

class FrequentlyQuestionCubit extends Cubit<FrequentlyQuestionState> {
  final CommonRepository commonRepository;
  FrequentlyQuestionCubit({
    required this.commonRepository,
  }) : super(FrequentlyQuestionState());

  initialize() async {
    var questions = await commonRepository.getFrequentlyQuestions();
    emit(state.copyWith(questions: questions));
  }

  changeOpenStatus(int idx) {
    var items = [...state.questions];
    items[idx].uiShowAnswer = !items[idx].uiShowAnswer;
    emit(state.copyWith(questions: items, updateAt: DateTime.now()));
  }
}
