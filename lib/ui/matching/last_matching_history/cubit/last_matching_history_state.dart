import 'package:equatable/equatable.dart';
import 'package:oasis/enum/screen_status.dart';
import 'package:oasis/model/matching/last_matching.dart';
import 'package:oasis/model/user/user_profile.dart';

class LastMatchingHistoryState extends Equatable {
  final ScreenStatus status;
  final UserProfile user;
  final List<LastMatching> matchings;

  LastMatchingHistoryState({
    this.status = ScreenStatus.initial,
    this.user = UserProfile.empty,
    this.matchings = const [],
  });

  LastMatchingHistoryState copyWith({
    ScreenStatus? status,
    UserProfile? user,
    List<LastMatching>? matchings,
  }) {
    return LastMatchingHistoryState(
      status: status ?? this.status,
      user: user ?? this.user,
      matchings: matchings ?? this.matchings,
    );
  }

  @override
  List<Object?> get props => [
        status,
        user,
        matchings,
      ];
}
