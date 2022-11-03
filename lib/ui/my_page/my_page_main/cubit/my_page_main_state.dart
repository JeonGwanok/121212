import 'package:equatable/equatable.dart';
import 'package:oasis/enum/screen_status.dart';
import 'package:oasis/model/user/user_profile.dart';

class MyPageMainState extends Equatable {
  final UserProfile user;
  final ScreenStatus status;

  MyPageMainState({
    this.user = UserProfile.empty,
    this.status = ScreenStatus.initial,
  });

  MyPageMainState copyWith({
    UserProfile? user,
    ScreenStatus? status,
  }) {
    return MyPageMainState(
      user: user ?? this.user,
      status: status ?? this.status,
    );
  }

  @override
  List<Object?> get props => [user, status];
}
