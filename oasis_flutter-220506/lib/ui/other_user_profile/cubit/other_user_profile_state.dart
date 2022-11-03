import 'package:equatable/equatable.dart';
import 'package:oasis/enum/screen_status.dart';
import 'package:oasis/model/opti/compare_tendency.dart';

class OtherUserProfileState extends Equatable {
  final ScreenStatus status;
  final CompareTendency compareTendency;

  OtherUserProfileState(
      {this.status = ScreenStatus.initial,

      this.compareTendency = CompareTendency.empty});

  OtherUserProfileState copyWith({
    ScreenStatus? status,
    CompareTendency? compareTendency,
  }) {
    return OtherUserProfileState(
      status: status ?? this.status,
      compareTendency: compareTendency ?? this.compareTendency,
    );
  }

  @override
  List<Object?> get props => [
        status,
        compareTendency,
      ];
}
