part of 'mbti_test_cubit.dart';

class MBTITestState extends Equatable {
  final ScreenStatus status;
  final int mainPage; // 0: 설명 1, 1: 설명 2, 2: 문제 시작
  final int questionNumber;
  final MBTIQuestion currentQuestion;
  final String myMBTI;

  final MBTI mbti;

  final Map<int, MBTIExample> preAnswers;
  final Map<int, MBTIExample> mainAnswers;

  MBTITestState({
    this.status = ScreenStatus.initial,
    this.mainPage = 0,
    this.questionNumber = 0,
    this.mbti = MBTI.isEmpty,
    this.preAnswers = const {},
    this.mainAnswers = const {},
    this.myMBTI = "",
    this.currentQuestion = MBTIQuestion.empty,
  });

  MBTITestState copyWith(
      {ScreenStatus? status,
      int? mainPage,
      int? questionNumber,
      String? myMBTI,
      MBTI? mbti,
      MBTIQuestion? currentQuestion,
      Map<int, MBTIExample>? preAnswers,
      Map<int, MBTIExample>? mainAnswers}) {
    return MBTITestState(
        mainPage: mainPage ?? this.mainPage,
        questionNumber: questionNumber ?? this.questionNumber,
        mbti: mbti ?? this.mbti,
        myMBTI: myMBTI ?? this.myMBTI,
        preAnswers: preAnswers ?? this.preAnswers,
        mainAnswers: mainAnswers ?? this.mainAnswers,
        currentQuestion: currentQuestion ?? this.currentQuestion,
        status: status ?? this.status);
  }

  @override
  List<Object?> get props => [
        status,
        currentQuestion,
        mainPage,
        questionNumber,
        mbti,
        preAnswers,
        myMBTI,
        mainAnswers,
      ];
}
