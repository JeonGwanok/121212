import 'package:equatable/equatable.dart';
import 'package:oasis/enum/screen_status.dart';
import 'package:oasis/model/matching/matchings.dart';
import 'package:oasis/model/matching/propose.dart';
import 'package:oasis/model/opti/compare_tendency.dart';

class LastMatchingDetailState extends Equatable {
  final ScreenStatus status; // 기본적으로 status 는 페이지 스테이터스
  final Matching matching;
  final CompareTendency compareTendency;

  LastMatchingDetailState({
    this.status = ScreenStatus.initial,
    this.matching = Matching.empty,
    this.compareTendency = CompareTendency.empty,
  });

  LastMatchingDetailState copyWith({
    ScreenStatus? status,
    Matching? matching,
    CompareTendency? compareTendency,
  }) {
    return LastMatchingDetailState(
      status: status ?? this.status,
      matching: matching ?? this.matching,
      compareTendency: compareTendency ?? this.compareTendency,
    );
  }

  @override
  List<Object?> get props => [
        status,
        matching,
        compareTendency,
      ];
}
