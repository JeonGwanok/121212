import 'package:equatable/equatable.dart';
import 'package:oasis/enum/screen_status.dart';
import 'package:oasis/model/matching/propose.dart';
import 'package:oasis/model/opti/compare_tendency.dart';

class SentProposeProfileState extends Equatable {
  final ScreenStatus status;
  final Propose propose;
  final CompareTendency compareTendency;

  SentProposeProfileState(
      {this.status = ScreenStatus.initial,
      this.propose = Propose.empty,
      this.compareTendency = CompareTendency.empty});

  SentProposeProfileState copyWith({
    ScreenStatus? status,
    Propose? propose,
    CompareTendency? compareTendency,
  }) {
    return SentProposeProfileState(
      status: status ?? this.status,
      propose: propose ?? this.propose,
      compareTendency: compareTendency ?? this.compareTendency,
    );
  }

  @override
  List<Object?> get props => [
        status,
        propose,
        compareTendency,
      ];
}
