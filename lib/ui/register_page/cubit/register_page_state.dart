part of 'register_page_cubit.dart';

class RegisterPageState extends Equatable {
  final ScreenStatus status;
  final UserProfile user;
  final int page;

  RegisterPageState({
    this.status = ScreenStatus.initial,
    this.user = UserProfile.empty,
    this.page = 0,
  });

  RegisterPageState copyWith({
    ScreenStatus? status,
    UserProfile? user,
    int? page,
  }) {
    return RegisterPageState(
      status: status ?? this.status,
      user: user ?? this.user,
      page: page ?? this.page,
    );
  }

  @override
  List<Object?> get props => [
        status,
        user,
        page,
      ];
}
