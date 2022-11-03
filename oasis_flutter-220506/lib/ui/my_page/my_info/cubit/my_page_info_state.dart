import 'package:equatable/equatable.dart';
import 'package:oasis/enum/screen_status.dart';
import 'package:oasis/model/user/user_profile.dart';
import 'package:oasis/ui/sign/sign_up/component/terms/terms_model.dart';

class MyPageInfoState extends Equatable {
  final UserProfile user;
  final ScreenStatus status;
  final List<TermsModel> terms;

  MyPageInfoState({
    this.user = UserProfile.empty,
    this.status = ScreenStatus.initial,
    this.terms = const [],
  });

  MyPageInfoState copyWith({
    UserProfile? user,
    ScreenStatus? status,
    List<TermsModel>? terms,
  }) {
    return MyPageInfoState(
      user: user ?? this.user,
      status: status ?? this.status,
      terms: terms ?? this.terms,
    );
  }

  @override
  List<Object?> get props => [
        user,
        status,
        terms,
      ];
}
