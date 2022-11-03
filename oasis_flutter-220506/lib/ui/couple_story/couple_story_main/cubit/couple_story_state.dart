import 'package:equatable/equatable.dart';
import 'package:oasis/enum/screen_status.dart';
import 'package:oasis/model/my_story/my_story_response.dart';
import 'package:oasis/model/user/user_profile.dart';

class CoupleStoryState extends Equatable {
  final ScreenStatus status;
  final UserProfile user;

  final MyStoryResponse? loves;
  final MyStoryResponse? marries;

  CoupleStoryState(
      {this.status = ScreenStatus.initial,
      this.user = UserProfile.empty,
      this.loves,
      this.marries});

  CoupleStoryState copyWith({
    ScreenStatus? status,
    UserProfile? user,
    MyStoryResponse? loves,
    MyStoryResponse? marries,
  }) {
    return CoupleStoryState(
      status: status ?? this.status,
      user: user ?? this.user,
      loves: loves ?? this.loves,
      marries: marries ?? this.marries,
    );
  }

  @override
  List<Object?> get props => [
        status,
        user,
        loves,
        marries,
      ];
}
