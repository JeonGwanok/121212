part of 'tendency_test_cubit.dart';

class TendencyTestState extends Equatable {
  final ScreenStatus status;
  final int mainPage; // 0: 설명1, 1: 문제1,  2: 문제2,
  final List<Tendency> tendencies;
  final Map<int, Tendency> answers;

  TendencyTestState({
    this.status = ScreenStatus.initial,
    this.mainPage = 0,
    this.tendencies = const [],
    this.answers = const {},
  });

  TendencyTestState copyWith({
    ScreenStatus? status,
    int? mainPage,
    List<Tendency>? tendencies,
    Map<int, Tendency>? answers,
  }) {
    return TendencyTestState(
      status: status ?? this.status,
      mainPage: mainPage ?? this.mainPage,
      tendencies: tendencies ?? this.tendencies,
      answers: answers ?? this.answers,
    );
  }

  @override
  List<Object?> get props => [
        status,
        mainPage,
        tendencies,
        answers,
      ];
}
