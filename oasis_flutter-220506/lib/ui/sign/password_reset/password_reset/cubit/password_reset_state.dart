part of 'password_reset_cubit.dart';

class PasswordResetState extends Equatable {
  final ScreenStatus status;

  final String username;

  final String password;
  final String rePassword;

  final PasswordFieldStatus passwordStatus;
  final RepasswordFieldStatus repwStatus;

  final DateTime? updatedAt;

  PasswordResetState({
    this.status = ScreenStatus.initial,
    this.username = "",
    this.password = "",
    this.rePassword = "",
    this.passwordStatus = PasswordFieldStatus.initial,
    this.repwStatus = RepasswordFieldStatus.initial,
    this.updatedAt,
  });

  get enableButton =>
      passwordStatus == PasswordFieldStatus.success &&
      repwStatus == RepasswordFieldStatus.success;

  PasswordResetState copyWith({
    ScreenStatus? status,
    String? username,
    String? password,
    String? rePassword,
    PasswordFieldStatus? passwordStatus,
    RepasswordFieldStatus? repwStatus,
    DateTime? updatedAt,
  }) {
    return PasswordResetState(
      status: status ?? this.status,
      username: username ?? this.username,
      password: password ?? this.password,
      rePassword: rePassword ?? this.rePassword,
      passwordStatus: passwordStatus ?? this.passwordStatus,
      repwStatus: repwStatus ?? this.repwStatus,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }

  @override
  List<Object?> get props => [
        status,
        username,
        password,
        rePassword,
        passwordStatus,
        repwStatus,
        updatedAt,
      ];
}
