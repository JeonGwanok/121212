import 'package:equatable/equatable.dart';
import 'package:oasis/enum/screen_status.dart';
import 'package:oasis/model/opti/tendencies.dart';

class MatchingUserMBTIDetailState extends Equatable {
  final ScreenStatus status;
  final Map<int, Tendency> tendencies; // 번호, 객체

  MatchingUserMBTIDetailState({
    this.status = ScreenStatus.success,
    this.tendencies = const {},
  });

  MatchingUserMBTIDetailState copyWith({
    ScreenStatus? status,
    Map<int, Tendency>? tendencies,
  }) {
    return MatchingUserMBTIDetailState(
      status: status ?? this.status,
      tendencies: tendencies ?? this.tendencies,
    );
  }

  @override
  List<Object?> get props => [
        status,
        tendencies,
      ];
}
