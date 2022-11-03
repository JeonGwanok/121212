import 'package:equatable/equatable.dart';
import 'package:oasis/enum/screen_status.dart';
import 'package:oasis/model/community/community.dart';
import 'package:oasis/model/user/user_profile.dart';
import 'package:oasis/ui/common/search_bar.dart';

class RecommendMainState extends Equatable {
  final ScreenStatus status;
  final List<CommunityResponseItem>? items;
  final UserProfile user;

  RecommendMainState({
    this.status = ScreenStatus.initial,
    this.items,
    this.user = UserProfile.empty,
  });

  RecommendMainState copyWith({
    ScreenStatus? status,
    List<CommunityResponseItem>? items,
    UserProfile? user,
  }) {
    return RecommendMainState(
      status: status ?? this.status,
      items: items ?? this.items,
      user: user ?? this.user,
    );
  }

  @override
  List<Object?> get props => [
        status,
        items,
        user,
      ];
}
